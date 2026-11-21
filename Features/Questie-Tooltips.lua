local _, ns = ...

--[[
	Every client: the quest lines on a mob's, an object's or an item's tooltip, laid out as the Quest Arrow
	lists a waypoint (Routes-Stop-Lines.lua) instead of as Questie writes them. Questie still decides what
	goes on the tooltip: its own handlers run as ever, and so do its ID lines and its settings. Only the lines
	it would add for a quest are held back, while those handlers run, and our block is added in their place.

	Each quest leads with its title in its level color. Alone, each objective under it is one line: the quest
	log's check once done (or a blank the same size), its name, Questie's drop chance in gray after it, and the
	count on the right. In a group, even where only the player has it, each objective's name (and drop chance) is
	written once, and under it everyone who has it, the player first, each with their check, their name in
	their class color and their count; done players stay, checked. On a quest giver, a quest to take is one
	line, "Pick up [12] Quest Name" in its level color, and one to hand in is "Turn in [2] Quest Name" in gold,
	the arrow's wording. A blank line comes before each quest.

	Questie's handlers are wrapped at file load, before Questie hooks them to the tooltip as it starts up
	(QuestieTooltips:Initialize), so the hooks it sets take the wrapped ones. Plater and the like call
	Questie's GetTooltip outside those handlers and get Questie's lines as ever.

	All of it runs only while Enable Quest Tooltips (questTooltips) is on, read at each hover, so the switch
	takes effect on the next tooltip without a reload. Off, every tooltip is Questie's or the game's own.
]]

local QuestieTooltips = ns.ImportQuestieModule("QuestieTooltips")
local handlers = QuestieTooltips and QuestieTooltips.private
if not (handlers and type(QuestieTooltips.GetTooltip) == "function") then
	return
end

local L = ns.L

local ROW_INDENT = " " -- One space a row, as every list under a heading in the add-on's tooltips is indented

-- The keys ("m_2952") Questie would have shown lines for while one of its handlers runs; nil otherwise
local held

local function Questie(name)
	return ns.ImportQuestieModule(name)
end

local function Profile()
	return _G.Questie and _G.Questie.db and _G.Questie.db.profile or {}
end

-- Whether Enable Quest Tooltips is on; false before the saved settings load
local function On()
	return ns.db and ns.db.profile.questTooltips and true or false
end

-- A color as the code that starts it in a line's text
local function ColorCode(red, green, blue)
	return string.format("|cff%02x%02x%02x", red * 255, green * 255, blue * 255)
end

--------------------------------------------------------------------------------
-- Gathering
--------------------------------------------------------------------------------

-- Questie's drop chance as it rounds it: whole above 10%, then one, two or three decimals
local function DropText(rate)
	if rate >= 10 then
		return string.format("%.0f%%", rate)
	elseif rate >= 2 then
		return string.format("%.1f%%", rate)
	elseif rate >= 0.01 then
		return string.format("%.2f%%", rate)
	end
	return string.format("%.3f%%", rate)
end

local function Quest(quests, questID)
	local quest = quests[questID]
	if not quest then
		quest = { own = {}, players = {} }
		quests[questID] = quest
	end
	return quest
end

-- A player's rows under a quest, made the first time: name is as Questie keys them, display as shown
local function PlayerRows(quest, name, display, red, green, blue)
	local player = quest.players[name]
	if not player then
		player = { display = display, color = ColorCode(red, green, blue), rows = {} }
		quest.players[name] = player
	end
	return player.rows
end

--[[
	Whether a player already has a row for an objective: an object's name can stand for several objects
	(Basic Campfire), each a key of its own with the same quest's rows, and an objective is listed once
]]
local function HasIndex(rows, index)
	for _, row in ipairs(rows) do
		if row.index == index then
			return true
		end
	end
	return false
end

-- What the player's objective is called on this tooltip: for a spell cast on a mob, the item it's cast with
local function OwnObjectiveName(objective, sourceID)
	local spawn = objective.Type == "spell" and type(objective.spawnList) == "table" and objective.spawnList[sourceID]
	local itemID = type(spawn) == "table" and spawn.ItemId
	local QuestieDB = Questie("QuestieDB")
	if itemID and QuestieDB then
		local found, name = pcall(QuestieDB.QueryItemSingle, itemID, "name")
		if found and type(name) == "string" then
			return name
		end
	end
	return ns.routes.ObjectiveName(objective)
end

