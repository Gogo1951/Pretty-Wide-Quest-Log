local _, ns = ...

-- [uiMapArtID] = { -- Zone Name (uiMapID) | ["Width:Height:OffsetX:OffsetY"] = "Texture File IDs", },
ns.MAP_REVEAL_OVERLAYS = {}

--[[
How We Got the Data

Last Validated
	Never.

Notes
	- Every area of a zone's map that starts hidden until the character explores it, so the quest map can show the
	  whole zone (Features/Quest-Map-Reveal.lua). Keyed by the map's art ID (C_Map.GetMapArtID), which each client
	  numbers its own way, so no row is shared between folders.
	- Each key is the area's size and position on the map art, in the same form the client's own explored areas
	  report theirs (C_MapExplorationInfo.GetExploredMapTextures), so an area the character has explored is skipped
	  and Blizzard's copy is drawn instead.
	- Each value lists the client's own texture files for that area, left to right then top to bottom, one per
	  tile of the map art's tile size. No art ships with the add-on; these are the game's files.
	- Empty: this flavor's areas haven't been gathered yet, so its quest map shows only what the character has
	  explored.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	None.

QuestieDB
	None.
]]
