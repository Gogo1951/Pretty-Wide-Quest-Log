local _, ns = ...

--[[
	The window's height, point and scale, the map's scale, whether the map is hidden (mapHidden), and where
	the Quest Arrow was dragged (routesArrowPoint) live in global, so Reset Profile never moves, resizes,
	rescales or hides them. Height, point, mapHidden and routesArrowPoint have no default
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		showWelcome = true,
		enableQualityOfLife = true,
		giverCleanup = true,
		giverLevels = true,
		shareInterval = 3,
		shareWhispers = true,
		dungeonAnnounce = true,
		dungeonShare = true,
		enableWideQuestLog = true,
		zoneGap = true,
		showQuestLevels = true,
		markUntracked = true,
		zoneSort = "LEVEL_HIGHEST_FIRST",
		currentZoneFirst = true,
		questSort = "LEVEL_HIGHEST_FIRST",
		completedFirst = true,
		closeInCombat = false,
		showObjectiveAreas = true,
		routes = {
			enabled = true,
			showArrow = true,
			showMap = true,
			hideQuestieIcons = true, -- On the world map, Questie's icons for the objectives and turn-ins on the route
			-- Routes on Zone Map
			fullSizeMap = true, -- The map opens maximized while the route is on it
			markerScale = 1, -- The stop markers' size, times their 42 pixels
			showLine = true, -- The marching dots between the stops
			lineSpeed = 1.5, -- Dots a second the line marches; 0 holds it still
			lineOpacity = 0.8,
			-- Quest Arrow
			arrowScale = 1,
			lockArrow = false, -- Dragging it does nothing
			showDistance = true, -- The yards under it; "Objective Area" and "You're there" show either way
			cycleSeconds = 12, -- In an objective area, the eye's turn and the arrow's together
			showQuests = true, -- The quests and objectives under it
			questsListed = 4, -- Quests listed at most; the rest are counted
			hideInRaids = true,
			hideInInstances = true,
			partyQuests = true, -- Party members' quests the player doesn't have, as their Questie shares them
		},
	},
	global = {
		scale = 1,
		mapScale = 1,
	},
}