-- The player's own: the quests this gives or takes, and their objectives here, as Questie registers them
local function AddOwn(quests, key)
	local entries = QuestieTooltips.lookupByKey and QuestieTooltips.lookupByKey[key]
	if type(entries) ~= "table" then
		return
	end
	local profile = Profile()
	local givers = {}
	if profile.showQuestsInNpcTooltip then
		for _, entry in pairs(entries) do
			if entry.name then
				givers[entry.questId] = true
				local quest = Quest(quests, entry.questId)
				if entry.type == "Finisher" then
					quest.turnIn = true
				else
					quest.pickUp = true
				end
			end
		end
	end
	local ActiveQuests = Questie("ActiveQuests")
	local QuestieDB = Questie("QuestieDB")
	local sourceID = tonumber(key:sub(3))
	for _, entry in pairs(entries) do
		local objective = entry.objective
		if
			objective
			and not givers[entry.questId]
			and ActiveQuests
			and ActiveQuests.Get(entry.questId)
			and objective.Index
		then
			local quest = Quest(quests, entry.questId)
			if not quest.own[objective.Index] then
				local drop
				local rate = profile.enableTooltipDroprates
					and QuestieDB
					and objective.Type ~= "spell"
					and QuestieDB.GetItemDroprate(objective.Id, sourceID)
				if type(rate) == "table" and type(rate[1]) == "number" then
					drop = DropText(rate[1])
				end
				quest.own[objective.Index] = {
					name = OwnObjectiveName(objective, sourceID),
					have = objective.Collected,
					need = objective.Needed,
					done = objective.Completed
						or (objective.Needed ~= nil and (objective.Collected or 0) >= objective.Needed),
					drop = drop,
				}
			end
		end
	end
end

-- Whom Questie shows another player's progress for: a group member, or a nearby player sharing with you
local function OtherPlayer(name, questID)
	local QuestiePlayer = Questie("QuestiePlayer")
	local QuestieComms = Questie("QuestieComms")
	local member = QuestiePlayer and QuestiePlayer:GetPartyMemberByName(name)
	if member then
		local red, green, blue = ns.routes.ClassColor(name)
		return red, green, blue, false
	end
	local logs = QuestieComms and QuestieComms.remoteQuestLogs
	if
		QuestieComms
		and QuestieComms.remotePlayerEnabled[name]
		and type(logs) == "table"
		and logs[questID]
		and logs[questID][name]
		and (not Profile().onlyPartyShared or UnitInParty(name))
	then
		local class = QuestieComms.remotePlayerClasses and QuestieComms.remotePlayerClasses[name]
		local color = type(class) == "string" and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
		if color then
			return color.r, color.g, color.b, true
		end
	end
end

local function DisplayName(name, nearby)
	local short = Ambiguate(name, "short")
	if not nearby then
		return short
	end
	local l10n = Questie("l10n")
	local found, label = pcall(l10n, "Nearby")
	return found and type(label) == "string" and string.format("%s (%s)", short, label) or short
end

-- Everyone else's progress on the quests here, as their Questie shares it
local function AddShared(quests, key)
	local QuestieComms = Questie("QuestieComms")
	local data = QuestieComms and QuestieComms.data
	if not (IsInGroup() and data and data:KeyExists(key)) then
		return
	end
	local me = GetUnitName("player", true)
	for questID, players in pairs(data:GetTooltip(key)) do
		for name, objectives in pairs(players) do
			local red, green, blue, nearby
			if name ~= me then
				red, green, blue, nearby = OtherPlayer(name, questID)
			end
			if red then
				local quest = Quest(quests, questID)
				local rows = PlayerRows(quest, name, DisplayName(name, nearby), red, green, blue)
				for index, objective in pairs(objectives) do
					if type(index) == "number" and type(objective) == "table" and not HasIndex(rows, index) then
						local have, need = objective.fulfilled, objective.required
						rows[#rows + 1] = {
							index = index,
							text = objective.text,
							have = have,
							need = need,
							done = objective.finished or (need ~= nil and (have or 0) >= need),
						}
					end
				end
			end
		end
	end
end

--[[
	WoW Forever's own progress for the party, from the tooltip's lines, for members without Questie: anyone
	Questie shares a log for is already listed. Blizzard's line carries the count in its text, "2/12 Belt"
]]
local function NativeName(text)
	return text:match("^%s*%d+%s*/%s*%d+%s+(.+)$") or text:match("^(.-):%s*%d+%s*/%s*%d+%s*$") or text
end

