local ADDON_NAME, ns = ...
local L = ns.L

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
	local version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")
	if not version or version:find("@") then
		return "Dev"
	end
	return version
end

ns.Version = GetVersion()

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

--[[
	Every event the add-on can handle, in registration order, with its handler;
	an event listed twice runs both handlers, in this order. Feature files define
	the handlers; an event is registered only once a loaded file defines one of
	its handlers, so a client never registers an event only another client's
	files use. ns.EVENT_NAMES lists what was actually registered.
]]
local EVENTS = {
	{ "ADDON_LOADED", "OnAddonLoaded" },
	{ "PLAYER_LOGIN", "OnPlayerLogin" },
	{ "QUEST_LOG_UPDATE", "OnQuestLogUpdate" },
	{ "QUEST_WATCH_LIST_CHANGED", "OnQuestWatchListChanged" },
	{ "QUEST_ACCEPTED", "OnQuestAccepted" },
	{ "QUEST_REMOVED", "OnQuestRemoved" },
	{ "QUEST_TURNED_IN", "OnQuestTurnedIn" },
	{ "UNIT_QUEST_LOG_CHANGED", "OnUnitQuestLogChanged" },
	{ "GROUP_ROSTER_UPDATE", "OnGroupRosterUpdate" },
	{ "PLAYER_LEVEL_UP", "OnPlayerLevelUp" },
	{ "ZONE_CHANGED_NEW_AREA", "OnZoneChangedNewArea" },
	{ "PLAYER_REGEN_DISABLED", "OnPlayerRegenDisabled" },
	{ "CHAT_MSG_SYSTEM", "OnChatMsgSystem" },
	{ "PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld" },
	{ "GROUP_JOINED", "OnGroupJoined" },
	{ "GROUP_LEFT", "OnGroupLeft" },
	{ "GROUP_ROSTER_UPDATE", "OnDungeonRosterUpdate" },
}

local EVENT_HANDLERS = {}
for _, event in ipairs(EVENTS) do
	EVENT_HANDLERS[event[1]] = EVENT_HANDLERS[event[1]] or {}
	table.insert(EVENT_HANDLERS[event[1]], event[2])
end

ns.EVENT_NAMES = {}

local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(_, event, ...)
	if ns.diagnostics and ns.diagnostics.logging then
		ns:LogEvent(event, ...)
	end

	for _, handlerName in ipairs(EVENT_HANDLERS[event]) do
		local handler = ns[handlerName]
		if handler then
			handler(ns, ...)
		end
	end
end)

local function RegisterEvent(event)
	if eventFrame:IsEventRegistered(event) then
		return
	end
	eventFrame:RegisterEvent(event)
	ns.EVENT_NAMES[#ns.EVENT_NAMES + 1] = event
end

RegisterEvent("ADDON_LOADED")

--------------------------------------------------------------------------------
-- The Wide Quest Log
--------------------------------------------------------------------------------

--[[
	The Quest Log switch decides, as the saved settings load, whether the wide quest log runs this
	session; a change takes effect at the next /reload. On Classic Era and TBC its files widen and hook
	Blizzard's own quest log, which can't be undone, so each hands its work here and it runs only with the
	switch on. WoW Forever's quest log is a window of its own that stays closed with the switch off, so
	its pieces build at once and only the takeover of the quest log key waits (Forever-Quest-Log.lua)
]]
local wideQuestLogParts = {}

function ns.AddWideQuestLogPart(build)
	if ns.FLAVOR == "Camelot" then
		build()
	else
		wideQuestLogParts[#wideQuestLogParts + 1] = build
	end
end

local function StartWideQuestLog()
	ns.wideQuestLogActive = ns.db.profile.enableWideQuestLog and true or false
	if ns.wideQuestLogActive then
		for _, build in ipairs(wideQuestLogParts) do
			build()
		end
	end
	wideQuestLogParts = nil
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

function ns:ApplyProfile()
	ns.ApplyQuestGiverCleanup()
	if ns.wideQuestLogActive then
		ns.RefreshQuestLog()
	end
	for _, registryName in pairs(ns.OPTIONS_REGISTRY) do
		AceConfigRegistry:NotifyChange(registryName)
	end
end

function ns:OnAddonLoaded(name)
	if name ~= ADDON_NAME then
		return
	end

	ns.db = LibStub("AceDB-3.0"):New(ns.SAVED_VARIABLES_NAME, ns.DATABASE_DEFAULTS, true)
	for _, message in ipairs({ "OnProfileChanged", "OnProfileReset", "OnProfileCopied" }) do
		ns.db.RegisterCallback(ns, message, "ApplyProfile")
	end
	StartWideQuestLog()
	ns.ApplyQuestGiverCleanup()
	ns.RegisterOptionsPanels()

	if ns.OnDatabaseReady then
		ns:OnDatabaseReady()
	end

	for _, event in ipairs(EVENTS) do
		if event[1] ~= "ADDON_LOADED" and ns[event[2]] then
			RegisterEvent(event[1])
		end
	end
end

--------------------------------------------------------------------------------
-- Welcome
--------------------------------------------------------------------------------

function ns:PrintWelcome()
	if not ns.db.profile.showWelcome then
		return
	end
	ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

-- Prints on every login while it holds, ignoring the welcome toggle: it's a conflict, not a greeting. It never turns either add-on off.
function ns:WarnIfPredecessorLoaded()
	if C_AddOns.IsAddOnLoaded(ns.PREDECESSOR_ADDON_NAME) then
		ns:PrintMessage(L["CHAT_PREDECESSOR_LOADED"])
	end
end

-- Prints regardless of the welcome toggle: it explains missing features, not a greeting.
function ns:NoteIfQuestieMissing()
	C_Timer.After(ns.QUESTIE_NOTICE_DELAY, function()
		if not C_AddOns.IsAddOnLoaded(ns.QUESTIE_ADDON_NAME) then
			ns:PrintMessage(L["CHAT_QUESTIE_MISSING"])
		end
	end)
end

function ns:OnPlayerLogin()
	ns:PrintWelcome()
	ns:WarnIfPredecessorLoaded()
	ns:NoteIfQuestieMissing()
end
