local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

--[[
	The cell of the POI icons (Interface\\Minimap\\POIIcons) holding the corpse's gravestone, as this client's
	CorpsePinTemplate takes it: { left, right, top, bottom }
]]
ns.CORPSE_ICON_COORDS = { 0.875, 1, 0, 0.125 }

--[[
How We Got the Data

Last Validated
	2026-11-13, Season of Discovery 1.15.9.70576

Notes
	- The gravestone the route's corpse waypoint shows on the map (Features/Routes/Routes-Stop-Look.lua), the
	  same cell the game's own CorpsePinTemplate marks the corpse with on the world map and minimap.
	- Season of Discovery uses Classic Era's sheet.
	- Carried over unchanged from Routes-Stop-Lines.lua, where the cell was chosen by flavor.

SQL (CMaNGOS)
	None.

Wowhead
	None.

wago.tools
	None.

QuestieDB
	None.
]]
