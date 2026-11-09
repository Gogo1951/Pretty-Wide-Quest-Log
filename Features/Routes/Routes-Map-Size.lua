local _, ns = ...

--[[
	Routes: the world map opened full size while the Routes map shows (routes.KeepFullSize)
]]

local routes = ns.routes

--[[
	The map opens full size through its own miniWorldMap setting, which every client's map reads as it
	opens and maximizes itself by: calling its Maximize from here would run Blizzard's panel layout
	(SetUIPanelAttribute, MaximizeUIPanel) as add-on code. Kept off while the option is on, set again after
	the player shrinks the map, and never written in combat. Map add-ons don't stand in the way: Leatrix
	Maps and Mapster never read miniWorldMap, and both keep their own scale and position for each size,
	applied as the map changes size (SynchronizeDisplayState), so they lay out the full-size map too
]]
local function KeepFullSize()
	local settings = routes.Settings()
	if not (settings.fullSizeMap and settings.showMap) or InCombatLockdown() then
		return
	end
	if GetCVarBool("miniWorldMap") then
		ns.TrackerTaintStep("SetCVar", SetCVar, "miniWorldMap", "0")
	end
end
routes.KeepFullSize = KeepFullSize
