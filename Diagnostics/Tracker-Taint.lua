local addonName, ns = ...

local D = ns.DiagnosticsStrings
local GetClientHeader = ns.GetDiagnosticClientHeader

--------------------------------------------------------------------------------
-- Tracker Taint Watch
--------------------------------------------------------------------------------

--[[
    Finds which of the add-on's actions leaves Blizzard's objective tracker
    tainted (GitHub #23). Once one tracker update runs tainted, it writes its
    state (isDirty, state, contentsHeight and so on) tainted, and the next
    update reads that state before it rewrites it, so the taint carries from
    update to update until a reload. Inside a scenario that update reads
    auras, which are secret to tainted code, and errors, whatever started it:
    the tracker's own next-frame update, or Edit Mode's anchor callback.

    While watching, every field of the tracker's frames is checked with
    issecurevariable, which names the add-on that tainted it without touching
    it. The add-on's calls into the game that can mark the tracker dirty go
    through ns.TrackerTaintStep, which checks before the call and right after
    it, then again a frame later and a second later, since the tracker
    updates on the next frame. A poll each second catches taint that arrives
    between steps. Read-only: nothing of Blizzard's is written.
]]

local POLL_SECONDS = 1
local LATE_CHECK_SECONDS = 1
local LOG_SIZE = 500
local NESTED_DEPTH = 1
local MAX_NESTED_KEYS = 200
local MAX_STEP_ARGS = 3

-- Frames the tracker and Edit Mode keep their state on, by global name. Every module in the container's list is added too
local TRACKER_GLOBALS = {
	"ObjectiveTrackerFrame",
	"ObjectiveTrackerManager",
	"QuestObjectiveTracker",
	"CampaignQuestObjectiveTracker",
	"ScenarioObjectiveTracker",
	"WorldQuestObjectiveTracker",
	"BonusObjectiveTracker",
	"AchievementObjectiveTracker",
	"AdventureObjectiveTracker",
	"ProfessionsRecipeTracker",
	"MonthlyActivitiesObjectiveTracker",
	"InitiativeTasksObjectiveTracker",
	"UIWidgetObjectiveTracker",
	"EditModeManagerFrame",
}

local function Watch()
	return ns.diagnostics and ns.diagnostics.trackerTaint
end

local function Watching()
	local watch = Watch()
	return watch ~= nil and watch.watching == true
end

local function Append(line)
	local lines = Watch().lines
	lines[#lines + 1] = line
	if #lines > LOG_SIZE then
		table.remove(lines, 1)
	end
end

--------------------------------------------------------------------------------
-- Scanning
--------------------------------------------------------------------------------

local function IsFrame(value)
	return type(rawget(value, 0)) == "userdata"
end

-- Small plain tables are looked into one level down, so a tracker's own lists are covered without walking whole layouts
local function IsSmallTable(value)
	local count = 0
	for _ in pairs(value) do
		count = count + 1
		if count > MAX_NESTED_KEYS then
			return false
		end
	end
	return true
end

local function CollectTargets()
	local targets, seen = {}, {}
	local function Add(name, value)
		if type(value) == "table" and not seen[value] then
			seen[value] = true
			targets[#targets + 1] = { name = name, value = value }
		end
	end
	for _, name in ipairs(TRACKER_GLOBALS) do
		Add(name, _G[name])
	end
	local container = _G.ObjectiveTrackerFrame
	local modules = type(container) == "table" and container.modules
	if type(modules) == "table" then
		for index, module in ipairs(modules) do
			local name = type(module) == "table" and type(module.GetName) == "function" and module:GetName()
			Add(name or ("ObjectiveTrackerFrame.modules[" .. index .. "]"), module)
		end
	end
	return targets
end

function ns.HasTrackerToWatch()
	return #CollectTargets() > 0
end

local function ScanTable(found, path, tbl, depth)
	for key, value in pairs(tbl) do
		if type(key) == "string" then
			local secure, taintedBy = issecurevariable(tbl, key)
			if not secure then
				found[path .. "." .. key] = taintedBy or "?"
			elseif depth > 0 and type(value) == "table" and not IsFrame(value) and IsSmallTable(value) then
				ScanTable(found, path .. "." .. key, value, depth - 1)
			end
		end
	end
end

-- Every tainted field as path -> the add-on that tainted it
local function Scan()
	local found = {}
	for _, target in ipairs(CollectTargets()) do
		local ok, problem = pcall(ScanTable, found, target.name, target.value, NESTED_DEPTH)
		if not ok then
			found[target.name .. " (could not scan: " .. tostring(problem) .. ")"] = "?"
		end
	end
	return found
end

local function SortedPaths(set)
	local paths = {}
	for path in pairs(set) do
		paths[#paths + 1] = path
	end
	table.sort(paths)
	return paths
end

--------------------------------------------------------------------------------
-- Checking
--------------------------------------------------------------------------------

local function BetweenSteps()
	local last = Watch().lastStep
	if not last then
		return "before any step"
	end
	return string.format("between steps, %.1fs after %s", GetTime() - last.time, last.label)
end

-- Logs what was tainted or cleared since the last check, and says in chat the first time the add-on's taint shows up
local function Check(context)
	if not Watching() then
		return
	end
	local watch = Watch()
	local current = Scan()
	local added, cleared = {}, {}
	for path, taintedBy in pairs(current) do
		if watch.known[path] ~= taintedBy then
			added[#added + 1] = path
		end
	end
	for path in pairs(watch.known) do
		if not current[path] then
			cleared[#cleared + 1] = path
		end
	end
	watch.known = current
	if #added == 0 and #cleared == 0 then
		return
	end
	table.sort(added)
	table.sort(cleared)
	local now = GetTime()
	for _, path in ipairs(added) do
		local taintedBy = current[path]
		Append(string.format("%.3f   %s: TAINTED %s (by %s)", now, context, path, taintedBy))
		if taintedBy == addonName and not watch.first then
			watch.first = { path = path, context = context }
			ns:PrintMessage(string.format(D.TRACKER_TAINT_CHAT, path, context))
		end
	end
	for _, path in ipairs(cleared) do
		Append(string.format("%.3f   %s: clean again %s", now, context, path))
	end
end

local function Describe(label, ...)
	local count = math.min(select("#", ...), MAX_STEP_ARGS)
	if count == 0 then
		return label
	end
	local parts = {}
	for index = 1, count do
		local value = select(index, ...)
		local name = type(value) == "table" and type(value.GetName) == "function" and value:GetName()
		parts[index] = name or tostring(value)
	end
	return label .. " (" .. table.concat(parts, ", ") .. ")"
end

local function FinishStep(label, ...)
	Check("right after " .. label)
	C_Timer.After(0, function()
		Check("a frame after " .. label)
	end)
	C_Timer.After(LATE_CHECK_SECONDS, function()
		Check("1s after " .. label)
	end)
	return ...
end

--[[
    Feature code calls the game through this wherever the call can mark the
    tracker dirty: ns.TrackerTaintStep("Track", C_QuestLog.AddQuestWatch, questID)
    calls C_QuestLog.AddQuestWatch(questID) and returns what it returns. With
    no function it only marks the moment in the log. Off, it's one check and
    the call, so it's safe on every path.
]]
function ns.TrackerTaintStep(label, func, ...)
	if not Watching() then
		if func then
			return func(...)
		end
		return
	end
	Check(BetweenSteps())
	label = Describe(label, ...)
	Append(string.format("%.3f STEP %s", GetTime(), label))
	Watch().lastStep = { label = label, time = GetTime() }
	if func then
		return FinishStep(label, func(...))
	end
	return FinishStep(label)
end

--------------------------------------------------------------------------------
-- Start, Stop, Report
--------------------------------------------------------------------------------

function ns:StopTrackerTaintWatch()
	local watch = Watch()
	if not (watch and watch.watching) then
		return
	end
	Check(BetweenSteps())
	watch.watching = false
	watch.stopped = GetTime()
	if watch.ticker then
		watch.ticker:Cancel()
		watch.ticker = nil
	end
end

function ns:StartTrackerTaintWatch()
	ns:StopTrackerTaintWatch()
	local watch = { watching = true, lines = {}, started = GetTime() }
	ns.diagnostics.trackerTaint = watch
	ns.diagnostics.trackerTaintReport = nil
	watch.known = Scan()
	watch.atStart = watch.known
	watch.ticker = C_Timer.NewTicker(POLL_SECONDS, function()
		Check(BetweenSteps())
	end)
end

-- The status line beside the buttons: idle, watching, or what it found
function ns:GetTrackerTaintState()
	local watch = Watch()
	if not watch then
		return "idle"
	end
	if watch.first then
		return "found", watch.first.path, watch.first.context
	end
	return watch.watching and "watching" or "stopped"
end

local function AppendTaintList(lines, set)
	local paths = SortedPaths(set)
	if #paths == 0 then
		lines[#lines + 1] = "  none"
		return
	end
	for _, path in ipairs(paths) do
		lines[#lines + 1] = string.format("  %s (by %s)", path, set[path])
	end
end

function ns:BuildTrackerTaintReport()
	local lines = { GetClientHeader(), "" }
	local watch = Watch()
	if not watch then
		lines[#lines + 1] = "(the watch hasn't run)"
		return table.concat(lines, "\n")
	end

	local names = {}
	for _, target in ipairs(CollectTargets()) do
		names[#names + 1] = target.name
	end
	lines[#lines + 1] = string.format(
		"Tracker Taint Watch: started %.3f, %s",
		watch.started,
		watch.watching and "still watching" or string.format("stopped %.3f", watch.stopped)
	)
	lines[#lines + 1] = "Watched: "
		.. (#names > 0 and table.concat(names, ", ") or "nothing, no objective tracker found")
	lines[#lines + 1] = ""
	if watch.first then
		lines[#lines + 1] = string.format("FIRST TAINT BY %s: %s, %s", addonName, watch.first.path, watch.first.context)
	else
		lines[#lines + 1] = string.format("No tracker field was tainted by %s while watching.", addonName)
	end
	lines[#lines + 1] = ""
	lines[#lines + 1] = "Tainted when the watch started:"
	AppendTaintList(lines, watch.atStart)
	lines[#lines + 1] = ""
	lines[#lines + 1] = "Log:"
	if #watch.lines == 0 then
		lines[#lines + 1] = "  (no steps, nothing changed)"
	else
		for _, line in ipairs(watch.lines) do
			lines[#lines + 1] = line
		end
	end
	lines[#lines + 1] = ""
	lines[#lines + 1] = "Tainted now:"
	AppendTaintList(lines, watch.watching and Scan() or watch.known)
	return table.concat(lines, "\n")
end