local function AddNative(quests, tooltip)
	local Forever = Questie("Forever")
	if not (IsInGroup() and Forever and type(tooltip.GetPrimaryTooltipData) == "function") then
		return
	end
	-- Forever.GetNativePartyProgress gives nothing for lines WoW Forever keeps secret
	local read, progress = pcall(function()
		local data = tooltip:GetPrimaryTooltipData()
		return ns.IsReadable(data) and type(data) == "table" and Forever.GetNativePartyProgress(data.lines) or nil
	end)
	if not (read and type(progress) == "table") then
		return
	end
	for questID, members in pairs(progress) do
		for name, objectives in pairs(members) do
			local quest = Quest(quests, questID)
			if quest.players[name] == nil and objectives[1] then
				local red, green, blue = ns.routes.ClassColor(name)
				local rows = PlayerRows(quest, name, Ambiguate(name, "short"), red, green, blue)
				for index, objective in ipairs(objectives) do
					local have, need = objective.fulfilled, objective.required
					rows[#rows + 1] = {
						index = index,
						native = true,
						text = NativeName(objective.text),
						have = have,
						need = need,
						done = need ~= nil and (have or 0) >= need,
					}
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- The Block
--------------------------------------------------------------------------------

local function QuestTitle(questID)
	local QuestieDB = Questie("QuestieDB")
	local found, quest = pcall(function()
		return QuestieDB.GetQuest(questID)
	end)
	quest = found and type(quest) == "table" and quest or {}
	return ns.routes.QuestTitle({ questID = questID, questName = quest.name or tostring(questID), quest = quest })
end

-- The quest log's check once done, or a blank the same size so the text lines up, then the text
local function Checked(done, text)
	return ns.CheckIcon(GameTooltipText, done) .. " " .. text
end

-- An objective's name, with Questie's drop chance in gray after it where it knows one
local function WithDrop(heading)
	return heading.drop and (heading.name .. " " .. ns.GetColor("MUTED") .. heading.drop .. "|r") or heading.name
end

-- A line with "4 / 12" on the right where the row counts something, in silver once done
local function AddCounted(tooltip, left, row)
	local red, green, blue = ns.GetColorRGB(row.done and "HELP" or "TEXT")
	if row.need then
		tooltip:AddDoubleLine(left, ns.routes.CountText(row.have, row.need), red, green, blue, red, green, blue)
	else
		tooltip:AddLine(left, red, green, blue)
	end
end

