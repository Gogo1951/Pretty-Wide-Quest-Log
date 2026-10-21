local _, ns = ...

--[[
	The window's height, point and scale, the map's scale, and whether the map is hidden (mapHidden) live
	in global, so Reset Profile never moves, resizes, rescales or hides them. Height, point and mapHidden
	have no default
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
	},
	global = {
		scale = 1,
		mapScale = 1,
	},
}
