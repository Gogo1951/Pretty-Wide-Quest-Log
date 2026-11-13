# Pretty Wide Quest Log // Technical Reference

> Code map for working on Pretty Wide Quest Log: where things live, how they connect, and the traps. Where this and the code disagree, the code wins. For players, see [README.md](https://github.com/Gogo1951/Pretty-Wide-Quest-Log/blob/main/README.md).

## File Map

```
Pretty-Wide-Quest-Log/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── config.yml                      This add-on's New issue page: blank-issue link, Discord, CurseForge
│   │   ├── defect.yml                      Shared, from Common-Core
│   │   └── request.yml                     Shared, from Common-Core
│   └── workflows/
│       ├── ci.yml                          Calls Common-Core: CI checks on every PR and push to main
│       ├── issue-labels.yml                Calls Common-Core: labels a new Defect by its Issue Type
│       └── package.yml                     Calls Common-Core: release packaging on a tag
├── .gitattributes                          Shared, from Common-Core
├── .gitignore                              Shared, from Common-Core
├── .luacheckrc                             Lint config: WoW globals read, the few the add-on writes
├── .pkgmeta                                Externals and ignore list; strips Data/Wrath and Data/Mainline
├── Bindings.xml                            The Use Quest Item key binding; the client loads it, no TOC line
├── Pretty-Wide-Quest-Log_Vanilla.toc       Classic Era, Season of Discovery included; Vanilla and Discovery data both
├── Pretty-Wide-Quest-Log_TBC.toc           TBC Anniversary
├── Pretty-Wide-Quest-Log_Camelot.toc       WoW Forever
├── Pretty-Wide-Quest-Log_Mists.toc         Mists of Pandaria Classic
├── Data/
│   ├── Flavor.lua                          The flavor from the TOC's X-Flavor: ns.FLAVOR, ns.IS_DISCOVERY, ns.DATA_FOLDER
│   ├── Data.lua                            Identity, links, palette, options registry, ns.LAYOUT, message and timing constants
│   ├── Default-Settings.lua                AceDB defaults: profile with its Routes and fonts subtables, global, char
│   └── {Game}/                             Vanilla, Discovery, TBC, Camelot, Mists; Wrath and Mainline ship to no client
│       ├── Map-Icons-{Game}.lua            The corpse gravestone's cell on the POI icon sheet, for the route
│       ├── Map-Reveal-{Game}.lua           The docked map's unexplored areas, by map art ID
│       ├── Quest-Item-Counts-{Game}.lua    How many of each item a quest asks for, for Zone Info's Things to Bring
│       ├── Quest-Tags-{Game}.lua           Quest tag IDs to the level tag's letter
│       ├── Sample-Quests-{Game}.lua        The quests and areas the Example lines name
│       └── Wowhead-{Game}.lua              The flavor's Wowhead quest address, a single setting
├── Diagnostics/                            Diagnostic Tools, copied whole; Manifests.lua is this add-on's part
├── Features/
│   ├── Core.lua                            Event table and dispatcher, AceDB, the Wide Quest Log switch and parts, login notices
│   ├── Utilities.lua                       Colors, number grouping, ns.IsReadable, Questie imports and log, VoiceOver, share helpers
│   ├── Fonts.lua                           Font areas: copies of Blizzard's fonts with each area's settings, SharedMedia faces
│   ├── Announcements.lua                   Player prints, messages for others with the marker, quest references within 255 bytes
│   ├── Key-Bindings.lua                    Set Key's route to the game's Key Bindings list, General panel repaint
│   ├── Quest-Log-API.lua                   Quest log by quest ID on every client: entries, select, share, abandon, tags, titles
│   ├── Share-Needs.lua                     Who in the group needs a quest shared; WoW Forever's share held until combat ends
│   ├── Quest-Details-Data.lua              WoW Forever and Mists: the selected quest's details as plain data
│   ├── Quest-Sort.lua                      The sort rules both quest logs share, the frozen zone order, the current zone's match
│   ├── Quest-Display.lua                   Level tags and their legend, quest titles, quest ID
│   ├── Quest-Objectives.lua                Objective lines on both quest logs: check, count column, inline icons, inset
│   ├── Quest-Info-Style.lua                Quest text styling: headings, spacing, Blizzard's style kept to put back
│   ├── Quest-Rewards.lua                   Experience and gold styling, reward button and rewards block spacing
│   ├── Tracking-Mark.lua                   The tracking mark in the list, and whether Questie's tracker has taken over
│   ├── Wowhead-Link.lua                    Clickable quest IDs and the Wowhead address copy popup
│   ├── Quest-Chain-Data.lua                The selected quest's chain from Questie's database, each part's label and color
│   ├── Quest-Chain.lua                     The Quest Chain section of the details
│   ├── Quest-Giver.lua                     Quest giver window cleanup: gate, own text, page spacing, description fade fix
│   ├── Quest-Giver-Skins.lua               What skins (ElvUI) change on the quest giver window, put right
│   ├── Gossip.lua                          Gossip greeting style and its measuring copy, line spacing, level tags
│   ├── Quest-Giver-Pages.lua               The quest giver's greeting and progress pages, the progress page's quest ID
│   ├── Window.lua                          Window title, art, height clamp, resize grip and list buttons, both quest logs
│   ├── Turn-In-Line.lua                    The Ready to Turn In line and its tooltip, from Questie's quest data
│   ├── Classic-Tracking.lua                Classic Era and TBC: Track All and Untrack All by log index
│   ├── Classic-Quest-Sort.lua              Classic Era and TBC: the sorted order, and Blizzard's rows redrawn to show it
│   ├── Classic-Quest-Rows.lua              Classic Era and TBC: the list's rows, how many show and where each goes
│   ├── Classic-Quest-List.lua              Classic Era and TBC: list update, row style, list buttons, zone name hovers
│   ├── Classic-VoiceOver.lua               Classic Era and TBC: VoiceOver's play buttons on the sorted rows
│   ├── Classic-Quest-Details.lua           Classic Era and TBC: detail pane layout, rewards, chain, daily reset, quest ID
│   ├── Classic-Quest-Log.lua               Classic Era and TBC: widens Blizzard's window, art, resizing, scale, combat close
│   ├── Classic-Zone-Actions.lua            Classic Era, TBC and Mists: share runs, log quests, shareability by selecting
│   ├── Classic-Quest-Map.lua               Classic Era and TBC: exploration layer, its combat hold, following the selection
│   ├── Classic-ElvUI.lua                   Classic Era and TBC: ElvUI styling of the add-on's pieces, opaque backdrop
│   ├── Forever-Tracking.lua                WoW Forever: tracking and Track All by quest ID, deferring to Questie's tracker
│   ├── Forever-Quest-Log.lua               WoW Forever and Mists: the own window, buttons, repaints, side windows, scale
│   ├── Quest-Log-Key.lua                   WoW Forever and Mists: the quest log key, bound over to the window
│   ├── Forever-Quest-Log-Key.lua           WoW Forever: micro menu and tracker clicks taken over from the world map
│   ├── Forever-Quest-List-Entries.lua      WoW Forever and Mists: the list's entries, built from the log and sorted
│   ├── Forever-Quest-List-Party.lua        WoW Forever and Mists: party members on a quest, the row's count and names
│   ├── Forever-Quest-List.lua              WoW Forever and Mists: list rows, clicks, right-click menu, list buttons
│   ├── Forever-Quest-Details-Rewards.lua   WoW Forever and Mists: reward buttons, tooltips, links, item loading
│   ├── Forever-Quest-Details.lua           WoW Forever and Mists: the detail pane, drawn on frames of its own
│   ├── Forever-Quest-Giver.lua             WoW Forever and Mists: quest giver gold, experience and quest ID
│   ├── Forever-VoiceOver.lua               WoW Forever and Mists: VoiceOver's or Spoken Quests' play buttons on the rows
│   ├── Forever-Zone-Actions.lua            WoW Forever: share runs, log quests and shareability by quest ID
│   ├── Forever-Quest-Map.lua               WoW Forever and Mists: Blizzard's map layers, the marker, combat holds
│   ├── Mists-Tracking.lua                  Mists: tracking and Track All by log index, redrawing WatchFrame
│   ├── Mists-Quest-Log-Key.lua             Mists: micro menu and tracker clicks taken over from Blizzard's quest log
│   ├── Mists-Quest-Portrait.lua            Mists: the quest giver's model under or beside the map, or beside the window
│   ├── Zone-Share.lua                      The Share Quests button on a hovered zone name, every client
│   ├── Share-Reminders.lua                 The whisper when a quest share fails for a reason the member can fix
│   ├── Zone-Share-Offer.lua                On joining a party, whispers members in your zone how many of its quests they lack
│   ├── Dungeon-Quest-Lookup.lua            The current dungeon or zone, and which logged quests are its
│   ├── Dungeon-Quests.lua                  In a party dungeon, announces its quests and shares them with each member once
│   ├── Player-Map-Pin.lua                  The docked map's player arrow: position and facing
│   ├── Quest-Map.xml                       The docked map's canvas frame and pin templates, which only XML can build
│   ├── Quest-Map.lua                       The map beside the window: layout, Map Scale, Show Map / Hide Map, pin mixin
│   ├── Questie-Map.xml                     Pin templates for Questie's icons and objective areas
│   ├── Questie-Map.lua                     Questie's icons on the docked map, the zone dropdown, refreshing
│   ├── Questie-Map-Tooltip.lua             The tooltip on the docked map's Questie icons
│   ├── Questie-Map-Quest-Giver.lua         The zone a quest was given in, for picking a quest's map
│   ├── Questie-Map-Areas.lua               Each objective's spawns clustered into the shapes of its areas
│   ├── Questie-Map-Area-Layer.lua          The map-sized pin the objective areas are shaded on
│   ├── Quest-Map-Reveal.lua                The docked map's unexplored areas, drawn so the whole zone shows
│   ├── Zone-Info-Data.lua                  Zone Info's lists for a zone from Questie, a few quests a frame; the route's wanted pick-ups
│   ├── Zone-Info.lua                       Zone Info: the box under the map, its zone menu and its two columns
│   └── Routes/
│       ├── Routes.xml                      Routes' load order, and the line, waypoint and join-up pin templates
│       ├── Routes-Core.lua                 Settings and SetSetting, listeners, login handlers, migrations, shared helpers
│       ├── Routes-Planner.lua              The planner coroutine and frame budget, the watcher, when to plan again
│       ├── Routes-Ignore.lua               The ignore list: saved and group-only ignores, kept by zone, zone reset
│       ├── Routes-Solver.lua               Orders the route: cheapest insertion, or-opt, 2-opt, seeded shakes, warm starts
│       ├── Routes-Party.lua                Party members' quests from Questie's shared logs, member names and presence
│       ├── Routes-Group-Up.lua             Joining up with the group when anyone is off the minimap
│       ├── Routes-Geography.lua            Position and zone in world yards, a ghost's corpse, maps within a zone
│       ├── Routes-Questie.lua              Questie's log, escorts, timers, instance quests, the replan signature
│       ├── Routes-Blobs.lua                Spawns into blobs, and each objective's candidate places
│       ├── Routes-Nodes.lua                Own and party quests into objective and turn-in nodes
│       ├── Routes-Pick-Ups.lua             Quests to pick up nearby: Local Available Quests, free quest slots
│       ├── Routes-Quest-Plans.lua          A quest not yet taken: its objectives and turn-in from Questie's database
│       ├── Routes-Chains.lua               Quest chains planned ahead: predicted objectives, turn-ins, follow-ups
│       ├── Routes-Flights.lua              Flight paths to discover, and known ones as shortcuts: read from flight maps
│       ├── Routes-Pinning.lua              Progress, camps worked and left, and the node pinned first
│       ├── Routes-Overlaps.lua             Two objectives at once: riders where spawns overlap, shared camp credit
│       ├── Routes-Stops.lua                Ordered nodes merged into waypoints, and each task's text and color
│       ├── Routes-Stop-Lines.lua           A waypoint's quests as lines, for the Quest Arrow and the map tooltip
│       ├── Routes-Camps.lua                Every place each objective can be done, continent-wide, for the maps
│       ├── Routes-Stop-Look.lua            A marker's disc, ring and icon, for world map and minimap markers
│       ├── Routes-Map-Size.lua             The full-size world map, through the miniWorldMap CVar
│       ├── Routes-Map-Line.lua             The route's marching line of dots on the world map
│       ├── Routes-Map-Questie-Icons.lua    Questie's icons hidden under the markers, and the textures they borrow
│       ├── Routes-Map-Blizzard-Quests.lua  Blizzard's quest markers and objective areas hidden under the route
│       ├── Routes-Map-Tooltip.lua          A waypoint's or camp's tooltip on the world map
│       ├── Routes-Map.lua                  The route's markers on the world map: data provider, clicks, frame levels
│       ├── Routes-Map-Meet.lua             The join-up marker on the world map
│       ├── Routes-Minimap.lua              The route's waypoints on the minimap, off by default
│       ├── Routes-Arrow-Survey.lua         What the Quest Arrow sees: the areas the player is in, what's next, where to point
│       ├── Routes-Arrow.lua                The Quest Arrow: when it shows, pointing, its colors, the eye, dragging
│       ├── Routes-Arrow-List.lua           The quest list under the Quest Arrow, and the title rows item buttons read
│       ├── Routes-Arrow-Item-Choice.lua    Which items get a Use Item button, and where
│       ├── Routes-Arrow-Items.lua          The secure Use Item buttons, their combat holds and the binding's names
│       ├── Routes-Arrow-Shade.lua          The edgeless shade behind the Quest Arrow on hover
│       ├── Routes-Arrow-Menu-Panel.lua     The Quest Arrow menu's plates, row layout and flyout placement
│       ├── Routes-Arrow-Menu.lua           The Quest Arrow menu's rows, opening and closing, right-click ignore
│       └── Routes-TomTom.lua               TomTom's own quest arrow stood down while the Quest Arrow shows
├── Includes/
│   ├── Images/                             Icon, window art (PWQL_*), party icon, Routes art (Route-*)
│   └── Libraries/                          Vendored LibStub, CallbackHandler, Ace3 and LibSharedMedia, never edited
├── Locales/                                The enUS.lua source of truth and ten more locales
├── Options/
│   ├── Options-Utilities.lua               Shared rows: feature and Routes switches, status lines, Example lines, reload prompt
│   ├── Options-Fonts.lua                   The Font section each Wide Quest Log and NPC Dialogue panel ends with
│   ├── Options-General.lua                 Root panel: welcome, the feature switches, Use Quest Item key row
│   ├── Options-Quest-Log.lua               Wide Quest Log panel and its Quest List, Quest Details, Window & Map panels
│   ├── Options-NPC-Dialogue.lua            NPC Dialogue panel: quest giver window cleanup, its levels, dialogue font
│   ├── Options-Quality-of-Life.lua         Quality of Life panel: sharing, whispers, zone offers, dungeon quests
│   ├── Options-Routes-Map.lua              Quest Route panel: the line, party objectives, joining up
│   ├── Options-Quest-Arrow.lua             Quest Arrow panel: size, lock, text, item buttons, Local Available Quests, hiding
│   ├── Options-Maps.lua                    Maps & Objectives panel and its Mini-Map, Zone Map, Continent & World Map panels
│   ├── Options-Profiles.lua                Stock AceDBOptions
│   ├── Options-Feedback-Support.lua        Feedback & Support panel
│   └── Options.lua                         Registration (panels under panels too), opener, combat guard, /pwql
├── LICENSE
├── README.md                               Player-facing overview
├── README-Notes.md                         Recorded exceptions to the Style Guide
├── README-Technical.md                     This document
└── README-Testing.md                       Manual test plan
```

Retired, so don't bring them back: an unsuffixed TOC; the root-level `Legacy.lua`, `Modern.lua`, `Common.lua`, `Layout.lua` and `img/` (their code lives in `Features/`, art in `Includes/Images/`); `Features/Forever-Quest-Map.xml` (every client loads `Features/Quest-Map.xml`); `Features/Zone-Menu.lua` (replaced by `Features/Zone-Share.lua`); `Options/Options-Forever-Quest-Log.lua` (its switch is on the Wide Quest Log panel, its reload prompt in `Options/Options-Utilities.lua`); the `WOWHEAD_QUEST_URLS` table (each flavor's address is its own `Data/{Game}/Wowhead-{Game}.lua`); `ns.MAP_SIZE_ADDONS` (the full-size map works beside map add-ons; see The Zone Map); and a custom player icon (the world map and minimap keep Blizzard's own player arrow and party dots; only the docked map draws one, `Player-Map-Pin.lua`).

## Architecture

### Two Quest Logs, One Layout

- **Classic Era and TBC** ship Blizzard's classic `QuestLogFrame`; the `Features/Classic-*.lua` files widen it in place: move Blizzard's regions and rows, swap the art, and post-hook `QuestLog_Update`, `QuestLog_SetSelection`, `QuestLogTitleButton_OnClick` (list file, which calls the sort file's order and redraws) and `QuestLog_UpdateQuestDetails`, `QuestFrameItems_Update` (details file). `Classic-Quest-Rows.lua` makes and places the rows (`ns.CreateClassicQuestRows`, called from the list's part); `Classic-Quest-Log.lua` owns the window, art, resizing, scale and Close When Combat Starts.
- **WoW Forever** runs the Retail engine, whose quest log is docked in the world map, so there's nothing to widen: `Forever-Quest-Log.lua` builds a window of its own (`PrettyWideQuestLogFrame`, `ns.questLogFrame`; shared state in `ns.questLog`) and the other `Forever-*.lua` files fill it.
- **Mists** keeps Blizzard's `QuestLogFrame` but runs the same own window and takes over from Blizzard's (see Taint).
- Each TOC picks its files; no quest log file asks which flavor it's on. Order in every TOC: libraries, locales, `Data/`, the shared Features (`Core.lua` through `Turn-In-Line.lua`), the client's quest log set, sharing and dungeon files, the map files, `Features/Routes/Routes.xml`, Diagnostics, Options (`Options.lua` last).
  - Classic Era / TBC: `Classic-Tracking`, `-Quest-Sort`, `-Quest-Rows`, `-Quest-List`, `-VoiceOver`, `-Quest-Details`, `-Quest-Log`, `-Zone-Actions`; `Classic-Quest-Map.lua` after the shared map files; `Classic-ElvUI.lua` after `Routes.xml`. The log's part reads `ns.GetQuestRowHeight`, which exists only once the list's part has built its rows.
  - WoW Forever: `Forever-Tracking.lua`, `Forever-Quest-Log.lua`, shared `Quest-Log-Key.lua`, `Forever-Quest-Log-Key.lua`, then list entries, list party, list, details rewards, details, quest giver, VoiceOver, zone actions; `Forever-Quest-Map.lua` after the shared map files.
  - Mists: the WoW Forever set with `Mists-Tracking.lua`, `Mists-Quest-Log-Key.lua`, `Classic-Zone-Actions.lua` (its quest log calls are by index), and `Mists-Quest-Portrait.lua` after `Routes.xml`.
  - `Quest-Details-Data.lua` is in the WoW Forever and Mists TOCs only.
- **Quest log access by quest ID**: the `ns` accessors in `Features/Quest-Log-API.lua` (`ns.GetQuestLogEntry`, `ns.GetLogIndexForQuestID`, `ns.SelectQuest`, `ns.SetQuestZoneCollapsed`, `ns.IsPushableQuest`, `ns.ShareQuest`, `ns.AskToAbandonQuest`, `ns.GetQuestTagByID`, `ns.GetQuestTitleByID`, `ns.IsUnitOnQuest`, `ns.IsDailyFrequency`, …), loaded everywhere. Client's own calls where `C_QuestLog.GetInfo` exists (WoW Forever); elsewhere they walk the log by index, and those that act select, act, then put the selection back (`WithQuestSelected`). Each call is chosen once at load. WoW Forever's `ns.ShareQuest` lives in `Share-Needs.lua` (held through combat, see Combat Lockdown).
- **Details data** (WoW Forever and Mists): `ns.GetSelectedQuestDetails` (`Quest-Details-Data.lua`) returns text, objectives and rewards as plain tables; `Forever-Quest-Details.lua` draws them (see Taint, Quest Text).
- **Feature tests, not flavor tests.** Shared code tests for the API or mixin (`FogOfWarFrameMixin`, `C_QuestLog.GetNextWaypointForMap`, `C_QuestInfoSystem`, …). Feature code reads `ns.FLAVOR` only for `"Camelot"`: the marker in group chat (`BuildSent`, `Announcements.lua`), the dungeon quests' range check, and Routes' party names (`routes.UnitFullName`). Diagnostics reads it for labels and a few client-only rows. `ns.EXPANSION` is defined but read by nothing. Data differences come from the TOC's data folder, never a flavor check.
- **The flavor comes from the TOC's `X-Flavor`** (`Data/Flavor.lua`), never the client: WoW Forever's `WOW_PROJECT_ID` has changed value once already. Season of Discovery shares the Era client, so the Vanilla TOC lists both `Data/Vanilla/` and `Data/Discovery/`, each file returning at once unless `ns.IS_DISCOVERY` matches; `ns.DATA_FOLDER` names the folder that built the tables. `Data/Wrath/` and `Data/Mainline/` hold full data sets with no TOC; `.pkgmeta` leaves them out of a release.
- Shared files call whichever client files loaded through common `ns` names: `ns.SharedQuest`, `ns.ShareableZoneQuests`, `ns.ShareQuests`, `ns.LogQuests`, `ns.ToggleTracking`, `ns.SetAllTracked`, `ns.questMap.FollowQuest`, `ns.questLogFrame`, `ns.abandonButton` / `ns.shareButton`.
- **One layout**: every client shares `ns.LAYOUT` (`Data/Data.lua`; every gap on `LAYOUT.SPACE`) and `Features/Window.lua` (title, art, resize grip, list buttons). The details column (`CONTENT_WIDTH`) is exactly `REWARD_COLUMNS_WIDTH`, two reward buttons wide, because reward buttons can't shrink; `TEXT_MARGIN` around it. The window grows by `EXTRA_WIDTH` past the classic art's parchment, and `ns.CreateWindowArt` fills it with a strip cut from the middle piece's last `STRIP_SOURCE` pixels so both seams continue the art. Numbers in the details end two spaces inside the column (`ns.TwoSpacesWide`, `Quest-Objectives.lua`): body text wraps short of the edge, and a flush number looks like it runs past.

### The Wide Quest Log Switch

- `enableWideQuestLog` is read once, in `ADDON_LOADED`: `StartWideQuestLog` (`Features/Core.lua`) sets `ns.wideQuestLogActive` (switch on and a loaded file has a wide quest log, `ns.hasWideQuestLog`, which `ns.AddWideQuestLogPart` sets).
- **Classic Era and TBC**: hooks on Blizzard's quest log can't be removed, so every Classic quest log file but the rows and zone actions (`Classic-Tracking.lua`, `-Quest-Sort`, `-Quest-List`, `-VoiceOver`, `-Quest-Details`, `-Quest-Log`, `-Quest-Map`, `-ElvUI`) and the shared map files that build on it (`Quest-Map.lua`, `Questie-Map.lua`, `Questie-Map-Tooltip.lua`, `Questie-Map-Quest-Giver.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, `Quest-Map-Reveal.lua`) wraps its body in `ns.AddWideQuestLogPart(function() ... end)`. Core queues them at file load and runs them in TOC order, each through `securecall`, inside `ADDON_LOADED`, only with the switch on. `Classic-Quest-Rows.lua` only defines a function the list's part calls.
  - Deliberate exceptions that must work with the switch off: `Share-Reminders.lua`'s file-scope `QuestLogPushQuest` post-hook (only notes which quest went out), and `Classic-Zone-Actions.lua`, which Share Quests, the whispers and the dungeon quests call; it touches the quest log only when called. `Quest-Map.lua` sets `ns.hasQuestMap` and `PrettyWideQuestLogPinMixin` at file scope (the XML after it names the mixin).
- **WoW Forever and Mists**: the window is the add-on's own and stays closed unless opened, so `Forever-Quest-Log.lua` sets `ns.questLogIsOwnWindow` and `ns.hasWideQuestLog` at file scope, files build at file load (before `ns.db` exists), and `ns.AddWideQuestLogPart` runs a part at once, without `securecall`. Only the takeover waits for the switch: `ns.TakeOverQuestLog()` (`Forever-Quest-Log-Key.lua` or `Mists-Quest-Log-Key.lua`), from `ns:OnDatabaseReady`. Switch off: the key opens Blizzard's quest log and nothing opens the window (its hidden toggle button still exists).
- Core drops its queue after the parts run, so a part added after `ADDON_LOADED` throws.
- With the switch off on Classic Era and TBC, everything a part defines is nil (`ns.RefreshQuestLog`, `ns.ResetWindow`, `ns.ApplyWindowScale`, `ns.ApplyMapScale`, `ns.ResetZoneOrder`, `ns.questLogFrame`, `ns.questMap`, `ns.listButtons`, `ns.abandonButton`, `ns.shareButton`). Code outside a part checks `ns.wideQuestLogActive` first (`ns:ApplyProfile`, `Tracking-Mark.lua`, `ns.ApplyFontSettings`). `ns.hasQuestMap` is true while `ns.questMap` is nil: test `ns.wideQuestLogActive` first.
- **Options gates** (`Options-Quest-Log.lua`): `Hidden` (switch off in the profile) hides the Wide Quest Log panels' settings; `Inactive` (not running this session) grays them out while a reload is pending; `MapHidden` adds `ns.hasQuestMap`. Sub-panels show `NEEDS_WIDE_QUEST_LOG` or the pending line in place of their settings (`SubPanelIntro`).
- **Reload prompt**: a change applies at the next `/reload`. `ns.IsQuestLogReloadPending()` (`Options-Utilities.lua`) compares the profile's value with `ns.wideQuestLogActive` (a profile switch counts; flipping back goes quiet; false on a client with no wide quest log). A status line shows under the switch on the General and Wide Quest Log panels, and `PRETTYWIDEQUESTLOG_RELOAD` offers the reload a frame after the game's Options window closes. `ns.WatchOptionsForReload` hooks that window's `OnHide` the first time one of the add-on's panels shows inside it: the window may not exist at load, and watching it rather than the panels still prompts after the player moves to another category. Every registered panel is passed in (`Options.lua`'s `watched` list).
- Independent of the switch: the NPC Dialogue panel (quest giver window cleanup, its font), gossip greeting, Share Quests' quest log calls, the share whispers, zone share offers, dungeon quests, Routes, login notices. A zone's Share Quests button is part of the wide quest log; the Quality of Life panel says so while the switch is off (`ZoneShareNeedsLog`).

### Event Loop

- `Features/Core.lua` owns the only event frame. Its `EVENTS` table pairs each event with a handler named for it; an event listed more than once runs every row in table order.
  - No third field: handler on `ns`, called `handler(ns, ...)`, without the event name.
  - Third field: the `ns` key of an owner table, called `handler(owner, ...)`. One name on `ns` holds one function, so each further feature on the same event keeps its handler on its own table.
  - Handlers are looked up at every dispatch; a missing owner or handler is skipped; each runs through `securecall`, so one erroring doesn't stop the event's later rows.
- Owners: `ns.keyBindings`, `ns.dungeonQuests`, `ns.zoneShareOffer`, `ns.shareReminders`, `ns.questMap`, `ns.shareNeeds`, `ns.questLogWindow`, and Routes' `ns.routes`, `ns.routesMap`, `ns.routesArrow`, `ns.routesGroupUp`, `ns.routesItems`. Read `EVENTS` for the rows. Who holds the `ns` slots is not obvious:
  - The window (`Forever-Quest-Log.lua`): the quest events, `UNIT_QUEST_LOG_CHANGED`, `GROUP_ROSTER_UPDATE`, `PLAYER_LEVEL_UP`, `ZONE_CHANGED_NEW_AREA`, `PLAYER_REGEN_DISABLED`; on Classic Era and TBC `Classic-Quest-Log.lua`'s part holds the last two.
  - The dungeon quests (`Dungeon-Quests.lua`): `PLAYER_ENTERING_WORLD`, `GROUP_JOINED`, `GROUP_LEFT`; their `GROUP_ROSTER_UPDATE` is on `ns.dungeonQuests`.
  - `Share-Reminders.lua`: `CHAT_MSG_SYSTEM`. `Quest-Log-Key.lua`: `UPDATE_BINDINGS`, `PLAYER_REGEN_ENABLED`. Core: `ADDON_LOADED`, `PLAYER_LOGIN`.
- Notable rows:
  - `ADDON_LOADED` → `ns:OnAddonLoaded`, then `ns.routesMap:OnAddonLoaded` (adds the route when `Blizzard_WorldMap` loads on demand). Both run for every add-on, so each checks the name.
  - `PLAYER_REGEN_ENABLED` → the work held during combat (see Combat Lockdown).
  - `UPDATE_BINDINGS` → the quest log key's override, then `ns.keyBindings` (repaints the General panel's key row).
  - `QUEST_REMOVED`, `QUEST_TURNED_IN` → the window, then `ns.routes` (drops that quest's saved ignores, `Routes-Ignore.lua`).
  - `GROUP_JOINED` / `GROUP_LEFT` → dungeon quests, zone share offer, share reminders; `GROUP_LEFT` then `ns.routes` (drops the group's ignores). `GROUP_ROSTER_UPDATE` → the window, dungeon quests, zone share offer, `ns.routes`, `ns.routesArrow`.
  - `PLAYER_ENTERING_WORLD` → dungeon quests, zone share offer (both read `isInitialLogin` / `isReloadingUi`), then Routes' three owners.
  - `TAXIMAP_OPENED`, `UI_INFO_MESSAGE` → `ns.routes` only (flight paths learned, `Routes-Flights.lua`). `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST` → `ns.routes` only.
  - `BAG_UPDATE_DELAYED`, `BAG_UPDATE_COOLDOWN`, `PLAYER_TARGET_CHANGED` → `ns.routesItems` only (the Quest Arrow's Use Item buttons).
- Routes takes events only through these rows. Each TOC lists it with the single line `Features/Routes/Routes.xml`; without it the Routes owners are nil and their rows skip.
- **`ns:OnAddonLoaded` for this add-on, in order**: `AceDB:New`; `PruneOtherClientCharacters`; `MoveQuestGiverCleanup`; `ns.SyncFonts` (fonts made at file load take the saved settings before anything lays out); the three profile callbacks to `ns:ApplyProfile`; `ns.RegisterOptionsPanels` (the Profiles builder reads `ns.db`); registration pass 1; `StartWideQuestLog`; registration pass 2; `ns.ApplyQuestGiverCleanup`; `ns:OnDatabaseReady` (one slot, defined only by `Forever-Quest-Log.lua`). The last two and every Classic part run through `securecall`; panels and events come first so a feature erroring in setup takes only itself down.
- **Two registration passes** (`RegisterLoadedEvents`): each registers, once, every event with at least one row whose owner and handler exist by then; pass 2 picks up handlers defined inside Classic parts (switch on only). `ADDON_LOADED` is registered at file load and skipped by the passes. An event with no live row after pass 2 is never registered, so no client registers an event only another client's files handle. What was registered is exported as `ns.EVENT_NAMES` for Diagnostics.
  - Classic Era / TBC: `PLAYER_REGEN_DISABLED`, `ZONE_CHANGED_NEW_AREA` (for the log) and the map's `PLAYER_REGEN_ENABLED` row register only with the switch on.
  - WoW Forever / Mists: every handler is at file scope, so all register whatever the switch says; with it off the key's `UPDATE_BINDINGS` and `PLAYER_REGEN_ENABLED` handlers do nothing (`ns.questLogTakenOver` unset).
- While the Event Log records (`ns.diagnostics.logging`), the dispatcher passes each event to `ns:LogEvent` first; otherwise one boolean check.
- **Events request, they don't redraw**:
  - Own window: every quest event funnels into `ns.RequestUpdate()`, at most one repaint a frame and only while open, because `QUEST_LOG_UPDATE` bursts. `PLAYER_LEVEL_UP` because difficulty colors change; `UNIT_QUEST_LOG_CHANGED` for `"player"` and readable `party` units (party counts; the unit is tested with `ns.IsReadable` first); `GROUP_ROSTER_UPDATE` for counts and the Share button; `PLAYER_REGEN_DISABLED` / `_ENABLED` to gray and restore tracking controls; `ZONE_CHANGED_NEW_AREA` redraws without re-sorting zones (see Sorting). Questie's tracker `Update` post-hook (installed in `ns:OnDatabaseReady`, whatever the switch) and reward items finishing loading request the same.
  - Classic quest log: redraws through Blizzard's `QuestLog_Update`, which its hooks follow.
  - Docked map: `questMap.RequestRefresh` (`Questie-Map.lua`) waits `REFRESH_DELAY`, because Questie draws in batches over several frames.
  - Routes: debounced by the planner (see Planning and When to Plan Again).
  - Dungeon quests: a ticker every `ns.DUNGEON_CHECK_INTERVAL` while in a party dungeon. Zone share offers: timers on `ns.ZONE_OFFER_*`.
- `PLAYER_LOGIN`: Core prints the welcome (`showWelcome`), the predecessor warning (see Moving from Wide Quest Log Plus) and, `ns.QUESTIE_NOTICE_DELAY` later so it isn't lost among login lines, `CHAT_QUESTIE_MISSING_FEATURES` without Questie. The last two ignore the welcome toggle: they explain, not greet. Routes' row then runs its migrations (see Migration Chain) and its `routes.OnLogin` handlers.

### Blizzard's Side Windows (WoW Forever and Mists)

- Blizzard's left-side panels (quest giver, gossip, vendor, trainer, character) and the own window make way for each other, as Blizzard's windows do: a file-scope `ShowUIPanel` hook (`Forever-Quest-Log.lua`) hides the window when a `left` or `doublewide` panel opens (`UIPanelWindows` area, or the `UIPanelLayout-area` attribute), and opening the window hides those (`CloseLeftPanels`), out of combat only. Bags are left alone.
- Exempt: Blizzard's own quest log on Mists while the window takes over from it out of combat (`ns.IsTakenOverPanel`, always false on WoW Forever), or opening it would close the window it's meant to open.
- `ns.WasClosedForPanel` remembers the panel the window last closed for until the next frame; that's how WoW Forever's `ToggleQuestLog` hook tells a close from an open.

### Combat Lockdown

**Refuses, never queued** (the player acts again after):

- The options opener (`ns:OpenOptionsPanel`, `Options/Options.lua`) and the General panel's Set Key (`ns:OpenKeyBindings`, `Key-Bindings.lua`), each with a chat line.
- Track / Untrack and Track All on WoW Forever and Mists (`ns.ToggleTracking`, `ns.SetAllTracked`; `RefusedInCombat` in `Forever-Tracking.lua` / `Mists-Tracking.lua`): `ERR_NOT_IN_COMBAT`, because a watch change from add-on code in combat taints the objective tracker. Every Track control is disabled in combat to match (`ns.QuestActions`, the list's Track All button).
- `CloseLeftPanels`: opening the window leaves Blizzard's side windows open, since hiding them goes through the panel manager.
- The takeover: in combat the micro menu and tracker clicks leave Blizzard's map (WoW Forever) or quest log (Mists) open; the quest log key, bound to the add-on's own button, opens the window either way. On Mists `ns.IsTakenOverPanel` is false in combat, so Blizzard's quest log opening then closes the window like any left panel.
- Routes never writes the `miniWorldMap` CVar in combat; the next `KeepFullSize` out of combat does.

**Deferred to `PLAYER_REGEN_ENABLED`**, rows in `EVENTS` order:

1. Quest log key's override binding (`Quest-Log-Key.lua`): bindings can't change in combat; `ns.RouteQuestLogKey` sets `routePending`.
2. Docked map's Blizzard layers (`questMap`): the canvas calls `SetPassThroughButtons` on every pin it acquires, blocked for add-on code in combat, so each copied provider's `RefreshAllData` is wrapped to note it and return: every copied provider in `Forever-Quest-Map.lua` (`heldProviders`), the exploration layer alone in `Classic-Quest-Map.lua` (`explorationHeld`, inside a part). The add-on's own pin mixins (`PrettyWideQuestLogPinMixin`, `PrettyWideQuestLogRoutePinMixin`) make `SetPassThroughButtons` a no-op, as HereBeDragons-Pins does, so they draw in combat.
3. A single share on WoW Forever (`ns.shareNeeds`, `Share-Needs.lua`): WoW Forever blocks `QuestLogPushQuest` for add-on code in combat even on a click. One `pendingShare` slot, replaced by a later request; `CHAT_SHARING_AFTER_COMBAT`; sent after if still in log, shareable and grouped. Mists and Classic share at once (`Quest-Log-API.lua`).
4. The window's tracking controls (`ns.questLogWindow`) repaint enabled.
5. The Quest Arrow's Use Item buttons (`ns.routesItems`, every client): secure buttons, so item, place and showing lock in combat; stale ones fade and catch up here (`pendingAfterCombat`).

**Waits by polling**:

- Share Quests and the dungeon quests' runs (`ns.ShareQuests`, both zone actions files): a share due in combat retries each share interval; leaving the group ends the run.
- Routes: the planner watches `InCombatLockdown()`; a fight drops any plan underway, `routes.RequestPlan` in combat only flags a plan for after, and the first frame out checks at once (see Combat under Routes).

**Close When Combat Starts** (`closeInCombat`) hides the window on `PLAYER_REGEN_DISABLED` with a plain `Hide` (unprotected frame). The Classic counterpart, `HideUIPanel(QuestLogFrame)` in `Classic-Quest-Log.lua`'s part, is allowed in combat for that unprotected frame; it registers on pass 2. Both quest logs work in combat.

### Taint

**Classic Era and TBC** only hook, but Blizzard sees these as add-on writes; none reaches anything protected there:

- New size to the panel manager via `SetUIPanelAttribute` (`width` once; `height`, `bottomClampOverride` on change), the provided interface, not by replacing the `UIPanelWindows` entry. No attributes on a client without it.
- Extra `QuestLogTitle{N}` rows created for a taller window (`ShowRowCount`, `Classic-Quest-Rows.lua`) and `QUESTS_DISPLAYED` written: row spacing moves Blizzard's rows, so fewer show than the window holds (`RowsThatFit`) and Blizzard's own scroll range reaches the last entry. A change in the shown count reruns `QuestLog_Update` from the list's hook.
- Blizzard's All and Track toggles faded and unclickable; Expand All runs `QuestLogCollapseAllButton_OnClick`; Track All / Untrack All do a shift-click's work (`AutoQuestWatch_Insert`; `RemoveQuestWatch` after removing from `QUEST_WATCH_LIST`), then `QuestWatch_Update` and `QuestLog_Update`.
- The sorted order is drawn on Blizzard's rows (`SetID`, text, textures rewritten); Blizzard's handlers read that ID (see Sorting).
- Share Quests and the dungeon quests select, expand, collapse and call `QuestLogPushQuest`, as Blizzard's Share button does (`Classic-Zone-Actions.lua`).

**WoW Forever** (no Blizzard function is replaced):

- Only with the wide quest log active does `ns:OnDatabaseReady` call `ns.TakeOverQuestLog()` (`Forever-Quest-Log-Key.lua`), setting `ns.questLogTakenOver`:
  - `TOGGLEQUESTLOG`'s keys are bound with `SetOverrideBindingClick`, owned by the window, to the hidden `PrettyWideQuestLogToggleButton` (`ns.RouteQuestLogKey`, `Quest-Log-Key.lua`, shared with Mists), so the key never opens Blizzard's log; re-set on `UPDATE_BINDINGS`, deferred out of combat. `ClearOverrideBindings(frame)` first, so the window owns no other override.
  - `ToggleQuestLog` (micro menu) and `QuestMapFrame_OpenToQuestDetails` (tracker, Questie) are post-hooked: Blizzard's runs first and opens the map; out of combat the hook closes it with `HideUIPanel` in the same frame and opens the window (or that quest). A quest not in the log stays on Blizzard's map.
- Details never call `QuestInfo_Display` or borrow `QuestInfo` frames: own font strings and own reward buttons (`LargeItemButtonTemplate`, no scripts; `Forever-Quest-Details-Rewards.lua`), tooltips and links via the quest log calls after selecting. So the quest giver window, popup and map details keep `QuestInfo`, and the window draws in combat. `QuestInfo_Display` is post-hooked only for the quest giver window (see Quest Giver Window).
- Installed at file scope, whatever the switch: the `ShowUIPanel` hook, the `UISpecialFrames` entry (Blizzard reads it through `securecall`), the hidden toggle button, the quest giver's `QuestInfo_Display` hooks. The Questie tracker `Update` hook is installed in `ns:OnDatabaseReady` whatever the switch.
- Each details repaint selects the quest only when Blizzard's selection differs (`ns.SelectQuest`).
- Abandon, Share and the right-click menu call Blizzard's `QuestMapQuestOptions_AbandonQuest` / `_ShareQuest` (`ns.AskToAbandonQuest`, `ns.ShareQuest`). Zone expand/collapse is the window's own, by zone name for the session (`collapsedZones` in `Quest-Log-API.lua`, written into each header's `isCollapsed` by `ns.GetQuestLogEntry`); Blizzard's zones are never expanded or collapsed: `ExpandQuestHeader` / `CollapseQuestHeader` fire `QUEST_LOG_UPDATE` inside the call (Blizzard's quest log sets `ignoreQuestLogUpdate` around them), which taints the tracker, and Blizzard's map collapses the zones off its map on every refresh.
- Tracking: `C_QuestLog.AddQuestWatch` / `RemoveQuestWatch`, never in combat.
- Routes hides and re-shows Blizzard's quest marker and objective area pins on the world map and post-hooks those providers' `RefreshAllData` (`Routes-Map-Blizzard-Quests.lua`); it never writes to them or to the `questPOI` CVar.
- Share Quests and the dungeon quests select each quest and call `QuestLogPushQuest`, then reselect (`Forever-Zone-Actions.lua`).
- Routes never adds layers to the world map's pin frame levels: inserting one shifts Blizzard's definitions, writing their `startLevel` (and `maxLevel`, `topMostDefinition`) from add-on code for the session. Every Blizzard pin reads them in `ApplyFrameLevel`, and `AcquirePin` applies the level before the provider sets the pin up, so every quest marker would be set up tainted; a click on one runs `C_SuperTrack.SetSuperTrackedQuestID` / `AddQuestWatch` tainted, and a hover writes `POIButtonHighlightManager`, which the tracker's own POI buttons read. Route pins place themselves instead (see The Zone Map, Frame levels).
- **Objective tracker taint**: if one of these calls fires an event the tracker listens to (`QUEST_WATCH_LIST_CHANGED`, `QUEST_LOG_UPDATE`, `SUPER_TRACKING_CHANGED`, `QUEST_POI_UPDATE`) while it runs, the tracker marks itself dirty from add-on code and its next update runs tainted, writing its own state tainted, so taint carries until a reload; in a scenario the update reads secret auras and errors (from its own update or Edit Mode's `OnAnyEditModeSystemAnchorChanged`). Every such call goes through `ns.TrackerTaintStep` (`Diagnostics/Tracker-Taint.lua`): selection, watch changes, shares, abandon, the takeover's `HideUIPanel`, `CloseLeftPanels`, the `miniWorldMap` write, and window open/close marks. The Tracker Taint Watch (Run Tests) checks the tracker's frames, modules and `EditModeManagerFrame` with `issecurevariable` around each step. With the watch off a step costs one check.

**Mists** (the same file-scope pieces, key override and self-drawn details; otherwise):

- No function replaced. `ns.TakeOverQuestLog()` (`Mists-Quest-Log-Key.lua`) post-hooks `ShowUIPanel`, since everything (micro menu, Questie, the tracker's `QuestLog_OpenToQuest` into `QuestLogDetailFrame`) opens `QuestLogFrame` through the panel manager. Out of combat `HideUIPanel` closes Blizzard's in the same frame and the window shows Blizzard's selected quest; a second tracker click on the showing quest closes it. A `ToggleQuestLog` post-hook uses `openBeforeToggle` (kept a frame) to close an already-open window.
- Reading the log selects quests: `SelectQuestLogEntry` on every repaint (`ns.SelectQuest` always selects here), reward tooltips, and `ns.IsPushableQuest` / `ns.ShareQuest` / `ns.AskToAbandonQuest` around `GetQuestLogPushable`, `QuestLogPushQuest`, `SetAbandonQuest` (then Blizzard's own abandon popup), restoring the selection.
- Blizzard's zones stay expanded: a collapsed zone lists none of its quests, so `ns.ShowEveryQuestLogEntry` calls `ExpandQuestHeader(0)`; collapsing in the window only changes the session's `collapsedZones` (`Quest-Log-API.lua`).
- Share Quests and dungeon quests go through `Classic-Zone-Actions.lua`.
- Tracking by index, then `WatchFrame_Update`, since `WatchFrame` hears no event a watch change fires; refuses in combat, as on WoW Forever.

### Questie Tracking

Each client's tracking file defines the same `ns` surface the list and buttons call: `ns.CanTrack`, `ns.IsTracked`, `ns.HasRoomToTrack`, `ns.CanRemoveQuestWatch`, `ns.ToggleTracking`, `ns.SetAllTracked` (own window), or `ns.CanTrackMore`, `ns.TrackAllQuests`, `ns.CanUntrackAny`, `ns.UntrackAllQuests` (Classic Era and TBC).

#### WoW Forever (`Forever-Tracking.lua`)

- Why Questie leads: its tracker learns of a quest only through `C_QuestLog.AddQuestWatch` (the client's auto-watch on accept bypasses it), and shows only quests in its database, which lacks many WoW Forever quests.
- `TrackerFor(questID)`: Questie is in charge while `Questie.db.profile.trackerEnabled`, `QuestieTracker` has `IsTrackedByQuestie`, and `ns.QuestieLogEntries()` (`Utilities.lua`) returns a log. Returns the tracker, `false` (in charge but can't show the quest: untrackable), or nil (Blizzard's watch decides). Does not wait for Questie's tracker to start.
- `QuestieKnows`: on Questie 12.6.3+ (acceptances) only an entry carrying `.quest` counts, since a quest Questie's database lacks still gets an entry; before that, any entry counts.
- Questie's log is read at most once a frame (`QuestieLog`, keyed by `GetTime()`): a repaint asks about every quest.
- `ns.IsTracked`: `IsTrackedByQuestie` in a `pcall`, falling back to `QuestUtils_IsQuestWatched` if it throws; untrackable reads untracked. Ignores a second argument.
- Track always calls `AddQuestWatch`, even when Blizzard already watches: that call is what tells Questie. Blizzard's cap still holds under Questie (`ns.HasRoomToTrack`, against `Constants.QuestWatchConsts.MAX_QUEST_WATCHES`; refused with `OBJECTIVES_WATCH_TOO_MANY`).
- Untrack: Questie's `UntrackQuestId` when Blizzard has no watch; else (or if missing or it throws) `C_QuestLog.RemoveQuestWatch`, only while `ns.CanRemoveQuestWatch()` (`QuestUtil.CanRemoveQuestWatch`). Both watch calls go through `ns.TrackerTaintStep` (`Diagnostics/Tracker-Taint.lua`).
- Combat: a watch change from add-on code in combat taints the objective tracker, so `ns.ToggleTracking` / `ns.SetAllTracked` refuse with `ERR_NOT_IN_COMBAT` (`RefusedInCombat`; Mists the same). `ns.QuestActions(questID)` (`Forever-Quest-Log.lua`) is the single enable rule for the bottom Track / Share / Abandon buttons and the right-click menu. `OnPlayerRegenDisabled` and `questLogWindow:OnPlayerRegenEnabled` both repaint, so controls gray and return.
- An untrackable quest is refused four ways: one chat line per quest per session (`ns.QuestieCannotShowText`, `warnedUntrackable`), `QUESTIE_CANNOT_TRACK` on `UIErrorsFrame` on every refused click, a tooltip on the grayed Track button (`trackButton.untrackable`), a grayed menu item.
- Untracking from Questie's own menu may not touch Blizzard's watch list, so `ns:OnDatabaseReady` (`Forever-Quest-Log.lua`) post-hooks `QuestieTracker.Update` to `ns.RequestUpdate` (WoW Forever and Mists, whatever the switch says).

#### Classic Era and TBC (`Classic-Tracking.lua`, a quest log part)

- Works on log indexes in list order, doing a shift-click's work: `AutoQuestWatch_Insert(index, QUEST_WATCH_NO_EXPIRE)` to track; to untrack, remove the quest from `QUEST_WATCH_LIST` (Blizzard's watch timers forget it) then `RemoveQuestWatch` (Questie hooks it). Each ends with `QuestWatch_Update`, `QuestLog_Update`.
- Questie removes Blizzard's watch as it takes a quest (dodging Blizzard's limit), so Blizzard's watch count means nothing under Questie. Tracked = `IsQuestWatched` per quest (Questie replaces it).
- Trackable: not a header, not watched, and either Questie's tracker has started (`ns.IsQuestieTracking`, `Tracking-Mark.lua`: no limit) or the quest has objectives (`GetNumQuestLeaderBoards`) and the watch count is under `MAX_WATCHABLE_QUESTS` (refused with `QUEST_WATCH_TOO_MANY`).
- No combat refusal: it does what Blizzard's shift-click does.

#### Mists (`Mists-Tracking.lua`)

- Watch calls take a log index (`ns.GetLogIndexForQuestID`). Once Questie's tracker takes over it hooks `AddQuestWatch` / `RemoveQuestWatch` and replaces `IsQuestWatched`, so the same calls reach whichever tracker leads.
- `ns.CanTrack` and `ns.CanRemoveQuestWatch` are always true: no untrackable quests, and one with no objectives tracks even before Questie starts.
- `ns.HasRoomToTrack`: already tracked, Questie tracking (`ns.IsQuestieTracking`), or under `MAX_WATCHABLE_QUESTS`; else `QUEST_WATCH_TOO_MANY`. Combat refused as on WoW Forever.
- Every change ends in `Redraw`: `WatchFrame_Update` (`WatchFrame` hears no event from a watch change), then `ns.RequestUpdate`.
- `ns.IsTracked` / `ns.HasRoomToTrack` take an optional `questLogIndex`, because a by-ID lookup walks the whole log. Pass it where known (the list rows and list buttons do).

#### Before Questie's Tracker Starts (`Tracking-Mark.lua`, every client)

- Questie starts its tracker seconds after login, mid staged startup. Until then nothing reads as tracked, so with `markUntracked` the untracked mark (`ns.TRACKING_MARKS`) would flash on every row.
- `ns.ShowTrackingMark(texture, isTracked)` draws the tracked check, or with `markUntracked` the crossed-out eye on untracked quests; none while the tracker is enabled but not `started` (`IsQuestieTrackerPending`). The first time it sees that, it hooks `QuestieTracker:HookBaseTracker` to `ns.RefreshQuestLog` (which clears the frozen zone order too), only while `ns.wideQuestLogActive`.
- `ns.IsQuestieTracking()`: tracker enabled and `started`. Only the marks wait: WoW Forever's controls read Questie's log started or not; Classic and Mists follow Blizzard's cap until it starts.

### Sorting

#### Sort Rules (`Quest-Sort.lua`)

- Records carry `sortLevel`, `sortKey` (`ns.NameSortKey`: lowercased full title, so The Hinterlands sorts under T, as Blizzard does) and `sortIndex` (log index); zones add `title` and `averageLevel` (`ns.AverageLevel`, nil with no listed quests).
- Profile keys (Wide Quest Log panel, Sorting): `zoneSort`, `questSort` (`LEVEL_HIGHEST_FIRST`, `LEVEL_LOWEST_FIRST`, `ALPHABETICAL`), `currentZoneFirst`, `completedFirst`. Options `set` calls `ns.RefreshQuestLog()`.
- Zones (`CompareZones`): current zone first if `currentZoneFirst`; then average level (unknown after the rest) unless alphabetical; ties to name, then log order.
- Quests (`ns.SortQuests`): ready to turn in first if `completedFirst`; then `questSort`; ties to log order. Quests outside any zone list before every zone.
- `sortLevel` is the level the tag shows: `difficultyLevel` else `level` on the window (Mists' entries have only `level`), `GetQuestLogTitle`'s level on Classic Era and TBC.
- The add-on does all sorting itself, so each option holds the same on every client.

#### Current Zone

- `ns.IsCurrentZone` matches header text to `GetRealZoneText()` or, in a dungeon, any name in `ns.CurrentDungeonNames()` (`Dungeon-Quest-Lookup.lua`): headers are area names, and an instance's zone text can be spelled differently. Class and profession headers never match.
- `ns.CurrentDungeonNames` caches by instance ID, zone text and whether Questie's `ZoneDB` exists, because every repaint asks about every header.
- `ns.ZoneHeaderText` appends `ns.CURRENT_ZONE_MARK`. Quest Log Context (`Manifests.lua`) also calls `ns.IsCurrentZone`; the dungeon quests don't (they match `dungeon.names`).

#### Frozen Zone Order

- `ns.SortZones` freezes ranks by zone title on the first sort after the window opens and returns them; each list keeps its own (`zoneOrder`). A turn-in or drop doesn't reshuffle zones under the cursor; an unranked zone (new pickup) goes last.
- The freeze covers `currentZoneFirst`: `OnZoneChangedNewArea` repaints, moving the mark at once; the zone moves up only at the next open.
- `ns.ResetZoneOrder` (`Forever-Quest-List-Entries.lua`, or `Classic-Quest-List.lua` calling `ns.ResetClassicZoneOrder` and dropping its last order) runs on window close, and through `ns.RefreshQuestLog` on a Wide Quest Log sort or list setting change, a font change (`ns.ApplyFontSettings`), a profile change (`ns:ApplyProfile`) and Questie's tracker starting.

#### WoW Forever and Mists

- `ns.BuildQuestListEntries` (`Forever-Quest-List-Entries.lua`) builds; `ns.UpdateQuestList` (`Forever-Quest-List.lua`) draws in its own `WowScrollBoxList` and returns the quest count.
- Visibility matches the map's quest list: no hidden quests, no task quests (world quests, bonus objectives), bounties only once complete, no zone with nothing left to show.
- Also returns every quest that would show with its zone open (Track All, turn-in line, empty-log check, fallback selection) and whether every zone is collapsed (Expand All).
- `ns.ExpandAllZones` on the session's first open (`headersOpened`, `Forever-Quest-Log.lua`): a collapse lasts until the next login or reload.
- Mists' entries come through `ns.GetQuestLogEntry` with `isComplete` / `isFailed` on them; `EntryIsComplete` / `EntryIsFailed` read those first, because by-ID there walks the log.
- Rows (`InitRow`): click a header to collapse (`ns.SetQuestZoneCollapsed`); on a quest, shift-click links into an open chat box (`ChatFrameUtil.TryInsertQuestLinkForQuestID`) else toggles tracking; right-click opens the menu (`OpenQuestMenu`, Abandon only when `ns.CanAbandonQuest`); left-click shows it.
- Row color (`GetQuestColor`): the server's rating (`C_PlayerInfo.GetContentDifficultyQuestForPlayer`), which can differ from the level's; else `GetQuestDifficultyColor` by level, which also grays a quest `ns.IsQuestDisabledForSession` (its rating is skipped).
- `ValidateSelection`: a selected quest gone from the log is replaced by the first quest showing, else the first under a collapsed zone. `state.scrollToQuestID` scrolls a quest opened from elsewhere into view once its row exists, then clears.

#### Classic Era and TBC Rows

- The rows stay Blizzard's (other add-ons hook them). `QuestLog_Update` fills row *i* with entry *i* + offset, and every row handler (click, shift-click, collapse, party tooltip, Share Quests hover) finds its entry from row ID + offset. So `Classic-Quest-Sort.lua`'s `RedrawRow` redraws each row as `QuestLog_Update` would for the entry at its sorted place (text, +/- texture, tag, `[`N`]` party count, check, difficulty color) and sets its ID to match.
- `UpdateList` (`Classic-Quest-List.lua`, post-hook on `QuestLog_Update`, window shown only), in order: sort (`ns.BuildClassicDisplayOrder`); row count (`rows.RowsThatFit` / `rows.ShowRowCount`; a change reruns `QuestLog_Update` and returns); redraw (`ns.RedrawClassicRows`); positions; VoiceOver buttons (`ns.MatchVoiceOverButtons`); row style (`StyleQuestRows`, after VoiceOver, whose button functions rewrite titles and move the check); list buttons; turn-in line; map empty-log check.
- `StyleQuestRows`: list fonts on every shown row (Blizzard's `QuestLog_Update` sets its own first), level tag (`ns.QuestListTitle`), `ns.ZoneHeaderText`, tracking mark in Blizzard's check, Share Quests button, title shortened to clear the tag.
- VoiceOver's own `QuestOverlayUI.Update` can run after that hook, so `Classic-VoiceOver.lua` post-hooks it to `ns.RestyleClassicQuestRows` (buttons and styling with the last order; nothing before the first update, `listUpdated`).
- The selection highlight goes by place, so it's moved again after `QuestLog_SetSelection` (`ns.PlaceClassicSelectionHighlight`).
- A collapsed zone lists no quests, so it sorts by its average when last seen open (`knownZoneLevels`, session), else last.
- When the sorted order equals the log's own (zones alphabetical, quests lowest level first), `BuildDisplayOrder` returns nil: no redraw, and `RedrawRows` resets every row ID to its place.
- A shift-click link would insert the row's text, which leads with the level tag, so a `QuestLogTitleButton_OnClick` post-hook swaps in `row.plainTitle`, except with Questie loaded (it inserts its own link).

#### Row Spacing

- Every client: `LAYOUT.QUEST_ROW_HEIGHT` and `LAYOUT.HEADER_ROW_HEIGHT` (room for the Share Quests button), each `LAYOUT.ROW_HEIGHT` plus `ROW_PADDING` above and below; with `zoneGap`, `LAYOUT.HEADER_GAP` above every zone header but the first. Details start level with the first quest row (`LAYOUT.CONTENT_TOP`). The tracking mark sits at `LAYOUT.CHECK_X` (on the window, so does a header's +/-); text starts at `QUEST_TEXT_X` / `HEADER_TEXT_X`.
- WoW Forever and Mists: the scroll box's extent calculator sizes rows; the gap is a spacer entry (`isSpacer`, mouse off). Rows recycle among headers, quests and spacers, so `InitRow` resets everything.
- Classic Era and TBC: `Classic-Quest-Rows.lua`, whose `ns.CreateClassicQuestRows(hookRow)` the list's part calls (Blizzard's rows can only be measured then). Rows keep Blizzard's height; `RowTops` centers each in its padded slot below any gap. The quest slot (`ns.GetQuestRowHeight`) is the step the window's height snaps to.
  - Two counts: capacity from the window's height (`ns.SetQuestRowCount`, from `Classic-Quest-Log.lua`), and rows shown, `QUESTS_DISPLAYED`, which `RowsThatFit` lowers until the last entry fits, padding and gaps included, when scrolled to the end.
  - Why: Blizzard's scroll range (entries less `QUESTS_DISPLAYED`) must reach the last entry, and `QuestLog_Update` resets it every update, so a wider range set by the add-on is lost and the list jumps back up. Cost: higher up the list, with fewer gaps in view, room is left at the bottom.
  - `ShowRowCount` makes any missing `QuestLogTitle{N}` (with the list's hover hooks, `hookRow`) and hides every made row past the count, since `QuestLog_Update` fills only up to `QUESTS_DISPLAYED`. `PositionRows` re-anchors rows 2 on and hides any pushed past the bottom (and the highlight on one).

#### Party on a Quest

- WoW Forever and Mists (`Forever-Quest-List-Party.lua`): party count (`Party-On-Quest` icon + number, palette `INFO`) left of the tag or at the right edge; the title shortens to clear it. Hover lists names (class-colored) under `PARTY_QUEST_STATUS_ON`, or shows `PARTY_QUEST_STATUS_NONE`; a client without the string shows nothing.
- `IsPartyMemberOnQuest`: `ns.IsUnitOnQuest` (`Quest-Log-API.lua`), which the game answers only in range; where it says no or is secret, `ns.routes.QuestieHasUnitOnQuest` (`Routes-Party.lua`: Questie's shared logs, any distance, regardless of `partyQuests`; skipped without Routes). A "no" is unknown if secret or the member isn't `UnitIsVisible` (a range stand-in); any unknown suppresses the "none" line, which would be a guess.
- `party`N up to `GetNumSubgroupMembers()` only, so a raid gives the player's subgroup. A secret name or class (`ns.IsReadable`) only drops the name; the member still counts.
- Repaints on `GROUP_ROSTER_UPDATE` and `UNIT_QUEST_LOG_CHANGED` for the player or a readable `party` unit (`Forever-Quest-Log.lua`). A change only in Questie's shared logs waits for the next repaint.
- Quest Log Context reports the game's answers and how many were secret.
- Classic Era and TBC: Blizzard's `[`N`]` before the title, recomputed by `RedrawRow` from `IsUnitOnQuest`.

### Expand All, Track All and Show Map

- Bar above the list at `LAYOUT.LIST_BUTTONS_X` / `LIST_BUTTONS_Y`, `LAYOUT.LIST_BUTTONS_GAP` apart: `ns.CreateListButtons` (`Window.lua`) makes Expand All and Track All; each list file anchors them and sets `ns.listButtons`, after the last of which `Quest-Map.lua` hangs Show Map.
- Sized on first show (font loaded): widest label in this locale plus `LAYOUT.LABEL_PADDING`, at least `LAYOUT.BUTTON_WIDTH`; Expand All and Track All share one width. No button resizes as its label switches.
- Collapse All while any zone is open; Expand All once all are collapsed.
- Track All while a listed quest can still be tracked and there's room; else Untrack All, grayed when nothing is tracked. Tracks top-down in list order, so a nearly full watch list fills with what the player sees first; stops when full with Blizzard's string on `UIErrorsFrame`. Never full under Questie except on WoW Forever.
- **Classic Era and TBC** (`Classic-Quest-List.lua`, `Classic-Tracking.lua`): over the listed log indexes in display order (`ListedIndexes`), so quests under collapsed zones are passed by.
  - Buttons live in `QuestLogExpandButtonFrame`, which Blizzard hides while the log is empty.
  - Blizzard's "All" toggle and `QuestLogTrack` (which would peek between the buttons) are faded and unclickable, not removed.
  - Expand All runs `QuestLogCollapseAllButton_OnClick` and labels itself from the toggle's `collapsed`, keeping Blizzard's record right.
- **WoW Forever** (`ns.SetAllTracked`): every quest the list would show, collapsed zones included, silently skipping ones Questie can't show. Grayed in combat; Untrack All also needs `ns.CanRemoveQuestWatch()`.
- **Mists** (`ns.SetAllTracked`): same coverage, skips none, redraws `WatchFrame`. Grayed in combat only.
- WoW Forever and Mists: Expand All is disabled with no quests and calls `ns.SetQuestZoneCollapsed` per header (only the window's `collapsedZones` changes, see Taint).
- **Show Map** hides with the map while the log is empty (`questMap.SetLogEmpty`, from both list files, only when `ns.questMap` exists) and returns with the first quest; `mapHidden` untouched. Empty: no quest the list would show (window), no log entries (Classic Era and TBC). The window's list also shows `QUESTLOG_NO_QUESTS_TEXT` then.

### Share Quests

- One button (`Zone-Share.lua`, every client, `ns.zoneShareButton`, created at file scope), reparented onto the hovered zone row so it hides with it. Zone rows fit it because `LAYOUT.HEADER_ROW_HEIGHT` derives from `LAYOUT.ZONE_SHARE_BUTTON_HEIGHT`; width is label plus `LAYOUT.ZONE_SHARE_BUTTON_PADDING`. Fonts are the list area's copies (`ns.AreaFont("list", …)`).
- Lists drive it: `ns.ShowZoneShareButton` on row enter, `ns.HideZoneShareButton` on row leave (kept while the mouse is on the button; its own `OnLeave` hides it unless back on the row), `ns.UpdateZoneShareButton` per redrawn row, so a row recycled for a quest drops it.
  - Classic Era and TBC (`Classic-Quest-List.lua`, a wide-log part): `OnEnter` / `OnLeave` hooked on Blizzard's rows and those `ns.CreateClassicQuestRows` adds; zone from row ID + scroll offset; `StyleQuestRows` updates per pass. Zone rows keep Blizzard's clicks. ElvUI skins it (`Classic-ElvUI.lua`).
  - WoW Forever and Mists (`Forever-Quest-List.lua`): `Row_OnEnter` / `Row_OnLeave`, `InitRow`; `Row_OnClick` toggles a zone on either mouse button.
- Grayed, re-checked every frame in `OnUpdate`, while solo or while `ns.sharingQuests` (any run, dungeon included). Tooltip: `ERR_NOT_IN_GROUP` solo, else `SHARE_ZONE_QUESTS_TOOLTIP` with the interval.
- Click: `ns.ShareableZoneQuests(zoneTitle)`, then `ns.QuestsPartyNeeds` (no units: whole group, raid included). Shareable but everyone has them: `CHAT_SHARING_ZONE_PARTY_HAS`, nothing shared. Else print `ns.BuildSharePrint(count, zoneTitle)` (`Announcements.lua`; `CHAT_SHARING_ZONE_NONE` / `_ONE` / `CHAT_SHARING_ZONE`), gray itself, `ns.ShareQuests`.
- Shareability is worked out only on click: on Classic Era, TBC and Mists it means selecting each quest.
- No wide quest log, no button (Classic's hooks are a part; the own window stays shut). The Quality of Life panel says so (`ZONE_SHARE_NEEDS_WIDE_LOG`). Everything else in sharing works with the switch off.

#### The Run (`ns.ShareQuests(questIDs, units)`, Both Zone-Actions Files)

- One quest per `ns.GetShareInterval()` (read once at run start), a `C_Timer.After` chain; `ns.sharingQuests` set until the last position, so a second run can't start.
- Each share re-finds the quest, re-checks shareability and `ns.PartyNeedsQuest` (against `units` if given), and runs in `securecall`. A quest nobody needs by its turn is skipped without waiting out the interval. An erroring share returns nil, counted as shared, so the pace holds.
- Leaving the group ends the run. A share due in combat re-checks each interval, then the run resumes (WoW Forever blocks `QuestLogPushQuest` for add-on code in combat; both files wait alike).
- Interval: Quality of Life's `shareInterval` slider bounded by `ns.SHARE_INTERVAL_MIN` / `ns.SHARE_INTERVAL_MAX`; sooner than the minimum and the game calls the member busy. Quality of Life off: the default. Only the slider enforces the range; `ns.GetShareInterval` (`Utilities.lua`) returns the saved value.

#### Who Needs a Share (`Share-Needs.lua`)

- `ns.PartyNeedsQuest(questID, questLogIndex, units)`: true if some member among `units` (default: every other group member, `raidN` or `partyN`) isn't known to have it. Known: `ns.IsUnitOnQuest` says yes (in range only), or `routes.QuestieHasUnitOnQuest` (Questie's shared log, any distance). Unanswerable (out of range, secret, no Questie) counts as needing it, so a quest is dropped only when everyone it could reach has it. Offline skipped.
- `questLogIndex` is for index clients, where `ns.IsUnitOnQuest` (`Quest-Log-API.lua`) falls back to the global by-index `IsUnitOnQuest`.
- `ns.QuestsPartyNeeds(questIDs, units)` filters a list (each zone-actions file); the index version runs inside `WithEveryZoneOpen` so each quest has an index.
- Callers: Share Quests (whole group), dungeon share (`newInRange` units only, so a later joiner gets only what they lack), every share in a run. WoW Forever and Mists' single Share Quest (button, right-click menu) isn't filtered: the player's own pick.
- Also here, WoW Forever only (`if C_QuestLog.GetInfo`): `ns.ShareQuest` with the after-combat hold (`ns.shareNeeds`, `pendingShare`, `QuestMapQuestOptions_ShareQuest` through `ns.TrackerTaintStep`; see Combat Lockdown). Other clients' `ns.ShareQuest` is `Quest-Log-API.lua`'s select-and-`QuestLogPushQuest`.

#### The Zone-Actions Files

- Common `ns` names: `ns.SharedQuest(questLogIndex)` (Share Reminders), `ns.ShareableZoneQuests` (IDs plus the zone's quest count), `ns.LogQuests` (`{ questID, title, zoneTitle, isComplete, isFailed, pushable }`), `ns.QuestsPartyNeeds`, `ns.ShareQuests`. Outside any part: needed with the switch off.
- `Classic-Zone-Actions.lua` (Classic Era, TBC, Mists), index-based:
  - Only the selected quest can be shared or asked `GetQuestLogPushable`, so each is selected in turn; the selection is restored by index after zones re-close (entries back in place), so a selected header or no selection returns too. On Mists that's Blizzard's selection, which can differ from the window's quest.
  - Collapsed zones list no quests. `ns.ShareableZoneQuests` opens just its zone; `WithEveryZoneOpen` (`ns.LogQuests`, `ns.QuestsPartyNeeds`, each share) calls `ExpandQuestHeader(0)` only if something is collapsed, then re-collapses by title from the bottom up. Per share, so a zone collapsed mid-run is still searched; `QuestLog_Update` after each while Blizzard's log is shown.
  - So no diagnostic calls them: reports use `ns.DiagnosticLogQuests` (`Manifests.lua`; open zones only, `pushable` for the selected quest only).
- `Forever-Zone-Actions.lua`: collapsed zones still list quests (window collapsing is its own), so zones are left alone; `C_QuestLog.IsPushableQuest` by ID. Skips hidden and task quests like the list, but keeps incomplete bounties the list hides (`Forever-Quest-List-Entries.lua`). Each share: `ns.SelectQuest`, `QuestLogPushQuest` through `ns.TrackerTaintStep`, reselect the window's `ns.questLog.selectedQuestID`, `ns.RequestUpdate`.

#### Related

- Both logs' Share Quest buttons explain a solo gray-out (`ns.ExplainShareButton`, `Utilities.lua`; hooked because Classic's is Blizzard's `QuestFramePushQuestButton`).
- Own window's right-click menu: Track / Share / Abandon enabled from `ns.QuestActions` (`canShare`: pushable and grouped), Abandon listed only when `ns.CanAbandonQuest`. Handy Clicks lists the menu click only with `ns.questLogIsOwnWindow` (`Options-Quest-Log.lua`).

### Share Reminders

`Share-Reminders.lua`: a share that fails for a reason the member can fix earns them a whisper naming the quest; unfixable results (not eligible, already on it, done) earn none.

- **Which results.** `FIXABLE_RESULTS` names client globals (busy, too far, log full) read via `_G`; a missing one is skipped. `NamePattern` turns each into an anchored pattern at load (`%s` / `%n$s` capture the name), so `CHAT_MSG_SYSTEM` matches in any locale. The whisper doesn't say why: the game already told them.
- **Which quest.** Results don't name it. File-scope `hooksecurefunc("QuestLogPushQuest")` (every share path ends there; installed with the switch off too) notes it via `ns.SharedQuest`: the index passed (WoW Forever's menus pass one without selecting), else the selected quest; a header notes nothing. Each noted share resets `whispered`. A result counts within `ns.GetShareInterval()` of the last share, once per player per share.
- **Which whisper.** First `WHISPER_SHARE_FAILED`, later `WHISPER_SHARE_FAILED_AGAIN` (quest only) per player in `told`, reset on `GROUP_JOINED` / `GROUP_LEFT` (owner `ns.shareReminders`; `ns:` handlers for those events are Dungeon-Quests').
- **When.** `enableQualityOfLife` and `shareWhispers`; party only (`InPartyOnly`: no raid, battleground, arena), though sharing works there. Chat lockdown checked first: the system message is secret, nothing read.
- **Recipient.** The name captured from the system message, as is.
- **Shape** (`Announcements.lua`): `BuildSent` = marker + body + ` // ` + `L["ADDON_SHORT_NAME"]`. `ns:BuildWhisperMessage` puts `ns.TARGET_MARKER` on every client; `ns:BuildAnnounceMessage` (group chat) leaves it off on WoW Forever, which blocks `{rtN}` in group and channel chat but allows it in whispers. Pipes kept (quest links).
- **Quest reference.** `ns.FittingQuestReference(build, questID, title)` (whisper wrapper `ns.ShareWhisperQuestReference`) takes the best that keeps the message within `ns.CHAT_MESSAGE_MAX_LENGTH` bytes: Questie's `GetNativeQuestLinkStringById` (real link, clickable for all), `GetQuestLinkStringById` (bracketed text Questie links), `[Title]`, then `[Title...]` cut by `TrimToBytes` on a UTF-8 boundary.
- **Diagnostics.** Sharing Context (`Manifests.lua`) shows switches, raid / instance type, whether whispers can go out, chat lockdown; its `SHARE_RESULTS` mirrors `FIXABLE_RESULTS`. The Message Length report (`Diagnostics/Localization-Reports.lua`) measures the whispers and announcement against the byte limit.

#### Example Lines (Quality of Life Panel)

- Built by the sending code and drawn by `ns.RenderSample` (`Options/Options-Utilities.lua`) in `ns.OptionsExampleRow`s (`Options-Quality-of-Life.lua`), each hiding with its toggle: under Seconds Between Shares (`ns.BuildSharePrint` for the sample zone), share whispers (`ns.BuildShareWhisper`), zone share offer (`ns.BuildZoneShareOffer`), dungeon announcement (first of `ns.BuildDungeonAnnouncement`), dungeon sharing (`ns.BuildSharePrint` for the sample dungeon).
- `RenderSample`: label `SAMPLE_EXAMPLE` in the help color; PRINT through `ns.BuildPrintLine`; WHISPER / PARTY as received: `ChatTypeInfo` color (fixed hex fallback), `CHAT_WHISPER_GET` / `CHAT_PARTY_GET` prefix, class-colored sender, `{rtN}` drawn as its icon, color reopened after each `|r` (`Tint`).
- Samples: `ns.SAMPLE_QUEST_IDS`, `ns.SAMPLE_DUNGEON_AREA_ID`, `ns.SAMPLE_ZONE_AREA_ID` (`Data/{Game}/Sample-Quests-{Game}.lua`), area names via `C_Map.GetAreaInfo`. `ns.SampleQuests` requests an unloaded title (`C_QuestLog.RequestLoadQuestByID`) and shows `SAMPLE_QUEST_LOADING`. No sample quests, no rows (`ns.NoSampleQuests`).

### Zone Share Offer

`Zone-Share-Offer.lua`: when the player joins a party or someone joins it, whisper each party member in the player's zone how many of the player's shareable quests for that zone they lack. Setting `zoneShareOffer`. Handlers on owner `ns.zoneShareOffer`.

- **Noting members** (`Scan`, `members` by GUID: due time, or `true` once done). `GROUP_JOINED` / `GROUP_ROSTER_UPDATE` / zoning note each new party GUID due `ns.ZONE_OFFER_DELAY` later (Questie swaps logs meanwhile). Nothing noted until `ready`. Members present while the setting is off are marked done, never offered later. Party only: `PartyUnits` is empty in a raid.
- **Kept through a reload.** Done GUIDs go to `ns.db.char.zoneShareOffered[guid]` with the reason (read back by the report). Login, a reload while ungrouped, or `GROUP_LEFT` wipes it.
- **Login / reload in a group.** Questie requests party logs only on joining, so `RequestPartyLogsThenScan` waits for `Questie.started` (at most `ns.ZONE_OFFER_QUESTIE_WAIT`), sends `QC_ID_REQUEST_FULL_QUESTLIST` via `pcall(Questie.SendMessage, …)`, then sets `ready` and scans. No Questie, or the setting off: ready at once.
- **Checking** (`Check`, ticker on `ns.DUNGEON_CHECK_INTERVAL` while anyone is pending): offline is done; else `Offer`. Still "wait" `ns.ZONE_OFFER_MAX_WAIT` past due: done as "gave up". A member gone from the party is forgotten. Ticker stops when nothing waits, or in a raid / solo / setting off.
- **`Offer` outcomes.** Chat lockdown: wait. `ns.CurrentZone()` nil: in a dungeon or raid instance done (the dungeon share covers it, and that member stays done for the group), else wait. `routes.UnitZone(unit)`: nil waits, another zone is done for good. Then the count, then the name.
- **What counts** (`MissingCount`). `ns.ZoneQuests(zone)` once per check (`check.zoneQuests`), `pushable` only. Needs a source: `UnitIsVisible` (game answers) or `routes.MemberHasQuestie`; neither waits. Missing = game says not on it (readable) and Questie doesn't say so; a secret game answer without Questie never counts. Completed-before quests count (nothing says which). 0: done, no whisper.
- **Whisper.** `ns:Announce("WHISPER", target, ns.ZoneShareOfferFormat(count, zone.name))` (`ZONE_SHARE_OFFER` / `_ONE`, marker on every client). `WhisperTarget` as Good to Go's Rank Watch: `GetUnitName(unit, true)` (on WoW Forever first name + surname; the first name alone reaches no one), else `GetPlayerInfoByGUID` name-realm; unreadable waits.
- **Diagnostics.** `ns.ZoneShareOfferStatus()` → per member done / due / trying with the last try's reason, or the saved pre-reload reason; plus `ready`, ticker. Shown in Sharing Context.

### Dungeon Quests

`Dungeon-Quests.lua` (when, who, what's been had) and `Dungeon-Quest-Lookup.lua` (which dungeon or zone, which quests): in a dungeon with a party, announce the player's quests still to do there and share the shareable ones. Settings `dungeonAnnounce`, `dungeonShare`.

- **Where** (`PartyDungeon`). Instance type `party` or `raid` (`INSTANCE_TYPES`), `IsInGroup()` and not `IsInRaid()`, a setting on. A party turned raid stops; turning back resumes on the roster update.
- **When.** `ns:OnPlayerEnteringWorld`, `ns:OnGroupJoined`, `ns.dungeonQuests:OnGroupRosterUpdate` (`Forever-Quest-Log.lua` owns `ns:OnGroupRosterUpdate`) only start a ticker (`ns.DUNGEON_CHECK_INTERVAL`) via `Watch`. Setting and profile changes call `ns.dungeonQuests.Watch` (`ns.ApplyQualityOfLifeSettings`, `ns:ApplyProfile`). The ticker stops when nothing is left, or outside a party dungeon.
- **Who.** `PartyMembers`: `partyN`, online, by GUID, with range. Unfilled slots (around loading screens) and secret GUID / connection (`ns.IsReadable`) are skipped, so they never read as leave-and-rejoin. Range: `UnitInRange` (unchecked counts out); WoW Forever hides party range, so `IsInRange` says yes there and both go on the first check.
- **Gathering.** Waits until every online member still owed the announcement or a share is in range, or `ns.DUNGEON_SHARE_MAX_WAIT` from `waitStart`. Members already shared with are never waited on; if only out-of-range members remain owed when the wait ends, a fresh wait starts.
- **What this group has had** (`dungeons[key]`: `announced`, `sharedWith` GUIDs). Key: instance ID (8th return of `GetInstanceInfo`), same for every instance of a dungeon, independent of Questie. Memory only, cleared on `GROUP_LEFT`. So one announcement per dungeon per group, shares once per member per dungeon, nothing on re-zoning, a run of their own for a later joiner (whose `QuestLogPushQuest` offers to the whole party; "already on it" earns no whisper).
- **Login and reload.** Not arriving: `adoptPending` from `isInitialLogin` / `isReloadingUi`; until `ns.DUNGEON_LOGIN_GRACE` after the first member appears (roster fills late), each check marks the dungeon announced and members shared. Only if grouped at that loading screen (`groupedAtLogin`); a group formed after is arriving. The next loading screen resets it.
- **Announcement** (`DungeonAnnouncementArguments`): skips ready and failed; to `ns:GetGroupChatChannel()` (instance chat, raid, party). References via `ns.FittingQuestReference`, joined by `LIST_SEPARATOR`, packed greedily, split only between quests. First message `DUNGEON_QUESTS_ANNOUNCE` (`_ONE` for one), later `DUNGEON_QUESTS_ANNOUNCE_CONTINUED`. Nothing to do: nothing sent, counts as announced. Chat lockdown: `Announce` returns false, retried next check. `ns.BuildDungeonAnnouncement` gives the built messages (Options, reports).
- **Sharing** (`Share`): every matched `pushable` quest, ready or not, filtered by `ns.QuestsPartyNeeds(…, units)` for the newly in-range members, then a `ns.BuildSharePrint` line naming the dungeon and `ns.ShareQuests(questIDs, units)`. Nothing left: no print, members still marked. While `ns.sharingQuests`, the share waits for a later check with members unmarked.

#### Which Quests (`Dungeon-Quest-Lookup.lua`)

- `CurrentDungeon` (`ns.CurrentDungeon`): name, `key`, `areaIDs` (Questie `ZoneDB.instanceIdToAreaId[instanceID]` plus alternatives from `ZoneDB:GetDungeons()`, as Questie files some dungeons under a second ID), header `names` (`GetRealZoneText()`, instance name, area names of the IDs; empty names while loading name nothing).
- `ns.CurrentZone()`: same shape for the open world (nil in an instance or without `ns.routes`): map from `routes.PlayerZone()` as `key` and `zoneMapID`, names from zone text and map name, no `areaIDs`.
- `ns.DungeonQuests(area)` over `ns.LogQuests()` in log order; `ns.ZoneQuests` is the same function. Each match carries `matchedBy`:
  - `header`: quest's zone title is one of `names`.
  - `Questie` (`QuestieQuestIn`): `zoneOrSort` in the area, or an objective creature / object spawns there, an item drops there (NPC or object drop), a kill credit, `triggerEnd`, extra objective (spawns or references) or required source item is there. Catches class quests.
  - Area test (`AreaHas`): dungeon by its `areaIDs`; zone by Questie's `GetUiMapIdByAreaId` (cached per area ID in `areaMaps`) inside the zone (`routes.IsInZone`) and not an instance map (`routes.IsInstanceMap`).
  - World event quests (`QuestieEvent.IsEventQuest`) never count, even under the header.
  - Every Questie read `pcall`ed. No Questie, or an area it can't place: header only.
- `ns.CurrentDungeonNames()`: the header names for the current-zone mark (`Quest-Sort.lua`), cached on instance ID + zone text + whether Questie's `ZoneDB` is there, because the list asks per header per repaint.

#### Diagnostics

- Sharing Context (`Manifests.lua`): group, run, combat, interval, selected quest's shareability and `ns.PartyNeedsQuest`, zone's Share Quests count (counts only on index clients); in a dungeon also Questie lookups present (`DUNGEON_QUESTIE_QUERIES`), event quests left out, instance ID, key, area IDs, raid flag, `ns.DungeonShareStatus` (ticker, announced, wait, members' range and shares), matched quests and the announcement with bytes.
- On index clients the report's `DungeonQuests` swaps `ns.DiagnosticLogQuests` in for `ns.LogQuests` for the call, so nothing is expanded or selected; non-selected quests read "sharing not checked", collapsed zones are counted and left out.

### Quest Text

Both quest logs and the quest giver window, every client, set quest text from shared files:

- `Quest-Display.lua`: naming. `ns.QuestListTitle` (tagged only while `showQuestLevels`), `ns.LevelTag` / `ns.LevelTitle`, `ns.QuestSuffix` (letter from the flavor's `ns.QUEST_TAG_SUFFIXES`, since tag IDs mean different kinds per flavor; E for an untagged elite), `ns.QuestLevelLegend` (only letters this client can show, built once at load), `ns.StyleQuestID`.
- `Quest-Objectives.lua`: `ns.StyleObjective`, `ns.CheckIcon` / `ns.InlineIcon`, `ns.TwoSpacesWide`, `ns.ClearObjectiveCounts`.
- `Quest-Info-Style.lua`: section heading font, `ns.StyleQuestText`, Blizzard style memory (`ns.RememberBlizzardStyle` / `ns.RestoreBlizzardStyle` / `ns.BlizzardFontFile`), `ns.StyleQuestInfo` / `ns.RestoreQuestInfoStyle`, `ns.CreateRoomBelow`.
- `Quest-Details-Data.lua` (WoW Forever and Mists TOCs, after `Quest-Log-API.lua`): `ns.GetSelectedQuestDetails`, the selected quest as plain data.
- `Quest-Rewards.lua`: experience and gold wherever `QuestInfo` shows them, `ns.SpaceAroundRewardButtons`, `ns.SpaceRewardsBlock`.

- **Section heading font** (`PrettyWideQuestLogSectionHeadingFont`): `QuestTitleFont` less `LAYOUT.SECTION_HEADING_SHRINK`, so the title reads as the one heading over Description / Rewards. No shrink when ElvUI is loaded (checked once at load; its title font is already small). Re-copied on every `SetFont` / `SetShadowColor` / `SetShadowOffset` on `QuestTitleFont`, since skins set it after load and again on option changes. Area copies of it (see Fonts) follow in turn: `Fonts.lua` hooks the heading font's own `SetFont`.
- **`ns.StyleQuestText(region, sectionHeading, area)`**: `LAYOUT.LINE_SPACING`; with `sectionHeading` the section heading font; with `area` that area's copy (of the heading font, else of the remembered Blizzard font object, else the current one). Keeps color.
- **`ns.RememberBlizzardStyle`**: first call per region only. Stores `ns.FontBase` of its font object (so a region already on an area copy still records Blizzard's), file/size/flags and spacing. Restore uses `SetFont` only when Blizzard had set no font object; a region with neither keeps what it has.
- **Spacing**: every gap, margin and padding is a step of `LAYOUT.SPACE` (`Data/Data.lua`, each step double the last; the comment there says what each is for). Free sizes follow the same doubling. Positions matched to Blizzard's art, and Blizzard's own control sizes, stay. Named gaps (`TITLE_SPACE_BELOW`, `HEADING_SPACE_ABOVE` / `_BELOW`, `REWARD_BUTTONS_SPACE`, `REWARD_LINE_SPACE`, `MONEY_EXPERIENCE_SPACE`, `PAGE_TOP`, `QUEST_LINE_SPACE`, `QUEST_ID_GAP`, ...) are `LAYOUT` entries built from those steps.

#### Two Kinds of Details

- **Classic Era and TBC** (`Classic-Quest-Details.lua`, a wide quest log part): restyles Blizzard's `QuestLog*` regions in place.
  - Fonts (`details` area via `ns.StyleQuestText` / `ns.SetAreaFont`), widths and anchors set once: the quest log has them to itself, and a font setting reaches them through the font object. Only the title is anchored to the pane; the rest hang off it.
  - Description heading's gap reset after every `QuestLog_UpdateQuestDetails` (`SpaceAboveDescription`), because Blizzard re-anchors it each time under whatever comes last.
  - `QuestFrameItems_Update` hook, `"QuestLog"` only (`AlignRewards`): `Realign` zeroes Blizzard's 3px offsets (first reward button of each section left, captions in) so two button columns fill the text column exactly; `SpaceUnderRewardsHeading`; `ns.SpaceAroundRewardButtons`; `AlignMoney` right-aligns gold two spaces in, `MONEY_RIGHT_PADDING` cancelling the money frame's own inset.
  - Chain and quest ID go inside `QuestLogSpacerFrame` (Blizzard's spacer under the last piece), grown to hold them, placed again a frame later once the pane settles (`PlaceQuestID`).
- **WoW Forever and Mists** (`Forever-Quest-Details.lua`): own frames from `ns.GetSelectedQuestDetails`, never calling or borrowing `QuestInfo`, which the quest giver window and Blizzard's own details (map's on WoW Forever, `QuestLogFrame`'s on Mists) use, so none can blank or misstyle another's text.
  - `ns.DisplayQuestDetails` calls `ns.SelectQuest` first: the data calls read Blizzard's selection, and `Mists-Quest-Portrait.lua` reads it after.
  - `Place` stacks pieces down the column; `height` accumulates and the scroll child ends `PAGE_TOP` under the last. Order: title (name only, `QUEST_TITLE_FORMAT_FAILED` if failed; icon and level are already in the list), objectives text, timer / group size / required gold, WoW Forever's next waypoint, objective lines, Description, Rewards, chain, quest ID.
  - Timer counts down from an `OnUpdate` on the scroll child (`timerExpires`), set only while the quest has one, because only events repaint the pane.
  - Colors: `GetMaterialTextColors`, `"Stone"` plus Quest Text Contrast's background atlas when it wants light text; finished objectives `FINISHED_COLOR`, as Mists grays them.
  - Rewards (`PlaceRewards`): choices, spells, then the "You will receive:" line with gold right-aligned on it (`CoinText`: `C_CurrencyInfo.GetCoinTextureString`, else the global), experience under it (`MONEY_EXPERIENCE_SPACE` with gold, `SPACE.LINE` without), then items and currencies. Buttons two per row, 1px apart, first row `REWARD_BUTTONS_SPACE` under its line.
  - Reward buttons (`Forever-Quest-Details-Rewards.lua`, `ns.CreateRewardButtons` → `Fill(index, reward)`, `HideFrom(index)`): plain `LargeItemButtonTemplate`, made on first need. Quality-colored names, counts via `ns.FormatNumber`, unusable tinted. An unloaded item asks once (`ContinueOnItemLoad`) and calls `ns.RequestUpdate` on arrival. Hover and modified click re-select (`ns.SelectQuest`) before `SetQuestLogItem` / `SetQuestLogCurrency` / `GetQuestLogItemLink`, since those read the selection and something may have moved it; spells use `SetSpellByID`.
  - Scroll bar is the list's `MinimalScrollBar`, because `ScrollFrameTemplate`'s bar differs per client.
- **`ns.GetSelectedQuestDetails(questID)`**: fields listed in its comment. Client-specific calls chosen once at load, by-quest-ID variant first. WoW Forever only: group size, next waypoint, currency choices (`GetQuestLogChoiceInfoLootType`, indexed apart from items for their tooltips), `C_QuestInfoSystem.GetQuestRewardCurrencies`. Mists' reward currency indexes can skip, so it scans to `GetMaxRewardCurrencies()`. Spells skip known, boost and follower spells; objectives skip `spell` and `log` types, as Blizzard does. Choices, rewards, money and experience stay empty unless `C_QuestLog.ShouldShowQuestRewards`; spells don't check it.

#### Shared Pieces

- **Objective lines** (`ns.StyleObjective`, both logs): description's font and spacing (`MatchFont`), not Blizzard's smaller one. Check (or same-size blank so names align), name, count in its own FontString right-aligned `COUNT_GAP` clear, the line narrowed to make room. `SplitObjective`: "8/8 Name" (WoW Forever), "Name: 8/8" (Classic), zhCN/zhTW's full-width colon; anything else is all name. Check sized in whole pixels and dropped `CHECK_DROP` of the size, because self-sized it came out small and riding high in ElvUI's font. Skins recolor lines in later hooks, so counts re-match their line's color a frame later (`RecolorCounts`).
- **Two spaces in** (`ns.TwoSpacesWide`): body text wraps short of the column edge, so a number flush to it looks like it runs past. Counts, gold, experience and quest ID end two spaces in, measured as "0  0" minus "00" because a FontString may not draw trailing spaces.
- **Quest ID** (`ns.StyleQuestID(text, questID, source)`): source's (the description's) font less `QUEST_ID_FONT_SHRINK` via `SetFont`, its color. On first use it hooks source's `SetTextColor` and recolors the ID and its Wowhead chain icon (color baked into the `|T` string), since skins recolor the description later.
- **TBC daily reset line** (`L["DAILY_RESET"]`, `GetQuestResetTime`, `Classic-Quest-Details.lua`): under the title, objectives `DAILY_RESET_SPACE_BELOW` under it while shown. Never on Classic Era (`ns.IsDailyFrequency` false without `LE_QUEST_FREQUENCY_DAILY`). Takes the description's font object, then its font (a skin may set it apart from the object); color follows the description's `SetTextColor`.

#### Blizzard's QuestInfo

Shared by the quest giver window's detail and reward pages (every client) and Blizzard's own details (WoW Forever, Mists). Follows the quest giver cleanup, not the Wide Quest Log switch.

- **Styled before layout**: `ns.ApplyQuestGiverCleanup` runs `ns.StyleQuestInfo` (`QUEST_INFO_TEXT`, `QUEST_INFO_HEADINGS`, the rewards frame's choose/receive text and `Header`; `dialogue` area) as saved settings load, before Blizzard first measures; off → `ns.RestoreQuestInfoStyle`. Pieces a client lacks are skipped. Page objective lines keep Blizzard's font, no check or count column.
- **Experience and gold** (`QuestInfo_Display` hook, `Quest-Rewards.lua`): for every caller, the description's font object and color while the cleanup is on, Blizzard's while off.
  - Experience regrouped with `ns.FormatNumber`. ElvUI appends a level share in bright green from a hook of unknown order, so only the leading number is regrouped; while the description is dark (parchment) every color code becomes `PARCHMENT_GAIN` after each `SetText` / `SetFormattedText` (`RecolorGain`, guarded against its own `SetText`).
  - Gold: coin buttons get `PrettyWideQuestLogMoneyFont` (copy of the description's font object, no shadow); Blizzard's coin fonts kept per button (`blizzardCoinFonts`). Blizzard sizes coins when it lays them out, so when a button's font object changes `MoneyFrame_Update` reruns with `staticMoney`.
- **Rewards block** (`ns.SpaceRewardsBlock`, from `SpaceQuestGiverPage`): `HEADING_SPACE_BELOW` under the heading, buttons `REWARD_BUTTONS_SPACE` clear of text (`ns.SpaceAroundRewardButtons`), later lines `REWARD_LINE_SPACE` where Blizzard leaves `BLIZZARD_REWARD_LINE_GAP`, experience `MONEY_EXPERIENCE_SPACE` under gold or `SPACE.LINE` without (then "You will also receive:" is its own label). Block height grows by how far pieces moved; idempotent on the same layout.
- **Skin fixes** (`Quest-Giver-Skins.lua`, listed after `Quest-Giver.lua` so its `QuestInfo_Display` pass runs after the page is spaced):
  - Reward names: Blizzard draws them white on a dark plate; a skin hiding the plate leaves white-with-shadow on bare parchment. Cleanup on and plate hidden or alpha 0 → description's color, no shadow. Buttons are shared, so every display restyles every button, again a frame later because skins restyle in later hooks. Otherwise → color and shadow kept in `namesBefore`.
  - Backdrop: see Quest Giver Window.

### Fonts

`Fonts.lua`, every client, loaded right after `Utilities.lua` so files that make FontStrings as they load can ask for fonts. LibSharedMedia-3.0 ships with the add-on (`.pkgmeta` external, every TOC). Four text areas (`ns.FONT_AREAS`), each `profile.fonts[area]` = `face`, `size`, `outline`, `shadow`, `slug` (defaults in `Data/Default-Settings.lua`), set from the Font section `ns.AddFontOptions` (`Options-Fonts.lua`) adds to its panel:

- `list` (Quest List panel): quest list rows, the zone Share Quests button (`Zone-Share.lua`), the empty-log line; WoW Forever and Mists in `Forever-Quest-List.lua`, Classic Era and TBC on Blizzard's rows in `Classic-Quest-List.lua`'s `StyleQuestRows` (`ns.SetButtonAreaFonts`).
- `details` (Quest Details panel): the quest log's details (`Forever-Quest-Details.lua`; `Classic-Quest-Details.lua`'s Blizzard regions).
- `dialogue` (NPC Dialogue panel): quest giver pages, gossip greeting, and the `QuestInfo` pieces they share with Blizzard's own details. Part of the cleanup's styling, so its controls are disabled with `FONT_DIALOGUE_NEEDS_CLEANUP` while `giverCleanup` is off.
- `window` (Window & Map panel): window title, quest count (`Forever-Quest-Log.lua`; `Classic-Quest-Log.lua`) and Turn-In line. The bottom buttons are in no area.
- The three quest log sections take `Hidden` / `Inactive` (`Options-Quest-Log.lua`): hidden with the Quest Log switch off, grayed until the wide quest log runs.

How: `ns.AreaFont(area, blizzardFont)` returns the area's copy of a Blizzard font object (object or global name), made once per area and font (`PrettyWideQuestLog<Area>Font<N>`): `CopyFontObject` of Blizzard's, then face (`""` = Blizzard's; `GAME_FONTS` keys = the locale's `STANDARD_TEXT_FONT` / `UNIT_NAME_FONT` / `DAMAGE_TEXT_FONT`; else a SharedMedia name), size (points added to Blizzard's, `ns.FONT_SIZE_MIN`..`MAX`, never under `SMALLEST_SIZE`), outline (`DEFAULT` keeps Blizzard's, `MONOCHROME` always kept), shadow (`false` clears it) and `SLUG`. Defaults copy Blizzard's exactly but for Slug, so the text follows the game's fonts and whatever ElvUI or a font add-on does to them. Each Blizzard font copied is hooked on `SetFont` / `SetShadowColor` / `SetShadowOffset` (`Follow`) and its copies re-synced; copies themselves are never hooked.

- **Slug** (`Flags`): added only where the font has no thick outline, no `MONOCHROME` and no visible shadow (`HasShadow`: offset and alpha), none of which Slug draws. On by default, so it lands on the parchment's shadowless text and leaves the list's shadowed gold text alone until its shadow is turned off.
- **FontStrings use the copy as their font object**, so a setting change redraws them with nothing to set again. `ns.ApplyFontSettings` = `ns.SyncFonts`, then what measures text: `ns.RefreshQuestLog` (while `ns.wideQuestLogActive`) and `ns.ApplyQuestGiverCleanup`.
- **Blizzard's regions** take the copy through `ns.StyleQuestText(region, sectionHeading, area)`, `ns.SetAreaFont` or `ns.SetButtonAreaFonts`, keeping color. `ns.FontBase` unwraps a copy, so `ns.AreaFont` never copies a copy and `ns.RememberBlizzardStyle` stores Blizzard's object, which lets the cleanup going off restore Blizzard's.
- **No font yet**: a Blizzard object with no font set comes back as itself, uncached.
- **Load order**: copies made as files load have no saved settings yet (`ns.FontSettings` nil) and match Blizzard's. Core runs `ns.SyncFonts` right after AceDB and in `ns:ApplyProfile`.
- **Missing SharedMedia face**: `FontFile` returns nil, so the area keeps Blizzard's face until it's registered; `LibSharedMedia_Registered` for a name some area uses reruns `ns.ApplyFontSettings`. `ns.FontChoices` keeps listing a saved name SharedMedia lacks, so the dropdown never shows blank.
- **Reset Font** writes every key from `ns.DATABASE_DEFAULTS.profile.fonts[area]` (AceDB leaves defaults out of the saved file).
- Quest Log Context lists SharedMedia's font count and each area's settings with the resulting file, size and flags (`FontLines`, `FONT_REPORT_BASES`, `Manifests.lua`).

### Quest Giver Window

Gate: `ns.IsQuestGiverCleanupOn()` = `giverCleanup` (`Quest-Giver.lua`), the NPC Dialogue panel's switch (`Options-NPC-Dialogue.lua`), independent of the Wide Quest Log and Quality of Life switches, so it works with Blizzard's quest log. `MoveQuestGiverCleanup` (`Core.lua`) sets it off once per profile (`giverCleanupMoved`) where `enableQualityOfLife` is false. `ns.ApplyQuestGiverCleanup` reapplies at once (pages, backdrop, `QuestInfo`, then `ns.RequestUpdate` where defined); called by Core as saved settings load, `ns:ApplyProfile`, the NPC Dialogue toggles and `ns.ApplyFontSettings`. An open window relays out on its next open.

- **Own text** (`StyleQuestGiverPages`, `QUEST_GIVER_PAGES`): FontStrings the greeting/detail/progress/reward pages hold directly (chiefly the progress page, which no client draws with `QuestInfo`). Found by font, not name: Blizzard's font file (`ns.BlizzardFontFile`, the remembered one, since styling changes it) equal to `QuestTitleFont`'s = heading; the heading hung from the page itself = the title. `dialogue` area. Styled at load, before first layout.
- **Shared `QuestInfo` text**: see Blizzard's QuestInfo.
- **Detail and reward page spacing** (`SpaceQuestGiverPage`, `QuestInfo_Display` hook, quest giver page + cleanup on only): walks `template.elements` (every third entry is a show function), sets each piece's space above by `PIECE_KINDS` kind (hung from the page `PAGE_TOP`; heading `HEADING_SPACE_ABOVE`; rewards that plus `REWARDS_HEADING_RISE`; under the title `TITLE_SPACE_BELOW`; under a heading `HEADING_SPACE_BELOW`; detail pieces `SPACE.NEAR`; spacer 0), only on `TOPLEFT` anchors and pieces parented to that page, then `ns.SpaceRewardsBlock`. The rise is for WoW Forever and Mists, whose Rewards heading sits higher in its block, detected by `ns.LayOutQuestGiverPage` existing (only `Forever-Quest-Giver.lua` defines it). Blizzard lays pages out afresh, so off = left alone.
- **Description fade** (`Quest-Giver.lua`, every client, whatever the cleanup switch): Blizzard reveals the detail page's description with a moving alpha gradient and ends the fade once the FontString says it's past the last letter; skinned (ElvUI) and laid out, it can say so after a few letters and the rest stays invisible. `QuestFrameDetailPanel` `OnUpdate`: when `fading` ends with `fadingProgress` short of the text length, `SetAlphaGradient` past the end for `REVEAL_FRAMES` frames. A fade that reached the end, or instant text, is left alone.
- **Greeting page** (`Quest-Giver-Pages.lua`): greeting `PAGE_TOP` down; Current/Available Quests `HEADING_SPACE_ABOVE` under it (0 when the greeting is empty); first line `HEADING_SPACE_BELOW` under its heading, later lines `QUEST_LINE_SPACE`. `QuestGreetingFrameHorizontalBreak` (hidden by ElvUI but still holding its place) becomes the whole section gap. Blizzard re-anchors all but the greeting each show, so off restores only the greeting (`greetingBlizzardY`). Runs from the panel's `OnShow` and `QuestFrameGreetingPanel_OnShow` (Blizzard calls it directly when already open). Buttons from `titleButtonPool` where present, else `QuestTitleButtonN`.
- **Progress page** (`Quest-Giver-Pages.lua`, `QuestFrameProgressItems_Update` hook): title `PAGE_TOP`, text `TITLE_SPACE_BELOW`, "Required items:" `HEADING_SPACE_ABOVE`, gold or first item row `HEADING_SPACE_BELOW` under it, first row `SPACE.NEAR` under gold. Quest ID right-aligned `QUEST_ID_GAP` under `LastShown` (left button of the last item row, else gold, heading, text), with `ns.CreateRoomBelow` because a scroll frame only scrolls to its last child. Off: title/text/heading/gold go back to offsets kept on first move (`blizzardY`; Blizzard re-anchors the first item row itself), quest ID hides.
- **Gossip** (`Gossip.lua`, every client):
  - Greeting: `dialogue` area and line spacing from `GossipGreetingTextMixin.Setup`. The list measures rows with a hidden copy (`greetingTextFrame` in the greeting's data entry) that Blizzard never runs `Setup` on; unstyled, it measures a long greeting short and the first option overlaps the text. A `GossipFrame.Update` hook styles the copy and, if its height changed, `Rebuild`s the ScrollBox (`RetainScrollPosition`; `FullUpdate` only as fallback, since it leaves shown rows at their old size and place). The copy is made in the first update and persists, so later opens measure right first time.
  - Line spacing (`SpaceGossipLine`): each quest line and option `QUEST_LINE_SPACE` taller, on `Setup` of the quest button mixins and `GossipOptionButtonMixin`. The list measures with a copy set up the same way, so it makes room; `Setup` sizes afresh, so the extra never stacks. A top-hung icon drops half the extra from Blizzard's anchor (`blizzardIconPoints`, kept on first sight); off puts it back.
- **Skinned backdrop** (`Quest-Giver-Skins.lua`, `ns.UpdateQuestGiverBackdrop`): ElvUI keeps the parchment but makes the window see-through, so trackers and nameplates show through. Cleanup on → opaque in the skin's color via `customBackdropAlpha = 1` (ElvUI honors it through color updates); off → the skin's alpha (`skinAlpha`). Backdrop is `QuestFrame.backdrop` (Classic Era, TBC) or `QuestFrame` itself when it has `template` (WoW Forever, Mists); an unskinned window has neither and is left alone. Checked on each `QuestFrame` `OnShow` and by `ns.ApplyQuestGiverCleanup`.
- **WoW Forever and Mists `QuestInfo` pages** (`Forever-Quest-Giver.lua`, `ns.LayOutQuestGiverPage` from its own `QuestInfo_Display` hook): gold and experience right-aligned two spaces in from `template.contentWidth` (`AlignRewardNumbers`); quest ID `QUEST_ID_GAP` under `LastShown` (`LAST_PIECES`, counting only pieces actually on this page, since one left showing from Blizzard's details belongs to that window). One quest ID, its room and its Wowhead button reparent to whichever page shows. Any other caller: quest ID hides, and gold/experience go back beside their labels only if this file moved them (`rewardNumbersMoved`).
- **Level tags** (`giverLevels`, sub-option shown only with the cleanup on; `ns.TagQuestLine`, `Quest-Giver.lua`): log-style tag before each quest line with a known level, in the line's own color, letter from `ns.GetQuestTagByID`. Gossip: hooks on `GossipSharedAvailableQuestButtonMixin.Setup` / `GossipSharedActiveQuestButtonMixin.Setup`, then the button's own `Resize`. Greeting page: `GetActiveLevel` / `GetAvailableLevel` and `GetActiveQuestID` / `GetAvailableQuestInfo`, button regrown to the taller of text and icon. Blizzard may run either twice on the same text, so `levelTaggedText` prevents double tags. `Quest-Giver-Pages.lua` captures `ns.TagQuestLine` at load, so `Quest-Giver.lua` must load first.

### Quest Chain

Every client, Questie data only. `Quest-Chain-Data.lua` finds the chain; `Quest-Chain.lua` draws the section (`ns.CreateQuestChainSection`, `ns.UpdateQuestChainSection(section, questID, headingSource, textSource)`, which returns whether it shows), placed `HEADING_SPACE_ABOVE` under the rewards and above the quest ID. On Classic Era and TBC the details part builds it, so it exists only while the wide quest log runs.

- **Finding** (`ns.GetQuestChain`): `QueryQuestSingle` in `pcall` (Questie may be absent or not ready). Back: a part counts only as the quest's sole prerequisite (single `preQuestSingle`, no `preQuestGroup`) that names it as `nextQuestInChain`; forward: `nextQuestInChain`. Branches show only the straight run. Capped at `MAX_PARTS` (only a data loop reaches it); under two parts = no chain. Last hit cached in `lastChain` (details repaint in bursts; Questie data is fixed per session) and returned by reference, so callers only read. Misses aren't cached: before Questie's DB is ready every quest looks chainless.
- **Labels** (`ns.QuestChainPartLabel`): name from the client, else Questie, else the ID. Badge text only when Questie's level > 0, regardless of `showQuestLevels`. Tag is Questie's corrected `GetQuestTagInfo` where present, else the client's; elite is always the client's. Tag names are never compared (localized).
- **Color** (`ns.QuestChainPartColor`): server difficulty (`C_PlayerInfo.GetContentDifficultyQuestForPlayer`, where the client has it) for a part in the log, since the server rates only logged quests; else `GetQuestDifficultyColor` by level. A badge shows only with both a level and a color.
- **Rows**: heading `QUEST_CHAIN_PROGRESS` with position; rows `ROW_GAP` (`LAYOUT.HEADER_GAP`) apart. Turned-in parts other than the current (`C_QuestLog.IsQuestFlaggedCompleted`) get `ns.CheckIcon` and `TURNED_IN_ALPHA`; the current part gets a band in the text's color (`CURRENT_PART_BAND_ALPHA`, `CURRENT_PART_BAND_MARGIN` for room around the badge). Check and badge have their own column so long names wrap under the name.
- **Badge** (`CreateBadge`): a pill with no art (two circle-masked caps plus a middle, one solid color so overlaps don't show). Text is the quest log color, `QUEST_ID_FONT_SHRINK` smaller than the description; the box is that color times `BADGE_SHADE`, because quest log colors are made for dark backgrounds and wash out on parchment. All badges share the widest possible width (`BadgeTextWidth`: doubled digit with each suffix in `BADGE_SUFFIXES`, cached per font) plus `BADGE_PAD_X` / `BADGE_PAD_Y`, so names align; a part with no badge keeps the empty room.
- **Hover**: Questie's own tooltip (`QuestieLink:CreateQuestTooltip`, `questie:<questID>:<player GUID>`, in `pcall`), skipped until `Questie.started` because before that it only prints a wait message to chat.
- **Fonts**: `CopyFont` reads font, color and shadow off the Description heading and text FontStrings, since skins set them there, not on font objects. ElvUI recolors those only after the details fill, so `FollowSourceColors` hooks `SetTextColor` / `SetShadowColor` on both (once per section) and recolors heading and rows.

### Ready to Turn In

`Turn-In-Line.lua`: total XP and gold waiting in ready quests, a line (`TURN_IN_SUMMARY`, `window` font area) centered between `ns.abandonButton` and `ns.shareButton`.

- Both numbers come from Questie's `QuestXP`, so no Questie = no line. `GetQuestLogRewardXP` takes `self`, `GetQuestRewardMoney` doesn't (matching Questie's definitions); both in `pcall`. Gold via `CoinText` (`C_CurrencyInfo.GetCoinTextureString`, else the global; no gold part without either).
- Quests worth nothing are dropped; line hides when none remain. At `GetMaxPlayerLevel()` only gold shows.
- Callers build `readyQuests` (`{ questID, title, zone }`, list order): `Classic-Quest-List.lua` inside its part, from the listed indexes only (collapsed zones list none); `Forever-Quest-List.lua` from every quest.
- Placed on first show (`PlaceTurnInLine`), not on creation: on Classic Era and TBC `Classic-Quest-Log.lua` records Blizzard's buttons as `ns.abandonButton` / `ns.shareButton` only after the list part made the line.
- Tooltip: quests grouped by zone (`OTHER` for none), zones in first-seen order, under `TURN_IN_TOOLTIP`, in its own `PrettyWideQuestLogTurnInTooltip`, made opaque after every `Show` (NineSlice center and a skin's `backdrop`) because showing restores the see-through style and it opens over quest text.

### Wowhead Link

`Wowhead-Link.lua`, `ns.LinkQuestIDToWowhead(parent, text, getQuestID)`: every quest ID the add-on shows (both logs' details, progress page, WoW Forever / Mists quest giver pages) is clickable.

- Hover: `WOWHEAD_LINK_TOOLTIP`. Click: `PRETTYWIDEQUESTLOG_WOWHEAD` popup (`WOWHEAD_LINK_COPY`) with the address selected. Both act only while the ID text is shown. The edit box reverts any edit; Enter/Escape close.
- Address prefix is `ns.WOWHEAD_QUEST_URL`, one value per flavor in `Data/{Game}/Wowhead-{Game}.lua`, so the TOC picks the site section. Season of Discovery: the Classic Era TOC lists `Data/Discovery/` after `Data/Vanilla/`; each file returns early on the wrong side of `ns.IS_DISCOVERY`.
- No address → returns without a button: no error, just no link. Quest Log Context prints the address or `(none)`; Validate Data checks it through its `Wowhead` row in `ns.DIAGNOSTIC_DATA_SOURCES`.
- Sets `text.linksToWowhead` so `ns.StyleQuestID` prefixes the chain icon (`ns.WOWHEAD_LINK_ICON`, dropped `LAYOUT.LINK_ICON_DROP`) in the ID's color. Returns the button so an ID that changes parents takes it along.

### Quest Map

`Features/Quest-Map.lua`: a map docked right of the window, every client, showing the selected quest's zone. A quest log part, so on Classic Era and TBC it exists only while the wide quest log runs.
- `ns.hasQuestMap` is set at file scope (true wherever the TOC lists the file); `ns.questMap` exists only once the part has run.
- Blizzard's map canvas (`MapCanvasFrameTemplate`) with a few world map data providers, built the way the Battlefield Map is. The add-on's own frame: the world map is never opened or touched.
- `PrettyWideQuestLogMapFrame` is declared in `Quest-Map.xml`: the canvas's `OnLoad` needs its `ScrollContainer` child, which only XML can arrange. `BorderFrame` is what the canvas turns on to block the mouse while locked. The same file declares the marker template (WoW Forever and Mists) and the player arrow template.
- Size: `MAP_ASPECT` at `HEIGHT_SHARE` of the visible window's height (`LayOut`), re-run on every window `OnSizeChanged`; `SPLIT_SHARE` while Zone Info is under it (`questMap.SetZoneInfoShown`, see Zone Info). `questMap.SharedHeight` is the height the two share.
- `questMap.holder` (`BackdropTemplate`, dialog backdrop) takes the mouse, so clicks never reach what's behind the map. Placement is the `style` table (`edge`, `x`, `top`, `bottom`, `inset`), measured in game against the window art; `questMap.SetStyle` changes keys and lays out again (`Classic-ElvUI.lua` uses it, and reskins `holder`, `toggleButton`, `closeButton`, `zoneDropdown`).
- Wheel mode `MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_NONE`: no zoom, but the wheel stays enabled so it doesn't zoom the camera.
- Art refitted (`canvas:OnFrameSizeChanged`) from the scroll container's own `OnSizeChanged`, once the new size has taken.
- **Combat.** The canvas calls `SetPassThroughButtons` on every pin it acquires, which WoW blocks from add-on code in combat. Every pin template of this map (marker, player, Questie's icons, area layer) takes `PrettyWideQuestLogPinMixin`, whose `SetPassThroughButtons` is a no-op, as HereBeDragons-Pins does for Questie's. Defined at the top of `Quest-Map.lua`, outside the part, because the XML templates name it. These pins draw in combat. Blizzard's providers can't: their `RefreshAllData` is held in combat and run from `questMap:OnPlayerRegenEnabled` (Core `EVENTS`, owner `questMap`), defined by each client's map file.

#### Load Order

Each TOC lists, after `Dungeon-Quests.lua`: `Player-Map-Pin.lua`, `Quest-Map.xml`, `Quest-Map.lua`, `Questie-Map.xml`, `Questie-Map.lua`, `Questie-Map-Tooltip.lua`, `Questie-Map-Quest-Giver.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, the client's map file (`Classic-Quest-Map.lua` in Vanilla and TBC, `Forever-Quest-Map.lua` in Camelot and Mists), `Quest-Map-Reveal.lua`. Then `Routes/Routes.xml`, then `Classic-ElvUI.lua` (Vanilla, TBC) or `Mists-Quest-Portrait.lua` (Mists). Why:
- `Player-Map-Pin.lua` (file scope, not a part) defines `ns.AddPlayerPin`, called by `Quest-Map.lua`, and `ns.AddPlayerPinLevel`, called by the client's map file, both at build.
- `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons` as it builds, and defines the pin mixin both XML files name.
- Every `Questie-Map-*` file reads `ns.questMap` as it builds. `Questie-Map-Tooltip.lua` also reads `questMap.QUESTIE_PIN_TEMPLATE`, set by `Questie-Map.lua`.
- The tooltip, quest giver, areas and area layer files only add functions (`ShowPinTooltip`, `QuestGiverMapID`, `ObjectiveAreas`, `SpotOutline`, `DrawObjectiveAreas`, `RemoveObjectiveAreas`), read by `Questie-Map.lua` and the client's map file only when drawing.
- `Classic-Quest-Map.lua` takes `questMap.RequestRefresh` by value as its `QuestLog_UpdateQuestDetails` hook.
- `Forever-Quest-Map.lua` reads `ns.questMap` and `ns.questLog` and hooks `ns.DisplayQuestDetails` at load.
- `Quest-Map-Reveal.lua` hooks the exploration pin the client's map file made (found by `EnumeratePinsByTemplate` at build).
- `Mists-Quest-Portrait.lua` reads `ns.questMap.holder` and hooks `ns.ApplyMapScale` and `questMap.SetZoneInfoShown` at load.
- `Zone-Info-Data.lua` and `Zone-Info.lua` come right after `Routes/Routes.xml`: Zone Info reads `routes.pickUpHelpers`, `routes.FollowUpIndex` and `routes.IsInZone` as it works, and its part reads `ns.questMap` and sets `questMap.onZoneShown` and `questMap.EndBrowse` as it builds. `Mists-Quest-Portrait.lua` and `Classic-ElvUI.lua` come after it, as each reads `questMap.SetZoneInfoShown` or `questMap.zoneInfoBox`.

WoW Forever and Mists run all of it at file load (parts run at once there, `ns.questLogIsOwnWindow`; `Forever-Quest-Map.lua` isn't a part). Classic Era and TBC run the parts in the same order inside `ADDON_LOADED`. Routes needs none of these files at load: it draws on `WorldMapFrame` with templates of its own and reads nothing of `ns.questMap`. The player arrow reads `ns.routes` only when placing itself.

#### First Draw and Picking a Map

- Each client's map file adds the layers, registers frame levels and defines `ns.questMap.FollowQuest`, which the canvas's `OnShow` calls. Every client goes through `ns.questMap.FollowQuestieQuest` with its own fallback map.
- **The canvas needs a map before it first draws**, as the Battlefield Map does: Blizzard's layers ask for zoom levels the scroll container builds only once it has a map. When `FollowQuest` leaves no map, `OnShow` tries `MapUtil.GetDisplayableMapForPlayer`, then `C_Map.GetFallbackWorldMapID` where it exists. It calls `MapCanvasMixin.OnShow` only once `ScrollContainer.zoomLevels` exists (`CanDraw`); until then `drawPending`, run by the first map `questMap.ShowMap` sets (a hide clears it).
- **Whether the canvas has a map is read from `canvas.mapID` (`CanvasMap`), never `canvas:GetMapID()`**, which answers the player's map until one is set: trusting it skips `SetMapID` when the quest is in the player's zone, and the first draw finds no zoom levels.
- `questMap.CanShowMap` accepts only a map with art (`C_Map.GetMapArtLayers` not empty): a client can know a map it has no art for (some dungeons Questie names). `questMap.ShowMap` climbs `parentMapID` to the nearest map with art (`DrawableMap`), stays put when none has any, and returns whether the map moved (a move redraws every layer). The zone dropdown and the quest giver's zone filter with `CanShowMap` without climbing, so a quest whose icons sit only on artless maps counts as having none.

#### Show Map and Map Scale

- Show Map / Hide Map sits `LAYOUT.LIST_BUTTONS_GAP` after the last of `ns.listButtons`, widened once on first show to fit the longer label (`SHOW_MAP`, `L["HIDE_MAP"]`). The map has its own close button (`UIPanelCloseButtonNoScripts`) top right.
- `global.mapHidden`: one setting for every character, no default, cleared (nil) rather than set false when the map shows, so Reset Profile never hides or shows the map.
- An empty log hides the map and Show Map (`questMap.SetLogEmpty`, called by `Forever-Quest-List.lua` and `Classic-Quest-List.lua` on every update), leaving `mapHidden` alone.
- The map is the window's child, so it follows Window Scale. Map Scale (`global.mapScale`) scales the holder on top through `ns.ApplyMapScale`, run on every window `OnShow` and from Reset Window, which writes the default back.
- Both Map Scale and Show Objective Areas live on the Window & Map panel (`ns.BuildWindowMapOptions`, `Options-Quest-Log.lua`): hidden where `ns.hasQuestMap` isn't set or the Quest Log switch is off (`MapHidden`), grayed out while the wide quest log isn't running.

#### The Player Arrow (Every Client)

`Features/Player-Map-Pin.lua`: the docked map has no player arrow of its own, so a provider draws Blizzard's `WorldMapArrow` (`PrettyWideQuestLogPlayerPinTemplate`) at Blizzard's size, turned by `GetPlayerFacing`. The world map and minimap keep Blizzard's own arrow.
- Level `PIN_FRAME_LEVEL_PWQL_PLAYER`, added last by each client's map file (`ns.AddPlayerPinLevel`) so it's over every layer, before the map first draws.
- Position from HereBeDragons the way Routes finds the player (`routes.HereBeDragons`, `routes.PlayerPosition`, out-of-bounds allowed), else `C_Map.GetPlayerMapPosition`. Every value goes through `ns.IsReadable` (WoW Forever secret values).
- Moves on its own `OnUpdate` every `INTERVAL`. Off the shown map (outside 0-1) or with no readable position or facing, only the `Arrow` texture hides, never the pin, so the `OnUpdate` keeps watching.
- No mouse: the map still drags under it.

#### WoW Forever and Mists

`Features/Forever-Quest-Map.lua`, not a part.
- **Layers**, each only if the client has its mixin (`AddProvider`): exploration, fog of war (also needs `FogOfWarFrameMixin`; Mists has the provider but not the frame, so no fog), quest objective area (`QuestBlobDataProviderMixin`), dungeon entrances, flight points, then a marker layer of its own. Frame levels in the world map's order (the `levels:AddFrameLevel` block), `PIN_FRAME_LEVEL_QUEST_MARKER` over Questie's icons, the player last. Entrances and flight points keep Blizzard's own mouse handling (names on hover).
- **Following.** A hook on `ns.DisplayQuestDetails` runs `ShowQuest` at once when `ns.questLog.selectedQuestID` changed, map showing or not, then always `RequestRefresh`, since Questie's icons can arrive after the log changes.
- `ShowQuest`'s fallback: `GetQuestUiMapID`, else (nil or 0) `questMap.QuestGiverMapID`, else the player's zone, handed to `FollowQuestieQuest`. Then `ClearFocusedQuestID` when Questie's icons have the quest or nothing is selected, else `SetFocusedQuestID`; then redraws the blob pin and the marker directly.
- **Never drawn twice.** Blizzard's objective area and the marker draw only `BlizzardQuestID`: the shown quest unless `questMap.questieQuestID` has it. `ShowQuest` redraws them only after `FollowQuestieQuest` has set `questieQuestID`, because a map move inside it redraws every layer while `questieQuestID` still names the last quest.
- **Blob pin `Refresh` is replaced on this map's copy**: Blizzard's redraw less its `questPOI` check, drawing `BlizzardQuestID` only. Questie turns `questPOI` off when its own objectives are chosen, which would leave a quest Questie has no icons for with no area. The CVar and the world map are left alone. It acquires no pins, so it draws in combat.
- **Marker** (`PrettyWideQuestLogQuestMarkerPinTemplate`), the add-on's own rather than Blizzard's quest provider: no mouse (drags pass through, a click runs nothing). Placed at the quest's entry in `C_QuestLog.GetQuestsOnMap` for the shown map, else `C_QuestLog.GetNextWaypointForMap` where it exists (WoW Forever). `MARKER_TEXTURE`, or `MARKER_TEXTURE_COMPLETE` once `ns.IsQuestComplete`. Scaling limits as Questie's icons.
- **Combat.** Every Blizzard provider's `RefreshAllData` is wrapped after it's added: in combat it marks `heldProviders` and returns; `OnPlayerRegenEnabled` runs each held one once. The marker isn't wrapped. Replacing a provider's `RefreshAllData` after the wrap drops the hold.
- Client differences are feature tests (each provider mixin, `FogOfWarFrameMixin`, `GetNextWaypointForMap`), never flavor checks.
- Quest Map Context shows which quest the objective area and marker draw for, the layers this client has, whether combat is holding Blizzard's redraws, and WoW Forever's next waypoint.

#### Classic Era and TBC

`Features/Classic-Quest-Map.lua`, a part. These clients have no Blizzard quest areas or markers, nor data to draw them from, so only the exploration layer; levels `PIN_FRAME_LEVEL_MAP_EXPLORATION`, `PIN_FRAME_LEVEL_QUEST_BLOB`, `PIN_FRAME_LEVEL_ACTIVE_QUEST`, then the player.
- Exploration's `RefreshAllData` is held in combat (`explorationHeld`) and run once from `OnPlayerRegenEnabled`.
- The quest comes from Questie's icons alone. The fallback (`QuestGiverMapID`, else the player's zone) is passed as a function, so Questie's database is asked only when the quest has no icons.
- Selected quest: `GetQuestLogTitle(GetQuestLogSelection())`, a header counting as none. Follows through a `QuestLog_UpdateQuestDetails` hook that only asks for a refresh.

#### Unexplored Areas (Every Client)

`Features/Quest-Map-Reveal.lua`. The map art leaves out unexplored areas, so a quest in a new zone would show bare parchment. It hooks `RefreshOverlays` on this canvas's exploration pin (`MapExplorationPinTemplate`); after Blizzard draws the explored areas, it draws the rest that `ns.MAP_REVEAL_OVERLAYS` lists for the art ID (`C_Map.GetMapArtID`).
- Cut into tiles as Blizzard cuts explored ones: the current art layer's `tileWidth`/`tileHeight`, the last tile of a row or column fitted into the smallest power-of-two file (`PieceSize`). `ARTWORK` sublevel -1, under Blizzard's; joins the pin's `textureLoadGroup` on a full update.
- Table shape: `[artID] = { ["Width:Height:OffsetX:OffsetY"] = "fileID, fileID, ..." }`, files row by row. An area counts as explored when `C_MapExplorationInfo.GetExploredMapTextures` reports the same key.
- Only the client's own file IDs, so no art ships and no other map add-on is needed.
- Art IDs differ by client, so one `Data/{Game}/Map-Reveal-{Game}.lua` per flavor folder: Vanilla, TBC, Camelot, Mists by their own TOCs; Discovery by the Vanilla TOC after Vanilla, each of the pair guarded by `ns.IS_DISCOVERY` so one table is built; Wrath and Mainline listed by no TOC, left out of the zip by `.pkgmeta`.
- Always on, no setting. The world map and Battlefield Map are untouched, so another reveal add-on never draws here, nor this there.
- Quest Map Context shows the art ID, areas listed vs explored, map arts listed, and exploration pins with `RefreshOverlays` to hook.

#### Questie's Icons (Every Client)

`Features/Questie-Map.lua`: a data provider (`questieProvider`) redrawing the selected quest's Questie icons (objectives, turn-in) as `PrettyWideQuestLogQuestiePinTemplate` pins (`Questie-Map.xml`), level `PIN_FRAME_LEVEL_ACTIVE_QUEST`. Questie never draws on this map and isn't told it exists.
- **Source.** Questie's own HereBeDragons-Pins (`HereBeDragonsQuestie-Pins-2.0`): `worldmapPins` maps each icon to its `uiMapID` and world position, turned into zone coordinates by `HereBeDragonsQuestie-2.0`. Both through `LibStub`'s silent flag, once at build (Questie's libraries, not bundled; every TOC's `OptionalDeps: Questie` loads Questie first). Without them nothing draws.
- **`IsShownIcon` leaves out** route lines (`type == "line"`), icons at alpha 0, icons without `data` or `texture`, and manual icons (`isManualIcon`: townsfolk, Show on Map), whose `data.Id` is an NPC's or object's and can equal an unrelated quest's ID.
- **Kept on purpose:** icons Questie's settings hide, since this map shows the quest picked in the log whatever Questie shows elsewhere; and icons Routes hides on `WorldMapFrame` (`Routes-Map-Questie-Icons.lua`), since only the icon texture's alpha is tested.
- **Size.** `ICON_SIZE` times Questie's scale for the icon's kind (`data:GetIconScale()`); Questie's Global Scale is left out, as it would shrink these with Questie's world map icons. `SetScalingLimits` as Questie's world map pins, so pins keep their size on screen instead of shrinking with this smaller canvas.
- **Glow.** With Questie's `alwaysGlowMap`, at `GLOW_SCALE` times the icon, never on `"available"` or `"complete"` icons. Color from `ObjectiveData.Color`, only the file from `icon.glowTexture`: Questie shows that texture only once the world map has been opened.

`ns.questMap.FollowQuestieQuest(questID, fallback)` picks, in order:
1. The dropdown's zone, while the same quest stays selected.
2. The player's zone (`MapUtil.GetDisplayableMapForPlayer`), if the quest has an icon there.
3. The zone with most of its icons (`QuestZones`).
4. The fallback: a map ID, or a function asked only when the quest has no icons.

It sets `questMap.questieQuestID` while Questie has icons for the quest, and returns whether it has any.

- **Zone dropdown** (`WowStyle2DropdownTemplate`, `ZONE_DROPDOWN_WIDTH`, `LAYOUT.SPACE.NEAR` in from the top-left) when icons span more than one zone, most icons first, ties to the lower map ID. A pick (`chosenMapID`) holds until another quest is selected; passed over while it has no icons, back if they return with the same quest selected.
- **Refreshing.** Hooks on Questie's pin library (`AddWorldMapIconMap`, `AddWorldMapIconWorld`, `RemoveWorldMapIcon`, `RemoveAllWorldMapIcons`), since Questie draws a little after the log changes and a batch at a time; the scroll container's resize (circles are sized for the map on screen); the client's map file; the Show Objective Areas toggle; `ns:ApplyProfile`. All only call `questMap.RequestRefresh`: at most once per `REFRESH_DELAY`, only while the canvas is visible (checked on asking and on running). It runs `FollowQuest`, then redraws Questie's provider unless the map moved (`zoneChanged`), which already redrew every layer.

#### Pin Tooltip (Every Client)

`Features/Questie-Map-Tooltip.lua` defines `questMap.ShowPinTooltip`, set as each pin's `OnEnter` by `AddPin`. Questie's own tooltips can't be reused: they gather neighbors from the world map's own pins.
- The quest's name, then every NPC or object on a pin within `CLUSTER_DISTANCE` (a share of the map, each axis apart, not yards); an area's marker stands for every NPC or object in its area (`pin.area.names`). Each is followed by its objectives, one per description.
- Row style: names and objective rows both indented `ROW_INDENT`, so the check (`ns.CheckIcon`, checked once done) lines up with the names; the count on the right (`AddDoubleLine`); done rows in `HELP`.

#### The Quest Giver's Zone (Every Client)

`Features/Questie-Map-Quest-Giver.lua`: `ns.questMap.QuestGiverMapID`, the zone a quest was given in, from Questie's database. The fallback for a quest with no Questie icons (Classic Era and TBC inside the fallback function; WoW Forever and Mists only when `GetQuestUiMapID` gives nil or 0). Quest Map Context shows its answer.
- `QuestieDB` and `ZoneDB` through `ns.ImportQuestieModule`; nil without Questie, `QueryQuestSingle` or `GetUiMapIdByAreaId`.
- Walks `startedBy`, NPCs then objects in Questie's order; for each, the area with most of its spawns (`BusiestArea`, ties to the lower area ID); the first whose zone the map can show wins.
- Else the quest's `zoneOrSort` when above 0 (covers item-started quests). Negative is a class or profession, so such a quest no NPC or object starts gets nil.
- `AreaMapID`: an area with a `ZoneDB` parent (`GetParentZoneId`) gives way to it before `GetUiMapIdByAreaId`; a map without art (`CanShowMap`) is skipped, not climbed.

#### Objective Areas (Every Client)

With Show Objective Areas on (`profile.showObjectiveAreas`), `Features/Questie-Map-Areas.lua` shades where each of the selected quest's objectives is found, as Questie's own areas do, and that objective's icons give way to one marker per area.
- The toggle is grayed out without Questie (tooltip says why, saved choice kept) and asks for a map refresh.
- **Built from `icon.data.ObjectiveData.spawnList`** (every spawn in Questie's database), not Questie's icons, which Questie thins out where they crowd. Only objectives (`SpawnObjective`): never givers or turn-ins.
- **Spawns** (`CollectSpawns`). Kept where `ZoneDB:GetUiMapIdByAreaId` puts the area on exactly the shown map and `Phasing.IsSpawnVisible` agrees (without `Phasing`, all count); one per position and icon. Measured in yards from `GetZoneSize` (Questie's HereBeDragons). Grouped by Questie's icon, so objects and creatures never share an area. Each group sorted by position, so the same spawns always make the same areas.
- **Clustering** (`Cluster`): greedy, each untaken spawn takes later ones within `CLUSTER_RADIUS` of the moving center, two passes.
- **Shape** (`Outline`): convex hull grown through a ring of `PADDING_POINTS` around each corner, by `EDGE_PADDING` or more, so it reaches at least far enough from its middle to clear its marker by `SPOT_GAP` on screen. A lone spawn is a circle, a line of spawns a rounded bar.
- That least reach (`MinRadius`) is in yards from the zone's size and the canvas width at minimum zoom (`GetScaleForMinZoom` where the client has it, else the current scale; `FALLBACK_MIN_RADIUS` when either is unusable). So the gap is the same on every zone's map, and a map resize redraws the areas. No zone size: nothing shaded, every icon plain.
- **Merging** (`MergeTouching`): within one icon group, shapes that overlap or come within `TOUCH_GAP` merge with a new hull until none touch (box check, then separating-axis test), so each blob has one marker, at the hull's centroid, in the look of the objective's icon of that kind. Different objectives, and one objective's objects vs creatures, may still overlap.
- **Circles.** Every icon left on the map, turn-in included, gets a circle clearing it by `SPOT_GAP` (`questMap.SpotOutline`) in its objective's color, or `TITLE` gold for the turn-in. Never merged with areas; not drawn with the setting off. An objective with no spawns placed on the shown map keeps Questie's icons, each circled.
- **Cache.** Per objective in a weak-keyed table (`built`) until the map, the least reach (map size on screen, marker size) or Questie's `spawnList` changes.

`Features/Questie-Map-Area-Layer.lua` draws them on one map-sized pin (`PrettyWideQuestLogAreaPinTemplate`) at `PIN_FRAME_LEVEL_QUEST_BLOB`, acquired only when there's something to shade; the pin zooms with the map.
- Fill: a fan of triangles from the centroid, each a white texture whose four corners `SetVertexOffset` moves onto the triangle's three, corners put counterclockwise first; `FILL_ALPHA`, objective color or `FALLBACK_COLOR`.
- Outline: a `Line` per edge at `OUTLINE_ALPHA`, thickness reset on `OnCanvasScaleChanged` so it stays `OUTLINE_WIDTH` on screen.
- Textures and lines are reused between draws, spares hidden. Neither takes the mouse.
- Quest Map Context shows the setting, `questMap.areaCount` (areas and circles shaded), and for when nothing is shaded: whether `ZoneDB` and `Phasing` were found, the zone's size, and each objective's spawns in the zone vs placed.

### Zone Info

`Features/Zone-Info.lua` (a part) and `Features/Zone-Info-Data.lua` (file scope, `ns.zoneInfoData`): a box under the docked map for the zone the map shows, from issue #31. Show Zone Info (`showZoneInfo`, Window & Map, grayed out without Questie) turns it off, and the map goes back to `HEIGHT_SHARE`.
- **Box.** `questMap.zoneInfoBox`, the holder's child with its backdrop, anchored under it and as wide, so Map Scale, Hide Map and ElvUI's restyle take it too. Its height is `questMap.SharedHeight()` less the holder's. `questMap.SetZoneInfoShown` lays the map out at `SPLIT_SHARE` and keeps it shown with an empty log (`ApplyShown`), where the map falls back to the player's zone.
- **Zone.** `Questie-Map.lua`'s `ShowZone` reports every zone it puts the map on to `questMap.onZoneShown`; the box climbs it to a zone map (`data.ZoneOf`). The header's `WowStyle2DropdownTemplate` menu lists Where You Are, Your Quests (`data.LogZones`, by `zoneOrSort`), Most Quests for You (`data.AvailableZones`, Questie's available quests by `zoneOrSort`, not gray) and every continent's zones (`data.Continents`, from maps 946 and 947). Picking one sets `questMap.browseMapID`, which `ShowZone` takes over the quest's zone, and hides the map's quest zone dropdown. Back to Quest, or `FollowQuestieQuest` seeing a new quest, calls `questMap.EndBrowse`, which only clears it.
- **Quests to Pick Up.** Questie's available set (`AvailableQuests.__availableQuests`), not taken or done (`IsTakenOrDone`), not a dungeon or raid quest, working in the zone (`QuestHere`), started by an NPC or object none of which stands in the zone (`StarterHere`), not gray (`IsTooLow` "green"). Sorted by the giver's zone, then level, then name. Share badge from `questFlags` bit 8 (`QUEST_FLAG_SHARABLE`), Party from `routes.PartyHasQuest`. Ask for Shares fills the chat box (`ChatFrameUtil.OpenChat`) with the shareable ones not in the party, within 255 characters, and never sends.
- **Works in the zone** (`QuestHere`, kept per zone in `zoneCache`, `MAX_CACHED_ZONES`): filed under it (`zoneOrSort`), its starter or finisher spawns there, a creature, object or kill credit objective spawns there, an item objective drops there (`ItemHere`: some source here and at most `FEW_DROP_SOURCES`, or `ZONE_DROP_SHARE` of them; none past `MAX_DROP_SOURCES`), or its explore spot. Area IDs go through `ZoneDB:GetUiMapIdByAreaId` and `routes.IsInZone`.
- **Things to Bring.** Roots: every available quest that works here (giver anywhere), the log's quests that work here, and quests of a profession the character knows at any skill (`SkillQuests`, an index of `requiredSkill` read once a session, resumable like `FollowUpIndex`) that aren't repeatable, whose prerequisites are done and that work here. Then a breadth-first walk of `routes.FollowUpIndex` plus `nextQuestInChain`, `MAX_FOLLOW_UP_DEPTH` deep, keeping quests `CouldEverTake` (race, class, profession known, nothing exclusive taken; no level). Items come from the roots and the follow-ups that work here: `objectives[3]` and `requiredSourceItems`, dropping Questie's item class 12 and, once loaded (`C_Item.RequestLoadItemDataByID`, `GET_ITEM_INFO_RECEIVED`), the game's quest class or a bind-on-pickup or quest bind type. One row per item, needs added across its quests: the log's `Needed`, then `ns.QUEST_ITEM_COUNTS`, then the number before the item's name in `objectivesText`; "?" when none is known. Bag counts (`GetItemCount`, no bank) redraw on `BAG_UPDATE_DELAYED`.
- **Working it out.** `data.Request` runs `Build` in a coroutine, `BUDGET_MS` a frame; a new request drops the one underway. Refreshes when the zone changes, the box shows after something changed, a quest is taken, dropped or handed in (`REFRESH_DELAY`), or after a level or skill change (`AVAILABLE_DELAY`, once Questie has redone its set). Events in Core `EVENTS`, owner `zoneInfo` (file scope, so they register; each does nothing until the part has built).
- **Track a pick-up.** The + saves the quest to `ns.db.char.zoneInfoWanted`; `routes.AddLocalQuestNodes` takes a wanted quest from anywhere in its giver's zone, whatever its level or kind, ahead of every other (`task.wanted`), and `routes.LocalQuestSignature` includes the list so a change plans again. `data.PruneWanted` drops ones taken or done. The + hides while the route is off (`routes.IsWanted`).
- **Data.** `Data/{Game}/Quest-Item-Counts-{Game}.lua`: CMaNGOS `quest_template` ReqItemId / ReqItemCount (classic-db for Vanilla, Discovery and Camelot; tbc-db; wotlk-db for Wrath). One string a file, a line a quest (`\nQuest ID:Item ID,Count,...`), found with a plain `string.find`: a table a quest cost several times the memory. Mists and Mainline ship empty: Cataclysm reworked the old quests and no open Mists database is current, so counts there come from the log and the quest text.

### Quest Giver Portrait (Mists)

`Features/Mists-Quest-Portrait.lua`: Blizzard's Mists quest log shows the giver's model beside itself, so this does the same for the window that stands in for it. Not a part. The Mists TOC lists it after every other Features file (after `Routes.xml`), since at load it reads `ns.questLogFrame`, `ns.questLog` and `ns.questMap.holder`, and hooks `ns.DisplayQuestDetails`, `ns.ApplyMapScale` and `ns.OnWindowResizeStopped` (an empty function in `Window.lua` that exists to be hooked).

- **Blizzard's model is left alone.** A `ModelScene` of its own (`PanningModelSceneMixinTemplate`) in a box with the map's border (`holder.backdropInfo`) and a `NAME_HEIGHT` strip for the giver's name. `Pose` follows `QuestFrame_ShowQuestPortrait`: -1 is the player, otherwise the giver, mounted if it has a mount (with no mount the `mount` actor holds the giver).
- **Placement.** Map open with Zone Info under it: beside the map's top-right corner at Blizzard's size (`PlaceBesideMap`). Map open without it: under the map (`GAP`), Blizzard's proportions (`MODEL_WIDTH`, `MODEL_HEIGHT`), ending level with the art's bottom (`LAYOUT.ART_INSET_BOTTOM`), no wider than the map. Measured through effective scales, since Map Scale applies to the map and not the box. Under `MIN_MODEL_HEIGHT` of room it hides rather than moving. Map closed: beside the window at Blizzard's size (`BESIDE_X`, `BESIDE_Y`).
- **What it reads.** `GetQuestLogPortraitGiver` reads Blizzard's selected quest, so nothing changes while `ns.GetSelectedQuestID` isn't the quest the window shows (a quest giver window took the quest text). No selected quest, no giver, or `QuestLogShouldShowPortrait` (where it exists) saying no hides the box. `posedAs` (portrait, mount, scene) keeps a repaint from restarting the model; cleared when the window closes or nothing is selected.
- **Refit.** Map open/close, window resize and Map Scale refit it a frame later (`RequestRefit`), once the map has been laid out. Hidden during a grip drag (`frame.isResizing`), drawn once as it ends.

### ElvUI, VoiceOver and Spoken Quests

#### Classic Era and TBC

ElvUI and VoiceOver work on Blizzard's own quest log frames, so the Classic files make room for them rather than replacing what they draw. `Classic-ElvUI.lua` and `Classic-VoiceOver.lua` are parts, so neither acts with the Wide Quest Log switch off. The quest giver window's ElvUI backdrop is `Quest-Giver-Skins.lua`'s, on every client (see Quest Giver Window).

- **ElvUI's grip.** `Classic-Quest-Log.lua` removes Blizzard's art and draws its own either way, and on every show moves the resize grip to the skin's backdrop corner (`QuestLogFrame.backdrop`, `AnchorGrip`) when there is one.
- **ElvUI skins at login, after this add-on loads**, so `Classic-ElvUI.lua` checks on each `QuestLogFrame` `OnShow` until there's a backdrop and ElvUI's Skins module, then acts once (`skinned`). With ElvUI's quest skin off there's never a backdrop, and the window keeps the add-on's art.
  - `ns.HideQuestLogParchment` (`Classic-Quest-Log.lua`) hides that art and the "no active quests" parchment, and keeps them hidden.
  - The backdrop is ElvUI's see-through Transparent template, which shows Questie's tracker through the quest text, so it's made opaque in its own color (`MakeOpaque`); `customBackdropAlpha` is ElvUI's field for that and survives its color updates.
  - `HandleButton` on `ns.listButtons`, `ns.zoneShareButton` and the map's toggle; `HandleCloseButton` on the map's close button; `HandleDropDownBox` on the zone dropdown; the holder gets the Transparent template in place of its own backdrop, made opaque the same way.
  - The map moves beside the skin's backdrop instead of the art (`questMap.SetStyle` with `MAP_GAP`, `MAP_INSET`).
  - The WoW Forever and Mists TOCs don't list this file; their window keeps its own art under ElvUI.
- **VoiceOver's title padding.** VoiceOver puts a play button over the start of each title. With it on, the list's row styling starts each title with `ns.VoiceOverTitlePrefix` (`Classic-VoiceOver.lua`): enough spaces to clear the button, measured once per font file and size (else two). Spaces only: a tab draws as a missing glyph in some fonts, ElvUI's among them.
- **VoiceOver's buttons follow Blizzard's order**, row *i* to entry *i* + scroll offset. `ns.MatchVoiceOverButtons(order)` deals them out again by what each sorted row shows, through VoiceOver's own functions (`CreatePlayButton`; `UpdatePlayButton` for a quest a sound pack can read, else `UpdateQuestTitle` with the button disabled; `UpdatePlayButtonTexture`). `CanDealButtons` checks every VoiceOver field it calls first (`OVERLAY_FUNCTIONS` and the data fields), so a VoiceOver update that renames one only leaves the buttons alone.
- **Row styling runs after the buttons.** VoiceOver's functions rewrite the title and move the check, so `UpdateList` (`Classic-Quest-List.lua`) runs `StyleQuestRows` right after `ns.MatchVoiceOverButtons`. VoiceOver's overlay `Update` can run after the `QuestLog_Update` hook and restyle the rows, so it's hooked to `ns.RestyleClassicQuestRows`: buttons and row styling again with the order the last update built (`currentOrder`), without rebuilding the order or rerunning the list's update. Hooked whether or not VoiceOver's quest log part is on yet, since that's read from its saved settings after this file loads.

**Spoken Quests** is a fork of VoiceOver that keeps the `VoiceOver` global and its quest log functions, so all of the above applies to it. `ns.GetVoiceOver` (`Features/Utilities.lua`) finds either (`ns.VOICEOVER_ADDON_NAMES`), returning the global only when it holds `QuestOverlayUI`, `DataModules` and `Enums` (read with `rawget`, since the global falls back to `_G`), and only while its quest log part is on (`Addon:IsPartOn`, where present). Both are in the TOCs' `OptionalDeps`, so the global exists when the Classic file hooks it. Quest Log Context reports the global, its pieces (`VOICEOVER_OVERLAY_PIECES`) and the part switch (`VoiceOverContext`, `Manifests.lua`).

#### VoiceOver and Spoken Quests (WoW Forever and Mists)

VoiceOver or Spoken Quests puts its play buttons on Blizzard's quest list (the world map's on WoW Forever, `QuestLogFrame`'s on Mists), which the window stands in for, so they'd never show. `Features/Forever-VoiceOver.lua` puts one on each quest row of the add-on's list.

- `ns.ShowVoiceOverButton(row, questID)` places it at `LAYOUT.QUEST_TEXT_X` and returns `TITLE_INSET` (0 without a button), which `Forever-Quest-List.lua` moves the title over by.
- Made with VoiceOver's `MakePlayButton`, `BindPlayButton` and `SetPlayButtonState`, disabled for a quest no sound pack can read (`DataModules:PrepareSound`), and only when every one of those fields is there (`GetOverlay`). Bound once per quest, and again while its title hasn't loaded (`boundQuestID`, `boundTitle`).
- A set of its own, one per quest, reusing a button once its quest leaves the log (`TakeLeftoverButton`): Blizzard's list takes VoiceOver's own set back to its rows whenever it redraws.
- Rows are recycled, so each row lets go of its button (`ns.HideVoiceOverButton`) before it's set up again, unless another row already took it for the same quest (`button.row`).

### Routes

One route through the player's quests, planned by `Features/Routes/` and shown by the Waypoint Markers (world map, minimap) and the Quest Arrow.

- **Scope.** Only the player's zone (`routes.PlayerZone`), with the caves, buildings and cities inside it. Whatever zone a quest is filed under, only its spawns here count.
- **What goes on it.** Objectives not done (their Questie spawns clustered into blobs); turn-ins, ready or planned ahead of their objectives; with `partyQuests`, party quests the player lacks; quests to pick up (nearby, or anywhere in the zone as a chain start); with `predictiveRoutes`, whole quests not yet taken and their follow-ups; flight paths not yet discovered.
- **Order.** Open path from the origin, a traveling salesman problem with several candidate places per node and precedence (`Routes-Solver.lua`); a trip somewhere else costs more than its yards, and nothing far off goes between two places of one camp. Known flight paths in the zone are shortcuts that take no time (Flying, below).
- **Needs Questie.** Places, objectives and counts come from Questie's quest log and database; distances from Questie's HereBeDragons (`HereBeDragonsQuestie-2.0`, `routes.HereBeDragons()`, nil until Questie loads it), in world yards.
- **Not a quest log part.** Runs on every client whatever the Wide Quest Log switch says; never draws on the add-on's own map (`ns.questMap`).
- **Engine vs display.** This part covers planning: `Routes-Core.lua`, `-Planner`, `-Solver`, `-Geography`, `-Questie`, `-Blobs`, `-Nodes`, `-Pick-Ups`, `-Quest-Plans`, `-Chains`, `-Flights`, `-Pinning`, `-Overlaps`, `-Stops`, `-Camps`. Hand-off: the planner sets `routes.stops`, `routes.start`, `routes.nodes`, `routes.engaged`, `routes.camps` together and calls every `routes.AddListener` listener (`routes.Notify`); the views read those plus task fields (below). Display, party, group-up, ignore list and TomTom: The Zone Map onward.

#### Loading

Each TOC lists one line, `Features/Routes/Routes.xml`, after `Quest-Map-Reveal.lua`, before Diagnostics: then `Classic-ElvUI.lua` (Classic Era, TBC), `Mists-Quest-Portrait.lua` (Mists), nothing more on WoW Forever.

Leaving that line out removes the feature cleanly:

- `ns.routes` and `ns.routesSolver` are nil; Core's `EVENTS` rows owned by `routes`, `routesMap`, `routesArrow`, `routesItems`, `routesGroupUp` find no handler and register nothing.
- `ns:ApplyProfile` skips `routes.ApplySettings`; `ns.RegisterOptionsPanels` (`Options/Options.lua`) registers neither Maps & Objectives with its three map panels nor Quest Route and Quest Arrow; `ns.OptionsRoutesToggle` hides the General panel's two switches.
- `Diagnostics/Manifests.lua` checks `ns.routes` at file load and adds no Routes API rows; Routes Context reports it not loaded.
- `Options-Routes-Map.lua`, `Options-Quest-Arrow.lua`, `Options-Maps.lua` only define builders, so they load harmlessly.

Most Routes files capture what they need by value at load, so `Routes.xml` order matters. Engine captures:

- `Routes-Planner.lua`: `routes.Notify` (Core). Its `routes.OnLogin(UpdateWatcher)` must be the first login handler, so it stays right after Core.
- `Routes-Geography.lua`, `Routes-Questie.lua`, `Routes-Blobs.lua`: `routes.HereBeDragons` (`Routes-Core.lua`).
- `Routes-Blobs.lua`: `IsInZone`, `IsInstanceMap` (`Routes-Geography.lua`).
- `Routes-Nodes.lua`: `IsInstanceQuest`, `QuestLog`, `QuestState`, `IsEscort`, `ForEachObjective`, `HasSpawns` (`Routes-Questie.lua`); `NewPoints`, `AddSpawns`, `Cluster`, `Candidates` (`Routes-Blobs.lua`).
- `Routes-Pick-Ups.lua`, `Routes-Flights.lua`: `NewPoints`, `AddSpawns`, `Cluster`, `Candidates` (`Routes-Blobs.lua`).
- `Routes-Quest-Plans.lua`: `routes.pickUpHelpers` (`Routes-Pick-Ups.lua`); `AddSpawns`, `NewPoints`, `Cluster`.
- `Routes-Chains.lua`: `routes.pickUpHelpers` (`Routes-Pick-Ups.lua`), `Candidates` (`Routes-Blobs.lua`), `routes.QuestPlan` (`Routes-Quest-Plans.lua`), so that file precedes it. `Routes-Pick-Ups.lua` calls `routes.IsChainQuest` and reads `routes.MAX_CHAIN_STARTS` from `Routes-Chains.lua` only at plan time.
- `Routes-Pinning.lua`: `QuestLog`, `ForEachObjective` (`Routes-Questie.lua`); `BlobKey` (`Routes-Nodes.lua`).
- `Routes-Overlaps.lua`: `Unworked` (`Routes-Nodes.lua`); `RIDE_RADIUS` computed at load from `routes.MIN_STOP_RADIUS` (`Routes-Blobs.lua`).
- `Routes-Stops.lua`: `routes.MIN_STOP_RADIUS`, `routes.NAME_LIMIT` (`Routes-Blobs.lua`). `Routes-Camps.lua`: Questie helpers, `Cluster` (`Routes-Blobs.lua`), `IsArea` (`Routes-Stops.lua`).
- Display files that follow capture engine values too (`Routes-Stop-Lines.lua`: `IsArea`; `Routes-Arrow-Survey.lua`: `routes.AREA_REACH`); their own order is under The Zone Map and The Quest Arrow.

Frames build at file load (planner, watcher, the arrow). Anything needing saved settings or the world map registers via `routes.OnLogin(handler)`. `routes:OnPlayerLogin` runs the dated migrations (`MigrateSettings`, `DropRetiredSettings`, `DropPredictiveSettings`, each tagged with its removal date), then the handlers in load order: `UpdateWatcher` (Planner), saved ignores back into `routes.skipped` (Ignore), the new-character flight rule (Flights), Map's, Minimap's, Arrow's.

#### Settings

- Profile table `ns.db.profile.routes` (Reset Profile restores it); keys and defaults in `ns.DATABASE_DEFAULTS.profile.routes` (`Data/Default-Settings.lua`), each commented. `routes.Settings()` returns the defaults table itself until `ns.db` exists.
- **Feature switches** `showMap`, `showArrow` (General panel and atop each own panel). `routes.IsWanted()` = either on; nothing plans and the watcher doesn't run otherwise. `showLine` draws only between markers, so it never needs a plan.
- **What's planned** (all change the route for both views): `predictiveRoutes` (off by default: a lot for new players), `showFlightPaths`, `showLocalQuests` with its Local Available Quests rows (`localQuestRange`, `localQuestLevel`, `localEscortQuests`, `localGroupQuests`, `localOtherZoneQuests`) on the Quest Arrow panel (`Options-Quest-Arrow.lua`); `partyQuests` on the Quest Route panel (`Options-Routes-Map.lua`), shown while either switch is on. The arrow menu toggles `predictiveRoutes`, `showLocalQuests`, `showFlightPaths`, `partyQuests`, `showNextObjective`.
- **Writes** go through `routes.SetSetting(key, value)`: stores, `UpdateWatcher`, then while wanted notifies every listener and plans at once when `showMap`/`showArrow` comes back with no route (`PlanIfShownAgain`); with neither on, `routes.Clear` (calls `routes.CancelPlan` first, so a plan finishing later can't put the route back).
- **Trap: `SetSetting` doesn't plan.** The arrow menu calls `routes.RequestPlan()` right after (`routes.SetPartyQuests`, `Routes-Ignore.lua`, for `partyQuests`). An Options control waits for the signature to change and settle: `predictiveRoutes` directly, the pick-up settings via `routes.LocalQuestSignature`, `showFlightPaths` via `routes.FlightPathSignature`, `partyQuests` via the party parts (`Routes-Party.lua` reads Questie's party logs only with it on).
- `ns:ApplyProfile` → `routes.ApplySettings`: notify and plan when wanted, else clear.
- Arrow position is account-wide presentation (`ns.db.global.routesArrowPoint`, `routes.ArrowPoint`/`SetArrowPoint`, `routes.ResetArrowPosition`); see The Quest Arrow.

#### Geography

`Routes-Geography.lua`; positions are world yards from HereBeDragons.

- **Zone.** `routes.PlayerZone` climbs from `C_Map.GetBestMapForUnit("player")` out of any `Enum.UIMapType.Micro` map (`ZoneOf`), so a cave still routes the zone around it. `routes.IsUnitOutOfZone(unit)` and `routes.UnitZone` compare the same way; unreadable (`ns.IsReadable`, WoW Forever in combat) or unknown counts as in-zone / nil. `routes.UnitWorldPosition` places a member from their zone map position.
- **Origin.** `routes.Origin()`: a ghost's corpse (`routes.CorpsePosition`, asked of the ghost's map then each parent, since the graveyard can be a zone away; its zone is the deepest map at the corpse) else the player (`routes.PlayerPosition`), with a `corpse` flag.
- **`routes.IsInZone(mapID, zone)`**: parents up to the continent reach the zone (`IsWithinByParents`), or the map is a city that `CITY_ZONES` puts in that zone. Why the second: the capitals are filed under the continent, not their zone, so their parents don't say. A city counts only for its own zone: Thunder Bluff for Mulgore, never the Barrens, though the Barrens' map reaches over it. The table has both the Classic Era/TBC/WoW Forever map IDs and the Mists ones. Cached per zone (asked per spawn).
- **`routes.IsInstanceMap(mapID)`**: the map or a parent up to the continent is `Enum.UIMapType.Dungeon`. Why: the game can file a dungeon's map under its entrance zone, which `IsInZone` alone passes. Cached per map.

#### Nodes: Quests Into Route Points

`routes.BuildNodes(yield)` (`Routes-Nodes.lua`) returns `nodes`, `start` `{ x, y, instance, zone, corpse }` and the pins (`routes.PinEngaged`'s result); nil while Questie isn't ready (`routes.IsQuestieReady`: `Questie.started` and HereBeDragons) or there's no position. It calls `routes.NoteLeftCamps` first.

- **Log source.** `routes.QuestLog()` (`Routes-Questie.lua`): quest ID → Questie quest from `ns.QuestieLogEntries`; on Questie 12.6.3+ a fresh table of each acceptance's `.quest`, before it Questie's own live table.
- **Trap: never `pairs` the log across a yield.** Before 12.6.3 it's Questie's live table, which can change while a yield waits. Walk `routes.LoggedQuestIDs(log)` (`Routes-Planner.lua`), as `BuildNodes` and `routes.BuildCamps` do; `routes.PartyQuests` lists its IDs first the same way.

Build order inside `BuildNodes`: own quests → party quests → `routes.AddLocalQuestNodes` (pick-ups, returns chain starts) → `routes.AddChainNodes` → party objectives wait on the player's own pick-up of that quest → `routes.AddFlightPathNodes` → sort by `key` → `routes.LinkOverlaps` → `routes.PinEngaged`.

Own quests, by `routes.QuestState` (`quest:IsComplete()` in a `pcall`: 1 done, -1 failed, 0 not yet):

- **0:** each objective not `Completed` → `"objective"` node keyed `questID:o<index>`; Questie's `SpecialObjectives` → `questID:s<index>` (`routes.ForEachObjective`). None for an objective with no spawns yet or in `routes.skipped`.
  - Turn-in `questID:turnIn` planned ahead: not `ready`, `requires` = its objective nodes. None when any objective left has no node (the route couldn't finish the quest), nor for an instance quest.
  - **Without `predictiveRoutes` it's still planned, `hidden`**; the planner drops hidden nodes after solving (`Shown`). Why: planned as if the player never walked back, an open path ends out in the fields, and a ready turn-in in town looks cheapest done first.
- **1:** `"turnIn"` node, `ready`, no requirements. Places: every spawn of every NPC/object in `Finisher` (`routes.ForEachFinisher`).
- **-1:** nothing, so a failed escort or timed quest drops off.
- **Turn-ins need the game's own log** (`routes.IsOnQuest`: `C_QuestLog.IsOnQuest`, else `GetQuestLogIndexByID`, else true): Questie can still list a quest a moment after turn-in or abandon.
- **Helping the party** (`routes.PartyNeeds(questID)`, `Routes-Party.lua`): an objective the player has done that a sharing member still needs stays a node, `helping`, and the turn-in isn't `ready` (planned ahead) until nobody needs it. A helping objective the route can't plan is left off and doesn't block the turn-in, so ignoring it is the way to turn in now.

Quest kinds, cached until the quest log settles (`routes.ForgetQuestTags`, from the planner's `QUEST_LOG_DELAY` timer), because the client learns a tag only once it has loaded the quest:

- **Dungeon/raid** (`routes.IsInstanceQuest`): tag in `INSTANCE_KINDS` via `ns.QUEST_TAG_SUFFIXES`, Questie's `QuestieDB.GetQuestTagInfo` first (its corrections), then `ns.GetQuestTagByID`. No tag from either isn't cached, so the signature replans once it loads. Objectives left off; turn-in only at places out in the world (`AddSpawns` with `outdoors` drops `routes.IsInstanceMap` spawns), its blobs cached under their own version so a late tag doesn't keep the indoor ones.
- **Escort** (`routes.IsEscort`): Questie's `questTagIds.ESCORT`, or the `PARTY_ACCEPT` bit of `questFlags`, because most Classic escorts carry no tag.
- **Timed** (`routes.TimedQuests`): from the client, never cached. WoW Forever: `C_QuestLog.GetQuestTimers`. Elsewhere: `GetQuestTimers` + `GetQuestIndexForTimer` + `GetQuestLogTitle`'s quest ID, so the log's selection is never touched.
- A timed or escort quest not failed marks its nodes `urgent` with `turnInDistance` (yards to its nearest turn-in blob here, `math.huge` if none).

Party quests the player lacks (`routes.PartyQuests(ownLog, yield)`, no instance quests): `"objective"` nodes `questID:p<index>`, `party`, never `urgent`; turn-in `questID:pt` from `routes.QuestTurnInBlobs` (`Routes-Quest-Plans.lua`), `party`, `ready` once no objective node is left, else waiting on them and hidden without `predictiveRoutes`. Then each party objective of a quest the player is to pick up (a non-party `pickUp` node) also requires that pick-up, so the player takes the quest before working it.

Which spawns count (`AddSpawns`, `Routes-Blobs.lua`):

- Questie's `{ [areaID] = { { x, y, phase }, ... } }`, 0–100 scale; negative coordinates (Questie's -1,-1) skipped.
- Only where `ZoneDB:GetUiMapIdByAreaId` lands in the zone (`routes.IsInZone`), on the origin's continent, and `Phasing.IsSpawnVisible` shows it.
- An `"event"` objective's or event-icon spawn's name is dropped (`routes.SpawnName`): it only repeats the objective text.

Caching:

- Own and party objective blobs, and own turn-in blobs, cache in a weak-keyed table per Questie objective/quest table (`CachedBlobs`), with zone, instance and a version (`routes.CountEntries` of `spawnList`, so a spawn list Questie fills in later regathers). An objective's blobs carry its raw spawns (`blobs.spawns`) for "is the player among them".
- Database-only lookups (givers, `IsElsewhere`, `IsChainQuest`, quest plans) cache in plain tables per zone, wiped on entering another zone so they don't pile up over a session. Flight master blobs cache on the master's own entry.
- **Trap: nodes are sorted by `key` before anything else**, because Questie's log is a hash and the same quests must give the same route (and the same Shake throws).

Task fields the display reads (beyond the solver's `candidates`/`choice`/`requires`): `kind` (`objective`, `turnIn`, `pickUp`, `flightPath`, `corpse` from `MakeStops`, and `fly` from `routes.AddFlightStops`), `questID`, `questName`, `quest`, `objective`, `blobs`, `spawns`, `ready`, `hidden`, `urgent`, `party`, `helping`, `rider`, `inArea`, `predicted`, `pickUpNode`, `after`, `holdersOf`, `chained`, `shared`, `escort`, `offRoute`, `npcID`, `flightMaster`.

#### Quests to Pick Up

`routes.AddLocalQuestNodes(nodes, start, log, yield)` (`Routes-Pick-Ups.lua`), with `showLocalQuests` or `predictiveRoutes`. Returns the chain starts (nearest first) for `AddChainNodes`.

- **Candidates.** Questie's available set (`AvailableQuests.__availableQuests`, already through Questie's level, repeatable, dungeon and hidden filters), by sorted quest ID; not taken or done (`IsTakenOrDone`: Questie's log, `Questie.db.char.complete`, `C_QuestLog.IsOnQuest`, since the available set lags); not ignored (`questID:pickUp`); givers are NPCs and objects of `startedBy` (never a dropped item) out in the world in the zone (`StarterBlobs`, outdoors); no instance quests; not below `localQuestLevel` (`IsTooLow`: `green` drops gray, beyond `QuestieCompat.GetQuestGreenRange`; `yellow` anything more than 2 below; `questie` nothing more).
- **Handling** (`Handling`): `route`, `map` or `off`, the strictest of what applies: `localEscortQuests` (`routes.IsEscort`), `localGroupQuests` (`QuestieDB.IsGroupQuest`), `localOtherZoneQuests` (`IsElsewhere`). The costly checks run only when they could make it stricter. Returns the reason (`escort`, `group`, `elsewhere`).
- **`IsElsewhere`**: something the quest needs (each creature, object, item drop source, kill credit, child quest's finisher, `triggerEnd` area, the turn-in: `Needs`) has known spawns but none in the zone. A need with no known spawns (bought, made, cloth) counts as here. Child quests matter for items handed out by NPCs, which nothing drops: The Warsong Reports' three updates come from scouts in Ashenvale (child quests 6545-6547), so it's elsewhere from the Barrens, where Kadrak gives and takes it.
- **Which giver places.** A chain start (below) or a quest a party member has (`routes.PartyHasQuest`, `shared`) takes givers from the whole zone; any other, only those within `routes.LocalQuestRange()` (`localQuestRange`, whose default matches the planner's `REPLAN_DISTANCE` so a giver passed between plans isn't missed).
- **Chain start** (`chained`): `predictiveRoutes` on, `routes.IsChainQuest`, and `Handling` gives `route`. Works with `showLocalQuests` off, when chain starts and shared quests are the only pick-ups.
- `route` → a `pickUp` node (`ready`, `quest` a small `{ name, level }` table for the title line, `escort` for `routes.TaskColor`'s `ROUTE_ESCORT`). `map` → `routes.mapOnlyPickUps` (a new table each plan) with `offRoute` = the reason; `BuildCamps` turns them into camps.
- **Never more pick-ups than the log has room for** (`FreeQuestSlots`: `C_QuestLog.GetMaxNumQuestsCanAccept`, else `MAX_QUESTS`, else 20, less Questie's log): shared first, then nearest giver, then quest ID. Past `routes.MAX_CHAIN_STARTS` chain starts, a chain start loses `chained` and keeps only givers in range (or none). Follow-ups don't count against slots: each takes its predecessor's.
- `routes.LocalQuestSignature()`: both switches, player level (Questie offers more per level), range and each choice.

#### Quest Chains Planned Ahead

`routes.AddChainNodes(nodes, start, log, chainStarts, yield)` (`Routes-Chains.lua`), only with `predictiveRoutes`. A quest not yet taken is planned whole, so the route knows a follow-up waits in the north before it sends the player there.

- **`routes.IsChainQuest`**: the zone can finish it (not `IsElsewhere`) and it isn't a breadcrumb whose target doesn't wait on it (`breadcrumbForQuestId` + `IsNeededBreadcrumb`). The giver being here is the caller's check. Cached per zone.
- **Planning a quest** (`PlanQuest`, from `routes.QuestPlan` in `Routes-Quest-Plans.lua`): one `objective` node per objective with spawns here, keyed `questID:f<position>`, `predicted`, requiring the pick-up; its `objective` shaped as Questie's for the views (`Description` the target's or objective's name, `Icon` Questie's icon type for the kind, `Color` `ROUTE_PREDICTED`, `Index`, `predicted`, no count). Then a `turnIn` node `questID:ft` requiring all of them; no turn-in in the zone ends that branch.
- **`routes.QuestPlan`**: `ObjectiveSpecs` reads `objectives` (creatures, objects, items by `npcDrops`/`objectDrops`, kill credit) and `triggerEnd`; an objective with no spawn in the zone (bought, made) is left off. Turn-in blobs from `finishedBy`, outdoors only. `routes.QuestTurnInBlobs` serves the party's `:pt` turn-ins from the same cache.
- **Follow-ups.** `FollowUpIndex`: reverse index of every quest's `preQuestSingle`/`preQuestGroup` (absolute value: Questie's negative sign only skips an exclusive check), built from `QuestieDB.QuestPointers` once a session, one quest per `yield`, resumed by the next plan if cancelled; plus `nextQuestInChain`. Breadth-first queue: the log's turn-ins (by quest ID), then chain starts (each planned whole first), then the party's quests.
- A follow-up's `pickUp` node (`predicted`, `requires` from `WaitsOn`, `after` = the unlocking quest for the tooltip's "After you turn in") needs: not planned, on the route, ignored, taken or done; not an instance quest; not too low; `WaitsOn` non-nil (`preQuestSingle`: any one on the route, nil once one is done since Questie's available set then covers it; `preQuestGroup`: every one not done must be on the route); a giver in the zone; `CouldTake`; `IsChainQuest`; `Handling` = `route`.
- **`CouldTake`**: nothing in `UNPLANNABLE` (fields Questie checks against the character that this can't: skill, reputation, spell, `parentQuest`...), not repeatable, not hidden (Questie's char list or `QuestieCorrections.hiddenQuests`), `requiredLevel` reached, race and class via `QuestiePlayer.HasRequiredRace`/`HasRequiredClass`, no `exclusiveTo` quest taken, done or planned.
- **Party follow-ups** (from `:pt` turn-ins, with `routes.PartyQuestHolderUnits`): keys `questID:pp`, `:pf<n>`, `:pft`, all `party`, `holdersOf` = the quest they grew from (whose holders an ignore is for). `MemberCouldTake` checks one holder's level, race (`LibQuestieDB.Enum.raceMaskById`) and class; members' done quests aren't shared, so `WaitsOn` takes nothing as done and a follow-up needing more than its predecessor is left out. One the player's own chain plans, or anyone has, isn't planned twice.
- Caps (`Routes-Chains.lua`): `MAX_CHAIN_STARTS`, `MAX_PLANNED_QUESTS` (chain starts plus follow-ups, a plan stays quick), `MAX_CHAIN_DEPTH` follow-ups after any one quest.
- **`predicted` means "of a quest not taken yet"**: every chain node but a chain start's own pick-up. `IsPinnable` refuses it; `LinkOverlaps` never anchors one; the views use `pickUpNode` (ignoring a predicted node ignores its pick-up) and `routes.ObjectivesTitle`. Taking the quest replaces the `:f` nodes with real `:o` ones next plan.

#### Flight Paths to Discover

`routes.AddFlightPathNodes(nodes, start, yield)` (`Routes-Flights.lua`), with `showFlightPaths`: each flight master of the player's faction in the zone whose path the character lacks and isn't ignored → `flightPath` node `flight:<npcID>`, `ready`, `npcID`, `flightMaster` (name). At one NPC like a turn-in (`AtQuestGiver`, `Routes-Stops.lua`).

- **List** (`routes.FlightMasters`): Questie's `Townsfolk.townsfolk["Flight Master"]` (built before `Questie.started`), friendly by `QuestieDB.IsFriendlyToPlayer` (fallback on `friendlyToFaction` letters), minus `NOT_FLIGHT_PATHS` (druid Moonglade masters). Cached for the session once Questie has built its list; asked again each plan until then.
- **Known** (`ns.db.char.routesFlightMasters`, NPC ID → true; no API says it away from a flight master). `TAXIMAP_OPENED` (`routes:OnTaximapOpened`) marks the NPC talked to (`TalkingTo`: `UnitGUID("npc")`, else `"target"`), then `ReadFlightMap`: `C_TaxiMap.GetAllTaxiNodes(TaxiMapID())` nodes not `Unreachable`, placed through HereBeDragons (`node.position`, else `TaxiNodePosition`) and matched to the Questie flight master within `MATCH_REACH` (`FlightMasterAt`). **Only when the `Current` node lands within `MATCH_REACH` of the player** (`linedUp`): a client whose flight map isn't drawn like its world map marks only the one talked to. `UI_INFO_MESSAGE` = `ERR_NEWTAXIPATH` marks the talked-to NPC too. `MarkKnown` plans when anything is new. `routes.lastFlightMap` keeps the last read for Routes Context.
- **Trap: a character with paths from before tracking would be sent to every flight master.** Nothing goes on the route on a continent until `ns.db.char.routesFlightMapSeen[instance]` (HereBeDragons instance), set by a lined-up read Questie could match (a flight map shows only its continent). At login a character at `NEW_CHARACTER_LEVEL` or below with nothing seen gets `routesFlightMapSeen.all`.
- `routes.FlightPathSignature()`: setting, tracked on this continent, known count, Questie's flight master count. Display: `routes.FLIGHT_ICON`, `ROUTE_FLIGHT` via `routes.TaskColor`, `routes.FlightPathLabel`.

#### Flying

Known flight paths are shortcuts, always on: flying between two takes no time. The arrow says "Talk to Devrak to fly to Camp Taurajo" (`ROUTES_FLY_FROM`).

- **Which** (`routes.KnownFlights(start, yield)`, set as `start.flights` before the solve, `Routes-Planner.lua`): flight masters in the zone (`FlightMasterBlobs`, so `routes.IsInZone` and its city rule apply) whose path is known (`routes.IsFlightMasterKnown`), each `{ x, y, npcID, name, place }`; nil for fewer than two, or for a ghost. `place` is what the flight map calls it, from `C_TaxiMap.GetTaxiNodesForMap(zone)` (answers away from a flight master) matched within `MATCH_REACH`, the part before the comma ("Camp Taurajo, The Barrens"), cached by NPC ID; else the flight master's name.
- **Cost** (`Routes-Solver.lua`): a leg is the shorter of walking and `FlightYards(a) + FlightYards(b) + FLIGHT_COST` (200 yards, for stopping to talk), each the walk to the place's nearest known flight master. The nearest at each end is always the best pair, and if both ends share one, flying can't beat walking (triangle inequality), so a leg stays a lookup. `FlightYards` caches on the point, stamped with `flightPlan`, which each `Solve` bumps.
- **Waypoints** (`routes.AddFlightStops(stops, start)`, after `MakeStops`): before each stop the leg to it flies to (`Solver.FlightLeg`, the same test against the last solve's flights), a stop at the departure flight master with one `fly` task (`fly:<from>:<to>`, `npcID`, `flightMaster`, `destination`, one candidate) and `landing` (`{ x, y }` of the arrival flight master). Not when that key is ignored. `routes.FlyingSignature()` (known count) replans when a path is learned.
- **Display.** `routes.TaskText`/`TaskColor` (`ROUTE_FLIGHT`), the arrow's and the map tooltip's one line, `routes.FLIGHT_ICON` on the marker, `routes.FlightLabel` ("Flight to Camp Taurajo", `ROUTES_MENU_FLY`) on the menu and in chat; ignorable like a flight path. The map line's leg after a fly waypoint starts at `landing` (`Draw(mapID, positions, landings)`, `Routes-Map-Line.lua`); the flight has no leg. Taking off hides the arrow; landing plans fresh from the arrival.

#### Blobs and Candidates

`routes.Cluster(points, yield)` (`Routes-Blobs.lua`):

- Points live in flat arrays plus a count (`routes.NewPoints`), not a table each: an objective can have hundreds of spawns and per-spawn tables would dominate a plan's memory.
- Grid of `CLUSTER_RADIUS` squares keyed by number; densest first (ties by position); each untaken square absorbs squares whose middle is within `CLUSTER_RADIUS` of the blob's moving center. Last pass sets `radius` (at least `MIN_STOP_RADIUS`) and up to `NAME_LIMIT` sorted names. Returns `{ x, y, count, radius, names }` densest first; yields every `SPAWNS_PER_YIELD` spawns and after each blob.
- `routes.AddWorldSpawns` (continent-wide, by instance, dungeon spawns at entrances) feeds `Routes-Camps.lua` and flight master places.

`routes.Candidates(blobs, start, penalize)`:

- Up to `MAX_CANDIDATES` densest, the nearest to the origin swapped in for the last if absent.
- With `penalize` (objectives), `penalty` up to `SPARSE_PENALTY` yards scaled by sparseness vs the densest, added to route cost, so a thin camp loses unless on the way. Turn-ins, pick-ups, flight paths: none.
- Objectives pass `routes.Unworked(key, blobs)` (`Routes-Nodes.lua`) first: camps on `routes.worked` dropped unless none would remain. The node's `blobs` keep every blob, so standing in a worked camp is still noticed.
- **Trap: a candidate is the cached blob table itself**, so `penalty` is per-plan state written onto shared data: `Candidates` rewrites it each plan, then `LinkOverlaps` and `PinEngaged` change it in place.

#### Two Objectives at Once

`routes.LinkOverlaps(nodes, yield)` (`Routes-Overlaps.lua`), after the sort and before `PinEngaged`, sends the player where one trip does two objectives. Only objective nodes with spawns and a blob.

- **Anchors and riders.** An objective with one blob in the zone, not `predicted` (a quest not taken may never be), anchors. Another with more than one blob, not `urgent`, not already riding, rides when it has a spawn within `RIDE_REACH` of the anchor's blob or names a mob/object the anchor's blob names. Its only candidate becomes a new point at the anchor's place: no penalty, radius at least `RIDE_RADIUS`, count at least 2 (so `routes.IsArea` holds), names from its own nearest blob. `node.rider` = the anchor; `MakeStops` joins them. (Stolen Silver drops in one Sunscale camp, so Raptor Horns is done there.)
  - Key order decides: a rider follows the first anchor that claims it.
  - The rider keeps its own `blobs`/`spawns`, so area and pinning checks measure its own mobs; once the anchor is done, it plans from its own blobs again.
- **Shared camps.** For every other multi-blob objective, each `Unworked` blob counts other objectives with a blob within `RIDE_REACH`. The most shared joins the candidates (with the sparse penalty it would have had), then each candidate's penalty grows by `SHARED_CREDIT` per objective fewer than that blob serves.

#### Finishing What's Under Way

The shortest trip alone would walk the player out of a half-done camp. `routes.PinEngaged(nodes, start)` (`Routes-Pinning.lua`) gives each node that goes first one candidate (penalty zeroed) and makes the rest wait on it (`WaitOn` adds to `requires`). Distances from the origin (the corpse for a ghost).

1. **Timed and escort quests.** While any node is `urgent` only urgent nodes can be pinned, and each urgent quest's nodes go before everything not yet listed: nearest turn-in first (`UrgentQuests`, ties by quest ID, out-of-zone turn-in last). A timer or escorted NPC won't wait while the route tours the zone.
2. **What the player is working.** Otherwise every node whose blob the player is in (`EngagedBlob`) and `IsPinnable` allows is pinned there.
   - `IsPinnable`: never a turn-in not `ready`, never a `predicted` node. Always when `urgent`, one place (no spawns list or one spawn: turn-ins, pick-ups, flight paths, a lone chest), or the first plan in a zone (`routes.start` nil). A spread-out objective only when it was pinned already, is at the last plan's destination (`DestinationKeys`, via `routes.IsTaskLeft`), is being worked (`IsWorkingOn`), or the last plan chose this very blob for it further on (`PlannedPlaces`, by `routes.BlobKey`: the route was coming back, so do it now). A rider only the first two. So riding through a camp of an objective planned elsewhere doesn't take over the route (the arrow lists it under While You're Here).
   - `EngagedBlob`: **in the objective's area** (`routes.InArea`: within `routes.AREA_REACH` of any spawn, plus `routes.AREA_GRACE` once in; needs more than one spawn; the nearest blob is pinned); else, for one place, **inside a blob's radius** (plus `AREA_GRACE` once engaged); or **working it**: within `WORKING_REACH` of a blob's edge while its count rose in the last `WORKING_WINDOW` (`routes.NoteProgress`, each watcher check, records rises of `Collected`; a first look isn't progress).
   - Why `AREA_REACH` measures spawns, not blobs: an area's blob is a circle round its spawns' middle, often well past them, and a zone-wide spread then has no gaps. Its value covers the gap between spawns in almost every camp (`Routes-Core.lua` comment) without showing the eye from across the zone.
3. **Nearby turn-ins**, after solving (`routes.BringTurnInsForward`, on the shown order). Unless an urgent quest is on the route, each ready turn-in moves to the first slot after what it `requires` where the player will be within `TURN_IN_REACH` of it and the detour to it and on to the next waypoint is at most `max(TURN_IN_SLACK, that next leg)`. Why: a turn-in usually opens the next quest. Between camps, with the next far off, it goes first; mid-camp, with more a few steps on, it waits.

- A step-2 node standing in its area also gets `node.inArea`, which lets `MakeStops` join all such areas into one waypoint.
- Pins become `routes.engaged`, by key, `{ blob, collected }` (count when first pinned, kept while pinned). `routes.EngagedSignature(nodes)` lists nodes the player is in now by the same rules, `IsPinnable` included, so walking through a later camp doesn't replan; `routes.PinnedSignature()` lists what the plan pinned.
- **Worked camps.** `routes.NoteLeftCamps` (start of `BuildNodes`): a pinned spread-out objective, not done, whose count rose since pinned and whose camp the player has left (`EngagedBlob` with grace says no), goes on `routes.worked[key][BlobKey]` for `WORKED_MEMORY` (`Routes-Nodes.lua`). Leaving a camp early moves on instead of pointing back. One-place objectives never go on it. `routes.ResetZone` (`Routes-Ignore.lua`) clears it with `routes.engaged`, cancels any plan underway and forgets the last solve.

#### Solving the Order

`ns.routesSolver.Solve(start, nodes, yield, previous)` (`Routes-Solver.lua`): open path from `start`; each node picks one candidate (`node.choice`) and comes after everything in its `requires`. Nodes without candidates, and requirements on them, are dropped first. Returns the ordered nodes (and cost).

1. **Cheapest insertion** (`Construct`): over every node whose requirements are placed, every candidate and every slot after its last placed requirement, add the cheapest.
2. **Local search** (`LocalSearch`), up to `MAX_PASSES`, until no move saves more than `EPSILON`. Per pass: `ImproveChoices` (best candidate between neighbors), `TryOrOpt` (move a run of up to `MAX_SEGMENT`, either way round; a single node may switch candidates), `TryTwoOpt` (reverse a stretch); each of the last two takes its first improving move.
   - **Trap: moves are weighed and validated (`IsValidMove` via `OrOptIndex`/`TwoOptIndex`) without building the route they'd make.** A large route weighs hundreds of thousands of moves; building each would make over 100 MB of garbage per plan.
3. **Shaking** (`Shake`), three nodes or more: `min(SHAKES, max(MIN_SHAKES, floor(SHAKE_WORK / count)))` shakes (capped by `WARM_SHAKES` on a warm start). Each throws `THROWS` nodes to a random slot their requirements and dependents allow, on a random candidate, searches again, keeps the cheapest. Its LCG uses a fixed seed, so the same quests give the same route and it never flickers between equal answers.
4. **Keeping camps whole** (`KeepCampsWhole`): a node between two places within `CAMP_SPAN` of each other whose side trip is more than `CAMP_SPAN` and twice the leg it interrupts (`SplitsCamp`) moves to its cheapest slot that splits nothing and keeps its requirements and dependents in order; where none will do it stays. Why: yards alone now and then leave a camp half done for a turn-in barely cheaper than coming to it later.

- **Cost** (`Solver.Cost`) = each leg's `Distance` + each chosen candidate's penalty. A leg is its yards plus `TRIP_COST` for a trip somewhere else: nothing within `TRIP_NEAR` (one camp, as waypoints merge), all of it past `TRIP_FAR`, a share between. Symmetric, which 2-opt's deltas need, though not a metric. `KeepCampsWhole`'s test uses plain yards.
- **Warm starts.** The planner keeps the last solved order, hidden turn-ins and all, as `Solver.Snapshot` (node keys in order and each chosen place) with zone and instance (`lastSolve`, `Routes-Planner.lua`). A plan in the same zone and instance passes it as `previous`: `WarmRoute` lays out the nodes still there in that order, each on its candidate nearest where it was (within `WARM_REACH`, else candidate 1); a node whose requirements aren't in yet waits and goes in as soon as they are. `Construct` adds the rest, then local search, at most `WARM_SHAKES` shakes, `KeepCampsWhole`. Why: a replan after one objective or pick-up costs a fraction and doesn't reshuffle equal answers (about 40% less time for 1% more walking offline, per the code comment). Node keys must stay stable across plans for this to match. A new area, a landing or `routes.ResetZone` (`routes.ForgetLastSolve`) starts cold.

#### Waypoints

`routes.MakeStops(order, start)` (`Routes-Stops.lua`) folds ordered nodes into `routes.stops`:

- An objective joins the previous waypoint within `MERGE_RADIUS` of its first place, or when both are areas the player stands in (`node.inArea`), however far apart.
- Turn-ins, pick-ups and flight paths (`AtQuestGiver`) join only each other within `SAME_PLACE` (the same NPC), and nothing else joins them, so the route hands in one giver's quests at a time.
- A ghost's route begins with the corpse, a waypoint of its own (`CORPSE_RADIUS`, inside the client's resurrect reach) with task `{ key = "corpse", kind = "corpse" }`.
- `area` when any place is (`routes.IsArea`: count over one and radius over `MIN_STOP_RADIUS`). Radius = largest of its places'; names gather up to `NAME_LIMIT` in a list of its own.
- Shape: `{ x, y, instance, radius, mapID, names, area, turnIns, inArea, corpse, tasks = { node, ... } }`.
- Also here for the views: `routes.ObjectiveText`, `routes.TaskText` (per kind), `routes.TaskColor` (Questie's objective color, `ROUTE_ESCORT` for an escort pick-up, `ROUTE_FLIGHT`, `TEXT` for the corpse, else `TITLE`).
- **Trap: `routes.stops`, `routes.start`, `routes.nodes`, `routes.engaged` and `routes.camps` are assigned together when a plan lands**, so the watcher never compares a new plan's pins with the old plan's nodes.

#### Planning and When to Plan Again

All in `Routes-Planner.lua`.

- **Planner.** A coroutine (`Plan`) on a hidden frame: `routes.BuildNodes` → `Solver.Solve` (warm when it can) → `Solver.Snapshot` → `Shown` (drop `hidden`) → `routes.BringTurnInsForward` → `routes.MakeStops` → `routes.BuildCamps` (`Routes-Camps.lua`; see The Zone Map). `BuildNodes` returning nil keeps the route already drawn. The `Yield` passed to every stage yields once the slice passes the budget: `FRAME_SHARE` of the last frame, clamped to `MIN_BUDGET`..`MAX_BUDGET` ms (`debugprofilestop`). Why a share: a fixed budget would halve a high-refresh screen's frame rate while planning.
- `routes.RequestPlan` records the signature as it starts. While a plan runs, a request sets `replanQueued` (one more after). On a flight path it's dropped (landing plans anyway); in combat it waits. Errors go to `geterrorhandler()`; each listener runs in its own `pcall` (`routes.Notify`).
- `routes.CancelPlan` drops the plan underway and any queued one; called by `routes.Clear`, `OnNewArea` and `routes.ResetZone` so a plan built from old state can't land.
- **Flights.** The watcher reads `UnitOnTaxi("player")` and `InCombatLockdown()` every frame, because no event says reliably when a flight starts (`PLAYER_CONTROL_LOST` precedes `UnitOnTaxi`, and also fires for fears and stuns). Taking off drops any plan and notifies (`routes.IsOnTaxi`; the arrow hides). Landing is `OnNewArea`. On a flight with no camps yet (logging in mid-flight), a check builds the camps alone (`RequestCamps`/`PlanCamps`), so the map has markers in place of Questie's icons.
- **Watcher.** Runs only while wanted (`UpdateWatcher`). Every `CHECK_INTERVAL`, with Questie ready, out of combat and off a flight, it runs `routes.NoteProgress` and plans when:
  - **The signature changed and settled.** `routes.Signature()` (`Routes-Questie.lua`): each quest's state and instance/timed flags, each objective's done flag, has-spawns and helping (`h`), party objective done flags (`routes.PartyProgress`), ignored keys and members, members out of zone, `predictiveRoutes`, `routes.LocalQuestSignature()`, `routes.FlightPathSignature()`, the zone, ghost or alive. Counts and position aren't in it. Questie's data arrives in pieces, so a change plans only when two checks in a row see the same one (`settling`); for `GROUP_SETTLE_DELAY` after the group size changes (`routes:OnGroupRosterUpdate`) it waits regardless.
    - **Trap: the signature must never ask Questie's database for spawns.** `PartyProgress` reads only the shared logs; party spawn lists, the slow part of joining a group, are worked out only inside the coroutine (`routes.PartyQuests(ownLog, yield)`).
  - **The player walked into or out of a camp:** `routes.EngagedSignature(routes.nodes)` ≠ `routes.PinnedSignature()`.
  - **The player moved far:** `REPLAN_INTERVAL` since the last plan and beyond `REPLAN_DISTANCE` from `routes.start`, or another continent, or no `routes.start`. A corpse start never counts as moved.
- **Events** (Core's `EVENTS`, owner `routes`):
  - `QUEST_LOG_UPDATE` restarts a `QUEST_LOG_DELAY` timer that calls `routes.ForgetQuestTags` and forces the next check.
  - `PLAYER_ENTERING_WORLD`, `ZONE_CHANGED_NEW_AREA` → `OnNewArea` (landing too): `routes.CancelPlan` (a finishing plan would restore the old `routes.start`), clear `routes.start` and `lastSolve`, force a check counted as past `REPLAN_INTERVAL`.
  - `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST` force a check.
  - `GROUP_ROSTER_UPDATE` starts the group hold on a size change and `routes.PruneGroupIgnores`. `GROUP_LEFT`, `QUEST_REMOVED`, `QUEST_TURNED_IN`: ignore list (`Routes-Ignore.lua`).
  - `TAXIMAP_OPENED`, `UI_INFO_MESSAGE`: flight paths known (`Routes-Flights.lua`). `PLAYER_LOGIN`: migrations and login handlers (`Routes-Core.lua`).
- **Registration.** Routes' handlers are all file-scope, so with the TOC line they register on every client regardless of the Wide Quest Log switch. `TAXIMAP_OPENED`, `UI_INFO_MESSAGE`, `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST` are Routes' alone everywhere; on Classic Era and TBC so are `QUEST_LOG_UPDATE`, `QUEST_REMOVED`, `QUEST_TURNED_IN` (only `Forever-Quest-Log.lua` defines `ns` handlers for them). `Classic-Quest-Log.lua` defines `ns:OnZoneChangedNewArea` inside its wide quest log part.

#### Combat

- **The route freezes.** The watcher's `SetInCombat` (every frame) drops any plan as a fight starts (it would set out from where the fight began) and checks nothing until it ends. `routes.RequestPlan` in combat (a skip, reset, setting) only sets `planAfterCombat`. After the fight it checks at once and plans if a plan was dropped or asked for. Nothing is printed. The planner's `OnUpdate` also returns in combat, covering the frame before the watcher notices. An objective ignored in combat stays at its waypoint until that plan; the arrow menu hides it meanwhile (`routes.skipped`).
- **Secret values.** WoW Forever can keep unit maps and connection state secret in combat; `routes.IsUnitOutOfZone`, `routes.UnitZone`, `routes.UnitWorldPosition` and the party checks test `ns.IsReadable` first.
- Display in combat (map pins' `SetPassThroughButtons`, `KeepFullSize`, the arrow, Use Item buttons): see The Zone Map and The Quest Arrow.

#### A Waypoint's Look

`routes.ApplyStopLook(marker, stop, textures)` (`Routes-Stop-Look.lua`) dresses anything with the marker template's `Disc`/`Ring`/`Icon` (`PrettyWideQuestLogRouteStopPinTemplate`, `Routes.xml`): zone map pins (`Routes-Map.lua`, `textures` from Questie's pins on that map) and minimap markers (`Routes-Minimap.lua`, empty `NO_TEXTURES`). Loads before `Routes-Map.lua`, which captures `routes.IsUntrackedStop` (camp dimming) at load.

- Disc: tinted by the first task, `routes.TaskColor` (`Routes-Stops.lua`).
- Ring, checked in order: `IsUntracked` (not the corpse; every task `untracked` or in `routes.skipped`) gets `ROUTE_IGNORED_RING` when none is `untracked` (only ignored), else `ROUTE_ALERT_RING`; else `IsPartyStop` (every task `party`) gets `ROUTE_PARTY_RING`. A ring swaps the disc to `Route-Stop-Fill` and shows `Ring`; otherwise `Route-Stop` keeps its own black ring.
- Icon by the first task's kind: corpse `routes.CORPSE_ICON` cropped by `routes.CORPSE_ICON_COORDS` (`ns.CORPSE_ICON_COORDS`, per flavor in `Data/{Game}/Map-Icons-{Game}.lua`: the gravestone cell differs by client); turn-in, pick-up, objective from `textures.turnIns`/`pickUps`/`objectives`; flight path `routes.FLIGHT_ICON` (`Routes-Flights.lua`).
- No pin texture: `QuestieIcon` from `Questie.usedIcons` (player's theme): pick-up `ICON_TYPE_AVAILABLE`; turn-in `ICON_TYPE_INCOMPLETE` while not `task.ready` (planned ahead), else `ICON_TYPE_COMPLETE`; objective's `Icon`, else its first spawn's. Why: Questie draws its pins a while after a quest changes, and the route can draw first.

#### The Zone Map

`Routes-Map.lua`: a `MapCanvasDataProviderMixin` provider on `WorldMapFrame` (`AddToWorldMap`), added at login or on `ADDON_LOADED` for `Blizzard_WorldMap` (event owner `ns.routesMap`). Helpers load before it in `Routes.xml` and are captured by value: `Routes-Stop-Look.lua` (`routes.ApplyStopLook`, `routes.IsUntrackedStop`), `Routes-Map-Size.lua`, `Routes-Map-Line.lua`, `Routes-Map-Questie-Icons.lua`, `Routes-Map-Blizzard-Quests.lua`, `Routes-Map-Tooltip.lua`. `Routes-Map-Meet.lua` loads after it and captures `routes.MapPosition`, `IsOnMap`, `STOP_SIZE`, `STOP_ICON_SIZE`, `STOP_LEVEL`, `WIDE_MAP_SCALE` from it.

What draws (`providerMixin:RefreshAllData`):

- First, always: remove the route's pins, `ApplyQuestieIcons`, `ApplyBlizzardQuests`. Then nothing unless `routes.IsMapShownOn(mapID)` (`Routes-Core.lua`): `showMap`, plus `showWideMapMarkers` on a continent's, world's or cosmos' map (`routes.IsWideMap`).
- Route (line + waypoints) only on the route's zone map or a map inside it (`IsRouteMap`: `routes.IsInZone` against `routes.stops[1].mapID`), never while `routes.IsOnTaxi()`: it's replanned on landing, so mid-flight every map shows camp markers alone.
- Camps on every map shown, then the join-up marker (`routes.AddMeetPin`, see Joining Up with the Group).
- Positions: `MapPosition` (HereBeDragons `GetZoneCoordinatesFromWorldInstance`, past-the-edge allowed). Off the map shown: no marker, the line still runs to it. Another continent: nil, that leg hides.
- Redraws: the canvas's own refreshes; every `routes.AddListener` call while the map shows (closed, it only re-applies the icon hiding, so turning the route off brings icons back); `routes.RefreshGroupUpMarker`.

Camps (`Routes-Camps.lua`, `routes.camps`):

- `routes.BuildCamps` runs at the end of each plan inside its coroutine (and alone mid-flight, `RequestCamps` in `Routes-Planner.lua`); the planner sets it with the waypoints. Quest IDs listed first (`routes.LoggedQuestIDs`).
- A camp: a blob of one objective's spawns across the whole continent (`routes.AddWorldSpawns`, by world instance), shaped as a waypoint with `camp = true` and one task (a proxy of the shared task whose only candidate is the camp). Marker, tooltip and icon hiding treat it as a waypoint.
- Dungeon/raid spawns go at the instance's entrances (`ZoneDB:GetDungeonLocation`), one count per spawn per entrance, so the camp keeps their weight; other spawns on an instance map (`routes.IsInstanceMap`) are left out.
- Blobs cached in a weak-keyed table: by objective (versioned by `routes.CountEntries` of its spawn list), by quest for a turn-in.
- Covers: each objective not done of the player's quests, or done while the party needs it (`routes.PartyNeeds`, task `helping`); each done quest's turn-in while `routes.IsOnQuest`; with `partyQuests`, party quests' objectives not done (`:p<index>`, none for a dungeon/raid quest); each map-only pick-up (`routes.mapOnlyPickUps`, `Routes-Pick-Ups.lua`). A dungeon/raid quest's own objectives get entrance camps marked `untracked`.
- An ignored objective keeps its camps: ignoring takes it off the route, not off the map.
- One marker per objective or turn-in per map (`Gathered`): the camp with the most spawns within `GATHER_REACH`, placed at the spawn-weighted middle of those camps, naming up to `routes.NAME_LIMIT`. Middle just off the map: the objective's first camp on it instead.
- On the route's map, an objective with a waypoint (`RouteKeys`) gets no camp marker; one without draws at `CAMP_ALPHA` behind the waypoints, except an untracked one (its ring says so) and an escort pick-up (its green is the point). Other maps: full strength.

Frame levels (`PrettyWideQuestLogRoutePinMixin:ApplyFrameLevel`):

- Nothing is added to the map's frame level list (see Taint). Each pin reads `PIN_FRAME_LEVEL_AREA_POI` (HereBeDragons-Pins' layer for Questie's icons) and offsets from it by `LEVEL_OFFSETS`, keyed by its `PIN_FRAME_LEVEL_PWQL_ROUTE_*` type: line below, camps above, waypoints and the join-up marker above the camps. On WoW Forever's map the neighboring levels belong to layers it never draws.
- Map without that level: same order over `PIN_FRAME_LEVEL_TOPMOST` + `ABOVE_EVERY_LAYER`.
- The mixin's `SetPassThroughButtons` does nothing (see Pitfalls, Letting the canvas acquire pins in combat).

The line (`PrettyWideQuestLogRouteLinePinTemplate`, `routes.RouteLinePinMixin` mixed in at first acquire, `Routes-Map-Line.lua`):

- One canvas-sized pin, no mouse. Acquired only with `showLine` and at least one waypoint, so nothing runs per frame otherwise.
- Each leg a `Line` of `Route-Dot` repeated, `ROUTE_LINE` at `lineOpacity`. `LINE_WIDTH`/`DOT_SPACING` (`ns.LAYOUT.SPACE`) divided by canvas scale on zoom (`OnCanvasScaleChanged`).
- Dots march by sliding tex coords by `GetTime() * lineSpeed` (dots per second; 0 still).
- First leg follows the player every `UPDATE_INTERVAL` (`routes.OnRouteLinePinUpdate` → `PlacePlayerLeg`), reusing module-level position tables. While joining up it adds `meetLeg` (see Joining Up).

Markers (`PrettyWideQuestLogRouteStopPinTemplate`, `AddStopPin`); disc, ring and icon from `routes.ApplyStopLook` (see A Waypoint's Look).

- Size: `STOP_SIZE`/`STOP_ICON_SIZE` (keep in step with `Routes.xml`) × `markerScale`, or `wideMarkerScale * WIDE_MAP_SCALE` on wide maps, × `UIParent:GetEffectiveScale() / map:GetEffectiveScale()`. `SetScalingLimits` only sets zoom growth, so the setting must go into the size.
- Every acquire sets size, look, alpha, level and position.

Hovering (`OnStopEnter`): sets `routes.hoveredStop` (Questie's icons for its tasks come back) and builds the tooltip. `RemoveAllData` clears `hoveredStop`: a pin can vanish under a mouse that never leaves it.

- Body: `routes.AddStopTooltip` (`Routes-Map-Tooltip.lua`), from `routes.QuestsAt(stop, routes.PositionAt(stop))`, a blank line between quests. Per entry: flight path `ROUTES_FLIGHT_PATH_FROM` (gold); pick-up `ROUTES_PICK_UP_QUEST` in the quest's difficulty color (`routes.QuestTitle`), then in `HELP` why a map-only one is off the route (`OFF_ROUTE_REASONS` by `task.offRoute`) and, for a planned follow-up, `ROUTES_AFTER_TURN_IN`/`ROUTES_AFTER_PARTY_TURN_IN` (`task.after`); only a turn-in left: one gold `ROUTES_TURN_IN_QUEST`; else `routes.ObjectivesTitle` and progress rows. Corpse: one `ROUTES_CORPSE` line.
- Rows: every objective of the quest at this waypoint (`entry.here`), done or not, log order (`routes.QuestObjectives`): `ROW_INDENT`, `ns.CheckIcon` (blank when not done, so names align), description, `routes.CountText` on the right; done in `HELP`.
- `routes.ShowsParty()`: split by player under class-colored names (`routes.ClassColor`, white when secret): the player first unless it's a party quest, then each `routes.MemberProgress` member via `routes.MemberObjective` (by `Index`; Questie's `SpecialObjectives` aren't shared). Otherwise no names.
- Then gold `ROUTES_LOOK_FOR` with one name per row (grows down, not wide), then `routes.AddClickHints`.

Clicking (`OnStopMouseUp`; pins aren't buttons, both close the tooltip first): right-click per `RightClick`: waypoint → `routes.SkipStop`; camp → `routes.IgnoreTask`, or `routes.UnignoreTask` when ignored; nothing for the corpse or an `untracked` camp. Middle-click on any marker → `routes.ResetZone`.

Questie's icons (`Routes-Map-Questie-Icons.lua`):

- While `routes.IsMapShownOn` the map shown and `hideQuestieIcons`, `ApplyQuestieIcons` hides HereBeDragons pins (`QuestieTemplate`: Pins' `worldmapPinTemplate`, `HereBeDragonsPins-Questie-WorldMapPin` since Questie 12.8.0, else `HereBeDragonsPinsTemplateQuestie`) whose icon is for a task on `routes.stops` or `routes.camps`, plus every party objective icon (`IsPartyIcon`, `ObjectiveData.IsPartyObjective`), except the hovered marker's. Shows again only what it hid (`pin.hiddenByRoute`).
- Matching (`IsRouteIcon`): objective by Questie's objective table, a party one also by `routes.PartyObjectiveKey(questID, index)` (Questie's party icons hold an objective of its own making); turn-in by quest ID (`"complete"`); pick-up by quest ID (`"available"`). Other available-quest icons are left alone.
- Re-apply: post-hooks on Questie's pin library `worldmapProvider.RefreshAllData` and `HandlePin`, coalesced to one next-frame pass (`RequestApplyQuestieIcons`). `HandlePin` also checks the placed pin at once (`routes.ApplyToPlacedQuestieIcon`, pin = `icon:GetParent()` with `pin.icon == icon`). Sets rebuilt at most once a frame (`Sets`, keyed by `GetTime()`).

Blizzard's quest markers and objective areas (`Routes-Map-Blizzard-Quests.lua`):

- Why: WoW Forever's world map draws its own quest markers (`QuestDataProviderMixin`) and objective areas (`QuestBlobDataProviderMixin`) under `questPOI`, which Questie flips per objective style, so an objective could show two or three times under the route.
- `HookBlizzardQuests`, once from `AddToWorldMap`: providers in `WorldMapFrame.dataProviders` matched by `IsFromMixin` (more than half the mixin's own functions, ignoring what it inherits from `MapCanvasDataProviderMixin`), each `RefreshAllData` post-hooked. A map without the mixins finds none.
- `ApplyBlizzardQuests`, with `routes.IsMapShownOn`, `hideQuestieIcons` and anything on route/camps: hides marker pins (`GetPinTemplate()`, else `QuestPinTemplate`) whose `questID` is a route/camp quest, and the objective layer's single `provider.pin` (every quest's areas at once). Otherwise shows what it hid. Hover doesn't bring these back.
- Only `Hide`/`Show`, hidden pins in its own weak table; `questPOI` never touched (tracker, minimap and `QuestieOptionsUtils.DetermineTheme` read it). The add-on's own quest map (`Forever-Quest-Map.lua`) has its own area layer, unaffected.
- `routes.BlizzardQuestLayers()` counts for Routes Context.

Full-size map (`routes.KeepFullSize`, `Routes-Map-Size.lua`):

- With `fullSizeMap` and `showMap`, out of combat: writes `miniWorldMap` to `"0"` when it reads true, through `ns.TrackerTaintStep` (logged by the tracker taint watch). Every client's map reads it on open to maximize; Leatrix Maps and Mapster never read it and keep their own per-size layout (`SynchronizeDisplayState`).
- Called from `Routes-Map.lua`: at login, `WorldMapFrame` `OnHide` (a map the player shrank opens full next time), every listener call.

Settings (`ns.DATABASE_DEFAULTS.profile.routes`, written through `routes.SetSetting`, which notifies listeners):

- Maps & Objectives (`Options-Maps.lua`): `showMap` (same setting as the root panel's Waypoint Markers switch), a `ROUTES_SKIPPED` sample (`ns.SampleQuests`). Sub-panels: Mini-Map (`showMinimapMarkers`, `minimapMarkerScale`), Zone Map (`fullSizeMap`, `hideQuestieIcons`, `markerScale`), Continent & World Map (`showWideMapMarkers`, `wideMarkerScale`). Everything hides with `showMap` off. `hideQuestieIcons` sits on Zone Map but covers every map shown, Questie's and Blizzard's icons both.
- Quest Route (`Options-Routes-Map.lua`): `showLine` (grayed without `showMap`), `lineSpeed` (`LINE_SPEEDS`), `lineOpacity`; Party header, shown with `showMap` or `showArrow`: `partyQuests`, `groupUp` (disabled by `GroupUpOff`).
- Sizes are multipliers from `ns.OptionsSizeValues` on `STOP_SIZE`, `WIDE_MAP_SCALE` and the minimap's `MARKER_SIZE`.

#### The Minimap

`Routes-Minimap.lua`, refreshed at login and on every listener call (`Refresh`):

- Shown with `routes.IsMapShown()`, `showMinimapMarkers` (off by default) and not `routes.IsOnTaxi()`. One marker per waypoint in `routes.stops` with a place; camps never.
- Placed through Questie's `HereBeDragonsQuestie-Pins-2.0` `AddMinimapIconWorld` under `PIN_REF`, so they turn and zoom with the minimap; each refresh `RemoveAllMinimapIcons(PIN_REF)` and places them again. No library: nothing shows.
- Questie's own minimap icons are never hidden: they show each spawn and drop exactly, which is why the markers default off.
- Plain frames built like `PrettyWideQuestLogRouteStopPinTemplate` (`Disc`/`Ring`/`Icon`), reused in order from `markers`, `ClearAllPoints` before each placement. Size `MARKER_SIZE`/`MARKER_ICON_SIZE` × `minimapMarkerScale` (no effective-scale correction). Look from `routes.ApplyStopLook` with `NO_TEXTURES`, so the icon is Questie's by kind.
- `EnableMouseMotion` only: hover shows `routes.AddStopTooltip`, clicks reach the minimap. No hover restore of Questie icons, no click actions.

#### The Quest Arrow

Files: `Routes-Arrow-Survey.lua` looks around (`routes.ArrowSurvey`, `ArrowNearestPlace`, `ArrowNearestSpawn`); `Routes-Arrow.lua` builds `PrettyWideQuestLogRouteArrow`, points it, decides when it shows, hands its pieces to the list (`routes.arrowParts`, `routes.ARROW_LAYOUT`, `routes.arrowFrame`); `Routes-Arrow-List.lua` the lines under it; `Routes-Arrow-Item-Choice.lua` + `Routes-Arrow-Items.lua` Use Item buttons; `Routes-Arrow-Shade.lua` the hover shade; `Routes-Arrow-Menu-Panel.lua` + `Routes-Arrow-Menu.lua` the hover menu; `Routes-TomTom.lua` stands TomTom's arrow down. Settings: Quest Arrow panel (`Options/Options-Quest-Arrow.lua`), keys under `-- Quest Arrow` in `ns.DATABASE_DEFAULTS.profile.routes`.

- Frame: a `WIDTH`-wide `Button` at `MEDIUM` strata, clamped, ordinary and unprotected (keeps running in combat, toward the frozen route). Arrow texture `ARROW_SIZE`, pixel for pixel, anchored by its middle so the eye breathes in place. Distance line `SPACE.LINE` under the arrow's square, not the art: turned, a corner reaches nearly to the square's edge. Yards (`routes.YardsText`) in `HELP`; the eye's words replace them in `INFO`.

When it shows (`Refresh`):

- `showArrow`, and a route or a join-up place (`routes.groupUpTarget`, `Routes-Group-Up.lua`); not `IsAway`: on a flight path (`routes.IsOnTaxi`), in a raid with `hideInRaids`, in an instance with `hideInInstances`.
- Runs on every listener call, `routes.RefreshArrow` (Group-Up), and after login on `GROUP_ROSTER_UPDATE`, `PLAYER_ENTERING_WORLD`, `ZONE_CHANGED_NEW_AREA` (owner `ns.routesArrow`).
- Applies `arrowScale` when it changes, tracked in `appliedScale` (`GetScale()` returns a rounded value that may never equal the setting), and re-places the frame, as the saved spot is in screen units.
- Shown: zeroes its timers so the new waypoint draws at once. Hidden: clears `routes.arrowTarget`/`arrowNext` and the menu.

What it points at (`Survey`, every `LIST_INTERVAL`, while the player has position and facing on the route's continent):

- Sent-to waypoint: the first with a task left (`routes.IsTaskLeft`).
- Each task left whose area the player is in (`routes.InArea`: more than one spawn, within `routes.AREA_REACH`, held `routes.AREA_GRACE` longer via `hereKeys`) is work (`here`) if at the sent-to waypoint or engaged (`routes.engaged`), else on the way. A predicted task (quest not taken yet) is never either: nothing done there counts for it.
- A pick-up giver or flight master within `AREA_REACH` (+ grace) (`NearPickUp`) is on the way: a giver is one place, which `InArea` never counts. Added while working an area, else unless the arrow already points at its waypoint.
- `destination`: first waypoint with tasks left that aren't work; `afterDestination`: the next (never past the corpse). Route starting at the corpse: no work, nothing on the way, nothing after.
- Not located: survey cleared; destination falls back to the route's first waypoint.
- On the way is thinned by `ListPassing`: nearest first (yards to nearest spawn, or giver), each within `AREA_REACH` less `PASSING_STEP` per one already listed, so the more there are the nearer they must be. One listed last look (`passingKeys`) gets `AREA_GRACE` more so near-equals don't swap. Listed ones keep route order.

Working an area: the eye (`Route-Eye`, upright, `INFO`, breathing by `BREATH_GROWTH` over `BREATH_PERIOD`), "Current Objective Area" (`ROUTES_OBJECTIVE_AREA`), the work listed, and `AreaNote` in the `note` line, silver:

- `ROUTES_AREA_FINISH`: any work objective has one blob only.
- `ROUTES_AREA_MORE`: for every one, the route passes more of its spawns later, within `AREA_REACH` of a later leg, excluding spawns within the waypoint's radius plus `AREA_REACH` (`MoreAhead`, cached per plan, keyed by the `routes.stops` table).
- Else no note.

Otherwise it points at the destination. `routes.arrowTarget` = what it lists (work or destination), `routes.arrowNext` = the Next Objective (with `showNextObjective`: in an area the destination, else `afterDestination`); the menu's Ignore rows and Routes Context read them.

How it points (`Point`, the frame's `OnUpdate`):

- Turns every `TURN_INTERVAL`; distance and nearest place redone every `TEXT_INTERVAL` or when the waypoint changes, not each turn.
- Aims at the nearest place left at the waypoint, or the nearest edge of an area (`NearestPlace`), angle from `HBD:GetWorldVector` minus `GetPlayerFacing()`. For an area: its nearest spawn inside the chosen blob (`NearestSpawn`), yards counting down to `AREA_REACH` short of it, where the eye takes over, rather than to the camp's middle.
- Color (`Shade`): `ARROW_ON_COURSE` within `ON_COURSE`, `ARROW_TURN` out to `OFF_COURSE`, `ARROW_WRONG_WAY` beyond; each boundary blends over `BLEND`, band middles solid.
- Color measured from `ColorHeading`: facing, unless travel direction (`TravelHeading`, over `HEADING_WINDOW` from samples every `SAMPLE_INTERVAL`) differs by more than `FACING_TRUST`. Why: backing up or strafing toward the target shouldn't read red; facing kept otherwise because it answers a turn at once while travel lags. Under `MIN_TRAVEL` is standing, over `MAX_TRAVEL` a teleport/load; samples reset on instance change. Rotation always uses facing. `routes.arrowColoredBy` for Routes Context.
- Within `SPOT_REACH` of a single place (not an area, not the corpse): eye, `ROUTES_ARRIVED`. At the corpse it keeps pointing and says `ROUTES_ARRIVED` within the corpse waypoint's radius.
- Next Objective's arrow (`PointNext`): aims at the corpse itself or the nearest place, turned and colored the same way, its own dimmed distance.
- No position on that continent or no facing: arrow hides, distance blank, list stays. Waypoint on another continent: `ROUTES_OTHER_MAP` (`away`) where the arrow would be.
- `showDistance` off: yards blank, Next Objective's too; eye words still show.
- Joining up (`PointToMember`, while `routes.groupUpTarget`): points live at the place, `arrowTarget` nil (nothing to ignore at the arrow, right-click does nothing), list says `ROUTES_GROUP_UP`, Next Objective (with the setting) is the route's next waypoint. See Joining Up with the Group.

Interaction:

- Drag (unless `lockArrow`) closes the menu. On drop `HoldByTop` anchors `"TOP"` to `UIParent`'s `"BOTTOMLEFT"` so the list grows below a still arrow, and saves offsets times scale via `routes.SetArrowPoint` (`ns.db.global.routesArrowPoint`, account-wide, so profile changes never move it). `PlaceFrame` divides by scale; re-saves a spot saved by another point (marked `MIGRATION`); no spot: above screen center. `routes.ResetArrowPosition` (Core, Reset Arrow button) clears it and calls `routes.ResetArrow`.
- Mouse over opens the menu unless dragging. Right-click: `routes.IgnoreArrowObjective`. Middle-click: `routes.ResetZone`.
- `routes.IsMouseOverArrow` counts only the hit rect (`frame.hitInset`), so the empty width passes through.

TomTom (`Routes-TomTom.lua`):

- While the arrow shows (`OnShow`/`OnHide` hooks), TomTom's quest-objective waypoint feature (`"poi"`) is suppressed through its public `SuppressFeature`/`ReleaseFeature`, owner `L["ADDON_TITLE"]`. Why: two arrows pointing at different places. Session only, TomTom's saved settings untouched.
- Only a real TomTom (has `IsCrazyArrowEmpty`, `SuppressFeature`, `ReleaseFeature`). `routes.IsTomTomLoaded`/`IsTomTomQuestArrowSuppressed` feed Routes Context.

Quest Arrow panel (`ns.BuildQuestArrowOptions`): every control hidden while `showArrow` is off. Size, lock, Reset Arrow (confirmed); text (`showDistance`, `showQuests` with sub-rows `questsListed` and `showItemButtons`, `showNextObjective`, `predictiveRoutes`, `showFlightPaths`); the Local Available Quests section (`AddLocalQuestsSection`, see Nodes); hiding. Tooltips format the arrow's own locale lines at load, so translations match what it shows. The ignore Example renders `routes.BuildIgnoredMessage` for the flavor's first sample quest. `showNextObjective`, `predictiveRoutes`, `showLocalQuests`, `showFlightPaths` are the same settings the menu switches.

#### The Quest Arrow's List

`ListQuests(view, noteText, passing, nextStop, meet)` (`Routes-Arrow-List.lua`, `routes.ListArrowQuests`), called by `Point`; returns whether the Next Objective was laid out. One waypoint's lines come from `routes.ForEachStopLine` (`Routes-Stop-Lines.lua`); the map tooltip builds its own from the same helpers.

`Routes-Stop-Lines.lua` helpers shared with the map: `routes.QuestTitle` (level, tag letter from `ns.GetQuestTagByID`/`ns.QuestSuffix`, falling back to Questie's tag; no level: name alone in `TITLE`), `ObjectivesTitle` (predicted: `ROUTES_AFTER_PICK_UP`, or `ROUTES_AFTER_PARTY_PICK_UP`), `TaskPoint`, `IsAreaPoint`, `IsTaskLeft` (flight path: not yet known, so the arrow moves on before the next plan; a done objective the party still needs, `helping`, stays), `TaskDistance`, `PositionAt`, `QuestsAt` (per quest, nearest first), `QuestObjectives` (log order, then Questie's extras), `CountText`, `ClassColor`, `MemberObjective`.

`ForEachStopLine(stop, maxQuests, callback)`, callback `(kind, text, r, g, b, right, questID)`:

- Corpse: one `title`, `ROUTES_CORPSE` in `TITLE` gold.
- Per quest: flight path one line `ROUTES_FLIGHT_PATH_FROM` in gold; pick-up one line `ROUTES_PICK_UP_QUEST` in difficulty color (worth-the-walk at a glance); turn-in with nothing left there one gold `ROUTES_TURN_IN_QUEST` line carrying its quest ID; else the title (quest ID unless predicted: no item to use until it's in the log), then each objective left there, nearest first, `TEXT`, count on the right.
- `routes.ShowsParty`: under each objective a `name` line per one still needing it, the player first where it's their quest, then members (`routes.MemberProgress`) in class color with their own counts; anyone finished left off; the objective then has no count.
- Past `maxQuests`, one `more` line (`ROUTES_MORE_TASKS`, silver).

What `ListQuests` builds:

- `meet`: one `ROUTES_GROUP_UP` line in `TITLE` gold, nothing else but the Next Objective.
- With `showQuests`: the view's lines (`questsListed`), then passing under a dimmed `ROUTES_WHILE_HERE` heading with an `ICON_SIZE` eye in `INFO`, its lines at `DIM_ALPHA`.
- A timed quest's time left (`routes.TimedQuests`, `SecondsToTime`) on its own `timer` line under its title, `INFO`, `QUEST_TIMER_LOW` in the last minute; counts down because the list is rewritten each survey.
- Next Objective (independent of `showQuests`), all at `DIM_ALPHA`: silver heading, then its first quest only (no `more`). Its lines sit right of a column holding its arrow (level with the heading) and distance; column as wide as `routes.YardsText(9999)` (or `NEXT_ARROW_SIZE`) plus `SPACE.GROUP`, so the block holds still as the distance counts down.
- Spacing: `SPACE.GROUP` above each quest, heading and `more`; `SPACE.NEAR` under a heading and above an objective that follows another's names; `SPACE.LINE` otherwise. Titles `GameFontNormal`, the rest `GameFontHighlight`, same size: color, dimming and space carry hierarchy. Indents: objectives and timers `SPACE.NEAR`, names `2 * SPACE.NEAR`, `more` flush with titles (it stands for whole quests).
- Block left-aligned, as wide as its widest line rounded up to a whole pixel (else the widest line is cut by a fraction), capped at `WIDTH`, centered under the arrow; counts right-aligned on the block's edge at least `SPACE.GROUP` from the text. The distance line keeps its room while blank, so the list doesn't jump on arrival.
- Skips layout when the key (note plus every line's kind, colors, text, count, dim, icon, next flag, quest ID) is unchanged.
- Hit rect inset to the arrow and block (`SetHitRectInsets`, `frame.hitInset`).
- `routes.arrowTitleRows`: `rows` of `{ questID, top, room, dim }` (room: how far that quest's lines reach), the block's `left` edge, `version` bumped per layout. Next Objective's quest gets no row: the player isn't there.

#### The Quest Arrow's Item Buttons

Use Item buttons for quests listed where the player is (waypoint and "While You're Here"), as Questie's tracker has them. Gated by `showItemButtons` and `showQuests`. `Routes-Arrow-Item-Choice.lua` says which and where (`routes.WantedItemButtons`); `Routes-Arrow-Items.lua` owns the buttons.

Which (per title row, up to `ITEMS_PER_QUEST`):

- Player's own quests only (`routes.IsOnQuest`, not `quest.party`): only the player's bags count.
- The client's quest item, `GetQuestLogSpecialItemInfo` (feature-tested; Classic Era and TBC lack it), while owned; once the quest is done (`routes.QuestState == 1`) only if its show-when-complete return says so.
- While not done, items Questie's database names (`QuestieDB.GetQuest`, cached per quest): `sourceItemId`, `requiredSourceItems`, `ObjectiveData` of `Type` `"item"`; each while owned (`GetItemCount`) and usable (`GetItemSpell`) or wearable (`IsEquippableItem`).
- One item shared by two quests shows once, by the first.

Where:

- Left of the block, outside the list: first button's right edge `SPACE.GROUP` before `arrowTitleRows.left`, a second `SPACE.NEAR` further left, top level with the title. `BUTTON_SIZE` when the quest's lines leave room, else `SMALL_BUTTON_SIZE`, so a one-line quest's button clears the next quest's. Dimmed rows dim their buttons (`DIM_ALPHA`).
- `SecureActionButtonTemplate` (`type1` `"item"`, `item1` `"item:<id>"`), parented and anchored to `UIParent`, never the arrow (a protected frame under or anchored to the arrow makes it protected, unable to move or hide in combat). Placed from the arrow's `GetLeft`/`GetTop` at its scale, same strata, level above.
- A hook on the arrow's `OnUpdate` re-picks every `CHECK_INTERVAL` or when `version` changes, and re-places on any frame the arrow moved or rescaled (follows a drag). Arrow `OnHide` re-picks (nothing wanted). Listener calls and `BAG_UPDATE_DELAYED` re-pick.
- `routes.ArrowItemBounds` gives the shade the buttons' extent.

Combat:

- Out of combat `SetUp`/`Clear` set everything. In combat item, size, place and visibility can't change, so `Sync` only compares: a mismatched button (item, place, arrow moved or hidden) fades to `STALE_ALPHA` and still uses its item; `routesItems:OnPlayerRegenEnabled` catches up when anything waited (`pendingAfterCombat`).
- Count (shown above 1), cooldown (`CooldownFrameTemplate`, `BAG_UPDATE_COOLDOWN`) and range tint are plain regions, so they update in combat. Used up in combat: desaturated until it can hide.
- Range: icon tinted `ARROW_WRONG_WAY` while `IsItemInRange(item, "target")` is false, every `RANGE_INTERVAL` and on `PLAYER_TARGET_CHANGED`. Not asked for a friendly target in combat (client won't answer). WoW Forever secret values (cooldown, range, friendliness) go through `ns.IsReadable` and leave the display as it was.

Clicking and the key:

- Left-click uses the item. Acts on the up half regardless of `ActionButtonUseKeyDown` (`RegisterForClicks("AnyUp", "AnyDown")`, `useOnKeyDown` false), so key, click and a macro's `/click` (up only) all work.
- `Bindings.xml` (loaded by the client, never in a TOC) declares `CLICK PrettyWideQuestLogQuestItem1:LeftButton` (`routes.USE_ITEM_COMMAND`, from `BUTTON_PREFIX`). `BINDING_HEADER_PRETTYWIDEQUESTLOG` and the `BINDING_NAME_` global are set in `Routes-Arrow-Items.lua`. Button 1 is made at load; others out of combat as needed, then kept.
- The General panel's Key Bindings row (`Options-General.lua`) shows the bound key; Set Key calls `ns:OpenKeyBindings` (`Features/Key-Bindings.lua`), which tries the client's Key Bindings category ID, then a Settings category titled Key Bindings, then `KeyBindingFrame`, else prints where to look; refused in combat. `ns.keyBindings:OnUpdateBindings` repaints the panel.
- Tooltip: the item (`SetHyperlink`), then `routes.AddClickHints` rows: Click, and on button 1 the bound key.
- `routes.ItemButtonsState` feeds Routes Context.

#### The Quest Arrow's Hover Shade

`Routes-Arrow-Shade.lua`: a soft dark wash behind the arrow, its list and its item buttons while the mouse is over the arrow (`routes.IsMouseOverArrow`) or the menu is open, so text reads over bright ground. The only backing the arrow gets: no box, edge or always-on panel (maintainer decision).

- Nine `BACKGROUND` textures on the arrow frame from one soft round texture (`Route-Shade`, quarters at corners, strips along sides, solid middle stretched), vertex black, `SHADE_ALPHA` at full.
- Covers the hit rect's width (`frame.hitInset`), from `ART_TOP` (where the art starts inside its square) to the frame's bottom, widened left and down to `routes.ArrowItemBounds`; eases to nothing `SHADE_FADE` past every edge.
- Its own `OnUpdate` hook fades in/out over `SHADE_FADE_SECONDS`; while visible re-places each frame (list and buttons change as the player works), skipping when the bounds are unchanged. `OnHide` zeroes it.
- Reads `routes.IsArrowMenuShown` guarded, as the menu loads after it.

#### The Quest Arrow's Menu

`Routes-Arrow-Menu-Panel.lua` draws the plates and lays out rows; `Routes-Arrow-Menu.lua` says what the rows are and opens and closes the menu. Panels handed over in `routes.arrowMenuPanels` (`menu`, `submenu`, `Fill`, `OpenSubmenu`, `CloseSubmenu`, `submenus`).

Plates (`NewPanel`): `PrettyWideQuestLogRouteMenu` and the flyout `PrettyWideQuestLogRouteSubmenu` (frame level `+20`, over the menu), `DIALOG` strata, clamped, both in `UISpecialFrames` (Escape). `AddPlate` nine-slices `Route-Menu` drawn at `PLATE_SCALE` (sharp edges), `PLATE_CORNER` corners never stretched, reaching past the panel by `PLATE_MARGIN` (its shadow), at `PLATE_ALPHA`. Menu hiding hides the flyout.

Opening and closing:

- Arrow `OnEnter` opens it (`routes.ShowArrowMenu`) under the arrow's frame, or above the arrow when the arrow's center is in the lower half of the screen, `SPACE.NEAR` away.
- Stays while the mouse is over the arrow (`routes.IsMouseOverArrow`), the menu or the open flyout; hides `CLOSE_DELAY` after leaving all, at once when the arrow hides, on Escape, and when a drag starts.
- Refreshes every `REFRESH_INTERVAL` while open, on listener calls, after a row's click (`routes.RefreshArrowMenu`).

Rows (`Entries`, each `{ kind, left, right, leftColor, rightColor, hover, action, submenu, drag }`):

- Header `TAB_QUEST_ARROW`, `ADDON_SHORT_NAME` muted, then a `spacer` (`SPACE.GROUP`).
- Ignore (`ROUTES_MENU_SECTION_IGNORE` label, only with rows): `MenuTasks` of `routes.arrowTarget` then `routes.arrowNext` (marked `ROUTES_MENU_NEXT`), each a task left and not in `routes.skipped`, in the list's quest order: flight path, objectives in log order, turn-in, pick-up. Labels `routes.TaskLabel`, indented `INDENT` (one space, as tooltips). A task in both offered once; none for the corpse. Click: `routes.IgnoreTask`. Ignored ones are filtered here because an ignored task stays at the waypoint until the next plan, which in combat waits for the fight to end.
- Three labels with Blizzard's submenu arrow (`SUBMENU_ARROW`), each naming its flyout (`submenu`): Route, Show, and Ignored (with the count, only while `routes.IgnoredTasks()` has any).
  - Route (`RouteEntries`), most used first, each `routes.SetSetting` then `routes.RequestPlan` (it changes the route): `predictiveRoutes`, `showLocalQuests`, `showFlightPaths`. In a party (`routes.IsInParty`): `partyQuests` (`routes.SetPartyQuests`); with it on, each member (`routes.PartyMembers(true)`) as `ROUTES_MENU_MEMBER_OBJECTIVES` in class color, On/Off via `routes.SetMemberIgnored`, or an unclickable `status` row with the first reason: Offline, No Questie (`routes.MemberHasQuestie`), Out of Zone (`routes.IsUnitOutOfZone`); the row keeps its place for when that changes.
  - Show (`ShowEntries`), what only the arrow draws: `showNextObjective`.
  - Ignored (`IgnoredEntries`): ignore order, gray, hover brightens the name and shows Put Back; click `routes.UnignoreTask`.
- Toggles: On in `ON` green; Off gray with its name gray too.
- After a `separator`, the click hints as `hint` rows, click on the left, what it does on the right, both `INFO` blue, each usable too: Drag (only unlocked; dragging the row moves the arrow, `routes.DragArrowFromMenu`), Right-Click (only with something to ignore and not joining up; runs `routes.IgnoreArrowObjective`), Middle-Click (`routes.ResetZone`).
- `routes.IgnoreArrowObjective` ignores `MenuTasks(arrowTarget)[1]`, the first Ignore row; nothing while `routes.groupUpTarget`.

Layout (`Layout`, `Fill`):

- Rows are a line plus `SPACE.LINE` above and below; a section label `SPACE.NEAR` above instead (text centered on the line, extra room above); separators `SPACE.NEAR`; panel padded `SPACE.NEAR`. Width: widest row (hover's right side measured too, so Put Back never crowds the name), at least `MIN_WIDTH`.
- Fonts: header `GameFontNormal`, section `GameFontNormalSmall` in `TITLE`, rest `GameFontHighlight`. Highlight `TITLE` at `HIGHLIGHT_ALPHA`. Only clickable or draggable rows take the mouse.
- Laid out again only when `EntriesKey` (each row's kind and both texts) changes; `action`s rebound on every `Fill`, since a new plan makes new task tables.
- Flyout (`OpenSubmenu`): beside its label, first row level with it, right of the menu or left without room on screen; label keeps its highlight (`LockHighlight`). Hovering a label opens or switches it, any other menu row closes it (as a dropdown's submenu); its own rows leave it open. A refresh reopens the same one (`submenu.name`) or closes it once its label is gone; an empty flyout closes.

#### Party Members' Quests

`Routes-Party.lua`. With `partyQuests`, in a party but not a raid (a raid's quests would swamp the route), Questie's shared logs (`QuestieComms.remoteQuestLogs`: quest → member → objective `fulfilled`/`required`/`finished`) feed the route (`RemoteLogs`).

- `routes.PartyQuests(ownLog, yield)`: each quest a sharing member has and the player doesn't, Questie-shaped (`party = true`, name/level from `QuestieDB.GetQuest`). Quest IDs listed before any yield. Kept in `partyQuests` while any member has it, so objective tables and their cached blobs last between plans.
- Objectives built once per index from `ObjectiveData`, yield after each: description from text or target name (`TargetName`: `QueryNPCSingle`/`QueryObjectSingle`/`QueryItemSingle`), color `QuestieLib:ColorWheel()`, `spawnList` from `QuestieQuest.private.objectiveSpawnListCallTable[Type]`. Count: the fewest any still-needing member has; done when none needs it; `members` the sorted short names still needing it.
- A member counts (`IsSharing`) while not switched off (`routes.ignoredMembers`), present (`IsPresent`: a `party`N unit, connected, `routes.IsUnitOutOfZone` false; cached once a frame), and not hiding the quest (`CommsVisibility.ShouldShowPartyObjective`, `pcall`). A secret connection counts as offline; a secret or unknown map counts as in zone.
- Cheap readers (no database work, safe every check): `routes.PartyProgress(ownLog)` (signature, ignore list), `routes.PartyNeeds(questID)` (objective indexes of the player's own quest some other sharing member still needs; camps, nodes, signature), `routes.IsHelpNeeded(task)` (`routes.IsTaskLeft` for a `helping` task).
- Other exports: `routes.PartyHasQuest`, `routes.PartyQuestHolders` (short names, for party ignores), `routes.PartyQuestHolderUnits` (sorted units, for follow-ups), `routes.MemberProgress` (tooltips and arrow lines), `routes.PartyMembers(includeOffline)` (`offline`/`unknown` flags), `routes.GroupNames()` (raid too; nil while any name is unknown), `routes.IsInParty`, `routes.ShowsParty`, `routes.PartyObjectiveKey`.
- Used outside Routes, independent of `partyQuests`: `routes.QuestieHasUnitOnQuest` (`Forever-Quest-List-Party.lua`, `Share-Needs.lua`, `Zone-Share-Offer.lua`; Questie's shares reach any distance, the game's only in range), `routes.MemberHasQuestie` (an entry in `remotePlayerClasses` or any shared log; the arrow menu, `Zone-Share-Offer.lua`), `routes.UnitFullName`, `routes.UnitZone`.
- Names (`routes.UnitFullName`): first name, except on WoW Forever (`ns.FLAVOR`), where `UnitName`'s second return is a surname and Questie keys "First Surname". Secret name gives nil. Questie keys compared after `Ambiguate(name, "short")`.
- Route keys: objectives `questID:p<index>`, the member's turn-in `questID:pt` (`Routes-Nodes.lua`), all marked `party`; dungeon/raid party quests left out.
- Follow-ups from party turn-ins (`Routes-Chains.lua`, with `predictiveRoutes`): each party quest is a chain root with `units` and `holdersOf`; follow-ups keyed `questID:pp`, `:pf<index>`, `:pft`, waiting on the party turn-in; `MemberCouldTake` checks any holder's level, race (`LibQuestieDB.Enum.raceMaskById`), class and `exclusiveTo`. `after.party` drives `ROUTES_AFTER_PARTY_TURN_IN` / `ROUTES_AFTER_PARTY_PICK_UP`.
- Shared pick-ups (`Routes-Pick-Ups.lua`): a quest `routes.PartyHasQuest` is offered zone-wide (not `localQuestRange`), marked `shared`, sorted first for the log's free slots.
- Map: Questie's party objective icons hidden with the route; markers ringed `ROUTE_PARTY_RING`.

#### Joining Up with the Group

`Routes-Group-Up.lua`. Wanted (`IsWanted`) with `groupUp` and `partyQuests` (Options grays `groupUp` out otherwise, `GroupUpOff`), in a party, not in an instance. A frame checks every `CHECK_INTERVAL` (and next frame after `PLAYER_ENTERING_WORLD`, owner `ns.routesGroupUp`).

- No addon messages, no roles: each client works it out alone from member positions (`routes.UnitZone`, `routes.UnitWorldPosition`). `lastSeen` keeps each member's last readable place in this zone and continent; members gone from the party are pruned.
- Starts once any member here is past `APART` (off the minimap at its widest outdoor zoom), ends once all are within `TOGETHER`, so drifting a little doesn't restart it. A zone change resets it. With nobody placeable and anything secret, the state and spot stay as they were.
- The spot (`routes.groupUpTarget`, `{ x, y, instance }`, one table moved in place): the mean of the player, the members here and the group's first waypoint (`GroupWaypoint`: first of `routes.stops` on the player's continent with a `party` task or a quest `routes.PartyHasQuest`, else the first there). Each client uses its own route; the route itself is unchanged and still planned from the player.
- `Publish` calls `routes.RefreshArrow` and `routes.RefreshGroupUpMarker` only when the target appears or goes.
- No skipping: `routes.IgnoreArrowObjective` returns early and the arrow menu drops its right-click hint while joining up; the map marker has no click. The setting is the off switch.
- Arrow (`PointToMember`, `Routes-Arrow.lua`): points at the spot live, lists `ROUTES_GROUP_UP`, and with `showNextObjective` the route's next waypoint. Shows with no route at all.
- Map marker (`routes.AddMeetPin`, `Routes-Map-Meet.lua`, `PrettyWideQuestLogRouteMeetPinTemplate`): `Route-Stop-Fill` in `ROUTE_MEET` under a `ROUTE_PARTY_RING` ring, `Party-On-Quest` icon in `INFO`, sized and leveled as a waypoint. Its `OnUpdate` follows the spot every `MEET_INTERVAL`; off the map it fades to alpha 0 with the mouse off rather than hiding. Hover: `ROUTES_GROUP_UP`. Only on maps passing `routes.IsMapShownOn`.
- Line: while the spot is on the map, `PlacePlayerLeg` draws `meetLeg` player → spot and starts the first leg from the spot. Only where a line pin exists (`showLine`, a waypoint on this continent).
- Routes Context: `routes.GroupUpState()`, no names or places.

#### Ghosts

While a ghost, `routes.Origin` (`Routes-Geography.lua`) starts from the corpse (`routes.CorpsePosition`):

- `C_DeathInfo.GetCorpseMapPosition` asked of the ghost's map, then each parent (graveyard can be a zone away). Outside 0–1, or 0,0, is no answer. Zone: the deepest map at the corpse (`C_Map.GetMapInfoAtPosition`) raised from micro map to zone.
- The route covers the corpse's zone; first waypoint the corpse (`routes.MakeStops`, `CORPSE_RADIUS` in `Routes-Stops.lua`, task kind `"corpse"`). `PlayerMovedFar` never replans a corpse start.
- No answer (corpse in a dungeon): route from the player.
- Signature ends `"ghost"`/`"alive"`; `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST` bring the next check forward (`routes.OnPlayerDead` etc., `CheckSoon`).
- Corpse can't be ignored: `routes.SkipStop` passes over it (silent when nothing else is there), `routes.IgnoreTask` refuses it, no right-click action, not untracked-ringed.

#### Ignoring and Resetting

`Routes-Ignore.lua`. `routes.skipped` (`Routes-Core.lua`): task key → `{ label, questID, npcID, order, zone, holders }`; `zone` is `routes.PlayerZone()` when ignored (`0` where unknown). Every path goes through `Ignore`, which redirects a planned task of a quest not yet taken to its pick-up (`task.pickUpNode`) and leaves an existing entry alone.

- Party keys (`PARTY_KEYS`: `:p<index>`, `:pt`, `:pp`, `:pf<index>`, `:pft`) are session-only and keep `holders` (`routes.PartyQuestHolders` of the quest, or of `holdersOf` for a follow-up). Every other key is the player's own: mirrored to `ns.db.char.routesIgnored`, loaded back at login (`ignoredCount` resumes from the highest `order`). Flight paths (`flight:<npcID>`, `Routes-Flights.lua`) keep `npcID`.
- `routes.SkipStop(stop)` (waypoint right-click): ignores each non-corpse task, prints `ROUTES_SKIPPED` with Questie links (`routes.QuestLink`) or flight path labels.
- `routes.IgnoreTask(task)` (menu, camp right-click, arrow right-click): one task, prints `routes.BuildIgnoredMessage` (`ROUTES_IGNORED` / `ROUTES_IGNORED_PARTY`; also the Quest Arrow panel's sample), or `ROUTES_SKIPPED` for a flight path.
- `routes.UnignoreTask(key)`: prints `ROUTES_UNIGNORED`.
- `routes.TaskLabel(task)`: objective description, `ROUTES_MENU_TURN_IN`, `ROUTES_MENU_PICK_UP` or `routes.FlightPathLabel`.
- `routes.IgnoredTasks()`: the menu's list by `order`, only entries still in play: quest in the log; party objective/turn-in while `routes.PartyProgress` has the quest; party follow-up always (pruned with its holders); pick-up while not taken or done (`routes.pickUpHelpers.IsTakenOrDone`); flight path while undiscovered. Others stay in `routes.skipped`, unlisted.
- `QUEST_TURNED_IN`/`QUEST_REMOVED` (`ForgetQuest`): drop the quest's own entries; a pick-up entry survives a drop, goes on turn-in; party keys untouched.
- `routes.ResetZone()` (middle-click on the arrow or any map marker): drops every entry, own or party, whose `zone` is the current zone, clears `routes.engaged` and `routes.worked`, prints `ROUTES_ZONE_RESET`, then `routes.CancelPlan`, `routes.ForgetLastSolve` and a replan. Other zones' entries and ignored members stay; nothing clears every zone.
- `routes.SetMemberIgnored(name, ignored)`: `routes.ignoredMembers` (checked in `IsSharing`), prints `ROUTES_MEMBER_IGNORED`/`ROUTES_MEMBER_INCLUDED`. `routes.SetPartyQuests(on)`: `partyQuests` via `routes.SetSetting`, then a plan.
- `routes.PruneGroupIgnores()` (every `GROUP_ROSTER_UPDATE`, from `Routes-Planner.lua`): against `routes.GroupNames()`; drops ignored members who left and party entries none of whose holders remain; prints `ROUTES_MEMBER_LEFT_CLEARED` and replans only if something went.
- `GROUP_LEFT` (`routes:OnGroupLeft`): drops every party entry and ignored member; prints `ROUTES_GROUP_LEFT_CLEARED` only if something went. Own ignores and `routes.engaged` stay.
- Ignored keys and members are in the signature; every change plans through `routes.RequestPlan` (in combat, after the fight).

#### Client Differences

Same Routes files in all four TOCs. `ns.FLAVOR` is read once (`routes.UnitFullName`, WoW Forever surnames); the rest is a feature test, a measure or per-flavor data:

- Turn-ins only for quests the game's log has (`routes.IsOnQuest`): `C_QuestLog.IsOnQuest`, else `GetQuestLogIndexByID`, else Questie's log stands.
- Timed quests (`routes.TimedQuests`): `C_QuestLog.GetQuestTimers`, else `GetQuestTimers` + `GetQuestIndexForTimer` + `GetQuestLogTitle`, never touching the log selection.
- Secret values (WoW Forever) through `ns.IsReadable`: names, classes, party connection, unit maps and positions.
- Marker size divided by the map's effective scale (Classic Era/TBC's larger full-size map).
- World map may load on demand (`routesMap:OnAddonLoaded`).
- Instance quests by each flavor's `ns.QUEST_TAG_SUFFIXES`; corpse icon cell by each flavor's `ns.CORPSE_ICON_COORDS`.
- Blizzard quest layers hidden only where the world map has their mixins; TomTom's `"poi"` stood down only where TomTom offers `SuppressFeature`.

#### Questie

Without Questie there is no route:

- `routes.IsQuestieReady()` (`Routes-Questie.lua`): `Questie.started` and `HereBeDragonsQuestie-2.0` (`routes.HereBeDragons`, `LibStub` silent). Until then no plan, no camps, nothing for the arrow; Options panels still show.
- Map pins and minimap markers also need `HereBeDragonsQuestie-Pins-2.0`.

Modules through `ns.ImportQuestieModule` (`Utilities.lua`). Database queries, quest methods, comms visibility and the link builder are `pcall`ed; `ZoneDB` and `Phasing` lookups called directly once found. What Routes reads:

- Quest log: `routes.QuestLog` over `ns.QuestieLogEntries` (`ActiveQuests` acceptances' `.quest`, skipping entries without one, else `QuestiePlayer.currentQuestlog`). Per quest: `IsComplete`, `Objectives`, `SpecialObjectives`, `Finisher`, `name`, `level`.
- `QuestieDB`: `QueryNPCSingle`, `QueryObjectSingle`, `QueryItemSingle`, `QueryQuestSingle`, `GetQuest`, `GetQuestTagInfo`, `questTagIds`, `IsRepeatable`, `IsGroupQuest`, `IsFriendlyToPlayer`, `QuestPointers`.
- `ZoneDB:GetUiMapIdByAreaId`, `ZoneDB:GetDungeonLocation`; `Phasing.IsSpawnVisible`.
- `QuestieComms.remoteQuestLogs`, `remotePlayerClasses`; `CommsVisibility.ShouldShowPartyObjective`.
- `QuestieLib:ColorWheel`, `QuestieLink:GetQuestHyperLink`, `QuestieQuest.private.objectiveSpawnListCallTable`.
- Chains and pick-ups: `QuestiePlayer.HasRequiredRace`/`HasRequiredClass`, `QuestieCorrections.hiddenQuests`, `Questie.db.char.hidden`/`complete`, `LibQuestieDB.Enum.raceMaskById`, `AvailableQuests`, `QuestieCompat.GetQuestGreenRange`, `Townsfolk`.
- Icons: `Questie.usedIcons` and its `ICON_TYPE_*` constants.
- HereBeDragons world/zone coordinates, `GetWorldDistance`, `GetWorldVector`; Pins' `worldmapProvider` (`RefreshAllData`, `HandlePin(_, icon)`), `worldmapPinTemplate` pins, or `HereBeDragonsPinsTemplateQuestie` before Questie 12.8.0 (`pin.icon`, `.data`, `.texture`), `AddMinimapIconWorld`/`RemoveAllMinimapIcons`.

Without `ZoneDB` no objective has a place; without `Phasing` every spawn counts. Routes Context reports each, plus `QuestiePlayer`.

### Resizing and Scale

- Grip: `ns.CreateResizeGrip` (`Window.lua`), bottom-right, `LAYOUT.GRIP_INSET` inside the art's border (`ART_INSET_RIGHT`, `ART_INSET_BOTTOM`); under ElvUI's skin on Classic Era and TBC anchored inside `QuestLogFrame.backdrop` (`AnchorGrip`, `Classic-Quest-Log.lua`), since the frame's corner sits outside the visible window. `frame.isResizing` is set while dragging.
- `ns.ClampHeight`: whole list rows (`ns.GetQuestRowHeight` on Classic Era and TBC, `LAYOUT.QUEST_ROW_HEIGHT` on the window), at least `LAYOUT.BASE_HEIGHT`, no closer than `LAYOUT.MINIMUM_BOTTOM_CLAMP` to the screen bottom measured from the window's top (a lower window grows less). Window units: screen measures divided by scale.
- Panes get height less `LAYOUT.PANE_INSET` (the window's details slightly more, `ApplyHeight`). On Classic Era and TBC that sets row capacity (`ns.SetQuestRowCount`) and reruns `QuestLog_Update` on change.
- `global.height` saves when the drag ends: mouse-up, button released elsewhere (grip `OnUpdate`), or grip hidden mid-drag; then `ns.OnWindowResizeStopped` (an empty slot `Mists-Quest-Portrait.lua` post-hooks).
- Saved height applies on every open, not at load: screen size and UI scale aren't settled at load, so the clamp would cut it. The clamped value is never saved, so a smaller screen shrinks the window, not the setting.
- Art: only the plain lower half of each upper piece stretches (`ns.CreateWindowArt`, `TOP_SPLIT`); the top half holds the border.
- Window Scale (`global.scale`, Window & Map panel): on open, in `ns:OnDatabaseReady` on the window clients, and via `ns.ApplyWindowScale` on slider move (re-clamping height while open).
- Map Scale (`global.mapScale`): the map holder's scale on top of the window's (the map is its child); `ns.ApplyMapScale` (`Quest-Map.lua`) on window show and slider move.
- Reset Window (`ns.ResetWindow`, confirmed): clears height (and `point` on the window clients), writes `scale` / `mapScale` from `ns.DATABASE_DEFAULTS` rather than clearing (AceDB fills plain defaults only at load). `mapHidden` stays. Its description and confirm text differ by `RESET_WINDOW_KIND` (`MOVE` on the window clients, `SCALE` on Classic).
- Classic Era and TBC: Blizzard's panel manager keeps `BOTTOM_CLAMP` below the window for the action bars; `BottomClamp` trades it a pixel per pixel of extra height down to `MINIMUM_BOTTOM_CLAMP`, the only room to grow at normal UI scale. Each height change sets the `height` and `bottomClampOverride` panel attributes, or the manager scales the window down to fit what it thinks it needs. Bottom buttons Blizzard anchored to the top edge are re-hung off the bottom edge (`nearTheBottom`).
- WoW Forever and Mists: dragging within the top `LAYOUT.PANE_TOP` moves the window and saves `global.point`; none saved means `DEFAULT_POINT` (`Forever-Quest-Log.lua`).

### Moving from Wide Quest Log Plus

- This add-on continues Wide Quest Log Plus (folder `WideQuestLogPlus`) under a new name, folder and SavedVariables table. Both reshape the same Blizzard quest log, so they must never run together.
- While `ns.PREDECESSOR_ADDON_NAME` (`Data/Data.lua`) is loaded, `ns:WarnIfPredecessorLoaded()` (`Features/Core.lua`) prints `CHAT_PREDECESSOR_LOADED` on every login, whatever the welcome toggle: it's a conflict, not a greeting. It disables neither add-on.
- The old name lives only in that constant and the comment beside `ns.SAVED_VARIABLES_NAME`, that string's locale entries, one Quest Log Context line (`Diagnostics/Manifests.lua`) and the README credits. Don't carry it anywhere else, the old `/wqlp` and `/widequestlogplus` commands included. Its settings are in its own SavedVariables table and aren't carried over.

### Game Names

What the game names comes from the client, never `Locales/`; this add-on's lookups:

- **Quest tags**: `ns.QUEST_TAG_SUFFIXES` (`Data/{Game}/Quest-Tags-{Game}.lua`) maps tag IDs to the add-on's own letters (locale keys, `ns.QuestSuffix`, `Quest-Display.lua`). The tag comes from `ns.GetQuestTagByID` (`Quest-Log-API.lua`), or Questie's corrected tag first in the quest chain and Routes. A tag's localized name is never compared.
- **Sample quests and areas** (`ns.SAMPLE_QUEST_IDS`, `ns.SAMPLE_DUNGEON_AREA_ID`, `ns.SAMPLE_ZONE_AREA_ID`): `ns.SampleQuests` (`Options-Utilities.lua`) titles them through `ns.GetQuestTitleByID`, requesting loads until they arrive; areas through `C_Map.GetAreaInfo`. Each has a Game Names row.
- **Maps**: the client's `uiMapID`, named by `C_Map.GetMapInfo` in the map's zone dropdown. Map art and texture file IDs name nothing a player reads.
- **Items, spells, classes**: the add-on stores no item or spell ID of its own; reward names and icons come from the quest log calls, Use Item buttons' items from the client or Questie's database. `ns.CLASS_COLORS` is keyed by class token, colors only (the Example lines' sender).
- **Zone names** are the quest log's headers. The current-zone mark compares header text with `GetRealZoneText()` (`ns.IsCurrentZone`, `Quest-Sort.lua`), a name match, because neither quest log gives headers a map ID; dungeon quests also match the instance name and `C_Map.GetAreaInfo` of Questie's zone IDs (`Dungeon-Quest-Lookup.lua`).
- **The Key Bindings category**: Set Key finds it by the client's `KEY_BINDINGS` or `SETTINGS_KEYBINDINGS_LABEL` title where the client names no category ID (`Key-Bindings.lua`), a name match against the client's own string.
- **Quest, NPC, object names** in tooltips, the chain, the turn-in line, the route and the Quest Arrow come from the client or Questie's data.
- **Blizzard's GlobalStrings** the add-on shows or matches (row tags, `QUEST_LOG`, the own window's buttons and headings, `ERR_QUEST_PUSH_*`, the key row's `NOT_BOUND`, the Example lines' chat prefixes) each have a Game Names row (`SHARED_LABELS`, `OWN_WINDOW_LABELS`, `OWN_WINDOW_STRINGS`, `QUEST_ID_LABELS` and the client-only lists in `Diagnostics/Manifests.lua`). README-Notes lists the few labels deliberately kept as the add-on's own strings.

### Key Bindings

- `Bindings.xml` is loaded by the client on its own, never listed in a TOC. Its one binding clicks the Quest Arrow's first Use Item button (`CLICK PrettyWideQuestLogQuestItem1:LeftButton`, `routes.USE_ITEM_COMMAND`); the header and binding name globals are set in `Routes-Arrow-Items.lua`, the name through `_G["BINDING_NAME_" .. ...]`. The binding name is what the client saves a player's key against.
- An AceConfig panel can't set a binding, so the General panel's Key Bindings row (`AddKeyBindings`, `Options-General.lua`, only where Routes loaded) shows the bound key and Set Key calls `ns:OpenKeyBindings` (`Key-Bindings.lua`). It tries, at click time since a Settings category can register after login: `Settings.KEYBINDINGS_CATEGORY_ID`, then the Settings panel category titled Key Bindings, then the older `KeyBindingFrame` (loaded on demand), else prints `KEY_BINDINGS_LOCATION` naming the client's own menu labels. Refuses in combat.
- `ns.keyBindings:OnUpdateBindings` repaints the General panel when the player comes back from the game's list.
- The quest log key (`TOGGLEQUESTLOG`) isn't the add-on's binding: it's bound over with an override (see Taint).

### Options Panels

- `ns.RegisterOptionsPanels` (`Options/Options.lua`), called from `ns:OnAddonLoaded` after `AceDB:New`, registers each AceConfig table under its `ns.OPTIONS_REGISTRY` name (`Data/Data.lua`). The Settings panel lists panels in registration order: General (root), Wide Quest Log with Quest List, Quest Details, Window & Map and NPC Dialogue under it, Maps & Objectives with Mini-Map, Zone Map and Continent & World Map under it, Quest Route, Quest Arrow, Quality of Life, Profiles (`AceDBOptions-3.0`), Feedback & Support, Diagnostics. The Maps, Route and Arrow panels and the General key row exist only where `ns.routes` loaded.
- Panels under a panel: `AceConfigDialog:AddToBlizOptions` finds parents only on the AddOns list, so `AddPanel` builds the same `BlizOptionsGroup`, registers it with `Settings.RegisterCanvasLayoutSubcategory`, and lists it in `AceConfigDialog.BlizOptions` so `NotifyChange` refreshes it. Without subcategories it falls back to hanging under the root (`AddPanelUnder`).
- The root's category is kept by the ID `AddToBlizOptions` returns (`ns.optionsFrames.categoryID`): on clients where it's a number, a lookup by title finds nothing and the panel opens as a floating window. `/pwql` opens it through `Settings.OpenToCategory`, else `AceConfigDialog:Open`.
- Shared builders in `Options-Utilities.lua`: rows, feature switches (`ns.OptionsFeatureToggle`), Routes switches and controls (`ns.OptionsRoutesToggle`, `ns.OptionsRoutesControl`, hidden without Routes, written through `routes.SetSetting`), sub-option rows, status lines, the Example lines (`ns.RenderSample`), the reload prompt. `ns.AddFontOptions` (`Options-Fonts.lua`) adds a Font section to the Quest List, Quest Details, Window & Map and NPC Dialogue panels.
- `ns:ApplyProfile` ends by calling `NotifyChange` on every registry name, so open panels follow a profile change.

## Files That Change Together

- **New setting**: key in `ns.DATABASE_DEFAULTS.profile` (`global` only for reset-proof presentation, see Saved Variables) → control and locale keys (`<KEY>`, `<KEY>_DESCRIPTION`) on its feature's panel: the Wide Quest Log panels' builders in `Options-Quest-Log.lua` (`QuestLogToggle` / `SortSelect` / `SortSubOption` take `Hidden` and `Inactive`; map settings `MapHidden`), the NPC Dialogue panel's `Toggle` (calls `ns.ApplyQuestGiverCleanup()`), or Quality of Life's `Toggle` (calls `ns.ApplyQualityOfLifeSettings()`, hidden with its switch) → read live at use (`ns.RefreshQuestLog()` or `ns.questMap.RequestRefresh()` from `set`) → its context report line in `Diagnostics/Manifests.lua` (window size and scales: Display Context, `Settings-Reports.lua`). A Quality of Life setting read outside its panel also checks `enableQualityOfLife` (as `ns.GetShareInterval` does).
- **New Routes setting**: key in `ns.DATABASE_DEFAULTS.profile.routes` → control in `Options-Quest-Arrow.lua`, `Options-Routes-Map.lua` (Quest Route) or `Options-Maps.lua` (the map panels) via the panel's `Toggle` (wraps `ns.OptionsRoutesToggle`, description from `<KEY>_DESCRIPTION`) or `ns.OptionsRoutesControl`, with the panel's hidden gate → read via `routes.Settings()`, written only via `routes.SetSetting` → if it changes what's planned, `routes.Signature()` (`Routes-Questie.lua`) or `routes.RequestPlan()` → a `RouteSetting` line in Routes Context (`ArrowLines`, `ZoneMapLines`, `PartyLines`). Also on the Quest Arrow's menu: its entry in `Routes-Arrow-Menu.lua` and a `-- TRANSLATORS:` note on the description naming the menu's label.
- **Retiring a setting**: drop the key from `ns.DATABASE_DEFAULTS`, its control and locale keys → nil it in a dated `MIGRATION (remove after …)` function run from `routes:OnPlayerLogin` (`Routes-Core.lua`), since AceDB keeps a saved non-default value → any context report line.
- **New font area**: `ns.DATABASE_DEFAULTS.profile.fonts.<area>` → `ns.FONT_AREAS` (`Fonts.lua`) → `ns.AddFontOptions(args, "<area>", …)` on its panel and `FONT_<AREA>_DESCRIPTION` → `FONT_REPORT_BASES` (`Manifests.lua`).
- **New Options panel**: name in `ns.OPTIONS_REGISTRY` (`Data/Data.lua`) → builder in an `Options/` file, listed in every TOC before `Options.lua` → registration in `ns.RegisterOptionsPanels` at its place in the order (`AddPanelUnder` for a sub-panel) → its frame in the `watched` list for the reload prompt → `TAB_` locale keys.
- **New event**: a row in `EVENTS` (`Features/Core.lua`), which the dispatcher and `ns.EVENT_NAMES` both read → handler at file scope or inside a Classic part; a second feature on the same event uses an owner table created at file scope and named in the row's third field. Never `RegisterEvent` in a feature file; an event one client lacks goes only in that client's files.
- **New API call**: the list in `Diagnostics/Manifests.lua` for the clients that call it (`SHARED_`, `GIVER_PAGE_`, `LOG_INDEX_`, `CLASSIC_`, `OWN_WINDOW_`, `QUEST_ID_`, `INDEX_WINDOW_`, `ROUTES_`, `ITEM_BUTTON_FUNCTIONS`, `OWN_WINDOW_MAP_`, `FOREVER_MAP_FUNCTIONS`; Blizzard frames and mixins in the matching `_TABLES`; a call taken one of two ways gets its own `_ROUTE` row; a read one data kind makes in `KIND_API_CHECKS`, `Validate-Data.lua`) → the global in `.luacheckrc` `read_globals` (or `globals` if written). A function only hooked by name needs no entry. A GlobalString shown or matched also gets a Game Names row.
- **New Routes file**: its place in `Features/Routes/Routes.xml`, after everything it captures by value → its file in the File Map. Nothing in the TOCs.
- **New Features or Options file**: every TOC that loads it, in dependency order.
- **New key binding**: `Bindings.xml` → `BINDING_HEADER_` / `BINDING_NAME_` globals set in the owning Lua file (`.luacheckrc` `globals` for a plain name; one set through `_G[...]` needs none) → a row on the General panel (`AddKeyBindings`) → a key line in its context report. Renaming a binding loses players' keys.
- **New share result**: `FIXABLE_RESULTS` (`Share-Reminders.lua`) → `SHARED_LABELS` and `SHARE_RESULTS` (`Manifests.lua`) → `.luacheckrc` `read_globals`. A new whisper key also goes in `SHARE_WHISPER_KEYS` (`Localization-Reports.lua`); check Message Length in ruRU.
- **New quest tag kind**: its ID in each flavor's `Quest-Tags` file → `QUEST_SUFFIX_<KIND>` and `QUEST_TYPE_<KIND>` in `enUS.lua` → `LEGEND_ORDER` (`Quest-Display.lua`). Routes treats only `INSTANCE_KINDS` (`Routes-Questie.lua`) as instance quests.
- **Sample quests**: `Data/{Game}/Sample-Quests-{Game}.lua` in every folder, Vanilla and Discovery both; with quests listed both area IDs are required. An empty list hides the Example lines (`ns.NoSampleQuests`).
- **New data table**: `Data/{Game}/{Label}-{Game}.lua` in every folder, `Wrath` and `Mainline` included (Vanilla/Discovery copies guarded by `ns.IS_DISCOVERY`) → every TOC, before `Data/Default-Settings.lua` → a row in `ns.DIAGNOSTIC_DATA_SOURCES` whose `label` matches the file name (`ns.DataSourceFileName`) and `kind` its ID kind (`kind = "value"` for a single setting).
- **New flavor**: TOC with `X-Flavor` → `ns.EXPANSION` in `Data/Flavor.lua` → its data folder (out of `.pkgmeta`'s ignore list) → its quest log file set by which API it has (Classic rows, or the own window with its own tracking and takeover, zone actions by quest-ID support) → `Routes.xml` after `Quest-Map-Reveal.lua`, before Diagnostics, plus the Routes panels → check `OWN_WINDOW` and `QUEST_ID_API` rows separately.
- **New library**: `Includes/Libraries/` → `.pkgmeta` `externals` → every TOC's `# Includes` block.
- **Chat output change**: `Locales/enUS.lua` (one `%s` for the quest reference, no closing period) → Message Length report in ruRU against `ns.CHAT_MESSAGE_MAX_LENGTH`.
- **A string an options file formats**: at file load (`MARK_UNTRACKED_DESCRIPTION`, `SHOW_DISTANCE_DESCRIPTION`, `SHOW_NEXT_OBJECTIVE_DESCRIPTION`, `QUESTS_LISTED_DESCRIPTION`) or as its panel builds (`SHOW_QUEST_LEVELS_DESCRIPTION`, `GIVER_LEVELS_DESCRIPTION`): keep its `-- TRANSLATORS:` comment and placeholders in step, since a mismatch breaks the whole file or panel.
- **New sort or list setting**: besides New setting, read in both builders, `BuildQuestListEntries` (`Forever-Quest-List-Entries.lua`) and `BuildDisplayOrder` (`Classic-Quest-Sort.lua`), or the shared rule in `Quest-Sort.lua`; for spacing, both `listView`'s extent calculator (`Forever-Quest-List.lua`) and `RowTops` (`Classic-Quest-Rows.lua`).
- **New field on a sort record**: both builders (`Forever-Quest-List-Entries.lua`, `Classic-Quest-Sort.lua`) and the comparators in `Quest-Sort.lua`.
- **Row content on the list** (a badge, tag or column): `InitRow` (`Forever-Quest-List.lua`, title room) and `StyleQuestRows` (`Classic-Quest-List.lua`) plus `RedrawRow` (`Classic-Quest-Sort.lua`).
- **Tracking behavior**: `Forever-Tracking.lua` and `Mists-Tracking.lua` share one surface (`ns.ToggleTracking`, `ns.SetAllTracked`, `ns.IsTracked`, `ns.CanTrack`, `ns.HasRoomToTrack`, `ns.CanRemoveQuestWatch`); `Classic-Tracking.lua` has its own by index → callers `ns.QuestActions` (`Forever-Quest-Log.lua`) and `UpdateListButtons` in both list files.
- **New zone-actions `ns` name, or a field on `ns.LogQuests` entries**: `Classic-Zone-Actions.lua` and `Forever-Zone-Actions.lua` with the same signature and shape → `ns.DiagnosticLogQuests` in `Manifests.lua` for a new field.
- **New Questie query in the dungeon or zone match**: `Dungeon-Quest-Lookup.lua` → `DUNGEON_QUESTIE_QUERIES` (`Manifests.lua`).
- **New sent message**: locale key → its builder in `Announcements.lua` (`ns:BuildWhisperMessage` or `ns:BuildAnnounceMessage`) → its Example row on the Quality of Life panel → Message Length in ruRU.
- **New font setting field**: every area's entry in `profile.fonts` → `Sync` / `Flags` (`Fonts.lua`) → its control in `ns.AddFontOptions` (`Options-Fonts.lua`) and locale keys → `FontLines` (`Manifests.lua`).
- **New game font choice**: `GAME_FONTS` (`Fonts.lua`) → `FONT_GAME_*` in `enUS.lua` → `GAME_FONT_FACES` (`Manifests.lua`).
- **New QuestInfo piece to style or space**: `QUEST_INFO_TEXT` / `QUEST_INFO_HEADINGS` (`Quest-Info-Style.lua`) → `PIECE_KINDS` (`Quest-Giver.lua`) → `LAST_PIECES` (`Forever-Quest-Giver.lua`) if it can end a page.
- **Reward spacing**: the `ns.LAYOUT` reward gaps are applied in three places that must agree: `PlaceRewards` (`Forever-Quest-Details.lua`), `ns.SpaceRewardsBlock` (`Quest-Rewards.lua`), `AlignRewards` (`Classic-Quest-Details.lua`).
- **New quest ID spot**: `ns.StyleQuestID` → `ns.LinkQuestIDToWowhead` (keep the returned button if the ID reparents) → `ns.CreateRoomBelow` on a scrolling page → `UpdateScrollChildRect` after placing.
- **New VoiceOver field**: `CanDealButtons` / `OVERLAY_FUNCTIONS` (`Classic-VoiceOver.lua`) or `GetOverlay` (`Forever-VoiceOver.lua`) → `VOICEOVER_OVERLAY_PIECES` (`Manifests.lua`) → `ns.GetVoiceOver` (`Utilities.lua`) for a field the global must hold.
- **New docked map pin template**: XML template with `mixin="PrettyWideQuestLogPinMixin"` (`Quest-Map.xml` or `Questie-Map.xml`) → its provider → its frame level in both `Forever-Quest-Map.lua` and `Classic-Quest-Map.lua`, before `ns.AddPlayerPinLevel`.
- **New Blizzard layer on the docked map**: WoW Forever and Mists, `AddProvider` in `Forever-Quest-Map.lua` (combat hold automatic) and its `levels:AddFrameLevel` line; Classic Era and TBC, the provider and its own combat hold in `Classic-Quest-Map.lua` → the Quest Map Context layers line (`Manifests.lua`).
- **New node or task kind on the route**: built in its own file, called from `routes.BuildNodes` (`Routes-Nodes.lua`) → `AtQuestGiver` if it sits at one NPC, `routes.TaskText` / `routes.TaskColor` (`Routes-Stops.lua`) and a locale key → `routes.IsTaskLeft`, `routes.QuestsAt` (`Routes-Stop-Lines.lua`) → its icon in `routes.ApplyStopLook` (`Routes-Stop-Look.lua`) → `routes.AddStopTooltip` (`Routes-Map-Tooltip.lua`), `RightClick` (`Routes-Map.lua`) → `routes.TaskLabel` / `IgnoredTasks` (`Routes-Ignore.lua`) → `NoteTask` / `IsRouteIcon` / `QuestieTextures` (`Routes-Map-Questie-Icons.lua`) → its setting's part in `routes.Signature()` (`Routes-Questie.lua`) → its file in `Routes.xml`.
- **New party task key form**: `PARTY_KEYS` (and `PARTY_FOLLOW_UP_KEYS` for follow-ups) in `Routes-Ignore.lua` → its producer (`Routes-Nodes.lua`, `Routes-Camps.lua`, `Routes-Chains.lua`) → `IsRouteIcon` / `NoteTask` (`Routes-Map-Questie-Icons.lua`) if its icons should hide.
- **Something a predicted (not yet taken) node must not do**: check `node.predicted` in `IsPinnable` (`Routes-Pinning.lua`), `LinkOverlaps` (`Routes-Overlaps.lua`) and `Survey` (`Routes-Arrow-Survey.lua`).
- **New planned-ahead quest field Questie checks against the character**: `UNPLANNABLE` in `Routes-Chains.lua`, or a check in both `CouldTake` and `MemberCouldTake`.
- **New Local Available Quests choice**: its `profile.routes` key → `Handling` or the candidate filter in `Routes-Pick-Ups.lua` (chain follow-ups reuse it through `routes.pickUpHelpers`) → `routes.LocalQuestSignature` → its row in `Options-Quest-Arrow.lua`.
- **New plan output**: `Plan` and the planner's `OnUpdate` assignment in `Routes-Planner.lua`, kept with `stops` / `start` / `nodes` / `engaged` / `camps` → `PlanCamps` returns the same shape.
- **Marker base size**: world map, `STOP_SIZE` / `STOP_ICON_SIZE` (`Routes-Map.lua`) and the waypoint template's `<Size>` and `Icon` size (`Routes.xml`); minimap, `MARKER_SIZE` / `MARKER_ICON_SIZE` (`Routes-Minimap.lua`) → the `markerScale` / `minimapMarkerScale` comments in `Default-Settings.lua`.
- **New marker look** (ring or icon kind): `routes.ApplyStopLook` (`Routes-Stop-Look.lua`, drives both maps) → its color token → the template comment in `Routes.xml`.
- **New world map pin template**: `Routes.xml`, after `Routes-Map.lua` → `RemoveAllData` (`Routes-Map.lua`) → a `LEVEL_OFFSETS` entry if it needs its own level.
- **New line kind under the Quest Arrow**: its `ForEachStopLine` callback (`Routes-Stop-Lines.lua`) → `Line` font, `Indent` and spacing in `ListQuests`, the title-row boundaries the item buttons read, and the layout key in `Add` if it carries a new attribute (`Routes-Arrow-List.lua`).
- **New Quest Arrow menu row kind or flyout**: `Entries` / `EntriesKey`, and for a flyout its builder in `panels.submenus` (`Routes-Arrow-Menu.lua`) → `Layout` (`Routes-Arrow-Menu-Panel.lua`) → locale key for the label.
- **New piece drawn outside the Quest Arrow's list block**: export its bounds as `routes.ArrowItemBounds` does → `PlaceShade` (`Routes-Arrow-Shade.lua`).

## Saved Variables

- `PrettyWideQuestLogDB` (`ns.SAVED_VARIABLES_NAME`, every TOC's `## SavedVariables`), AceDB-3.0, the only SavedVariables table. Defaults in `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`).
- **Simple model** (`AceDB:New(..., true)`): every character shares one default profile; no setting differs per character. Reset Profile returns the profile to install defaults, `routes` and `fonts` subtables included, and leaves `global` and `char` alone. README-Notes records the per-character exception.
  - **`profile`**: every setting; Routes' in `routes`, each text area's font in `fonts`; plus `giverCleanupMoved` (see Migration Chain).
  - **`char`**: `routesIgnored`, the character's own ignored objectives by task key (`Routes-Ignore.lua`; the Quest Arrow's or a marker's middle-click resets the player's zone, `routes.ResetZone`); `routesFlightMasters` and `routesFlightMapSeen`, the flight paths it has (`Routes-Flights.lua`); `zoneShareOffered`, party members already offered the zone's quests in this group, kept through a reload (`Zone-Share-Offer.lua`); `zoneInfoWanted`, quests Zone Info's + put on the route until taken or done (`Zone-Info-Data.lua`).
  - **`global`**: only presentation, kept from a profile reset or switch: `scale`, `mapScale` (with defaults), `height`, `mapHidden`, `point` (the own window, WoW Forever and Mists; Blizzard places Classic's) and `routesArrowPoint` (no defaults). Reset Window (`ns.ResetWindow`) and the Quest Arrow panel's Reset Arrow (`routes.ResetArrowPosition`) are the confirmed resets for those.
- Resetting a key with a default writes the default back rather than clearing it (AceDB fills plain defaults only at load): `ns.ResetWindow`, Reset Font (`Options-Fonts.lua`).
- `ns:ApplyProfile` (all three profile callbacks): `MoveQuestGiverCleanup`, `ns.SyncFonts`, the quest giver cleanup, the list and map while the wide quest log runs, Routes (`routes.ApplySettings`), the dungeon quests, and `NotifyChange` on every panel.
- `PruneOtherClientCharacters` (`Core.lua`) runs right after `AceDB:New` (standing cleanup, not a migration): AceDB keys a character `"Name - Realm"` on realm clients and `"First Last"` on WoW Forever, so a key shaped the other way came from a copied WTF folder. Its `char` and `profileKeys` entries go, in the main table and every namespace, and its own profile unless a current-client character still uses it. Silent.
- No default lists are seeded.
- Diagnostic Tools' Saved Variables report dumps the whole table.

### Migration Chain

In run order; the dated ones are tagged `MIGRATION (remove after …)` in the code:

1. `MoveQuestGiverCleanup` (`Core.lua`, untagged, no removal date): once per profile (`giverCleanupMoved` flag), a profile with `enableQualityOfLife` off gets `giverCleanup` off, since the cleanup's switch moved from Quality of Life to NPC Dialogue. Runs in `ns:OnAddonLoaded` after the prune, and again in every `ns:ApplyProfile`.
2. `MigrateSettings` (`Routes-Core.lua`, after 2026-12-06), from Routes' `PLAYER_LOGIN`: an account-wide `global.routes` table onto the profile's `routes` (keys with a default only), its `arrowPoint` to `global.routesArrowPoint` unless one is saved; Routes Context reports old settings still waiting.
3. `DropRetiredSettings` (`Routes-Core.lua`, after 2026-12-07): drops `cycleSeconds` and `enabled` from the profile's `routes`.
4. `DropPredictiveSettings` (`Routes-Core.lua`, after 2026-12-11): drops `showUpcomingTurnIns` and `planQuestChains` (folded into `predictiveRoutes`).
5. `PlaceFrame` (`Routes-Arrow.lua`, after 2026-12-07), from a `routes.OnLogin` handler after the three above, on every Arrow Size change and on Reset Arrow: an arrow spot saved by a point other than `TOP` is re-saved by its top (`HoldByTop`).

## Pitfalls & Why

- **Hooking or reshaping Blizzard's quest log outside `ns.AddWideQuestLogPart` on Classic Era or TBC**: it runs with the Quest Log switch off, and can't be taken back. Every file that hooks `QuestLogFrame` or its functions wraps its body in a part; the only exceptions are the share whispers' `QuestLogPushQuest` post-hook and `Classic-Zone-Actions.lua`'s calls when invoked.
- **Calling a part's function from outside a part on Classic Era or TBC**: with the switch off it is nil. Check `ns.wideQuestLogActive`, or gate the control with `Inactive`.
- **Defining an event handler after `ADDON_LOADED`**: Core's last registration pass runs right after `StartWideQuestLog` runs the quest log parts, so a handler defined later (in a timer, a hook or `ns:OnDatabaseReady`) never registers an event no other handler has. Define handlers at file scope or in a part (see Files That Change Together, New event).
- **Adding a quest log part after load on Classic Era or TBC**: Core drops its queue once `ADDON_LOADED` has run the parts, so a late `ns.AddWideQuestLogPart` throws. Call it only at file scope.
- **Reading `ns.db` at file scope**: it doesn't exist until `ADDON_LOADED`. Classic's quest log parts run after it exists, but the own-window files, the shared files and Routes build at file load. Read settings at use, as `ns.IsQuestGiverCleanupOn` and `ns.ShowTrackingMark` check `ns.db` first, or in `ns:OnDatabaseReady` on WoW Forever and Mists, or in a `routes.OnLogin` handler for Routes.
- **Defining a handler or `ns:OnDatabaseReady` a second time**: each is one slot on `ns`, so the later file silently replaces the earlier. Put a second handler on the feature's own table and name it in its `EVENTS` row's third field.
- **Creating an `EVENTS` owner table after the second registration pass**: an event whose only handlers live on it never registers. Create the table at file scope, as `ns.dungeonQuests`, `ns.shareReminders`, `ns.zoneShareOffer`, `ns.shareNeeds`, `ns.keyBindings` and Routes' tables are.
- **Registering an event a client lacks**: throws. Add events through `EVENTS` in Core, never `RegisterEvent` in a feature file, and define the handler only in that client's files.
- **Resetting a setting that has a default by setting it to nil**: AceDB fills defaults only when the scope is first read, so the key reads nil until the next reload. `ns.ResetWindow` writes `scale` and `mapScale` from `ns.DATABASE_DEFAULTS` and clears only `height` and `point`, which have no default; Reset Font writes every default of its area back.
- **Restyling every `QuestFrameItems_Update`**: the quest giver window lays out its rewards through it too. The hook in `Classic-Quest-Details.lua` acts only when `questState` is `"QuestLog"`.
- **Forgetting to re-anchor Classic rows**: `PositionRows` (`Classic-Quest-Rows.lua`) moved them for the row spacing, and `QuestLog_Update` doesn't put them back. Every pass re-anchors every row below the first.
- **Widening the Classic list's scroll range with `FauxScrollFrame_Update`**: `QuestLog_Update` resets the range on every update, so the list jumps back. `Classic-Quest-Rows.lua` shows fewer rows instead (`RowsThatFit`).
- **Reading `QUESTS_DISPLAYED` as what the Classic window holds**: there are two counts, capacity (`ns.SetQuestRowCount`, from the height) and shown (`QUESTS_DISPLAYED`, at most capacity).
- **Adding work before `UpdateList`'s early return after a row-count change**: a changed shown count reruns `QuestLog_Update` from inside the list's own hook, which returns right after; it settles because the rerun's `RowsThatFit` gives the same count. Work there would run twice.
- **Routing VoiceOver's `Update` hook to the full Classic list update**: it would rerun the sort and row-count pass, which can itself call `QuestLog_Update`. It restyles only (`ns.RestyleClassicQuestRows`).
- **Resizing Classic's window without telling the panel manager**: it scales the whole window down. `ApplyHeight` sets the `height` and `bottomClampOverride` panel attributes whenever the height changes.
- **Applying the saved height at load**: the screen isn't settled, so the clamp cuts it short. Apply it in `OnShow`, and never save the clamped value.
- **Matching Blizzard's art by file path**: current clients return nil from `GetTextureFilePath` for XML textures. `IdentifyBlizzardArt` checks the file ID first.
- **Leaving sort ties to `table.sort`**: it isn't stable, so equal rows swap between repaints. `ns.SortQuests` and `ns.SortZones` (`Quest-Sort.lua`) end on `sortIndex`, the quest log index.
- **Loading `Classic-Quest-Log.lua` before `Classic-Quest-List.lua`**: the log's part calls `ns.GetQuestRowHeight()` as it builds, which exists only once the list's part has called `ns.CreateClassicQuestRows` (`Classic-Quest-Rows.lua`). The Vanilla and TBC TOCs list `Classic-Quest-Rows.lua` and `Classic-Quest-List.lua` before the log file.
- **Leaving extra Classic rows shown when the window shrinks**: `QuestLog_Update` fills only up to `QUESTS_DISPLAYED`, so rows made for a taller window keep drawing past the bottom edge. `ShowRowCount` (`Classic-Quest-Rows.lua`) hides every made row past the count.
- **Measuring a Classic row's title as Blizzard left it**: Blizzard sized it for its old position and cut it short there. `StyleQuestRows` sets the width to 0, measures the whole title, then shortens it to clear the tag.
- **Testing `GetQuestLogTitle`'s `isComplete` for truth**: a failed quest's is -1, which Lua counts as true. Compare its sign, as the Classic row styling (`isComplete > 0`, `< 0`) and `ns.GetQuestLogEntry` (`isComplete`, `isFailed`) do.
- **Styling Classic's rows before VoiceOver's buttons**: VoiceOver's button functions rewrite the title and move the check. `UpdateList` runs `StyleQuestRows` last, after `ns.MatchVoiceOverButtons`, and VoiceOver's own `Update` is followed by `ns.RestyleClassicQuestRows` (last built order).
- **Dragging Classic's window taller without re-hanging its bottom buttons**: some are anchored to the window's top edge, so they stay behind. `Classic-Quest-Log.lua` re-hangs off the bottom edge any child anchored to the top near the bottom (`nearTheBottom`).
- **Measuring a button label's width at load**: the font may not be loaded yet. `ns.CreateListButtons` fits the list buttons the first time they show.
- **Counting Blizzard's watches to find tracked quests on Classic Era or TBC**: with Questie's tracker on, Blizzard's watch count stays at 0. Untrack All asks `IsQuestWatched` of each listed quest, which Questie replaces with its own state.
- **Placing the turn-in line when it's made**: on Classic Era and TBC, `Classic-Quest-List.lua` makes the line before `Classic-Quest-Log.lua` records `ns.abandonButton` and `ns.shareButton`. `PlaceTurnInLine` waits for the first update that shows the line.
- **Asking Classic Era, TBC or Mists about a quest that isn't selected**: `GetQuestLogPushable`, `QuestLogPushQuest` and `SetAbandonQuest` act on the selected quest only. `Classic-Zone-Actions.lua` and the `ns` accessors in `Quest-Log-API.lua` select each in turn and put the player's selection back.
- **Looking for quests under a collapsed zone on Classic Era, TBC or Mists**: the quest log lists none, and expanding or collapsing shifts every index below. Find quests by quest ID after expanding, re-collapse from the bottom up, and put the selection back by its index only once every zone is back as it was. On Mists the window keeps Blizzard's zones open for this reason (`ns.ShowEveryQuestLogEntry`) and tracks its own collapsing.
- **Putting the selection back by quest ID on Classic Era, TBC or Mists**: a selected zone header, or no selection, is lost. `Classic-Zone-Actions.lua` re-collapses first, so every entry is back where it was, then passes the saved index to `SelectQuestLogEntry`.
- **Calling `ns.LogQuests` from code meant to only read**: on Classic Era, TBC and Mists it expands every zone and selects every quest in turn, and `ns.DungeonQuests` / `ns.ZoneQuests` call it. The reports read through `ns.DiagnosticLogQuests`, and Sharing Context swaps it in for `ns.LogQuests` for the length of its `ns.DungeonQuests` call.
- **Hiding Blizzard's side windows in combat**: some are protected, so `HideUIPanel` on them is blocked. `CloseLeftPanels` (`Forever-Quest-Log.lua`) does nothing in combat.
- **Selecting a quest from add-on code on every repaint (WoW Forever and Mists)**: a selection can mark Blizzard's objective tracker dirty and leave its next update tainted (see Taint). `ns.SelectQuest` selects only when the selection differs, through `ns.TrackerTaintStep`.
- **Changing the watch list in combat (WoW Forever and Mists)**: it taints the objective tracker. `ns.ToggleTracking` and `ns.SetAllTracked` refuse in combat with Blizzard's `ERR_NOT_IN_COMBAT` (`RefusedInCombat`, in both `Forever-Tracking.lua` and `Mists-Tracking.lua`), and the list's Track All and `ns.QuestActions` gray out while `InCombatLockdown()`.
- **Sharing in combat on WoW Forever**: `QuestLogPushQuest` is blocked there for add-on code. A single share waits for `PLAYER_REGEN_ENABLED` (`ns.shareNeeds`, `Share-Needs.lua`), and every share run (both zone-actions files) re-checks each interval until combat ends.
- **Loading `Quest-Log-Key.lua` before `Forever-Quest-Log.lua`**: it reads `ns.questLogFrame` as it loads, the frame that owns the override binding, and the client's key file reads `ns.questLog` too. The Camelot and Mists TOCs list it right after `Forever-Quest-Log.lua`, followed by that client's own key file.
- **Toggling the window from WoW Forever's `ToggleQuestLog` hook without asking `ns.WasClosedForPanel`**: the world map opening has already closed the window, so a toggle would reopen it and the micro menu button could never close it. `Forever-Quest-Log-Key.lua` toggles only when the window didn't just close for `WorldMapFrame`, and Mists keeps `openBeforeToggle` for the same reason.
- **Assuming the window means the quest ID API**: Mists has the window with only the older calls by index. Go through the `ns` accessors in `Features/Quest-Log-API.lua`, and in Diagnostics test `OWN_WINDOW` and `QUEST_ID_API` separately.
- **Asking Mists about a quest by ID in a loop**: `ns.GetLogIndexForQuestID`, `ns.IsQuestComplete` and the like walk the whole log each call. Read the entry's own `isComplete` and `isFailed`, and pass `questLogIndex` to `ns.IsTracked` and `ns.HasRoomToTrack` where the caller has it.
- **Treating Blizzard's selection as the window's on WoW Forever or Mists**: they can differ. `ns.DisplayQuestDetails` selects first, and `Mists-Quest-Portrait.lua` checks before it reads the giver.
- **Letting Blizzard's quest log close the window on Mists**: a panel in the left area closes the window, and Blizzard's would on every takeover. `ns.IsTakenOverPanel` exempts it while the takeover runs, out of combat only.
- **Forgetting `WatchFrame` on Mists**: it listens for no event a watch change fires. `Redraw` in `Mists-Tracking.lua` calls `WatchFrame_Update`.
- **Loading the tracking file after `Forever-Quest-Log.lua` on WoW Forever or Mists**: that file captures `ns.ToggleTracking`, `ns.AskToAbandonQuest` and `ns.ShareQuest` by value as it builds its bottom buttons. The Camelot and Mists TOCs list `Quest-Log-API.lua`, `Share-Needs.lua` and `Forever-Tracking.lua` or `Mists-Tracking.lua` before it.
- **Skipping `AddQuestWatch` for a quest Blizzard already watches on WoW Forever**: Questie's tracker never learns about it. `Track` in `Forever-Tracking.lua` calls `C_QuestLog.AddQuestWatch` regardless; adding a watch that exists is harmless.
- **Loading `Mists-Quest-Portrait.lua` before the map**: it reads `ns.questMap.holder` and hooks `ns.DisplayQuestDetails`, `ns.ApplyMapScale` and `ns.OnWindowResizeStopped` at load. The Mists TOC lists it after every other Features file.
- **Sharing quests back to back**: a share within about 3 seconds of the last gets the party member reported as busy. Share Quests and the dungeon quests space them by `ns.GetShareInterval()`, whose slider stops at `ns.SHARE_INTERVAL_MIN`, and share one run at a time (`ns.sharingQuests`).
- **Matching share results against English text**: fails in every other language. `Share-Reminders.lua` builds its patterns from the client's own `ERR_QUEST_PUSH_*` strings.
- **Reading or sending chat during chat lockdown**: system messages are secret and sends fail. `OnChatMsgSystem` returns while `C_ChatInfo.InChatMessagingLockdown()` holds; the dungeon announcement (`Announce` returns false) and the zone offer ("wait") retry on the next check instead of counting as sent.
- **Counting a login or reload inside a dungeon as arriving**: the party gets the announcement and every quest again. `isInitialLogin` / `isReloadingUi` mark the party seen over `ns.DUNGEON_LOGIN_GRACE` as already served, but only when the player was grouped at that loading screen (`groupedAtLogin`); a group formed after is served as arriving.
- **Waiting for party range on WoW Forever**: `UnitInRange` answers for no one there, so the dungeon quests would wait the full minute every time. `IsInRange` counts everyone as in range when `ns.FLAVOR` is `"Camelot"`.
- **Testing a party member's GUID or connection without checking for secrets**: on WoW Forever they can come back secret, and a secret value can't be tested or compared. `PartyMembers` (`Dungeon-Quests.lua`), `PartyUnits` (`Zone-Share-Offer.lua`) and `ns.PartyNeedsQuest` gate each read with `ns.IsReadable`.
- **Tracking dungeon shares per group instead of per member**: a newcomer would never get the quests, or everyone would get them again on every roster change. The dungeon state keeps the GUIDs shared with, per instance ID, until `GROUP_LEFT`.
- **Keying dungeon state by Questie's zone ID**: without Questie, or for a dungeon its `ZoneDB` doesn't know, there is none. The key is the game's instance ID, the 8th return of `GetInstanceInfo`.
- **Walking Questie's objective lists with `ipairs`**: they can have gaps, so `ipairs` stops early and misses objectives. `QuestieQuestIn` walks them with `pairs`.
- **Counting Questie's world event quests as a dungeon's**: Questie can place a holiday or Darkmoon Faire quest in a dungeon it has nothing to do with. `ns.DungeonQuests` leaves out anything `QuestieEvent.IsEventQuest` flags, even under the dungeon's header.
- **Sending a message over 255 bytes, or shortening one by characters**: `SendChatMessage` rejects the whole message, and the limit (`ns.CHAT_MESSAGE_MAX_LENGTH`) is in bytes, so cutting mid-character breaks the text. `ns.FittingQuestReference` picks a quest reference that fits, and `TrimToBytes` cuts the bracketed title on a UTF-8 boundary.
- **Splitting the dungeon announcement anywhere but between quests**: a quest link cut in two is broken text. `DungeonAnnouncementArguments` packs whole references and starts a new message, with its own lead, when the next one won't fit.
- **Stripping pipes from a message for other players**: the bodies carry quest links, which stripping breaks. `BuildSent` (`Announcements.lua`) keeps pipes.
- **Leading a group-chat message with a raid-marker token on WoW Forever**: the client blocks `{rtN}` in group and channel chat there, but allows it in whispers. `BuildSent` (`Announcements.lua`) leaves `ns.TARGET_MARKER` off only non-whispers on `"Camelot"`; whispers carry it on every client.
- **Drawing a chat line in an options panel as chat draws it**: after a link's `|r` a panel falls back to white, where chat falls back to the channel color. The Example lines' `Tint` (`Options-Utilities.lua`) reopens the color after every `|r`.
- **Treating every `QuestInfo_Display` call as a quest giver page's**: Blizzard's own quest details (the world map's on WoW Forever, the quest log's on Mists) call it too, so a hook that styles for one restyles both. Page layout (`SpaceQuestGiverPage`, `ns.LayOutQuestGiverPage`) checks `ns.IsQuestGiverPage(parentFrame)` and `ns.IsQuestGiverCleanupOn()`, and `ns.LayOutQuestGiverPage` puts the gold and experience back anywhere else it moved them (`rewardNumbersMoved`). The font and color fixes (`Quest-Rewards.lua`, `Quest-Giver-Skins.lua`) check only the cleanup, on purpose, since those frames are shared.
- **Styling Blizzard's quest text after it has been laid out**: Blizzard's measurements no longer match what's drawn. Style shared text as the saved settings load, as `ns.ApplyQuestGiverCleanup` does.
- **Moving a quest giver piece without keeping Blizzard's offset**: Blizzard anchors some pieces afresh on each show but others only once (the greeting page's greeting text, the progress page's title, text, items and heading), so those would keep the cleanup's offsets after it goes off. `Quest-Giver-Pages.lua` keeps each offset the first time it moves (`greetingBlizzardY`, `blizzardY`) and puts it back with the cleanup off.
- **Resizing the gossip window's lines outside `Setup`**: the list measures each row with a hidden copy set up the same way, so a frame resized anywhere else would overlap its neighbors. `SpaceGossipLine` adds `QUEST_LINE_SPACE` inside each button's `Setup` hook (which sizes afresh, so it never stacks), and level tags go through the button's own `Resize`.
- **Styling only the gossip greeting that shows**: the list places its rows by a hidden copy of the greeting (`greetingTextFrame`) whose `Setup` never runs, so a long styled greeting overlaps the first option. `Gossip.lua` styles that copy after each `GossipFrame.Update` and `Rebuild`s the ScrollBox when its height changes; `FullUpdate` recalculates heights but leaves the rows already shown at their old size and place.
- **Loading the quest text files out of order**: several capture another's functions at load. `Quest-Giver-Pages.lua` follows `Quest-Giver.lua` (`ns.TagQuestLine`); `Forever-Quest-Details-Rewards.lua` and `Quest-Chain.lua` precede `Forever-Quest-Details.lua` (`ns.CreateRewardButtons`, `ns.CreateQuestChainSection`); `Quest-Giver-Skins.lua` follows `Quest-Giver.lua` so its `QuestInfo_Display` pass runs after the page is spaced.
- **Defining `ns.LayOutQuestGiverPage` on another client**: `SpaceQuestGiverPage` (`Quest-Giver.lua`) adds `REWARDS_HEADING_RISE` only when that function exists, so the quest giver page's spacing would change.
- **Showing Questie's quest tooltip before Questie has started**: it only prints a wait message to chat. `ShowQuestieTooltip` (`Quest-Chain.lua`) checks `Questie.started`.
- **Hanging the quest giver page's quest ID under any shown `QuestInfo` piece**: a piece left showing from Blizzard's quest details belongs to that window, not the quest giver page. `LastShown` in `Forever-Quest-Giver.lua` counts only pieces on that page.
- **Tagging a quest giver's quest line every time Blizzard sets it up**: Blizzard may run the setup again on text already tagged. `levelTaggedText` skips a line already done.
- **Changing a coin button's font without laying the coins out again**: Blizzard sizes each coin to its text when it lays the coins out, so the amounts no longer fit. `StyleRewardMoney` (`Quest-Rewards.lua`) calls `MoneyFrame_Update` with the frame's `staticMoney` after any font change.
- **Regrouping the whole experience text**: ElvUI appends the share of a level in a hook that may run before or after the add-on's, and regrouping it would mangle the share. `Quest-Rewards.lua` regroups only the number at the front.
- **Styling for ElvUI at load**: ElvUI skins the quest log and the quest giver window after this add-on loads, so there's no backdrop yet. `Classic-ElvUI.lua` checks on each `QuestLogFrame` `OnShow` until it can act, and `Quest-Giver-Skins.lua` checks the quest giver window's backdrop on each `QuestFrame` `OnShow`.
- **Reading a skin's shadow from the font object**: ElvUI sets shadows on the FontStrings themselves, so a copy loses the Description's look. `CopyFont` in `Quest-Chain.lua` reads font, color and shadow off the FontString.
- **Caching a quest chain miss**: before Questie's database is ready every quest looks like it's in no chain, and the miss would stick for the session. `ns.GetQuestChain` keeps only a chain found (`lastChain`).
- **Calling Questie's modules directly, or taking an import as proof**: Questie may be missing, still loading, or have renamed a function, and `ImportModule` hands back an empty table for a module it doesn't have. Modules come through `ns.ImportQuestieModule`, which imports in a `pcall`; callers check each function exists before calling it, and wrap calls that can throw in a `pcall`.
- **Reading Questie's quest log from one place**: Questie 12.6.3 moved it from `QuestiePlayer.currentQuestlog` to the `ActiveQuests` module, each value an acceptance with the quest under `.quest`. `ns.QuestieLogEntries` (`Utilities.lua`) reads whichever exists and says which.
- **Reading VoiceOver's fields by plain indexing**: the `VoiceOver` global falls back to `_G` for anything it doesn't hold, so a missing field reads as some unrelated global instead of nil. `ns.GetVoiceOver` checks its fields with `rawget`. The one deliberate exception is `Classic-VoiceOver.lua` reading `GetQuestLogTitle` through it, where falling back to the global is the point.
- **Leaving VoiceOver's own play buttons on the add-on's rows (WoW Forever and Mists)**: Blizzard's list takes them back to its rows whenever it redraws. `Forever-VoiceOver.lua` makes a set of its own with VoiceOver's `MakePlayButton`.
- **Making the turn-in tooltip opaque once**: every `Show` restores the see-through style. `MakeOpaque` runs after each `Show`.
- **Reusing a quest tag ID across flavors**: tag 1 means Elite on some and Group on others. Keep each flavor's `ns.QUEST_TAG_SUFFIXES` in its own `Quest-Tags` file.
- **Loading Vanilla and Discovery data without the guard**: the Vanilla TOC lists both, so the later would overwrite the earlier. Each Vanilla file returns early when `ns.IS_DISCOVERY` is set, and each Discovery file when it isn't.
- **Loading the map files out of order**: several files read another's output as they build. `Player-Map-Pin.lua` defines `ns.AddPlayerPin` / `ns.AddPlayerPinLevel` that `Quest-Map.lua` and the client's map file call; `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons`, and defines the `PrettyWideQuestLogPinMixin` that `Questie-Map.xml` names; `Classic-Quest-Map.lua` takes `questMap.RequestRefresh` (`Questie-Map.lua`) by value for its `QuestLog_UpdateQuestDetails` hook; `Forever-Quest-Map.lua` reads `ns.questMap` at load; `Quest-Map-Reveal.lua` hooks the exploration pin the client's map file makes; `Questie-Map-Tooltip.lua` reads `questMap.QUESTIE_PIN_TEMPLATE`. The order is in the Quest Map's Load Order.
- **Building the map canvas in Lua**: `MapCanvasFrameTemplate`'s `OnLoad` runs before Lua could add the `ScrollContainer` and `BorderFrame` it needs. The frame stays in `Quest-Map.xml`.
- **Trusting Blizzard's objective area to draw on the docked map**: Questie turns `questPOI` off for some objective styles, and Blizzard's blob pin then draws nothing. `Forever-Quest-Map.lua` replaces `Refresh` on its own copy of the pin, less that check; never touch the CVar or the world map's provider.
- **Drawing Questie's quest twice on WoW Forever or Mists**: Blizzard's objective area and marker would sit under Questie's icons. They're drawn only for a quest Questie has no icons for (`BlizzardQuestID`, against `questMap.questieQuestID`, which `FollowQuestieQuest` sets first).
- **Showing a map the client has no art for**: the canvas can't draw it. `questMap.ShowMap` climbs to the nearest parent map that passes `questMap.CanShowMap`, and the quest giver's map (`AreaMapID`, `Questie-Map-Quest-Giver.lua`) skips such maps.
- **Disabling the mouse wheel on the map to stop zooming**: the wheel then zooms the camera behind it. `SetMouseWheelZoomMode` with `MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_NONE` keeps it enabled.
- **Letting the canvas acquire pins in combat**: it calls `SetPassThroughButtons` on each, which WoW blocks from add-on code in combat. The add-on's own templates use `PrettyWideQuestLogPinMixin` and `PrettyWideQuestLogRoutePinMixin`, whose `SetPassThroughButtons` does nothing. The docked map's copies of Blizzard's providers hold `RefreshAllData` in combat and run it from `questMap:OnPlayerRegenEnabled`: every provider on WoW Forever and Mists (wrapped as added, so replacing one's `RefreshAllData` afterwards drops the hold), the exploration layer on Classic Era and TBC.
- **Showing the canvas with no map set**: drawing with none breaks Blizzard's map code. The canvas's `OnShow` sets one first (the quest's, then the player's, then `C_Map.GetFallbackWorldMapID`), and holds `MapCanvasMixin.OnShow` until the scroll frame has zoom levels.
- **Asking the canvas for its map with `canvas:GetMapID()`**: until a map is set it answers the player's map, so it can't tell whether the canvas has one. The quest map reads the canvas's `mapID` field (`CanvasMap`).
- **Building objective areas from Questie's icons**: Questie thins its icons out where they crowd, so the areas would miss spawns. `Questie-Map-Areas.lua` reads every spawn from the objective's `spawnList`.
- **Reading the glow from Questie's glow texture**: Questie shows that texture only once the world map has been opened. `SetGlow` (`Questie-Map.lua`) takes the color from the icon's `ObjectiveData.Color` and only the texture file from `icon.glowTexture`.
- **Capturing a Routes function before the file that defines it loads**: the local is nil and the first plan throws. Keep a new file in `Routes.xml` after everything it captures by value (see Loading under Routes).
- **Parenting or anchoring a secure button to the Quest Arrow**: the arrow becomes protected, and in combat it can no longer move, hide or resize with its list. The Use Item buttons sit on `UIParent`, placed by the arrow's coordinates out of combat (`Routes-Arrow-Items.lua`).
- **Renaming the Use Item button or its binding**: the client saves players' keys against the binding name, so a rename silently drops them. Keep `BUTTON_PREFIX` (`Routes-Arrow-Items.lua`, `routes.USE_ITEM_COMMAND`) and `Bindings.xml` in step.
- **Creating the first Use Item button lazily**: a key pressed before any item shows would find no frame. `Routes-Arrow-Items.lua` makes button 1 at load.
- **Acting on key-down for the Use Item button**: a macro's `/click` sends only the up half. The buttons register up and down with `useOnKeyDown` false, so every path acts on up.
- **Branching on a WoW Forever secret value**: comparing or testing it errors. Item cooldown, range, friendliness, party connection and unit maps go through `ns.IsReadable` first and leave the display or answer as it was.
- **Coloring the Quest Arrow by facing alone**: backing up or strafing toward the target turns it red. `ColorHeading` (`Routes-Arrow.lua`) switches to the direction of travel past `FACING_TRUST`; turning the arrow still uses facing.
- **Drawing the route mid-flight**: it's replanned from where the player lands. The map provider's `RefreshAllData` skips the route while `routes.IsOnTaxi()`, and the minimap draws no markers (`IsShown`, `Routes-Minimap.lua`); camp markers still draw.
- **Hiding Questie's party icons a frame late**: Questie redraws them as party progress arrives, and they flash. The `HandlePin` hook hides the placed pin at once (`routes.ApplyToPlacedQuestieIcon`), relying on HereBeDragons parenting the icon to its pin.
- **Suppressing TomTom through its saved settings**: it would outlive the session and show in TomTom's options as the player's choice. `Routes-TomTom.lua` uses `SuppressFeature` / `ReleaseFeature` only.
- **Moving the pin templates above `Routes-Map.lua`**: `mixin="PrettyWideQuestLogRoutePinMixin"` names a global that doesn't exist yet. The mixin is defined in `Routes-Map.lua`, listed before the `<Frame>` templates, and declared in `.luacheckrc`'s `globals`.
- **Listing `Routes.xml` after the Diagnostics files**: `Manifests.lua` checks `ns.routes` at file load to add the Routes API rows, and would add none. Each TOC lists it among the Features, before Diagnostics.
- **Reaching for `ns.routes` without checking it**: Routes is one TOC line a release can leave out. `ns:ApplyProfile`, `ns.RegisterOptionsPanels`, the General panel's key row (`AddKeyBindings`), `ns.OptionsRoutesToggle`, Routes Context, and the Routes-Party readers outside Routes (`Share-Needs.lua`, `Forever-Quest-List-Party.lua`, `Zone-Share-Offer.lua`) all check `ns.routes` first.
- **Treating `routes.Settings()` as the saved table before `ADDON_LOADED`**: it returns `ns.DATABASE_DEFAULTS.profile.routes` itself, and a write there changes the defaults. Write only once `ns.db` exists, as the panels do.
- **Yielding inside a `pcall` or a `table.sort` comparator**: Lua 5.1 can't yield across a C call, so the planning coroutine dies. Every Questie query in the planner runs in its own `pcall` and the yielding `AddSpawns` is called outside it: `ForEachFinisher` (`Routes-Nodes.lua`), `ForEachStarter` (`Routes-Pick-Ups.lua`), `Field` (`Routes-Quest-Plans.lua`).
- **Writing a plan's results one at a time**: the watcher could compare a new plan's pins with the old plan's nodes and replan in a loop. The planner's `OnUpdate` (`Routes-Planner.lua`) assigns `routes.stops`, `start`, `nodes`, `engaged` and `camps` together.
- **Walking Questie's log with `pairs` across a yield**: before Questie 12.6.3 the log is Questie's live table, and `next` breaks if it changes mid-walk. Walk `routes.LoggedQuestIDs(log)` (`Routes-Planner.lua`), as `BuildNodes` and `BuildCamps` do; `routes.PartyQuests` lists Questie's party logs' IDs first the same way.
- **A fixed per-frame planning budget**: halves the frame rate on a fast screen. The planner takes `FRAME_SHARE` of the last frame, clamped to `MIN_BUDGET`..`MAX_BUDGET` (`Routes-Planner.lua`).
- **Resetting or changing zones while a plan runs**: finishing, it would put back the old pins and `routes.start`. `routes.ResetZone` and the zone handlers call `routes.CancelPlan()` first.
- **Reading a party member's map or connection in combat on WoW Forever**: the answer can be secret. `routes.IsUnitOutOfZone`, `routes.UnitZone`, `routes.UnitWorldPosition` and `Routes-Party.lua` test it with `ns.IsReadable` first (unreadable counts as present, offline, or unknown), and joining up keeps each member's last readable place (`lastSeen`, `Routes-Group-Up.lua`).
- **Detecting TomTom by its global alone**: other add-ons make a `TomTom` table of their own. `Routes-TomTom.lua` requires `IsCrazyArrowEmpty`, `SuppressFeature` and `ReleaseFeature`.
- **Building a moved route to weigh each move**: a 90-node route weighs hundreds of thousands of moves, over 100 MB of garbage a plan. `IsValidMove` and the searches work through index maps (`OrOptIndex`, `TwoOptIndex`), building only the move taken.
- **Using `math.random` in the solver**: equally good routes would flicker between plans. `Shake` uses its own generator from a fixed seed.
- **Leaving node order to Questie's log**: it's a hash, so the same quests would give different routes. `BuildNodes` sorts nodes by `key`.
- **Trusting a cached blob's `penalty`**: blobs are cached and shared between plans, and `LinkOverlaps` and `PinEngaged` change candidates' penalties in place. `routes.Candidates` (`Routes-Blobs.lua`) rewrites every candidate's penalty each plan.
- **Calling the world map's `Maximize` for the full-size map**: it runs Blizzard's panel layout as add-on code. `KeepFullSize` (`Routes-Map-Size.lua`) sets the `miniWorldMap` CVar instead, never in combat.
- **Turning the `questPOI` CVar off for Blizzard's quest markers**: it also takes them off the tracker and the minimap, changes the objective style Questie's options read back, has to be put back after a crash, and Questie notes that `questPOI` off makes the map open at login. `ApplyBlizzardQuests` (`Routes-Map-Blizzard-Quests.lua`) hides the world map's pins instead.
- **Hiding Questie's icons through Questie**: its own icon state would change on its other maps. `ApplyQuestieIcons` (`Routes-Map-Questie-Icons.lua`) hides HereBeDragons' pins, marks them `hiddenByRoute`, shows them again itself, and re-applies after Questie's provider `RefreshAllData` and `HandlePin`.
- **Sizing markers by the canvas alone**: Classic Era and TBC draw the full-size map at about 1.8 times the UI's scale, so markers come out that much bigger. The size is multiplied by `UIParent:GetEffectiveScale() / map:GetEffectiveScale()`.
- **Saving the arrow's spot in its own scale, or by any point but its top**: changing Arrow Size would move it, and so would the list under it changing height. `HoldByTop` re-anchors the arrow by its `TOP` and saves the offsets times the scale, and `PlaceFrame` divides by it.
- **Routing a dungeon quest's objectives**: they're inside the instance, so they're shown on the map only. `IsInstanceQuest` leaves them out by the flavor's tag table. Its turn-in is routed once it's done, but never inside the instance: checking `routes.IsInZone` alone would pass a dungeon's map filed under its entrance zone, so the turn-in's spawns also go through `routes.IsInstanceMap`.
- **Answering escort or instance questions once per session**: the client learns a quest's tag only once it has loaded the quest. Both caches are wiped a second after the quest log settles (`routes.ForgetQuestTags`).
- **Trusting Questie's tag alone for instance quests**: Questie keeps "no tag" for good once its one retry finds none, so a dungeon quest whose tag loads late would be routed. `IsInstanceQuest` falls back to the client's `ns.GetQuestTagByID`, and doesn't cache a quest neither has a tag for.
- **Formatting a locale string with the wrong placeholders**: a mismatched translation of a string an options file formats at file load breaks the whole file, and one formatted as a panel builds breaks that panel (see Files That Change Together).
- **Registering the options panels before `AceDB:New`**: the Profiles builder runs at registration and reads `ns.db`. `ns:OnAddonLoaded` calls `ns.RegisterOptionsPanels` right after the database and its profile callbacks.
- **Hanging an options panel under a sub-panel with `AceConfigDialog:AddToBlizOptions`**: it finds parents only on the AddOns list, so the panel lands under the root. `AddPanel` (`Options.lua`) registers its own `BlizOptionsGroup` as a subcategory and lists it in `AceConfigDialog.BlizOptions`, or `NotifyChange` never refreshes it.
- **Opening the root panel by its title**: on clients where the category ID is a number assigned at registration, a lookup by title finds nothing and the panel opens as a floating window. Keep the ID `AddToBlizOptions` returns (`ns.optionsFrames.categoryID`).
- **Watching the add-on's panels' `OnHide` for the reload prompt**: the player may move to another category before closing, and the game's Options window may not exist at load. `ns.WatchOptionsForReload` hooks the window itself the first time a panel shows in it.
- **Giving `ns.questLogFrame` another override binding**: `ns.RouteQuestLogKey` calls `ClearOverrideBindings` on the window every time bindings update, so it would vanish. Use another owner frame.
- **Looking up the Key Bindings category once at load**: a Settings category can register after login. `ns:OpenKeyBindings` searches at click time, then falls back to `KeyBindingFrame` and a chat line.
- **Testing an event's unit argument on WoW Forever without `ns.IsReadable`**: it can be secret, and `unit:find` on a secret value errors. `ns:OnUnitQuestLogChanged` checks it first.
- **Assuming a saved character key's shape**: AceDB keys `"Name - Realm"` on realm clients and `"First Last"` on WoW Forever; a copied WTF folder brings the other shape. `PruneOtherClientCharacters` drops those characters, and their unused profiles, at every load.
- **Removing `MoveQuestGiverCleanup` like a dated migration**: it has no removal date, and a profile first loaded later (a copy, a switch) still needs Quality of Life's old off state carried to `giverCleanup`. It runs per profile, once, behind `giverCleanupMoved`.
- **Loading `Forever-Quest-List.lua` before `Forever-Quest-List-Party.lua` or `Forever-Quest-Log.lua`**: it captures `ns.CountPartyOnQuest` / `ns.ShowPartyOnQuest` by value and reads `ns.questLogFrame` / `ns.questLog` at load, so the first row or hover throws. The Camelot and Mists TOCs list the log, then `-Entries`, `-Party`, then the list.
- **Drawing tracking marks before Questie's tracker starts**: until `QuestieTracker.started`, every quest reads untracked, so `markUntracked` flashes an eye on every row. `ns.ShowTrackingMark` hides marks while pending and redraws via a `HookBaseTracker` hook; draw marks only through it.
- **Treating a party member's "no" from `ns.IsUnitOnQuest` as known**: the game answers only in range, and on WoW Forever may answer secret. `Forever-Quest-List-Party.lua` falls back to Questie's shared logs and suppresses the "none" tooltip while any answer is unknown.
- **Checking Questie's tracker `started` before deciding WoW Forever trackability**: Questie learns of quests only through `AddQuestWatch`, so the Track controls must work from Questie's log as soon as it exists. `TrackerFor` reads `trackerEnabled` and the log, never `started`; only the marks wait.
- **Leaving row IDs from the last sorted order when the order matches Blizzard's (Classic Era and TBC)**: Blizzard's handlers would act on the wrong entry. `RedrawRows` resets every ID to its place when `BuildDisplayOrder` returns nil.
- **Letting Blizzard insert a Classic row's text on shift-click**: the text leads with the level tag. A `QuestLogTitleButton_OnClick` post-hook swaps in `row.plainTitle`, and steps aside with Questie loaded, which inserts its own link.
- **Sorting a collapsed Classic zone by its listed quests**: a collapsed zone lists none, so its average would be nil and it would jump to the end. `knownZoneLevels` keeps its last open average for the session.
- **Reading Questie's quest log per quest on WoW Forever**: a repaint asks about every quest. `QuestieLog` (`Forever-Tracking.lua`) reads it once per frame, keyed by `GetTime()`.
- **Defining `ns:OnPlayerEnteringWorld`, `ns:OnGroupJoined`, `ns:OnGroupLeft` or `ns:OnGroupRosterUpdate` in another file**: replaces the dungeon quests' (or `Forever-Quest-Log.lua`'s) handler silently. Use an owner table and an `EVENTS` row, as `ns.zoneShareOffer`, `ns.shareReminders` and `ns.dungeonQuests` do.
- **Treating `securecall`'s nil as a skipped share in `ns.ShareQuests`**: an erroring share would fire the next one at once, inside the busy window. A nil return counts as shared so the interval holds; only an explicit `false` (nobody needs it, gone, unshareable) skips the wait.
- **Asking shareability on hover or redraw on index clients**: it selects every quest in the zone. Share Quests computes it only on click; Sharing Context only counts.
- **Calling `ns.ZoneQuests` per party member**: on index clients each call expands every zone and selects every quest. `Offer` caches it in the check's table.
- **Asking `ns.IsUnitOnQuest` without an index outside `WithEveryZoneOpen` on a client without `C_QuestLog.IsUnitOnQuest`**: a quest under a collapsed Blizzard zone has no index, so the answer is nil and reads as "not on it". `ns.QuestsPartyNeeds` wraps its calls; `MissingCount` (`Zone-Share-Offer.lua`) doesn't, so a visible member without Questie can be over-counted there.
- **Offering zone quests right after a login or reload in a group**: Questie has no party logs then (it requests them only on `GROUP_JOINED`), so every member would read as lacking everything or unknown. `RequestPartyLogsThenScan` asks Questie (`QC_ID_REQUEST_FULL_QUESTLIST`) once it has started and only then notes the party.
- **Re-offering after a reload**: `members` is memory only. Done GUIDs persist in `ns.db.char.zoneShareOffered`; only a login, an ungrouped reload or `GROUP_LEFT` clears them.
- **Whispering a WoW Forever player by first name**: "No player named". `WhisperTarget` uses `GetUnitName(unit, true)` (first name + surname there), falling back to `GetPlayerInfoByGUID`.
- **Counting a secret `IsUnitOnQuest` answer as "doesn't have it"**: would whisper members who have everything. `MissingCount` counts a quest only from a readable "no" or Questie.
- **Keying the Share Reminders result to "the selected quest"**: WoW Forever's menus share by index without selecting. The `QuestLogPushQuest` hook passes its index argument to `ns.SharedQuest`, falling back to the selection only when none is given.
- **Hooking an area font copy, or copying a copy**: a copy changes only through `Sync`, so a hook on it misses Blizzard's changes, and a copy of a copy drifts from Blizzard's. `Fonts.lua` follows Blizzard's object (`Follow`) and unwraps any copy with `ns.FontBase` before copying or remembering.
- **Remembering a region's font after it took an area copy**: restoring would put the copy back, so the cleanup going off would keep the add-on's font. `ns.RememberBlizzardStyle` stores `ns.FontBase` of the font object.
- **Adding `SLUG` to every font**: Slug doesn't draw a thick outline, `MONOCHROME` or a shadow, so those would vanish. `Flags` leaves it off any font with one, which is why the list's shadowed text has no Slug until its shadow is turned off.
- **Treating a saved SharedMedia face as gone**: the add-on that registers it may simply load later. `FontFile` falls back to Blizzard's face without touching the setting, `LibSharedMedia_Registered` re-applies once a name in use turns up, and `ns.FontChoices` keeps the saved name listed.
- **Gating the description fade fix on the cleanup**: the invisible-description bug is Blizzard's fade under a skin, not the add-on's styling. The `QuestFrameDetailPanel` `OnUpdate` hook in `Quest-Giver.lua` runs whatever `giverCleanup` says, and touches only a fade that ended short of the text.
- **Offsetting a gossip icon from its current anchor**: `Setup` runs again on recycled buttons, so the icon would walk down a little each time. `SpaceGossipLine` offsets from Blizzard's anchor kept on first sight (`blizzardIconPoints`).
- **Measuring VoiceOver's title padding once for the session**: the player can change the list font. `VoiceOverPadding` caches per font file and size.
- **Hiding the player arrow's pin instead of its texture**: the pin's own `OnUpdate` is what notices the player back on the map, so a hidden pin never shows again. `PlacePlayer` (`Player-Map-Pin.lua`) hides only `pin.Arrow`.
- **Adding a docked map frame level after `ns.AddPlayerPinLevel`, or after the map first draws**: the player arrow falls under it. Each client's map file adds its levels, then the player's, at build, before the first draw (as `Player-Map-Pin.lua` asks).
- **Redrawing Questie's provider after a map move**: `SetMapID` already redrew every layer, so it draws twice. `RequestRefresh` skips the provider when `ShowZone` set `zoneChanged`.
- **Matching Questie's manual icons by `data.Id`**: townsfolk and Show on Map icons carry an NPC's or object's ID, which can equal an unrelated quest's. `IsShownIcon` drops `isManualIcon`.
- **Reading the player's position on the docked map without `ns.IsReadable`**: WoW Forever can return secret position or facing values, which error when compared. `Player-Map-Pin.lua` checks every value and hides the arrow instead.
- **Planning a quest not taken yet as if it were taken**: it could pin the route to a giver's quest the player never accepts, or anchor another objective to a camp they never visit. Chain nodes carry `predicted`; `IsPinnable` and `LinkOverlaps` refuse them, and ignoring one ignores its `pickUpNode`.
- **Planning more pick-ups than the log can hold**: the route sends the player to a giver who can't give. `AddLocalQuestNodes` caps pick-ups at `FreeQuestSlots`; follow-ups only take their predecessor's slot.
- **Putting every flight master on the route for an existing character**: no API lists known paths away from a flight master. Flight nodes wait per continent for `routesFlightMapSeen[instance]` (a lined-up flight map read), except a new character (`NEW_CHARACTER_LEVEL`, `seen.all`).
- **Trusting the flight map's node positions on every client**: some clients draw the flight map unlike the world map, and matching would mark the wrong flight masters known. `ReadFlightMap` matches only when the `Current` node lands within `MATCH_REACH` of the player.
- **Changing a node key's shape**: warm starts (`Solver.Snapshot`/`WarmRoute`), ignores (`routes.skipped`), pins (`routes.engaged`), worked camps and the signature all match by key across plans. Keep keys stable (`questID:o1`, `:turnIn`, `:pickUp`, `:f1`, `:pt`, `flight:<npcID>`...).
- **Dropping a turn-in planned ahead when Predictive Questing Routes is off**: the open path then ends out in the fields and a ready turn-in in town looks cheapest first. It's planned `hidden` and only dropped from what's drawn (`Shown`, `Routes-Planner.lua`).
- **Asking Questie's database for spawns in `routes.Signature()`**: it runs every `CHECK_INTERVAL`, and party spawn lists are the slow part of joining a group. The signature reads only shared logs (`routes.PartyProgress`); spawns are worked out inside the coroutine.
- **Using a database-only cache across zones**: givers, `IsElsewhere`, `IsChainQuest` and quest plans are plain tables per zone and would pile up over a session. Each wipes itself when the plan's zone changes; per-objective blobs use weak keys instead.
- **Matching Blizzard's map providers by every function on their mixin**: what each inherits from `MapCanvasDataProviderMixin` is shared by every layer, and the player's own layer (`GroupMembersDataProviderMixin`) passed as the quest area layer, so hiding its pin hid the player's arrow on the world map. `IsFromMixin` (`Routes-Map-Blizzard-Quests.lua`) counts only functions that differ from the base mixin, and needs more than half of them.
- **Adding a route layer to the world map's frame level list**: it rewrites Blizzard's levels from add-on code for the session and taints every quest marker (GitHub #23). Route pins compute their own level from `PIN_FRAME_LEVEL_AREA_POI` (`ApplyFrameLevel`, `LEVEL_OFFSETS`); a new template gets an offset there, not a new definition.
- **Hiding the join-up marker when the spot leaves the map**: a hidden pin gets no `OnUpdate`, so it would never come back. `OnMeetUpdate` sets alpha 0 and `EnableMouse(false)` instead, and `AddMeetPin` resets both on every acquire.
- **Leaving `routes.hoveredStop` set when the pins go**: a pin can be removed under a mouse that never leaves, and Questie's icons for that waypoint would stay shown. `RemoveAllData` clears it.
- **Setting only what differs on an acquired pin**: pins are pooled across maps and redraws. `AddStopPin` and `AddMeetPin` set size, look, alpha, level and position every time; `ApplyStopLook` sets texture, tex coords and ring visibility on every call.
- **Saving a party member's ignore**: their quest keys mean nothing after the group changes. Only keys outside `PARTY_KEYS` go to `char.routesIgnored`, and login skips any party key found there; a new party key form must be added to `PARTY_KEYS`.
- **Ignoring a planned objective or turn-in of a quest not taken yet on its own**: the quest isn't in the log yet, so its pick-up would stay on the route. `Ignore` and `routes.IgnoreTask` move to `task.pickUpNode`.
- **Comparing Questie's shared-log names raw**: keys may carry a realm, and on WoW Forever are "First Surname". Compare through `ShortName` (`Ambiguate(name, "short")`) against `routes.UnitFullName`, never `UnitName`'s first return alone.
- **Calling `routes.PartyQuests` for a quick check**: it builds Questie spawn lists and yields. Checks use `routes.PartyProgress`, `routes.PartyNeeds` or `routes.IsHelpNeeded`, which read only the shared logs.
- **Ending a join-up when every member's position turns secret**: in combat on WoW Forever nobody can be placed, and treating that as together would drop the spot mid-run. `Target` keeps the current state and spot when no member is placeable and any answer was secret.
- **Giving Join Up with Group a skip**: nothing could undo a skip, so joining up would be gone with no way back. Right-click does nothing while joining up (`routes.IgnoreArrowObjective`), the meet pin takes no clicks, and the `groupUp` setting is the off switch.
- **Placing a reused minimap marker without clearing its points**: HereBeDragons-Pins positions it, and an old anchor would fight that. `Refresh` calls `ClearAllPoints` before `AddMinimapIconWorld`.
- **Offering Ignore rows straight from a waypoint's tasks**: an ignored task stays at the waypoint until the next plan, which in combat waits for the fight to end, so it would be offered again. `MenuTasks` (`Routes-Arrow-Menu.lua`) filters `routes.skipped`.
- **Binding menu row actions only when the rows are laid out**: layout is skipped while the rows' text is unchanged, but a new plan makes new task tables, so clicks would ignore stale tasks. `Fill` (`Routes-Arrow-Menu-Panel.lua`) rebinds every row's `action` on every refresh.
- **Ending a drag from the menu's Drag row in the row's `OnDragStop`**: the menu hides as the drag starts, taking the row and its handler with it, and the arrow would stay stuck to the mouse. `routes.DragArrowFromMenu` (`Routes-Arrow.lua`) runs `dragWatcher`, which stops the drag when the left button comes up.
- **Adding a line attribute without adding it to the list's layout key**: `ListQuests` skips layout when the key is unchanged, so a change in only that attribute never shows. Add it to the `texts` format in `Add` (`Routes-Arrow-List.lua`).
- **Giving a predicted quest's title its quest ID**: it would get Use Item buttons for a quest not in the log. `ForEachStopLine` passes no quest ID for a `predicted` title; `Survey` also never counts a predicted task as here or on the way.
- **Comparing `frame:GetScale()` with `arrowScale`**: the client hands back a rounded value that may never equal the setting, so the arrow would rescale and re-place every refresh. `Refresh` (`Routes-Arrow.lua`) tracks `appliedScale`.
- **Putting a box, border or always-on panel behind the Quest Arrow**: rejected by the maintainer. The only backing is the edgeless hover shade in `Routes-Arrow-Shade.lua`, fading to nothing past every edge.
- **Recoloring the arrow's action lines**: turn-in, flight path, corpse and Group Up lines stay standard `TITLE` gold by maintainer decision (`ForEachStopLine`, `ListQuests`).
- **Writing click hints as a footer sentence**: maintainer decision is rows, the click on the left and what it does on the right, both `INFO` blue: `routes.AddClickHints` for tooltips, `hint` rows in the menu.
- **Moving `Routes-Stop-Look.lua` after `Routes-Map.lua`** in `Routes.xml`: `Routes-Map.lua` captures `routes.IsUntrackedStop` at load and would get nil. Likewise `Routes-Arrow-Menu-Panel.lua` must precede `Routes-Arrow-Menu.lua` (captures `routes.arrowMenuPanels`).
