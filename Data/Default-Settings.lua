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
			showArrow = true, -- The Quest Arrow feature
			showMap = true, -- The Waypoint Markers feature: the route's markers on the world map, and anything else Routes draws there
			hideQuestieIcons = true, -- On the world map, Questie's icons and Blizzard's quest markers and objective areas for what's on the route, and Questie's party objective icons
			-- Waypoint Markers
			fullSizeMap = true, -- The map opens maximized while the markers are on it
			markerScale = 1, -- The stop markers' size, times their 42 pixels
			-- Quest Route
			showLine = true, -- The Quest Route feature: the marching dots between the stops, drawn only with the markers (showMap)
			lineSpeed = 1.5, -- Dots a second the line marches; 0 holds it still
			lineOpacity = 0.8,
			-- Quest Arrow
			arrowScale = 1,
			lockArrow = false, -- Dragging it does nothing
			showDistance = true, -- The yards under it; "Current Objective Area" and "You're There" show either way
			showQuests = true, -- The quests and objectives under it
			questsListed = 4, -- Quests listed at most; the rest are counted
			showItemButtons = true, -- A Use Item button beside each listed quest with an item to use
			showNextObjective = false, -- In an objective area, the waypoint after it, dimmed under the list
			showUpcomingTurnIns = false, -- A quest's turn-in planned before it's done, Questie's gray question mark
			showLocalQuests = false, -- Quests Questie shows as available, whose giver is nearby, as waypoints to pick up
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
