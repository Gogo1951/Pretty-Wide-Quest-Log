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
	Every event the add-on can handle, in registration order, with its handler, named for the event, and
	where several features handle the same event, each after the first names the key of the ns table that
	holds its handler (its owner; without one, the handler is on ns). An event listed more than once runs
	every handler, in this order.
	Feature files define the handlers; an event is registered only once a loaded file, or a quest log part
	run at ADDON_LOADED, defines one of its handlers, so a client never registers an event only another
	client's files use. ns.EVENT_NAMES lists what was actually registered.
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
	{ "PLAYER_REGEN_ENABLED", "OnPlayerRegenEnabled" },
	{ "UPDATE_BINDINGS", "OnUpdateBindings" },
	{ "CHAT_MSG_SYSTEM", "OnChatMsgSystem" },
	{ "PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld" },
	{ "GROUP_JOINED", "OnGroupJoined" },
	{ "GROUP_LEFT", "OnGroupLeft" },
	{ "GROUP_ROSTER_UPDATE", "OnGroupRosterUpdate", "dungeonQuests" },
	{ "GROUP_JOINED", "OnGroupJoined", "shareReminders" },
	{ "GROUP_LEFT", "OnGroupLeft", "shareReminders" },
	{ "PLAYER_LOGIN", "OnPlayerLogin", "routes" },
	{ "PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld", "routes" },
	{ "ZONE_CHANGED_NEW_AREA", "OnZoneChangedNewArea", "routes" },
	{ "QUEST_LOG_UPDATE", "OnQuestLogUpdate", "routes" },
	{ "PLAYER_DEAD", "OnPlayerDead", "routes" },
	{ "PLAYER_ALIVE", "OnPlayerAlive", "routes" },
	{ "PLAYER_UNGHOST", "OnPlayerUnghost", "routes" },
	{ "ADDON_LOADED", "OnAddonLoaded", "routesMap" },
	{ "GROUP_ROSTER_UPDATE", "OnGroupRosterUpdate", "routes" },
	{ "GROUP_JOINED", "OnGroupJoined", "routes" },
	{ "GROUP_LEFT", "OnGroupLeft", "routes" },
	{ "GROUP_ROSTER_UPDATE", "OnGroupRosterUpdate", "routesArrow" },
	{ "PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld", "routesArrow" },
	{ "ZONE_CHANGED_NEW_AREA", "OnZoneChangedNewArea", "routesArrow" },
	{ "PLAYER_REGEN_ENABLED", "OnPlayerRegenEnabled", "questMap" },
	{ "PLAYER_REGEN_ENABLED", "OnPlayerRegenEnabled", "questLogApi" },
	{ "PLAYER_REGEN_ENABLED", "OnPlayerRegenEnabled", "questLogWindow" },
	{ "PLAYER_REGEN_ENABLED", "OnPlayerRegenEnabled", "routesItems" },
	{ "BAG_UPDATE_DELAYED", "OnBagUpdateDelayed", "routesItems" },
	{ "BAG_UPDATE_COOLDOWN", "OnBagUpdateCooldown", "routesItems" },
	{ "PLAYER_TARGET_CHANGED", "OnPlayerTargetChanged", "routesItems" },
}

local EVENT_HANDLERS = {}
for _, event in ipairs(EVENTS) do
	EVENT_HANDLERS[event[1]] = EVENT_HANDLERS[event[1]] or {}
	table.insert(EVENT_HANDLERS[event[1]], event)
end

-- An EVENTS row's owner and handler, or nothing while no loaded file defines it
local function FindHandler(event)
	local owner = ns
	if event[3] then
		owner = ns[event[3]]
	end
	local handler = owner and owner[event[2]]
	if handler then
		return owner, handler
	end
end

ns.EVENT_NAMES = {}

local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(_, event, ...)
	if ns.diagnostics.logging then
		ns:LogEvent(event, ...)
	end

	-- Through securecall, so an error is reported and the event's later handlers still run
	for _, row in ipairs(EVENT_HANDLERS[event]) do
		local owner, handler = FindHandler(row)
		if handler then
			securecall(handler, owner, ...)
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

-- Every event with a handler defined by now; an event already registered is skipped
local function RegisterLoadedEvents()
	for _, event in ipairs(EVENTS) do
		if event[1] ~= "ADDON_LOADED" and FindHandler(event) then
			RegisterEvent(event[1])
		end
	end
end

--------------------------------------------------------------------------------
-- The Wide Quest Log
--------------------------------------------------------------------------------

--[[
	The Quest Log switch decides, as the saved settings load, whether the wide quest log runs this
	session; a change takes effect at the next /reload. On Classic Era and TBC its files widen and hook
	Blizzard's own quest log, which can't be undone, so each hands its work here and it runs only with the
	switch on. On WoW Forever and Mists the quest log is a window of its own that stays closed with the
	switch off (Forever-Quest-Log.lua), so its pieces build at once and only the takeover of the quest log
	key waits (Quest-Log-Key.lua). A client whose TOC lists no quest log files has nothing to run,
	so the switch does nothing there
]]
local wideQuestLogParts = {}

