local _, ns = ...

--[[
	The cell of the POI icons (Interface\\Minimap\\POIIcons) holding the corpse's gravestone, as this client's
	CorpsePinTemplate takes it: { left, right, top, bottom }
]]
ns.CORPSE_ICON_COORDS = { 0.56640625, 0.6328125, 0.001953125, 0.03515625 }

--[[
How We Got the Data

Last Validated
	Never.

Notes
	- The gravestone the route's corpse waypoint shows on the map (Features/Routes/Routes-Stop-Lines.lua), the
	  same cell the game's own CorpsePinTemplate marks the corpse with on the world map and minimap.
	- The retail sheet.
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
