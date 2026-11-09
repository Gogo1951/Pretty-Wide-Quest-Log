local _, ns = ...

--[[
	Routes: TomTom's own quest arrow stands down while the Quest Arrow shows. On the clients where TomTom
	puts a waypoint on the quest objective being worked (its "poi" feature), a player with both would
	otherwise see two arrows pointing at different places. Through TomTom's public SuppressFeature, which
	lasts the session and leaves TomTom's saved settings alone; TomTom's settings show the feature as
	controlled by this add-on, and it comes back as soon as the Quest Arrow hides
]]

local routes = ns.routes
local L = ns.L

local FEATURE = "poi" -- TomTom's waypoint on the quest objective being worked

local suppressed = false

-- TomTom, if it's the real one with feature suppression: other add-ons make a TomTom table of their own
local function TomTom()
	local tomtom = _G.TomTom
	if type(tomtom) == "table" and tomtom.IsCrazyArrowEmpty and tomtom.SuppressFeature and tomtom.ReleaseFeature then
		return tomtom
	end
end

function routes.IsTomTomLoaded()
	local tomtom = _G.TomTom
	return type(tomtom) == "table" and tomtom.IsCrazyArrowEmpty ~= nil
end

function routes.IsTomTomQuestArrowSuppressed()
	return suppressed
end

local function StandDown(down)
	local tomtom = TomTom()
	if not tomtom or down == suppressed then
		return
	end
	suppressed = down
	if down then
		tomtom:SuppressFeature(L["ADDON_TITLE"], FEATURE)
	else
		tomtom:ReleaseFeature(L["ADDON_TITLE"], FEATURE)
	end
end

routes.arrowFrame:HookScript("OnShow", function()
	StandDown(true)
end)
routes.arrowFrame:HookScript("OnHide", function()
	StandDown(false)
end)