function ns.AddWideQuestLogPart(build)
	ns.hasWideQuestLog = true
	if ns.questLogIsOwnWindow then
		build()
	else
		wideQuestLogParts[#wideQuestLogParts + 1] = build
	end
end

local function StartWideQuestLog()
	ns.wideQuestLogActive = (ns.hasWideQuestLog and ns.db.profile.enableWideQuestLog) and true or false
	if ns.wideQuestLogActive then
		for _, build in ipairs(wideQuestLogParts) do
			securecall(build)
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
		if ns.hasQuestMap then
			ns.questMap.RequestRefresh()
		end
	end
	if ns.routes then
		ns.routes.ApplySettings()
	end
	if ns.dungeonQuests then
		ns.dungeonQuests.Watch()
	end
	for _, registryName in pairs(ns.OPTIONS_REGISTRY) do
		AceConfigRegistry:NotifyChange(registryName)
	end
end

--[[
    Characters from another game version, dropped without a word. AceDB keys
    a character "Name - Realm" on realm clients and "First Last" on the
    realm-free ones (WoW Forever), so a saved key shaped the other way from
    the one being played came from a copied WTF folder: its char section,
    its profile choice and, unless someone still uses it, its own profile go.
]]
local REALM_KEY_SEPARATOR = " - "

---@param characterKey any
---@param realmClient boolean
---@return boolean
local function IsOtherClientKey(characterKey, realmClient)
	if type(characterKey) ~= "string" then
		return true
	end
	return (characterKey:find(REALM_KEY_SEPARATOR, 1, true) ~= nil) ~= realmClient
end

---@param sv table # the saved table, or one of its namespaces
---@param realmClient boolean
---@param profilesInUse table<string, boolean>
---@return nil
local function PruneSavedTable(sv, realmClient, profilesInUse)
	local pruned = {}
	for _, section in ipairs({ "char", "profileKeys" }) do
		local characters = sv[section]
		if type(characters) == "table" then
			for characterKey in pairs(characters) do
				if IsOtherClientKey(characterKey, realmClient) then
					characters[characterKey] = nil
					pruned[characterKey] = true
				end
			end
		end
	end
	if type(sv.profiles) == "table" then
		for characterKey in pairs(pruned) do
			if not profilesInUse[characterKey] then
				sv.profiles[characterKey] = nil
			end
		end
	end
end

---@return nil
local function PruneOtherClientCharacters()
	local currentKey = ns.db.keys and ns.db.keys.char
	local sv = ns.db.sv
	if type(currentKey) ~= "string" or type(sv) ~= "table" then
		return
	end
	local realmClient = currentKey:find(REALM_KEY_SEPARATOR, 1, true) ~= nil
	local profilesInUse = { [ns.db.keys.profile or ""] = true }
	for characterKey, profileName in pairs(sv.profileKeys or {}) do
		if not IsOtherClientKey(characterKey, realmClient) then
			profilesInUse[profileName] = true
		end
	end
	PruneSavedTable(sv, realmClient, profilesInUse)
	for _, namespace in pairs(sv.namespaces or {}) do
		if type(namespace) == "table" then
			PruneSavedTable(namespace, realmClient, profilesInUse)
		end
	end
end

function ns:OnAddonLoaded(name)
	if name ~= ADDON_NAME then
		return
	end

	ns.db = LibStub("AceDB-3.0"):New(ns.SAVED_VARIABLES_NAME, ns.DATABASE_DEFAULTS, true)
	PruneOtherClientCharacters()
	for _, message in ipairs({ "OnProfileChanged", "OnProfileReset", "OnProfileCopied" }) do
		ns.db.RegisterCallback(ns, message, "ApplyProfile")
	end

	--[[
		The options panels and the events come first, so a feature that errors as it sets up below takes
		only itself down; each setup step runs through securecall, which reports its error and carries on.
		On Classic Era and TBC the quest log parts define their handlers as they run, so a second pass
		registers those events once the parts have run
	]]
	ns.RegisterOptionsPanels()
	RegisterLoadedEvents()

	StartWideQuestLog()
	RegisterLoadedEvents()
	securecall(ns.ApplyQuestGiverCleanup)
	if ns.OnDatabaseReady then
		securecall(ns.OnDatabaseReady, ns)
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
			ns:PrintMessage(L["CHAT_QUESTIE_MISSING_FEATURES"])
		end
	end)
end

function ns:OnPlayerLogin()
	ns:PrintWelcome()
	ns:WarnIfPredecessorLoaded()
	ns:NoteIfQuestieMissing()
end