--[[
	A quest's objectives here, each { name, drop, players }: players are each { display, row }, the player
	first, then everyone else by name. Questie's shares go by the objective's place in the quest, so a
	member's row goes under the player's objective in the same place; WoW Forever's own rows have no place,
	so they go by name. In the quest's order, then any only another player has
]]
local function Objectives(questID, quest)
	local objectives, byKey, byName = {}, {}, {}
	local function Heading(key, name)
		local heading = byKey[key] or byName[name]
		if not heading then
			heading = { name = name, players = {}, order = type(key) == "number" and key or 1000 + #objectives }
			objectives[#objectives + 1] = heading
			byKey[key] = heading
			byName[name] = heading
		end
		return heading
	end

	local red, green, blue = ns.routes.ClassColor("player")
	local me = ColorCode(red, green, blue) .. (ns.routes.UnitFullName("player") or UnitName("player")) .. "|r"
	for index, row in pairs(quest.own) do
		local heading = Heading(index, row.name)
		heading.drop = row.drop
		heading.players[1] = { display = me, row = row }
	end

	local others = {}
	for _, player in pairs(quest.players) do
		others[#others + 1] = player
	end
	table.sort(others, function(a, b)
		return a.display < b.display
	end)
	for _, player in ipairs(others) do
		for _, row in ipairs(player.rows) do
			local heading
			if row.native then
				heading = Heading("native:" .. row.text, row.text)
			else
				local own = quest.own[row.index]
				local name = own and own.name
					or ns.routes.ObjectiveName({ Description = row.text, questId = questID, Index = row.index })
				heading = Heading(row.index, name)
			end
			heading.players[#heading.players + 1] = { display = player.color .. player.display .. "|r", row = row }
		end
	end

	table.sort(objectives, function(a, b)
		return a.order < b.order
	end)
	return objectives
end

--[[
	Under a quest's title, as the Quest Arrow lists it: alone, each objective on one line with its check and
	count. Named, each objective's name, then who has it under it with their own check and count, a blank
	line before each objective after the first
]]
local function AddObjectives(tooltip, questID, quest, named)
	for i, heading in ipairs(Objectives(questID, quest)) do
		if not named then
			local row = heading.players[1].row
			AddCounted(tooltip, ROW_INDENT .. Checked(row.done, WithDrop(heading)), row)
		else
			if i > 1 then
				tooltip:AddLine(" ")
			end
			tooltip:AddLine(ROW_INDENT .. WithDrop(heading), ns.GetColorRGB("TEXT"))
			for _, player in ipairs(heading.players) do
				-- The check starts under the objective's name, so the names are in by just its width, as in the quest log
				AddCounted(tooltip, ROW_INDENT .. Checked(player.row.done, player.display), player.row)
			end
		end
	end
end

local function HasRows(quest)
	if next(quest.own) then
		return true
	end
	for _, player in pairs(quest.players) do
		if #player.rows > 0 then
			return true
		end
	end
	return false
end

--[[
	Whether names show: in a group, as the Quest Arrow does, so an objective only the player has still reads as
	theirs; alone, only where someone else is listed (a nearby player sharing with Questie)
]]
local function Named(quests)
	if IsInGroup() then
		return true
	end
	for _, quest in pairs(quests) do
		for _, player in pairs(quest.players) do
			if #player.rows > 0 then
				return true
			end
		end
	end
	return false
end

-- A giver's quest as its one line after prefix: "Turn in" in gold, or "Pick up" in its level color
local function AddGiverLine(tooltip, questID, quest, prefix)
	local title, red, green, blue = QuestTitle(questID)
	if quest.turnIn then
		tooltip:AddLine(prefix .. string.format(L["ROUTES_TURN_IN_QUEST"], title), ns.GetColorRGB("TITLE"))
	else
		tooltip:AddLine(prefix .. string.format(L["ROUTES_PICK_UP_QUEST"], title), red, green, blue)
	end
end

-- One quest, a blank line before it: a giver's one line, or the title and its objectives
local function AddQuest(tooltip, questID, quest, named)
	if not (quest.pickUp or quest.turnIn or HasRows(quest)) then
		return
	end
	if tooltip:NumLines() > 0 then
		tooltip:AddLine(" ")
	end
	if quest.turnIn or quest.pickUp then
		AddGiverLine(tooltip, questID, quest, "")
	else
		local title, red, green, blue = QuestTitle(questID)
		tooltip:AddLine(title, red, green, blue)
		AddObjectives(tooltip, questID, quest, named)
	end
end

local function AddBlock(tooltip, keys)
	local quests = {}
	for _, key in ipairs(keys) do
		AddOwn(quests, key)
		AddShared(quests, key)
	end
	local prefix = keys[1]:sub(1, 2)
	if prefix == "m_" or prefix == "o_" then
		AddNative(quests, tooltip)
	end

	local named = Named(quests)
	local QuestieLib = Questie("QuestieLib")
	local order = QuestieLib and QuestieLib:SortQuestIDsByLevel(quests, true) or {}
	for _, questID in ipairs(order) do
		AddQuest(tooltip, questID, quests[questID], named)
	end
end

--------------------------------------------------------------------------------
-- Questie's Handlers
--------------------------------------------------------------------------------

-- Inside a handler, Questie's lines are held back, noted only when it would have shown some
local GetTooltip = QuestieTooltips.GetTooltip
QuestieTooltips.GetTooltip = function(key, playerZone, ...)
	if not held then
		return GetTooltip(key, playerZone, ...)
	end
	local lines = GetTooltip(key, playerZone, ...)
	if type(lines) == "table" and next(lines) then
		held[#held + 1] = key
	end
	return nil
end

--[[
	GameTooltip's lines counted the way Questie counts them: from the first up to the first with no text, a
	secret one counting as filled
]]
local function CountTooltipLines()
	local count = 0
	while true do
		local line = _G["GameTooltipTextLeft" .. (count + 1)]
		local text = line and line:GetText()
		if not (issecretvalue and issecretvalue(text)) and text == nil then
			return count
		end
		count = count + 1
	end
end

--[[
	Runs Questie's handler with its quest lines held back, then adds our block where it would have shown
	them. Questie's errors stay its own, after the lines stop being held back. While Enable Quest Tooltips is
	off, Questie's handler runs as ever. For the unit and item handlers (recount), Questie's saved line count
	is set again after the block, as Questie saves it before the block exists and would otherwise skip a
	redraw of the same tooltip, leaving it without the block
]]
local function Wrap(name, TooltipOf, recount)
	local handler = handlers[name]
	if type(handler) ~= "function" then
		return
	end
	handlers[name] = function(...)
		if not On() then
			return handler(...)
		end
		held = {}
		local ok, failure = pcall(handler, ...)
		local keys = held
		held = nil
		if not ok then
			error(failure, 0)
		end
		local tooltip = TooltipOf(...)
		if #keys > 0 and tooltip and not tooltip:IsForbidden() then
			AddBlock(tooltip, keys)
			if recount then
				QuestieTooltips.lastGametooltipCount = CountTooltipLines()
			end
		end
	end
end

Wrap("AddUnitDataToTooltip", function(tooltip)
	return tooltip
end, true)
Wrap("AddItemDataToTooltip", function(tooltip)
	return tooltip
end, true)
Wrap("AddObjectDataToTooltip", function()
	return GameTooltip
end)

--------------------------------------------------------------------------------
-- The Minimap's Own Quest Tooltip
--------------------------------------------------------------------------------

--[[
	WoW Forever's minimap writes a tooltip of its own over a quest's objective area (its blob), on GameTooltip:
	the quest's title, then "- 0/8 Trophy Swoop Quill" for each objective there. It's taken as the minimap's
	when the minimap owns the tooltip or the mouse is over the minimap. It's laid out the
	same way as the blocks above. Each title is matched to a quest in the log by its text, each objective line
	to the quest's objective (Questie's) by its name, which gives the party's progress under it. Lines that
	aren't a quest's (a party member, a herb) stay as they are, where they are. Nothing changes unless a quest
	matched, so a tooltip already laid out, which no longer reads as the minimap's, is left alone
]]

local function Plain(text)
	return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""))
end

local function Trim(text)
	return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- The tooltip's lines, each { text, red, green, blue }: a line set with SetText can hold several
local function TooltipLines(tooltip)
	local lines = {}
	local name = tooltip:GetName()
	for i = 1, tooltip:NumLines() do
		local fontString = _G[name .. "TextLeft" .. i]
		local text = fontString and fontString:GetText()
		if not ns.IsReadable(text) then
			return nil
		end
		if type(text) == "string" then
			local red, green, blue = fontString:GetTextColor()
			for line in (text .. "\n"):gmatch("(.-)\n") do
				lines[#lines + 1] = { text = line, red = red, green = green, blue = blue }
			end
		end
	end
	return lines
end

-- The log's quests by title
local function LogTitles()
	local titles = {}
	for i = 1, ns.GetNumQuestLogEntries() do
		local entry = ns.GetQuestLogEntry(i)
		if entry and not entry.isHeader and entry.title and entry.questID then
			titles[entry.title] = entry.questID
		end
	end
	return titles
end

-- The quest's objective a minimap line names, by its name in Questie's data
local function MatchObjective(questieQuest, name)
	local wanted = name:lower()
	for _, objective in ipairs(type(questieQuest.Objectives) == "table" and questieQuest.Objectives or {}) do
		local description = type(objective.Description) == "string" and objective.Description:lower()
		if description and description ~= "" and (description == wanted or wanted:find(description, 1, true)) then
			return objective
		end
	end
end

-- A quest as the blocks above take it, from its objective lines on the minimap
local function MinimapQuest(questID, objectiveLines)
	local quest = { own = {}, players = {} }
	local QuestieDB = Questie("QuestieDB")
	local found, questieQuest = pcall(function()
		return QuestieDB.GetQuest(questID)
	end)
	questieQuest = found and type(questieQuest) == "table" and questieQuest or {}
	local members = ns.routes.MemberProgress(questID)
	for n, line in ipairs(objectiveLines) do
		local text = NativeName(line)
		local objective = MatchObjective(questieQuest, text)
		if objective and objective.Index then
			if objective.Update then
				pcall(objective.Update, objective)
			end
			local need = objective.Needed
			quest.own[objective.Index] = {
				name = ns.routes.ObjectiveName(objective),
				have = objective.Collected,
				need = need,
				done = objective.Completed or (need ~= nil and (objective.Collected or 0) >= need),
			}
			for _, member in ipairs(members) do
				local remote = ns.routes.MemberObjective(questieQuest, member, objective)
				if remote then
					local red, green, blue = ns.routes.ClassColor(member.name)
					local rows = PlayerRows(quest, member.name, member.shortName, red, green, blue)
					if not HasIndex(rows, objective.Index) then
						rows[#rows + 1] = {
							index = objective.Index,
							have = remote.fulfilled,
							need = remote.required,
							done = remote.finished
								or (remote.required ~= nil and (remote.fulfilled or 0) >= remote.required),
						}
					end
				end
			end
		else
			-- Not in Questie's data: the line's own name and count
			local have, need = line:match("(%d+)%s*/%s*(%d+)")
			have, need = tonumber(have), tonumber(need)
			quest.own[1000 + n] = { name = text, have = have, need = need, done = need ~= nil and have >= need }
		end
	end
	return quest
end

local restyling = false

local function RestyleMinimapTooltip(tooltip)
	if restyling or tooltip:IsForbidden() then
		return
	end
	local owner = tooltip:GetOwner()
	local ownedByMinimap = ns.IsReadable(owner) and owner == Minimap
	if not (ownedByMinimap or (Minimap and Minimap:IsMouseOver())) then
		return
	end
	local lines = TooltipLines(tooltip)
	if not lines then
		return
	end

	-- In order: each quest with its objective lines, and every other line as it was
	local titles, groups, quests, current = LogTitles(), {}, {}, nil
	for _, line in ipairs(lines) do
		local plain = Trim(Plain(line.text))
		local objectiveText = plain:match("^%-%s*(.+)$")
		if current and objectiveText then
			current.objectives[#current.objectives + 1] = objectiveText
		elseif titles[plain] then
			current = { questID = titles[plain], objectives = {} }
			groups[#groups + 1] = current
		else
			current = nil
			groups[#groups + 1] = { line = line }
		end
	end
	for _, group in ipairs(groups) do
		if group.questID then
			quests[group.questID] = MinimapQuest(group.questID, group.objectives)
		end
	end
	if not next(quests) then
		return
	end

	local named = Named(quests)
	restyling = true
	tooltip:ClearLines()
	for _, group in ipairs(groups) do
		if group.questID then
			AddQuest(tooltip, group.questID, quests[group.questID], named)
		else
			tooltip:AddLine(group.line.text, group.line.red, group.line.green, group.line.blue)
		end
	end
	tooltip:Show()
	restyling = false
end

-- A failure here never breaks the minimap's tooltip: it stays the game's own, as it does while the switch is off
local function SafeRestyle(tooltip)
	if not On() then
		return
	end
	local ok = pcall(RestyleMinimapTooltip, tooltip)
	if not ok then
		restyling = false
	end
end
hooksecurefunc(GameTooltip, "SetText", SafeRestyle)
hooksecurefunc(GameTooltip, "Show", SafeRestyle)

--[[
	The objective area's tooltip doesn't always come through SetText or Show above, so while the mouse is over
	the minimap the tooltip is looked at every frame too. It's read again only when its first line or its line
	count changes, as when the game writes its own text over ours
]]
local lastFirst, lastCount
local firstLine = _G[GameTooltip:GetName() .. "TextLeft1"]
GameTooltip:HookScript("OnUpdate", function(tooltip)
	if not (On() and Minimap and Minimap:IsMouseOver()) then
		lastFirst = nil
		return
	end
	local first = firstLine and firstLine:GetText()
	if not ns.IsReadable(first) then
		return
	end
	local count = tooltip:NumLines()
	if first == lastFirst and count == lastCount then
		return
	end
	SafeRestyle(tooltip)
	lastFirst, lastCount = firstLine:GetText(), tooltip:NumLines()
end)

--------------------------------------------------------------------------------
-- Questie's Map Icon Tooltips
--------------------------------------------------------------------------------

--[[
	Questie's icons on the minimap and the world map: their tooltip, laid out the same way, every time; Shift
	adds nothing. Questie still gathers what the tooltip lists, the icons around the hovered one
	(MapIconTooltip.ShowOnTooltip, which leaves them on the tooltip as npcAndObjectOrder, questOrder and
	manualOrder), and only how it's drawn (the tooltip's _Rebuild, which Questie calls again when a modifier
	key changes) is ours. Each giver's name heads their quests, as several givers in a town share one tooltip
	and the map doesn't show who stands there; under it each quest is one line, one space in: "Turn in" where
	it's in the log, "Pick up" otherwise. Givers go by their lowest-level quest. An active quest's objectives are the ones its
	lines name, matched to Questie's objectives by name, with everyone's progress under each. Journey's
	townsfolk notes stay as Questie writes them. Should ours fail or have nothing to draw, Questie's own is drawn
]]

local MapIconTooltip = Questie("MapIconTooltip")

local function GetQuestieQuest(questID)
	local QuestieDB = Questie("QuestieDB")
	local found, quest = pcall(function()
		return QuestieDB.GetQuest(questID)
	end)
	return found and type(quest) == "table" and quest or {}
end

-- Whom a map icon's tooltip lists another player's progress for, as Questie does: anyone it has a log of
local function MapPlayer(name)
	local QuestiePlayer = Questie("QuestiePlayer")
	if QuestiePlayer and QuestiePlayer:GetPartyMemberByName(name) then
		local red, green, blue = ns.routes.ClassColor(name)
		return red, green, blue, false
	end
	local QuestieComms = Questie("QuestieComms")
	local class = QuestieComms and QuestieComms.remotePlayerClasses and QuestieComms.remotePlayerClasses[name]
	local color = type(class) == "string" and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
	if color then
		return color.r, color.g, color.b, true
	end
	local red, green, blue = ns.GetColorRGB("HELP")
	return red, green, blue, false
end

-- The quest's objectives (Objectives, then Questie's own SpecialObjectives) that the lines name
local function NamedObjectives(questieQuest, texts)
	local found = {}
	local function Scan(list, special)
		local n = 0
		for _, objective in pairs(type(list) == "table" and list or {}) do
			n = n + 1
			local description = type(objective) == "table"
				and type(objective.Description) == "string"
				and objective.Description:lower()
			if description and description ~= "" then
				for _, text in ipairs(texts) do
					if text.lower:find(description, 1, true) then
						local key = special and 100 + n or objective.Index
						if key then
							found[#found + 1] = { objective = objective, key = key, special = special }
						end
						break
					end
				end
			end
		end
	end
	Scan(questieQuest.Objectives, false)
	Scan(questieQuest.SpecialObjectives, true)
	return found
end

-- An active quest as the blocks above take it, from its lines on Questie's tooltip ("2/8 Trophy Swoop Quill")
local function MapQuest(questID, textList)
	local texts = {}
	for _, textData in pairs(textList) do
		for text in pairs(type(textData) == "table" and textData or {}) do
			if type(text) == "string" then
				local plain = Trim(Plain(text))
				texts[#texts + 1] = { plain = plain, lower = plain:lower() }
			end
		end
	end
	local quest = { own = {}, players = {} }
	local questieQuest = GetQuestieQuest(questID)
	local ActiveQuests = Questie("ActiveQuests")
	local mine = ActiveQuests and ActiveQuests.Get(questID)
	local matched = NamedObjectives(questieQuest, texts)
	if mine then
		for _, match in ipairs(matched) do
			local objective = match.objective
			local need = objective.Needed
			quest.own[match.key] = {
				name = ns.routes.ObjectiveName(objective),
				have = objective.Collected,
				need = need,
				done = objective.Completed or (need ~= nil and (objective.Collected or 0) >= need),
			}
		end
		if #matched == 0 then
			-- Nothing matched by name: each line's own name and count, less a player's name after it
			for n, text in ipairs(texts) do
				local line = text.plain:gsub("%s*%b()%s*$", "")
				local have, need = line:match("(%d+)%s*/%s*(%d+)")
				have, need = tonumber(have), tonumber(need)
				quest.own[1000 + n] =
					{ name = NativeName(line), have = have, need = need, done = need ~= nil and have >= need }
			end
		end
	end

	local QuestieComms = Questie("QuestieComms")
	local found, shared = pcall(function()
		return QuestieComms:GetQuest(questID)
	end)
	local me = GetUnitName("player", true)
	for name, objectives in pairs(found and type(shared) == "table" and shared or {}) do
		if type(name) == "string" and name ~= me and type(objectives) == "table" then
			local red, green, blue, nearby = MapPlayer(name)
			local rows = PlayerRows(quest, name, DisplayName(name, nearby), red, green, blue)
			for _, match in ipairs(matched) do
				local entry = not match.special and objectives[match.key]
				if type(entry) == "table" and not HasIndex(rows, match.key) then
					local have, need = entry.fulfilled, entry.required
					rows[#rows + 1] = {
						index = match.key,
						text = match.objective.Description,
						have = have,
						need = need,
						done = entry.finished or (need ~= nil and (have or 0) >= need),
					}
				end
			end
		end
	end
	return quest
end

-- Journey's townsfolk notes, as Questie writes them
local function AddManual(tooltip, manualOrder, onWorldMap)
	for title, data in pairs(manualOrder) do
		if tooltip:NumLines() > 0 then
			tooltip:AddLine(" ")
		end
		tooltip:AddLine(title)
		for _, line in ipairs(type(data.Body) == "table" and data.Body or {}) do
			if type(line) == "string" then
				tooltip:AddLine(line)
			elseif type(line) == "table" then
				tooltip:AddDoubleLine(line[1], "|cFFffffff" .. tostring(line[2]) .. "|r")
			end
		end
		if onWorldMap and not data.disableShiftToRemove then
			local l10n = Questie("l10n")
			local found, hint = pcall(l10n, "Shift-click to hide")
			if found and type(hint) == "string" then
				tooltip:AddLine(hint, ns.GetColorRGB("MUTED"))
			end
		end
	end
end

-- The givers in order of their lowest-level quest, then by name; rank is each giver quest's place by level
local function SortedGivers(byGiver, rank)
	local list = {}
	for name, set in pairs(byGiver) do
		local first = math.huge
		for questID in pairs(set) do
			first = math.min(first, rank[questID] or math.huge)
		end
		list[#list + 1] = { name = name, set = set, first = first }
	end
	table.sort(list, function(a, b)
		if a.first ~= b.first then
			return a.first < b.first
		end
		return a.name < b.name
	end)
	return list
end

-- Draws the tooltip; returns whether it drew anything
local function DrawMapTooltip(tooltip)
	local quests, givers, active, byGiver, nameless = {}, {}, {}, {}, {}
	local ActiveQuests = Questie("ActiveQuests")
	-- Questie keys each giver's quests by the giver's name (MapIconTooltip.ShowOnTooltip: iconData.Name)
	for giverName, byTitle in pairs(tooltip.npcAndObjectOrder or {}) do
		local name = type(giverName) == "string" and Trim(Plain(giverName)) or ""
		local set = name ~= "" and (byGiver[name] or {}) or nameless
		if name ~= "" then
			byGiver[name] = set
		end
		for _, tip in pairs(type(byTitle) == "table" and byTitle or {}) do
			local questID = type(tip) == "table" and tip.questId
			if questID then
				local quest = quests[questID] or { own = {}, players = {} }
				quests[questID] = quest
				givers[questID] = quest
				set[questID] = quest
				if ActiveQuests and ActiveQuests.Get(questID) then
					quest.turnIn = true
				else
					quest.pickUp = true
				end
			end
		end
	end
	for questID, textList in pairs(tooltip.questOrder or {}) do
		if not quests[questID] and type(textList) == "table" then
			quests[questID] = MapQuest(questID, textList)
			active[questID] = quests[questID]
		end
	end

	local named = Named(quests)
	local QuestieLib = Questie("QuestieLib")
	local function ByLevel(set)
		return next(set) and QuestieLib:SortQuestIDsByLevel(set, true) or {}
	end

	-- Each giver's name, then their quests one space in; a blank line before each giver after the first
	local rank = {}
	for index, questID in ipairs(ByLevel(givers)) do
		rank[questID] = index
	end
	for _, giver in ipairs(SortedGivers(byGiver, rank)) do
		if tooltip:NumLines() > 0 then
			tooltip:AddLine(" ")
		end
		tooltip:AddLine(giver.name, ns.GetColorRGB("TEXT"))
		for _, questID in ipairs(ByLevel(giver.set)) do
			AddGiverLine(tooltip, questID, giver.set[questID], ROW_INDENT)
		end
	end
	-- A giver whose name can't be read: its quests as lines of their own, with no name
	for _, set in ipairs({ nameless, active }) do
		for _, questID in ipairs(ByLevel(set)) do
			AddQuest(tooltip, questID, set[questID], named)
		end
	end
	AddManual(tooltip, tooltip.manualOrder or {}, tooltip.miniMapIcon == false)
	return tooltip:NumLines() > 0
end

if MapIconTooltip and type(MapIconTooltip.ShowOnTooltip) == "function" then
	local ours = setmetatable({}, { __mode = "k" }) -- Our _Rebuilds, so a show Questie skipped isn't wrapped twice
	local ShowOnTooltip = MapIconTooltip.ShowOnTooltip
	MapIconTooltip.ShowOnTooltip = function(icon, tooltip, ...)
		ShowOnTooltip(icon, tooltip, ...)
		local questieRebuild = tooltip and tooltip._Rebuild
		if not On() or type(questieRebuild) ~= "function" or ours[questieRebuild] or not tooltip.ShownAsMapIcon then
			return
		end
		-- Questie's own draws once the switch is turned off, as on a tooltip already open
		local function Rebuild(self)
			self:ClearLines()
			if not On() then
				questieRebuild(self)
				return
			end
			local ok, drawn = pcall(DrawMapTooltip, self)
			if not (ok and drawn) then
				self:ClearLines()
				questieRebuild(self)
			end
		end
		ours[Rebuild] = true
		tooltip._Rebuild = Rebuild
		Rebuild(tooltip)
		tooltip:Show()
	end
end
