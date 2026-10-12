local _, ns = ...

--[[
	The window's height, point and scale, and the map's scale, live in global, so Reset Profile never moves
	or resizes them. Height and point have no default
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		showWelcome = true,
		enableQualityOfLife = true,
		giverCleanup = true,
		giverLevels = true,
		shareInterval = 3,
		shareWhispers = true,
		enableWideQuestLog = true,
		zoneGap = true,
		showQuestLevels = true,
		markUntracked = true,
		zoneSort = "LEVEL_HIGHEST_FIRST",
		currentZoneFirst = true,
		questSort = "LEVEL_HIGHEST_FIRST",
		completedFirst = true,
		closeInCombat = false,
	},
	global = {
		scale = 1,
		mapScale = 1,
	},
}
