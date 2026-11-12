local _, ns = ...

-- { left, right, top, bottom }
ns.CORPSE_ICON_COORDS = { 0.56640625, 0.6328125, 0.001953125, 0.03515625 }

--[[
How We Got the Data

Last Validated
	2026-11-12, WoW Forever 1.60.1.70888

Notes
	- The cell of the POI icons (Interface\\Minimap\\POIIcons) holding the corpse's gravestone, as this client's
	  CorpsePinTemplate takes it, given as texture coordinates.
	- The gravestone the route's corpse waypoint shows on the map (Features/Routes/Routes-Stop-Look.lua), the
	  same cell the game's own CorpsePinTemplate marks the corpse with on the world map and minimap.
	- WoW Forever ships the retail sheet, laid out differently from the Classic clients'.
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
