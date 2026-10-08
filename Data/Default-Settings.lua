local _, ns = ...

-- The window's height and point live in global with no default: Reset Profile must not move or resize it.
ns.DATABASE_DEFAULTS = {
	profile = {
		showWelcome = true,
		enableWideQuestLog = true,
		zoneGap = true,
		markUntracked = true,
		zoneSort = "LEVEL_HIGHEST_FIRST",
		questSort = "LEVEL_HIGHEST_FIRST",
	},
	global = {},
}
