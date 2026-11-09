local _, ns = ...

--[[
	Routes: Blizzard's own quest markers and objective areas on the world map (WoW Forever, behind its
	questPOI setting), hidden while the Routes map shows, so the route's markers aren't drawn over the same
	objectives two and three times. Hidden on the map only: the questPOI setting is left as the player has it,
	so the tracker, the minimap and Questie's objective style are untouched
]]

local routes = ns.routes

local hidden = setmetatable({}, { __mode = "k" }) -- The pins hidden here, to show again
local questProviders, blobProviders = {}, {}

--[[
	Whether a provider on the map was made from one of Blizzard's mixins: most of the mixin's functions are
	its own, so one another add-on post-hooked still counts
]]
local function IsFromMixin(object, mixin)
	local same, total = 0, 0
	for key, value in pairs(mixin) do
		if type(value) == "function" then
			total = total + 1
			if object[key] == value then
				same = same + 1
			end
		end
	end
	return total > 0 and same * 2 > total
end

-- The quests the route and the camps stand in for, objectives and turn-ins alike
local function RouteQuests()
	local quests, any = {}, false
	for _, list in ipairs({ routes.stops, routes.camps }) do
		for _, stop in ipairs(list) do
			for _, task in ipairs(stop.tasks) do
				if task.questID then
					quests[task.questID] = true
					any = true
				end
			end
		end
	end
	return quests, any
end

-- The template a marker layer's pins are made from, Blizzard's own name where the layer doesn't say
local function MarkerTemplate(provider)
	return provider.GetPinTemplate and provider:GetPinTemplate() or "QuestPinTemplate"
end

local function SetHidden(pin, hide)
	if hide then
		if pin:IsShown() then
			pin:Hide()
			hidden[pin] = true
		end
	elseif hidden[pin] then
		hidden[pin] = nil
		pin:Show()
	end
end

--[[
	Hides Blizzard's quest markers for the route's quests, and the objective area layer, which draws every
	quest's area on one pin, while the route has anything on the map; shows again what it hid otherwise.
	Only Hide and Show are called: no Blizzard function or field is replaced or written, so the map stays
	untainted, and a marker Blizzard hands out again shows on its own
]]
local function ApplyBlizzardQuests()
	if not WorldMapFrame then
		return
	end
	local hide = routes.IsMapShown() and routes.Settings().hideQuestieIcons
	local quests, any = RouteQuests()
	hide = hide and any
	for _, provider in ipairs(questProviders) do
		for pin in WorldMapFrame:EnumeratePinsByTemplate(MarkerTemplate(provider)) do
			SetHidden(pin, hide and pin.questID ~= nil and quests[pin.questID])
		end
	end
	for _, provider in ipairs(blobProviders) do
		if provider.pin then
			SetHidden(provider.pin, hide)
		end
	end
end

-- Blizzard redraws its layers as the map changes or quests update, a marker at a time, so a redraw is checked once it's done
local applyPending
local function RequestApplyBlizzardQuests()
	if applyPending then
		return
	end
	applyPending = true
	C_Timer.After(0, function()
		applyPending = nil
		ApplyBlizzardQuests()
	end)
end

--[[
	Finds Blizzard's quest marker and objective area layers on the world map, and post-hooks their redraws
	on those providers alone (hooksecurefunc, never a replacement). A client without them finds none
]]
local function HookBlizzardQuests(map)
	local quest, blob = QuestDataProviderMixin, QuestBlobDataProviderMixin
	if not (map.dataProviders and (quest or blob)) then
		return
	end
	for provider in pairs(map.dataProviders) do
		local list = (quest and IsFromMixin(provider, quest) and questProviders)
			or (blob and IsFromMixin(provider, blob) and blobProviders)
		if list and type(provider.RefreshAllData) == "function" then
			list[#list + 1] = provider
			hooksecurefunc(provider, "RefreshAllData", RequestApplyBlizzardQuests)
		end
	end
end

-- What was found and what's hidden now, for the Zone Map report (Diagnostics/Manifests.lua)
function routes.BlizzardQuestLayers()
	local count = 0
	local function Count(pin)
		if hidden[pin] and not pin:IsShown() then
			count = count + 1
		end
	end
	for _, provider in ipairs(questProviders) do
		for pin in WorldMapFrame:EnumeratePinsByTemplate(MarkerTemplate(provider)) do
			Count(pin)
		end
	end
	for _, provider in ipairs(blobProviders) do
		if provider.pin then
			Count(provider.pin)
		end
	end
	return { markers = #questProviders, areas = #blobProviders, hidden = count }
end

-- The route calls these as it draws and as it's added to the map (Routes-Map.lua)
routes.ApplyBlizzardQuests = ApplyBlizzardQuests
routes.HookBlizzardQuests = HookBlizzardQuests
