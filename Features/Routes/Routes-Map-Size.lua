local _, ns = ...

--[[
	Routes: the world map opened full size while the Routes map shows (routes.KeepFullSize), unless
	another add-on sizes the map itself (routes.MapSizedElsewhere)
]]

local routes = ns.routes

--[[
	The map opens full size through its own miniWorldMap setting, which every client's map reads as it
	opens and maximizes itself by: calling its Maximize from here would run Blizzard's panel layout
	(SetUIPanelAttribute, MaximizeUIPanel) as add-on code. Kept off while the option is on, set again after
	the player shrinks the map, and never written in combat. Left alone entirely while an add-on that sizes
	the map itself is loaded (ns.MAP_SIZE_ADDONS)
]]
function routes.MapSizedElsewhere()
	for _, name in ipairs(ns.MAP_SIZE_ADDONS) do
		if C_AddOns.IsAddOnLoaded(name) then
			return name
		end
	end
end

local function KeepFullSize()
	local settings = routes.Settings()
	if not (settings.fullSizeMap and settings.showMap) or InCombatLockdown() then
		return
	end
	if routes.MapSizedElsewhere() then
		return
	end
	if GetCVarBool("miniWorldMap") then
		ns.TrackerTaintStep("SetCVar", SetCVar, "miniWorldMap", "0")
	end
end
routes.KeepFullSize = KeepFullSize
