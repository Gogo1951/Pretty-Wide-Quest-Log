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
		zoneShareOffer = true,
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
		showZoneInfo = true, -- Zone Info under the map (Zone-Info.lua)
		--[[
			Each text area's font (Fonts.lua). face: "" is the game's font, a GAME_FONTS key one of the game's
			others, anything else a SharedMedia font by name. size: points from the game's size. outline:
			DEFAULT keeps the game's. shadow false takes the game's shadow away. slug: Blizzard's sharper renderer
		]]
		fonts = {
			list = { face = "", size = 0, outline = "DEFAULT", shadow = true, slug = true },
			details = { face = "", size = 0, outline = "DEFAULT", shadow = true, slug = true },
			dialogue = { face = "", size = 0, outline = "DEFAULT", shadow = true, slug = true },
			window = { face = "", size = 0, outline = "DEFAULT", shadow = true, slug = true },
		},
		routes = {
			showArrow = true, -- The Quest Arrow feature
			showMap = true, -- The Waypoint Markers feature: the route's markers on the world map, and anything else Routes draws there
			hideQuestieIcons = true, -- On the world map, Questie's icons and Blizzard's quest markers and objective areas for what's on the route, and Questie's party objective icons
			-- Waypoint Markers
			fullSizeMap = true, -- The map opens maximized while the markers are on it
			markerScale = 1, -- The stop markers' size on the zone map, times their 32 pixels
			-- Maps & Objectives: where else the markers show, each with its own size (Routes-Map.lua, Routes-Minimap.lua)
			showWideMapMarkers = true, -- Markers on a continent's or the world's map too
			wideMarkerScale = 1, -- Their size there, times the zone map's Medium shrunk to fit (WIDE_MAP_SCALE)
			showMinimapMarkers = false, -- The route's waypoints on the minimap; off, as Questie's icons there show each spawn
			minimapMarkerScale = 1, -- Their size there, times their 24 pixels
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
			predictiveRoutes = false, -- Quests the zone can finish planned whole with their follow-ups, and turn-ins shown before they're done; off, as it's a lot at first
			showLocalQuests = true, -- Quests Questie shows as available, whose giver is nearby, as waypoints to pick up
			showFlightPaths = true, -- Flight masters in the zone whose flight path the character doesn't have, as waypoints
			--[[
				Local Available Quests: which nearby quests count. The three kinds of quest below the level each
				take "route", "map" (a marker, no route line) or "off"
			]]
			localQuestRange = 400, -- Yards a quest giver can be from the player
			localQuestLevel = "green", -- Lowest level: "questie" (Questie's own filter), "green" or "yellow" and higher
			localEscortQuests = "map",
			localGroupQuests = "map", -- Group and elite quests
			localOtherZoneQuests = "map", -- An objective or the turn-in only in another zone
			hideInRaids = true,
			hideInInstances = true,
			partyQuests = true, -- Party members' quests the player doesn't have, as their Questie shares them
			groupUp = true, -- A party member off the minimap: the arrow leads to a meeting spot on the way
		},
	},
	global = {
		scale = 1,
		mapScale = 1,
	},
	char = {
		routesIgnored = {}, -- The Quest Arrow's ignores of the character's own objectives, by task key, until the zone is reset
		routesFlightMasters = {}, -- Flight masters whose flight path the character has, by NPC ID, as flight maps showed (Routes-Flights.lua)
		zoneShareOffered = {}, -- Party members offered the zone's quests in this group, by GUID, kept through a reload (Zone-Share-Offer.lua)
		routesFlightMapSeen = {}, -- Continents whose flight map was read (all for a new character): until then no flight path goes on the route there
		zoneInfoWanted = {}, -- Quests Zone Info's + put on the route, by quest ID, until taken or done (Zone-Info-Data.lua)
	},
}
