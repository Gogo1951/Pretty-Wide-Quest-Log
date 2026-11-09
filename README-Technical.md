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
├── .luacheckrc                             Lint config
├── .pkgmeta                                Externals and ignore list; strips Data/Wrath and Data/Mainline
├── Bindings.xml                            The Use Quest Item key binding; the client loads it, no TOC line
├── Pretty-Wide-Quest-Log_Vanilla.toc       Classic Era, Season of Discovery included
├── Pretty-Wide-Quest-Log_TBC.toc           TBC Anniversary
├── Pretty-Wide-Quest-Log_Camelot.toc       WoW Forever
├── Pretty-Wide-Quest-Log_Mists.toc         Mists of Pandaria Classic
├── Data/
│   ├── Flavor.lua                          The flavor from the TOC: ns.FLAVOR, ns.EXPANSION, ns.IS_DISCOVERY, ns.DATA_FOLDER
│   ├── Data.lua                            Names, links, palette, class colors, panel widths, ns.LAYOUT, marks, chat limit, share and dungeon timings
│   ├── Default-Settings.lua                AceDB defaults, Routes' subtable included
│   ├── {Game}/                             Vanilla, Discovery, TBC, Camelot, Mists; Wrath and Mainline ship to no client
│   ├── {Game}/Map-Reveal-{Game}.lua        The map's unexplored areas, by map art ID
│   ├── {Game}/Quest-Tags-{Game}.lua        Quest tag IDs to the level tag's letter
│   ├── {Game}/Sample-Quests-{Game}.lua     The quests and areas the Example lines name
│   └── {Game}/Wowhead-{Game}.lua           The flavor's Wowhead quest address, a single setting
├── Diagnostics/                            Diagnostic Tools, copied whole; Manifests.lua is this add-on's part
├── Features/
│   ├── Core.lua                            Version, event dispatcher, AceDB, the Wide Quest Log switch, login notices
│   ├── Utilities.lua                       Colors, number grouping, secret values, Questie imports and log, VoiceOver, share interval
│   ├── Announcements.lua                   Player prints, the share print, sent messages, group channel
│   ├── Quest-Log-API.lua                   Quest log calls by quest ID on every client, plus tags and titles
│   ├── Quest-Details-Data.lua              WoW Forever and Mists: the selected quest's details as plain data
│   ├── Quest-Sort.lua                      The sort rules both quest logs share, and the current zone's match
│   ├── Quest-Display.lua                   Level tags and their legend, quest titles, quest ID
│   ├── Quest-Objectives.lua                Objective lines on both quest logs: check, count column, inline icons, inset
│   ├── Quest-Info-Style.lua                Quest text styling: headings, line spacing, Blizzard's style kept to put back
│   ├── Quest-Rewards.lua                   The rewards block's spacing, experience and gold in the description's font
│   ├── Tracking-Mark.lua                   The tracking mark in the list, and whether Questie's tracker has taken over
│   ├── Wowhead-Link.lua                    The quest ID's Wowhead link and its copy popup
│   ├── Quest-Chain-Data.lua                The selected quest's chain from Questie's database, each part's label and color
│   ├── Quest-Chain.lua                     The Quest Chain section of the details
│   ├── Quest-Giver.lua                     Quest giver window cleanup: its own text, page spacing, level tags
│   ├── Quest-Giver-Skins.lua               What skins (ElvUI) change on the quest giver window, put right: backdrop, reward names
│   ├── Gossip.lua                          The gossip window's greeting style and quest line tags, while the cleanup is on
│   ├── Quest-Giver-Pages.lua               The quest giver's greeting and progress pages, and the progress page's quest ID
│   ├── Window.lua                          Window title, art, height clamp, resize grip and list buttons, both quest logs
│   ├── Turn-In-Line.lua                    The Ready to Turn In line and its tooltip, from Questie's quest data
│   ├── Classic-Tracking.lua                Classic Era and TBC: Track All and Untrack All
│   ├── Classic-Quest-Sort.lua              Classic Era and TBC: the sorted order, and Blizzard's rows redrawn to show it
│   ├── Classic-Quest-Rows.lua              Classic Era and TBC: the list's rows, how many show and where each goes
│   ├── Classic-Quest-List.lua              Classic Era and TBC: list update, row style, list buttons, zone name hovers
│   ├── Classic-VoiceOver.lua               Classic Era and TBC: VoiceOver's play buttons on the sorted rows
│   ├── Classic-Quest-Details.lua           Classic Era and TBC: detail pane layout, objectives, rewards, daily reset, quest ID
│   ├── Classic-Quest-Log.lua               Classic Era and TBC: widens Blizzard's window, art, resizing, scale, combat close
│   ├── Classic-Zone-Actions.lua            Classic Era, TBC and Mists: finding and sharing by quest ID, and the whole log
│   ├── Zone-Share.lua                      The Share Quests button on a hovered zone name, every client
│   ├── Share-Reminders.lua                 The whisper when a quest share fails for a reason the party member can fix
│   ├── Dungeon-Quest-Lookup.lua            The dungeon the player is in, and which quests in the log are its
│   ├── Dungeon-Quests.lua                  In a party dungeon, announces its quests and shares them with each member once
│   ├── Quest-Map.xml                       The map's canvas frame, which only XML can build
│   ├── Quest-Map.lua                       The map beside the window: layout, scale, Show Map / Hide Map
│   ├── Questie-Map.xml                     Pin templates for Questie's icons and objective areas on the map
│   ├── Questie-Map.lua                     Questie's icons on the map, the zone dropdown, refreshing
│   ├── Questie-Map-Tooltip.lua             The tooltip on the map's Questie icons
│   ├── Questie-Map-Quest-Giver.lua         The zone a quest was given in, for picking a quest's map
│   ├── Questie-Map-Areas.lua               Each objective's spawns clustered into the shapes of its areas
│   ├── Questie-Map-Area-Layer.lua          The layer the objective areas are shaded on
│   ├── Classic-Quest-Map.lua               Classic Era and TBC: exploration layer, following the selection
│   ├── Quest-Map-Reveal.lua                The map's unexplored areas, drawn so the whole zone shows
│   ├── Classic-ElvUI.lua                   Classic Era and TBC: opaque ElvUI backdrop, ElvUI-styled buttons, map, dropdown
│   ├── Forever-Quest-Log.lua               WoW Forever and Mists: window, buttons, events, side windows, scale, combat close
│   ├── Quest-Log-Key.lua                   WoW Forever and Mists: the quest log key, bound over to the window
│   ├── Forever-Quest-List-Entries.lua      WoW Forever and Mists: the list's entries, built from the log and sorted
│   ├── Forever-Quest-List.lua              WoW Forever and Mists: list rows, list buttons, zone name clicks, right-click menu
│   ├── Forever-Quest-Details-Rewards.lua   WoW Forever and Mists: the details' reward buttons, tooltips, links, item loading
│   ├── Forever-Quest-Details.lua           WoW Forever and Mists: the detail pane, drawn on frames of its own
│   ├── Forever-Quest-Giver.lua             WoW Forever and Mists: the quest giver window's gold, experience and quest ID
│   ├── Forever-VoiceOver.lua               WoW Forever and Mists: VoiceOver's or Spoken Quests' play buttons on the rows
│   ├── Forever-Quest-Map.lua               WoW Forever and Mists: Blizzard's map layers, the quest marker, following the selection
│   ├── Forever-Tracking.lua                WoW Forever: tracking and Track All by quest ID, deferring to Questie's tracker
│   ├── Forever-Quest-Log-Key.lua           WoW Forever: micro menu and tracker clicks taken over from the world map
│   ├── Forever-Zone-Actions.lua            WoW Forever: finding and sharing by quest ID, and the whole log
│   ├── Mists-Tracking.lua                  Mists: tracking and Track All by log index, redrawing WatchFrame
│   ├── Mists-Quest-Log-Key.lua             Mists: micro menu and tracker clicks taken over from Blizzard's quest log
│   ├── Mists-Quest-Portrait.lua            Mists: the quest giver's model under the map, or beside the window
│   └── Routes/
│       ├── Routes.xml                      Lists the Routes files in load order, and the two map pin templates
│       ├── Routes-Core.lua                 Settings, listeners, login setup, migrations, shared helpers
│       ├── Routes-Planner.lua              The planner coroutine, the watcher, when to plan again
│       ├── Routes-Ignore.lua               The ignore list: objectives, turn-ins and party members left off the route
│       ├── Routes-Solver.lua               Orders the route: cheapest insertion, or-opt, 2-opt, seeded shakes
│       ├── Routes-Party.lua                Party members' quests from Questie's shared quest logs
│       ├── Routes-Geography.lua            Position and zone in world yards, a ghost's corpse, which maps lie within a zone
│       ├── Routes-Questie.lua              Questie's log, escorts, timers, instance quests, the signature
│       ├── Routes-Blobs.lua                Spawns into blobs, and each objective's candidate places
│       ├── Routes-Nodes.lua                Objectives and turn-ins into nodes
│       ├── Routes-Pinning.lua              Progress, camps worked and left, and the node pinned first
│       ├── Routes-Overlaps.lua             Two objectives at once: one rides along where its spawns overlap another's
│       ├── Routes-Stops.lua                Ordered nodes merged into waypoints, and each task's text and color
│       ├── Routes-Stop-Lines.lua           A waypoint's quests for the Quest Arrow and the map tooltip
│       ├── Routes-Camps.lua                Every place each objective can be done, in every zone, for every map
│       ├── Routes-Map-Size.lua             The full-size world map
│       ├── Routes-Map-Line.lua             The route's marching line of dots on the world map
│       ├── Routes-Map-Questie-Icons.lua    Questie's icons hidden under the markers, and the textures the markers borrow
│       ├── Routes-Map-Blizzard-Quests.lua  WoW Forever: Blizzard's quest markers and objective areas hidden under the route
│       ├── Routes-Map-Tooltip.lua          A waypoint's or camp's tooltip on the world map
│       ├── Routes-Map.lua                  The route's markers on the world map, the data provider
│       ├── Routes-Arrow-Survey.lua         What the Quest Arrow sees: the areas the player is in, what's next, where to point
│       ├── Routes-Arrow.lua                The Quest Arrow: pointing, its colors, the eye, dragging, hiding
│       ├── Routes-Arrow-List.lua           The quest list under the Quest Arrow
│       ├── Routes-Arrow-Item-Choice.lua    Which items get a Use Item button, and where
│       ├── Routes-Arrow-Items.lua          The Quest Arrow's secure Use Item buttons, their combat holds and the key
│       ├── Routes-Arrow-Menu.lua           The Quest Arrow's hover menu: ignore, group quests, ignore list, click hints
│       └── Routes-TomTom.lua               TomTom's own quest arrow stood down while the Quest Arrow shows
├── Includes/
│   ├── Images/                             Icon, window art (PWQL_*), marks, party icon, Routes art (Route-*)
│   └── Libraries/                          Vendored LibStub, CallbackHandler and Ace3, never edited
├── Locales/                                The enUS.lua source of truth and ten more locales
├── Options/
│   ├── Options-Utilities.lua               Shared rows: feature and Routes switches, status lines, Example lines, reload check
│   ├── Options-General.lua                 Root panel: the welcome toggle and the four feature switches
│   ├── Options-Quest-Log.lua               Wide Quest Log panel: switch, Sorting, Quest Rows, Window & Map, Handy Clicks
│   ├── Options-Quality-of-Life.lua         Quality of Life panel: quest giver window, sharing, dungeon quests, Example lines
│   ├── Options-Routes-Map.lua              Routes on Zone Map panel: zone map, markers, route line, party
│   ├── Options-Quest-Arrow.lua             Quest Arrow panel: size, lock, position, text, item buttons, hiding
│   ├── Options-Profiles.lua                Stock AceDBOptions
│   ├── Options-Feedback-Support.lua        Feedback & Support panel
│   └── Options.lua                         Registration, opener, /pwql
├── LICENSE
├── README.md                               Player-facing overview
├── README-Notes.md                         Recorded exceptions to the Style Guide
├── README-Technical.md                     This document
└── README-Testing.md                       Manual test plan
```

Retired, so don't bring them back: an unsuffixed TOC; the root-level `Legacy.lua`, `Modern.lua`, `Common.lua`, `Layout.lua` and `img/` (their code lives in `Features/`, art in `Includes/Images/`); `Features/Forever-Quest-Map.xml` (every client loads `Features/Quest-Map.xml`); `Features/Zone-Menu.lua` (replaced by `Features/Zone-Share.lua`); `Options/Options-Forever-Quest-Log.lua` (its switch is on the Wide Quest Log panel, its reload prompt in `Options/Options-Utilities.lua`); the `WOWHEAD_QUEST_URLS` table (each flavor's address is its own `Data/{Game}/Wowhead-{Game}.lua`); and `ns.MAP_SIZE_ADDONS` (the full-size map works beside map add-ons; see The Zone Map).

## Architecture

### Two Quest Logs, One Layout

- **Classic Era and TBC** ship Blizzard's classic `QuestLogFrame`; the `Features/Classic-*.lua` files widen it in place: move Blizzard's regions and rows, swap the art, and post-hook `QuestLog_Update`, `QuestLog_SetSelection`, `QuestLogTitleButton_OnClick` (list file, which calls the sort file's order and redraws) and `QuestLog_UpdateQuestDetails`, `QuestFrameItems_Update` (details file). `Classic-Quest-Rows.lua` makes and places the rows (`ns.CreateClassicQuestRows`, called from the list's part); `Classic-Quest-Log.lua` owns the window, art, resizing and scale.
- **WoW Forever** runs the Retail engine, whose quest log is docked in the world map, so there's nothing to widen: the `Forever-*.lua` files build a window of their own.
- **Mists** keeps Blizzard's `QuestLogFrame` but rides the same own window and takes over from Blizzard's (see Taint).
- Each TOC picks its files; no quest log file asks which flavor it's on.
  - Classic Era / TBC: the `Classic-*.lua` set (tracking, sort, rows, list, VoiceOver, details, log, zone actions), `Classic-Quest-Map.lua` after the shared map files, `Classic-ElvUI.lua` after `Routes.xml`. TOC order matters: the log's part reads `ns.GetQuestRowHeight`, which exists only once the list's part has built its rows.
  - WoW Forever: `Forever-Tracking.lua`, `Forever-Quest-Log.lua`, shared `Quest-Log-Key.lua`, `Forever-Quest-Log-Key.lua`, then list entries, list, details rewards, details, quest giver, VoiceOver, zone actions; `Forever-Quest-Map.lua` after the shared map files.
  - Mists: the same window files with `Mists-Tracking.lua` and `Mists-Quest-Log-Key.lua`, `Classic-Zone-Actions.lua` (its quest log calls are Classic's), and `Mists-Quest-Portrait.lua` last.
- **Quest log access by quest ID**: the `ns` accessors in `Features/Quest-Log-API.lua` (`ns.GetQuestLogEntry`, `ns.GetLogIndexForQuestID`, `ns.SelectQuest`, `ns.IsPushableQuest`, `ns.ShareQuest`, `ns.AskToAbandonQuest`, `ns.GetQuestTagByID`, `ns.GetQuestTitleByID`, `ns.IsUnitOnQuest`, …), loaded everywhere. Client's own calls where `C_QuestLog.GetInfo` exists (WoW Forever); elsewhere they walk the log by index, and those that act select, act, then put the selection back (`WithQuestSelected`). Each call is chosen once at load.
- **Details data** (WoW Forever and Mists): `ns.GetSelectedQuestDetails` (`Quest-Details-Data.lua`) returns text, objectives and rewards as plain tables; `Forever-Quest-Details.lua` draws them (see Taint, Quest Text).
- **Feature tests, not flavor tests.** Shared code tests for the API or mixin (`FogOfWarFrameMixin`, `C_QuestLog.GetNextWaypointForMap`, `C_QuestInfoSystem`, …). Shared feature code reads `ns.FLAVOR` only for `"Camelot"`: the sent-message marker (`Announcements.lua`), the dungeon quests' range check, and Routes' party names (`routes.UnitFullName`). Diagnostics reads it for labels and a few client-only rows. Data differences come from the TOC's data folder, never a flavor check.
- **The flavor comes from the TOC's `X-Flavor`** (`Data/Flavor.lua`), never the client: WoW Forever's `WOW_PROJECT_ID` has changed value once already. Season of Discovery shares the Era client, so the Vanilla TOC lists both `Data/Vanilla/` and `Data/Discovery/`, each file returning at once unless `ns.IS_DISCOVERY` matches; `ns.DATA_FOLDER` names the folder that built the tables.
- Shared files call whichever client files loaded through common `ns` names: `ns.SharedQuest`, `ns.ShareableZoneQuests`, `ns.ShareQuests`, `ns.LogQuests`, `ns.questMap.FollowQuest`, `ns.questLogFrame`.
- **One layout**: every client shares `ns.LAYOUT` (`Data/Data.lua`) and `Features/Window.lua` (title, art, resize grip). The details column (`CONTENT_WIDTH`) is exactly `REWARD_COLUMNS_WIDTH`, two reward buttons wide, because reward buttons can't shrink; `TEXT_MARGIN` around it. The window grows by `EXTRA_WIDTH` past the classic art's parchment, and `ns.CreateWindowArt` fills it with a strip cut from the middle piece's last `STRIP_SOURCE` pixels so both seams continue the art. Numbers in the details end two spaces inside the column (`ns.TwoSpacesWide`, `Quest-Objectives.lua`): body text wraps short of the edge, and a flush number looks like it runs past.

### The Wide Quest Log Switch

- `enableWideQuestLog` is read once as the saved settings load; `Features/Core.lua` stores the answer in `ns.wideQuestLogActive` (switch on and a loaded file has a wide quest log, `ns.hasWideQuestLog`).
- **Classic Era and TBC**: hooks on Blizzard's quest log can't be removed, so every Classic quest log file (`Classic-Tracking.lua` through `Classic-ElvUI.lua`) and the shared map files that build on it (`Quest-Map.lua`, `Questie-Map.lua`, `Questie-Map-Tooltip.lua`, `Questie-Map-Quest-Giver.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, `Quest-Map-Reveal.lua`) wraps its body in `ns.AddWideQuestLogPart(function() ... end)`. Core queues them at file load and runs them in TOC order, each through `securecall`, inside `ADDON_LOADED`, only with the switch on. `Classic-Quest-Rows.lua` defines a function the list's part calls, so it only runs then too.
  - Deliberate exceptions that must work with the switch off: `Share-Reminders.lua`'s file-scope `QuestLogPushQuest` post-hook (only notes which quest went out), and `Classic-Zone-Actions.lua`, outside any part because Share Quests, the whispers and the dungeon quests call it; it touches the quest log only when called.
- **WoW Forever and Mists**: the window is the add-on's own and stays closed unless opened, so `Forever-Quest-Log.lua` sets `ns.questLogIsOwnWindow` and `ns.hasWideQuestLog`, files build at file scope (before `ns.db` exists), and `ns.AddWideQuestLogPart` runs parts at once. Only the takeover waits for the switch: `ns.TakeOverQuestLog()` (`Forever-Quest-Log-Key.lua` or `Mists-Quest-Log-Key.lua`). Switch off: the key opens Blizzard's quest log.
- Core drops its queue after the parts run, so a part added after `ADDON_LOADED` throws.
- With the switch off on Classic Era and TBC, everything a part defines is nil (`ns.RefreshQuestLog`, `ns.ResetWindow`, `ns.ApplyWindowScale`, `ns.ApplyMapScale`, `ns.ResetZoneOrder`, `ns.questLogFrame`, `ns.questMap`, `ns.listButtons`, `ns.abandonButton`, `ns.shareButton`). Code outside a part checks `ns.wideQuestLogActive` first (`ns:ApplyProfile`, `Tracking-Mark.lua`); the Wide Quest Log panel's controls use its `Inactive` gate. `ns.hasQuestMap` is set at file scope, so it's true while `ns.questMap` is nil: test `ns.wideQuestLogActive` first.
- **Reload prompt**: a change applies at the next `/reload`. `ns.IsQuestLogReloadPending()` compares the profile's value with `ns.wideQuestLogActive` (a profile switch counts; flipping back goes quiet). A status line shows under the switch on the General and Wide Quest Log panels, and `PRETTYWIDEQUESTLOG_RELOAD` offers the reload a frame after the game's Options window closes. `ns.WatchOptionsForReload` (`Options/Options-Utilities.lua`) hooks that window's `OnHide` the first time a panel shows inside it: the window may not exist at load, and watching it rather than the panels still prompts after the player moves to another category. Panel settings hide with the switch off (`Hidden`) and gray out while a reload is pending (`Inactive`).
- Independent of the switch: quest giver window styling, gossip greeting, Share Quests' quest log calls, the share whispers, dungeon quests, Routes, login notices.

### Event Loop

- `Features/Core.lua` owns the only event frame. Its `EVENTS` table pairs each event with a handler named for it; an event listed more than once runs every row in table order.
  - No third field: handler on `ns`, called `handler(ns, ...)`, without the event name.
  - Third field: the `ns` key of an owner table, called `handler(owner, ...)`. One name holds one function, so each further feature on the same event keeps its handler on its own table.
  - Handlers are looked up at every dispatch; a missing owner or handler is skipped; each runs through `securecall`, so one erroring doesn't stop the event's later rows.
- Owners: `ns.dungeonQuests`, `ns.shareReminders`, `ns.questMap`, `ns.questLogApi`, `ns.questLogWindow`, and Routes' `ns.routes`, `ns.routesMap`, `ns.routesArrow`, `ns.routesItems`. Read `EVENTS` for the rows; notable ones:
  - `ADDON_LOADED` → `ns:OnAddonLoaded`, then `ns.routesMap:OnAddonLoaded` (adds the route when `Blizzard_WorldMap` loads on demand). Its rows run for every add-on, so each checks the name.
  - `PLAYER_REGEN_ENABLED` → the work held during combat (see Combat Lockdown).
  - `BAG_UPDATE_DELAYED`, `BAG_UPDATE_COOLDOWN`, `PLAYER_TARGET_CHANGED` → `ns.routesItems` only (the Quest Arrow's Use Item buttons).
  - `GROUP_JOINED` / `GROUP_LEFT` → dungeon quests, share reminders, then `ns.routes` (clears the ignore list).
  - `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST` → `ns.routes` only.
- Routes takes events only through these rows. Each TOC lists it with the single line `Features/Routes/Routes.xml`; without it the Routes owners are nil and their rows skip.
- **`ADDON_LOADED` for this add-on, in order**: `AceDB:New`; `PruneOtherClientCharacters`; the profile callbacks (all three to `ns:ApplyProfile`); `ns.RegisterOptionsPanels`; registration pass 1; `StartWideQuestLog` (sets `ns.wideQuestLogActive`, runs the parts); registration pass 2; `ns.ApplyQuestGiverCleanup`; `ns:OnDatabaseReady` (one slot, defined only by `Forever-Quest-Log.lua`, which calls `ns.TakeOverQuestLog()` when the wide quest log runs). Each step through `securecall`; panels and events come first so a feature erroring in setup takes only itself down.
- **Two registration passes**: each registers, once, every event with at least one row whose owner and handler exist by then; pass 2 picks up handlers defined inside Classic parts (which exist only with the switch on). `ADDON_LOADED` is registered at file load and skipped by the passes. An event with no live row after pass 2 is never registered. What was registered is exported as `ns.EVENT_NAMES` for Diagnostics.
  - Classic Era / TBC: the quest log works through hooks; its handlers (`ns:OnZoneChangedNewArea`, `ns:OnPlayerRegenDisabled`) live in `Classic-Quest-Log.lua`'s part, so `PLAYER_REGEN_DISABLED` registers only with the switch on.
  - WoW Forever / Mists: every handler is at file scope (`Forever-Quest-Log.lua`, `Quest-Log-Key.lua`, `Forever-Quest-Map.lua`, `Quest-Log-API.lua`), so all register whatever the switch says; with it off the key's `UPDATE_BINDINGS` and `PLAYER_REGEN_ENABLED` handlers do nothing (`ns.questLogTakenOver` unset).
- While the Event Log records (`ns.diagnostics.logging`), the dispatcher passes each event to `ns:LogEvent` first; otherwise one boolean check.
- **Events request, they don't redraw**:
  - Own window: every quest event funnels into `ns.RequestUpdate()`, at most one repaint a frame and only while open, because `QUEST_LOG_UPDATE` bursts. `PLAYER_LEVEL_UP` because difficulty colors change; `UNIT_QUEST_LOG_CHANGED` for `"player"` and readable `party` units (party counts); `GROUP_ROSTER_UPDATE` for counts and the Share button; `PLAYER_REGEN_DISABLED` / `_ENABLED` to gray and restore tracking controls; `ZONE_CHANGED_NEW_AREA` redraws without re-sorting zones (see Sorting). Questie's tracker `Update` post-hook (installed in `ns:OnDatabaseReady`, whatever the switch) and reward items finishing loading request the same.
  - Classic quest log: redraws through Blizzard's `QuestLog_Update`, which its hooks follow.
  - Docked map: `questMap.RequestRefresh` waits `REFRESH_DELAY`, because Questie draws in batches over several frames, and only while the canvas shows.
  - Routes: debounced by the planner (see Planning and When to Plan Again).
  - Dungeon quests: a ticker every `ns.DUNGEON_CHECK_INTERVAL` while in a party dungeon.
- `PLAYER_LOGIN` prints the welcome, the predecessor warning (see Moving from Wide Quest Log Plus) and, `ns.QUESTIE_NOTICE_DELAY` later so it isn't lost among login lines, `CHAT_QUESTIE_MISSING_FEATURES` without Questie. The last two ignore the welcome toggle: they explain, not greet. Routes' handler then migrates its settings, starts the watcher and runs `routes.OnLogin` work.

### Blizzard's Side Windows (WoW Forever and Mists)

- Blizzard's left-side panels (quest giver, gossip, vendor, trainer, character) and the own window make way for each other, as Blizzard's windows do: a `ShowUIPanel` hook (`Forever-Quest-Log.lua`) hides the window when a `left` or `doublewide` panel opens, and opening the window hides those (`CloseLeftPanels`), out of combat only. Bags are left alone.
- Exempt: Blizzard's own quest log on Mists while the window is taking over from it out of combat (`ns.IsTakenOverPanel`, always false on WoW Forever), or opening it would close the window it's meant to open.
- `ns.WasClosedForPanel` remembers the panel the window last closed for until the next frame; that's how WoW Forever's `ToggleQuestLog` hook tells a close from an open.

### Combat Lockdown

**Refuses, never queued** (the player acts again after):

- The options opener (`ns:OpenOptionsPanel`, `Options/Options.lua`) — the standard combat guard.
- Track / Untrack on WoW Forever and Mists (`ns.ToggleTracking`): `ERR_NOT_IN_COMBAT`, because a watch change from add-on code in combat taints the objective tracker. Every Track control is disabled in combat to match (`ns.QuestActions` reads `InCombatLockdown`).
- `CloseLeftPanels`: opening the window leaves Blizzard's side windows open, since hiding them goes through the panel manager.
- The takeover: in combat the micro menu and tracker clicks leave Blizzard's window open; the quest log key, bound to the add-on's own button, opens the window either way. On Mists `ns.IsTakenOverPanel` is false in combat, so Blizzard's quest log opening then closes the window like any left panel.
- Routes never writes the `miniWorldMap` CVar in combat; the next `KeepFullSize` out of combat does.

**Deferred to `PLAYER_REGEN_ENABLED`**, rows in `EVENTS` order:

1. Quest log key's override binding (`Quest-Log-Key.lua`): bindings can't change in combat; `ns.RouteQuestLogKey` sets `routePending`.
2. Docked map's Blizzard layers (`Forever-Quest-Map.lua`): the canvas calls `SetPassThroughButtons` on every pin it acquires, blocked for add-on code in combat, so each copied provider's `RefreshAllData` is wrapped to mark it in `heldProviders` and return. The add-on's own pin mixins (`PrettyWideQuestLogPinMixin`, `PrettyWideQuestLogRoutePinMixin`) make `SetPassThroughButtons` a no-op, as HereBeDragons-Pins does, so they draw in combat.
3. A single share on WoW Forever (`Quest-Log-API.lua`): WoW Forever blocks `QuestLogPushQuest` for add-on code in combat even on a click. One `pendingShare` slot, replaced by a later request; `CHAT_SHARING_AFTER_COMBAT`; sent after if still in log, shareable and grouped. Mists and Classic share at once.
4. The window's tracking controls (`ns.questLogWindow`) repaint enabled.
5. The Quest Arrow's Use Item buttons (`ns.routesItems`, every client): secure buttons, so item, place and showing lock in combat; stale ones fade and catch up here.

**Waits by polling**:

- Share Quests and the dungeon quests' runs (`ns.ShareQuests`, both zone actions files): a share due in combat retries each share interval; leaving the group ends the run.
- Routes: the planner watches `InCombatLockdown()`; a fight drops any plan underway, `routes.RequestPlan` in combat only flags `planAfterCombat`, and the first frame out checks at once (see Combat under Routes).

**Close When Combat Starts** (`closeInCombat`) hides the window on `PLAYER_REGEN_DISABLED` with a plain `Hide` (unprotected frame). The Classic counterpart, `HideUIPanel(QuestLogFrame)` in `Classic-Quest-Log.lua`'s part, is allowed in combat for that unprotected frame; it registers on pass 2. Both quest logs work in combat.

### Taint

**Classic Era and TBC** only hook, but Blizzard sees these as add-on writes; none reaches anything protected there:

- New size to the panel manager via `SetUIPanelAttribute` (`width` once; `height`, `bottomClampOverride` on change), the provided interface, not by replacing the `UIPanelWindows` entry. No attributes on a client without it.
- Extra `QuestLogTitle{N}` rows created for a taller window (`ShowRowCount`, `Classic-Quest-Rows.lua`) and `QUESTS_DISPLAYED` written: row spacing moves Blizzard's rows, so fewer show than the window holds (`RowsThatFit`) and Blizzard's own scroll range reaches the last entry. A change in the shown count reruns `QuestLog_Update` from the list's hook.
- Blizzard's All and Track toggles faded and unclickable; Expand All runs `QuestLogCollapseAllButton_OnClick`; Track All / Untrack All do a shift-click's work (`AutoQuestWatch_Insert`; `RemoveQuestWatch` after removing from `QUEST_WATCH_LIST`), then `QuestWatch_Update` and `QuestLog_Update`.
- The sorted order is drawn on Blizzard's rows (`SetID`, text, textures rewritten); Blizzard's handlers read that ID (see Sorting).
- Share Quests and the dungeon quests select, expand, collapse and call `QuestLogPushQuest`, as Blizzard's Share button does (`Classic-Zone-Actions.lua`).

**WoW Forever** — no Blizzard function is replaced:

- Only with the wide quest log active does `ns:OnDatabaseReady` call `ns.TakeOverQuestLog()` (`Forever-Quest-Log-Key.lua`), setting `ns.questLogTakenOver`:
  - `TOGGLEQUESTLOG` is bound with `SetOverrideBindingClick`, owned by the window, to the hidden `PrettyWideQuestLogToggleButton` (`ns.RouteQuestLogKey`, shared with Mists), so the key never opens Blizzard's log; re-set on `UPDATE_BINDINGS`, deferred out of combat.
  - `ToggleQuestLog` (micro menu) and `QuestMapFrame_OpenToQuestDetails` (tracker, Questie) are post-hooked: Blizzard's runs first and opens the map; out of combat the hook closes it with `HideUIPanel` in the same frame and opens the window (or that quest). A quest not in the log stays on Blizzard's map.
- Details never call `QuestInfo_Display` or borrow `QuestInfo` frames: own font strings and own reward buttons (`LargeItemButtonTemplate`, no scripts; `Forever-Quest-Details-Rewards.lua`), tooltips and links via the quest log calls after selecting. So the quest giver window, popup and map details keep `QuestInfo`, and the window draws in combat. `QuestInfo_Display` is post-hooked only for the quest giver window (see Quest Giver Window).
- Installed at file scope, whatever the switch: the `ShowUIPanel` hook, the `UISpecialFrames` entry (Blizzard reads it through `securecall`), the hidden toggle button, the quest giver's `QuestInfo_Display` hooks. The Questie tracker `Update` hook is installed in `ns:OnDatabaseReady` whatever the switch.
- Each details repaint selects the quest only when Blizzard's selection differs (`ns.SelectQuest`).
- Abandon, Share and the right-click menu call Blizzard's `QuestMapQuestOptions_AbandonQuest` / `_ShareQuest` (`ns.AskToAbandonQuest`, `ns.ShareQuest`). Zone expand/collapse via `ExpandQuestHeader` / `CollapseQuestHeader` (`ns.SetQuestZoneCollapsed`; first open expands all, `ns.ExpandAllZones`).
- Tracking: `C_QuestLog.AddQuestWatch` / `RemoveQuestWatch`, never in combat.
- Routes hides and re-shows Blizzard's quest marker and objective area pins on the world map and post-hooks those providers' `RefreshAllData` (`Routes-Map-Blizzard-Quests.lua`); it never writes to them or to the `questPOI` CVar.
- Share Quests and the dungeon quests select each quest and call `QuestLogPushQuest`, then reselect (`Forever-Zone-Actions.lua`).
- **Objective tracker taint**: if one of these calls fires an event the tracker listens to (`QUEST_WATCH_LIST_CHANGED`, `QUEST_LOG_UPDATE`) while it runs, the tracker marks itself dirty from add-on code and its next update runs tainted, writing its own state tainted, so taint carries until a reload; in a scenario the update reads secret auras and errors (from its own update or Edit Mode's `OnAnyEditModeSystemAnchorChanged`). Every such call goes through `ns.TrackerTaintStep` (`Diagnostics/Tracker-Taint.lua`), which the Tracker Taint Watch (Run Tests) uses to check the tracker's frames, modules and `EditModeManagerFrame` with `issecurevariable` around each step. With the watch off a step costs one check.

**Mists** — the same file-scope pieces, key override and self-drawn details; otherwise:

- No function replaced. `ns.TakeOverQuestLog()` (`Mists-Quest-Log-Key.lua`) post-hooks `ShowUIPanel`, since everything (micro menu, Questie, the tracker's `QuestLog_OpenToQuest` into `QuestLogDetailFrame`) opens `QuestLogFrame` through the panel manager. Out of combat `HideUIPanel` closes Blizzard's in the same frame and the window shows the quest; a second tracker click on the showing quest closes it. A `ToggleQuestLog` post-hook uses `openBeforeToggle` (kept a frame) to close an already-open window.
- Reading the log selects quests: `SelectQuestLogEntry` on every repaint (`ns.SelectQuest` always selects here), reward tooltips, and `ns.IsPushableQuest` / `ns.ShareQuest` / `ns.AskToAbandonQuest` around `GetQuestLogPushable`, `QuestLogPushQuest`, `SetAbandonQuest` (then Blizzard's own abandon popup), restoring the selection.
- Blizzard's zones stay expanded: a collapsed zone lists none of its quests, so `ns.ShowEveryQuestLogEntry` calls `ExpandQuestHeader(0)`; collapsing in the window only changes the session's `collapsedZones` (`Quest-Log-API.lua`).
- Share Quests and dungeon quests go through `Classic-Zone-Actions.lua`.
- Tracking by index, then `WatchFrame_Update`, since `WatchFrame` hears no event a watch change fires; refuses in combat, as on WoW Forever.

### Questie Tracking

#### WoW Forever (`Forever-Tracking.lua`)

- Why Questie leads: its tracker learns of a quest only through `C_QuestLog.AddQuestWatch` (the client's auto-watch on accept bypasses it), and shows only quests in its database, which lacks many WoW Forever quests.
- `TrackerFor(questID)`: Questie is in charge while `Questie.db.profile.trackerEnabled`, `QuestieTracker` has `IsTrackedByQuestie`, and `ns.QuestieLogEntries()` (`Utilities.lua`) returns a log. Returns the tracker, `false` (in charge, but Questie can't show the quest: untrackable), or nil (Blizzard's watch decides). Questie can show it when `QuestieKnows`: on Questie 12.6.3+ (acceptances) the entry carries `.quest`, since a quest its database lacks still has an entry; before that, any entry counts.
- Questie's log is read at most once a frame (`QuestieLog`, keyed by `GetTime()`): a repaint asks about every quest.
- Tracked = `IsTrackedByQuestie`; if it throws, `QuestUtils_IsQuestWatched`.
- Track always calls `AddQuestWatch`, even when Blizzard already watches: that call is what tells Questie. Blizzard's cap still holds under Questie (`ns.HasRoomToTrack`, against `Constants.QuestWatchConsts.MAX_QUEST_WATCHES`; refused with `OBJECTIVES_WATCH_TOO_MANY`).
- Untrack: Questie's `UntrackQuestId` when Blizzard has no watch; else (or if that's missing or throws) `C_QuestLog.RemoveQuestWatch`, only while `ns.CanRemoveQuestWatch()` (`QuestUtil.CanRemoveQuestWatch`). Both watch calls go through `ns.TrackerTaintStep`.
- Combat: a watch change from add-on code in combat taints the objective tracker, so `ns.ToggleTracking` / `ns.SetAllTracked` refuse with `ERR_NOT_IN_COMBAT` (Mists too). `ns.QuestActions(questID)` (`Forever-Quest-Log.lua`) is the single enable rule for the bottom Track / Share / Abandon buttons and the right-click menu; `PLAYER_REGEN_ENABLED` repaints.
- An untrackable quest is refused four ways: one chat line per quest per session (`QUESTIE_CANNOT_SHOW`, `warnedUntrackable`), `QUESTIE_CANNOT_TRACK` on every refused click, a tooltip on the grayed Track button (`trackButton.untrackable`), a grayed menu item.
- Untracking from Questie's own menu may not touch Blizzard's watch list, so `ns:OnDatabaseReady` post-hooks `QuestieTracker.Update` to `ns.RequestUpdate` (WoW Forever and Mists, whatever the switch says).

#### Classic Era and TBC (`Classic-Tracking.lua`)

- Questie removes Blizzard's watch as it takes a quest (dodging Blizzard's limit), so Blizzard's watch count means nothing under Questie. Untrack All goes by `IsQuestWatched` per listed quest (Questie replaces it): remove the quest from `QUEST_WATCH_LIST` (Blizzard's watch timers forget it, as on a shift-click), then `RemoveQuestWatch` (Questie hooks it).
- Once Questie's tracker has started (`ns.IsQuestieTracking`, `Tracking-Mark.lua`): every quest trackable, no limit. Before: quests with objectives (`GetNumQuestLeaderBoards`), up to `MAX_WATCHABLE_QUESTS`.
- No combat refusal: it does what Blizzard's shift-click does.

#### Mists (`Mists-Tracking.lua`)

- Watch calls take a log index (`ns.GetLogIndexForQuestID`). Once Questie's tracker takes over it hooks `AddQuestWatch` / `RemoveQuestWatch` and replaces `IsQuestWatched`, so the same calls reach whichever tracker leads.
- `ns.CanTrack` and `ns.CanRemoveQuestWatch` are always true: no untrackable quests, and one with no objectives tracks even before Questie starts.
- `ns.HasRoomToTrack`: already tracked, Questie tracking, or under `MAX_WATCHABLE_QUESTS`; else `QUEST_WATCH_TOO_MANY`. Combat refused as on WoW Forever.
- Every change ends in `Redraw`: `WatchFrame_Update` (`WatchFrame` hears no event from a watch change), then `ns.RequestUpdate`.
- `ns.IsTracked` / `ns.HasRoomToTrack` take an optional `questLogIndex`, because a by-ID lookup walks the whole log; WoW Forever's ignore it. Pass it where known.

#### Before Questie's Tracker Starts (Every Client)

- Questie starts its tracker seconds after login, mid staged startup. Until then nothing reads as tracked (Questie's list empty on WoW Forever; `IsQuestWatched` still Blizzard's elsewhere), so with `markUntracked` the untracked mark (`ns.TRACKING_MARKS`) would flash on every row.
- `ns.ShowTrackingMark` (`Tracking-Mark.lua`) draws no marks while the tracker is enabled but not `started`, and the first time it sees that, hooks `QuestieTracker:HookBaseTracker` to `ns.RefreshQuestLog` (clearing the frozen zone order too), only while `ns.wideQuestLogActive`.
- Only the marks wait: WoW Forever's Track controls read Questie's log started or not; Mists' follow Blizzard's cap until it starts.

### Sorting

#### Sort Rules (`Quest-Sort.lua`)

- Records carry `sortLevel`, `sortKey` (`ns.NameSortKey`: lowercased full title, so The Hinterlands sorts under T, as Blizzard does) and `sortIndex` (log index); zones add `title` and `averageLevel`.
- Profile keys (Wide Quest Log panel, Sorting): `zoneSort`, `questSort` (`LEVEL_HIGHEST_FIRST`, `LEVEL_LOWEST_FIRST`, `ALPHABETICAL`), `currentZoneFirst`, `completedFirst`.
- Zones (`CompareZones`): current zone first if `currentZoneFirst`; then average level (`ns.AverageLevel`; unknown after the rest) or name; ties to name, then log order.
- Quests (`ns.SortQuests`): ready to turn in first if `completedFirst`; then `questSort`; ties keep log order. Quests outside any zone list before every zone.
- A quest's level is the one its tag shows: `difficultyLevel` else `level` on the window (Mists has only `level`), `GetQuestLogTitle`'s level on Classic Era and TBC.
- The add-on does all sorting itself, so each option holds the same on every client.

#### Current Zone

- `ns.IsCurrentZone` matches header text to `GetRealZoneText()` or, in a dungeon, any name in `ns.CurrentDungeonNames()` (`Dungeon-Quest-Lookup.lua`): headers are area names, and an instance's zone text can be spelled differently. Class and profession headers never match.
- `ns.CurrentDungeonNames` caches by instance ID, zone text and whether Questie's `ZoneDB` exists, because every repaint asks about every header.
- `ns.ZoneHeaderText` appends `ns.CURRENT_ZONE_MARK`. Quest Log Context also calls `ns.IsCurrentZone`; the dungeon quests don't (they match `dungeon.names`).

#### Frozen Zone Order

- `ns.SortZones` freezes ranks by zone title on the first sort after the window opens, so a turn-in or drop doesn't reshuffle zones under the cursor. An unranked zone (new pickup) goes last.
- The freeze covers `currentZoneFirst`: `ZONE_CHANGED_NEW_AREA` moves the mark at once; the zone moves up only at the next open.
- `ns.ResetZoneOrder` (per client: `Forever-Quest-List-Entries.lua`, or `Classic-Quest-List.lua` calling `ns.ResetClassicZoneOrder`) runs on window close, and through `ns.RefreshQuestLog` on a Wide Quest Log sort or list setting change, a profile change (`ns:ApplyProfile`) and Questie's tracker starting.

#### WoW Forever and Mists

- `ns.BuildQuestListEntries` (`Forever-Quest-List-Entries.lua`) builds; `ns.UpdateQuestList` (`Forever-Quest-List.lua`) draws in its own `WowScrollBoxList`.
- Visibility matches the map's quest list: no hidden quests, no task quests (world quests, bonus objectives), bounties only once complete, no zone with nothing left to show.
- Also returns every quest that would show with its zone open (Track All, turn-in line, empty-log check) and whether every zone is collapsed (Expand All).
- `ns.ExpandAllZones` on the session's first open: a collapse lasts until the next login or reload.
- Mists' entries come through `ns.GetQuestLogEntry` with `isComplete` / `isFailed` on them; `EntryIsComplete` / `EntryIsFailed` read those first, because by-ID there walks the log.

#### Classic Era and TBC Rows

- The rows stay Blizzard's (other add-ons hook them). `QuestLog_Update` fills row *i* with entry *i* + offset, and every row handler (click, shift-click, collapse, party tooltip, Share Quests hover) finds its entry from row ID + offset. So `Classic-Quest-Sort.lua`'s `RedrawRow` redraws each row as `QuestLog_Update` would for the entry at its sorted place and sets its ID to match.
- `UpdateList` (`Classic-Quest-List.lua`, post-hook on `QuestLog_Update`), in order: sort (`ns.BuildClassicDisplayOrder`); row count (`rows.RowsThatFit` / `rows.ShowRowCount`; a change reruns `QuestLog_Update` and returns); redraw; positions; VoiceOver buttons; row style (after VoiceOver, whose button functions rewrite titles and move the check); list buttons; turn-in line; map empty-log check.
- VoiceOver's own `QuestOverlayUI.Update` can run after that hook, so `Classic-VoiceOver.lua` post-hooks it to `ns.RestyleClassicQuestRows` (buttons and styling with the last order; nothing before the first update).
- The selection highlight goes by place, so it's moved again after `QuestLog_SetSelection` (`ns.PlaceClassicSelectionHighlight`).
- A collapsed zone lists no quests, so it sorts by its average when last seen open (`knownZoneLevels`, session), else last.
- When the sorted order equals the log's own (zones alphabetical, quests lowest level first), `BuildDisplayOrder` returns nil: no redraw, row IDs reset.
- A shift-click link would insert the row's text, which leads with the level tag, so a `QuestLogTitleButton_OnClick` post-hook swaps in `row.plainTitle`, except with Questie loaded (it inserts its own link).

#### Row Spacing

- Every client: `LAYOUT.QUEST_ROW_HEIGHT` and `LAYOUT.HEADER_ROW_HEIGHT` (room for the Share Quests button), each with `ROW_PADDING` above and below; with `zoneGap`, `LAYOUT.HEADER_GAP` above every zone header but the first. Details start level with the first quest row (`LAYOUT.CONTENT_TOP`).
- WoW Forever and Mists: the scroll box's extent calculator sizes rows; the gap is a spacer entry (`isSpacer`). Rows recycle among headers, quests and spacers, so `InitRow` resets everything.
- Classic Era and TBC: `Classic-Quest-Rows.lua`, whose `ns.CreateClassicQuestRows` the list's part calls (Blizzard's rows can only be measured then). Rows keep Blizzard's height; `RowTops` centers each in its padded slot below any gap. The quest slot (`ns.GetQuestRowHeight`) is the step the window's height snaps to.
  - Two counts: capacity from the window's height (`ns.SetQuestRowCount`, from `Classic-Quest-Log.lua`), and rows shown, `QUESTS_DISPLAYED`, which `RowsThatFit` lowers until the last entry fits, padding and gaps included, when scrolled to the end.
  - Why: Blizzard's scroll range (entries less `QUESTS_DISPLAYED`) must reach the last entry, and `QuestLog_Update` resets it every update, so a wider range set by the add-on is lost and the list jumps back up. Cost: higher up the list, with fewer gaps in view, room is left at the bottom.
  - `PositionRows` moves Blizzard's rows and hides any pushed past the bottom (and the highlight on one). `QuestLog_Update` fills only up to `QUESTS_DISPLAYED`, so rows beyond it must be hidden here. Rows created here get the list's hover hooks (`hookRow`).

#### Party on a Quest

- WoW Forever and Mists rows: party count (`Party-On-Quest.tga` + number, palette `INFO`) left of the tag or at the right edge; the title shortens to clear it. Hover lists names under `PARTY_QUEST_STATUS_ON`, or shows `PARTY_QUEST_STATUS_NONE`; a client without the string shows nothing.
- `IsPartyMemberOnQuest`: `ns.IsUnitOnQuest`, which the game answers only in range; where it says no or is secret, `ns.routes.QuestieHasUnitOnQuest` (`Routes-Party.lua`: Questie's shared logs, any distance, regardless of `partyQuests`; skipped without Routes). A "no" is unknown if secret or the member isn't `UnitIsVisible` (a range stand-in); any unknown suppresses the "none" line, which would be a guess.
- `party`N up to `GetNumSubgroupMembers()` only, so a raid gives the player's subgroup. A secret name or class (`ns.IsReadable`) only drops the name; the member still counts.
- Repaints on `GROUP_ROSTER_UPDATE`, `UNIT_QUEST_LOG_CHANGED` for a readable `party` unit, and the player's own updates. A change only in Questie's shared logs waits for the next repaint.
- Quest Log Context reports the game's answers and how many were secret.
- Classic Era and TBC: Blizzard's `[`N`]` before the title, recomputed by `RedrawRow`.

### Expand All, Track All and Show Map

- Bar above the list, `LAYOUT.LIST_BUTTONS_GAP` apart: `ns.CreateListButtons` (`Window.lua`) makes Expand All and Track All; `Quest-Map.lua` hangs Show Map after the last of `ns.listButtons`.
- Sized on first show (font loaded): widest label in this locale plus `LAYOUT.LABEL_PADDING`, at least `LAYOUT.BUTTON_WIDTH`; Expand All and Track All share one width. No button resizes as its label switches.
- Collapse All while any zone is open; Expand All once all are collapsed.
- Track All while a listed quest can still be tracked and there's room; else Untrack All, grayed when nothing is tracked. Tracks top-down in list order, so a nearly full watch list fills with what the player sees first; stops when full with Blizzard's string on `UIErrorsFrame` (`QUEST_WATCH_TOO_MANY`; WoW Forever `OBJECTIVES_WATCH_TOO_MANY`). Never full under Questie except on WoW Forever.
- **Classic Era and TBC** (`Classic-Tracking.lua`): a shift-click per quest (`AutoQuestWatch_Insert` with `QUEST_WATCH_NO_EXPIRE`, then `QuestWatch_Update`, `QuestLog_Update`), over listed entries only, so collapsed zones are passed by.
  - Buttons live in `QuestLogExpandButtonFrame`, which Blizzard hides while the log is empty.
  - Blizzard's "All" toggle and `QuestLogTrack` (which would peek between the buttons) are faded and unclickable, not removed.
  - Expand All runs `QuestLogCollapseAllButton_OnClick` and labels itself from the toggle's `collapsed`, keeping Blizzard's record right.
- **WoW Forever** (`ns.SetAllTracked`): every listed quest, collapsed zones included, silently skipping ones Questie can't show. Grayed in combat; Untrack All also needs `ns.CanRemoveQuestWatch()`.
- **Mists** (`ns.SetAllTracked`): same coverage, skips none, redraws `WatchFrame`. Grayed in combat only.
- WoW Forever and Mists: Expand All is disabled with no quests and calls `ns.SetQuestZoneCollapsed` per header (on Mists only `collapsedZones` changes, see Taint).
- **Show Map** hides with the map while the log is empty (`questMap.SetLogEmpty`, from both list files) and returns with the first quest; `mapHidden` untouched. Empty: no quest the list would show (window), no log entries (Classic Era and TBC).

### Share Quests

- One button (`Zone-Share.lua`, every client, `ns.zoneShareButton`), reparented onto the hovered zone row so it hides with it. Zone rows fit it because `LAYOUT.HEADER_ROW_HEIGHT` derives from `LAYOUT.ZONE_SHARE_BUTTON_HEIGHT`; width is label plus `LAYOUT.ZONE_SHARE_BUTTON_PADDING`.
- Hides when the mouse leaves both row and button (`ns.HideZoneShareButton`, its `OnLeave`). Each list calls `ns.UpdateZoneShareButton` per redrawn row, so a row recycled for a quest drops it.
- Classic Era and TBC: `OnEnter` / `OnLeave` hooked on Blizzard's rows (and those `Classic-Quest-Rows.lua` adds), zone from row ID + offset; `StyleQuestRows` updates it each pass. Zone rows keep Blizzard's clicks (right-click collapses too). ElvUI skins it with the list buttons (`Classic-ElvUI.lua`).
- WoW Forever and Mists: `Row_OnEnter` / `Row_OnLeave`, `InitRow`; `Row_OnClick` toggles a zone on either button.
- Grayed (re-checked every frame in `OnUpdate`) while solo (tooltip `ERR_NOT_IN_GROUP`, else `SHARE_ZONE_QUESTS_TOOLTIP` with the interval) or while any run is going (`ns.sharingQuests`, dungeon sharing included).
- Click: `ns.ShareableZoneQuests(zoneTitle)`, print `ns.BuildSharePrint` (`Announcements.lua`: `CHAT_SHARING_ZONE_NONE` / `_ONE` / `CHAT_SHARING_ZONE`), gray itself, `ns.ShareQuests`. Shareability is worked out only on click, because on Classic Era, TBC and Mists it means selecting each quest.
- No wide quest log, no button; the Quality of Life panel says so (`ZONE_SHARE_NEEDS_WIDE_LOG`). Dungeon sharing works either way.

#### The Run (`ns.ShareQuests`)

- One quest per `ns.GetShareInterval()`, a `C_Timer.After` chain on the interval as of run start; `ns.sharingQuests` blocks a second run until the last share.
- Each share re-finds the quest, re-checks shareability, and runs in `securecall`, so an error is reported and the run continues.
- Leaving the group ends it. A share due in combat re-checks every interval, then the run resumes (WoW Forever blocks `QuestLogPushQuest` for add-on code in combat; both files wait alike). WoW Forever's single Share Quest button waits for `PLAYER_REGEN_ENABLED` instead (see Combat Lockdown).
- Interval: Quality of Life's `shareInterval` slider, bounded by `ns.SHARE_INTERVAL_MIN` / `ns.SHARE_INTERVAL_MAX`; any sooner than the minimum and the game reports the member busy. Quality of Life off: the default. Only the slider enforces the range; `ns.GetShareInterval` (`Utilities.lua`) returns the saved value as is.

#### The Zone-Actions Files

- Four `ns` names: `ns.ShareableZoneQuests` (shareable IDs, and the zone's quest count), `ns.ShareQuests`, `ns.LogQuests` (every quest with zone, state, `pushable`), `ns.SharedQuest` (Share Reminders). Outside any part: Share Quests' calls, the whispers and the dungeon quests need them with the switch off.
- `Classic-Zone-Actions.lua` (Classic Era, TBC, Mists) contains the index-based awkwardness:
  - Only the selected quest can be shared or asked `GetQuestLogPushable`, so each is selected in turn; the player's selection is restored by index after zones re-close (entries are back in place), so a selected header or no selection returns too. On Mists that's Blizzard's selection, which can differ from the window's quest.
  - Collapsed zones list no quests. `ns.ShareableZoneQuests` opens just its zone; `ns.LogQuests` and each share (`WithEveryZoneOpen`) call `ExpandQuestHeader(0)`, then re-collapse from the bottom up so higher indexes hold. Per share, so a zone collapsed mid-run is still searched; `QuestLog_Update` after each while Blizzard's log is open.
  - So no diagnostic report calls them on these clients: reports use `ns.DiagnosticLogQuests` (`Manifests.lua`; open zones only, shareability for the selected quest only), and Sharing Context's Share Quests line only counts.
- `Forever-Zone-Actions.lua`: collapsed zones still list their quests, so zones are left alone; `C_QuestLog.IsPushableQuest` by ID. Skips hidden and task quests like the list, but counts incomplete bounties the list hides. Each share: `ns.SelectQuest`, `QuestLogPushQuest` (through `ns.TrackerTaintStep`), reselect the window's quest.

#### Related

- Both logs' Share Quest buttons explain a solo gray-out (`ns.ExplainShareButton`, `Utilities.lua`; hooked because Classic's is Blizzard's).
- The Handy Clicks right-click row shows only with `ns.questLogIsOwnWindow`: on Classic Era and TBC a right-click on a quest stays Blizzard's.
- The window's right-click menu lists Abandon only when `ns.CanAbandonQuest`; enables all three from `ns.QuestActions`.

### Share Reminders

`Features/Share-Reminders.lua`: a share that fails for a reason the member can fix earns them a whisper naming the quest; unfixable results (not eligible, already on it, done) earn none.

- **Which results.** `FIXABLE_RESULTS` names client globals (`ERR_QUEST_PUSH_BUSY_S`, `ERR_QUEST_PUSH_TOO_FAR_S`, `ERR_QUEST_PUSH_LOG_FULL_S`) read via `_G`; a missing one is skipped. `NamePattern` turns each into an anchored pattern at load (`%s` or `%1$s` captures the name), so `CHAT_MSG_SYSTEM` matches in any locale. One whisper for all; it doesn't say why, since the game already did.
- **Which quest.** Results don't name it. A file-scope `hooksecurefunc("QuestLogPushQuest")` (every share path calls it; installed with the switch off too) notes it via `ns.SharedQuest`: the index passed (WoW Forever's menus pass one without selecting), else the selected quest; a header notes nothing. A result counts within `ns.GetShareInterval()` of that share, once per player per share (`whispered`).
- **Which whisper.** First `WHISPER_SHARE_FAILED`, then `WHISPER_SHARE_FAILED_AGAIN` (quest only). `told` resets on `GROUP_JOINED` / `GROUP_LEFT`, handled on `ns.shareReminders` because the dungeon quests hold the `ns:` names.
- **When.** Quality of Life and `shareWhispers` on; party only (no raid, battleground or arena: spam), though sharing still works there. Chat lockdown (`C_ChatInfo.InChatMessagingLockdown`, checked first): the system message is secret, nothing sent.
- **Shape** (`ns:BuildAnnounceMessage`): marker `ns.TARGET_MARKER` (dropped on WoW Forever, which blocks raid-marker tokens), body with no closing period, ` // ` and `L["ADDON_SHORT_NAME"]`: `{rt3} I tried to share [Quest Name] with you, ... // PWQL`.
- **Quest reference.** `ns.FittingQuestReference` (wrapped by `ns.ShareWhisperQuestReference`) takes the best that keeps the message within `ns.CHAT_MESSAGE_MAX_LENGTH` bytes (`SendChatMessage` rejects longer): Questie's native link (`GetNativeQuestLinkStringById`, clickable for all), Questie's bracketed text (`GetQuestLinkStringById`, a link only with Questie), `[Title]`, then `[Title...]` cut on a UTF-8 boundary.
- **Message Length report** (Localization tab): each whisper for the longest readable title, bytes, SHORTENED if cut. Reads `ns.DiagnosticLogQuests`, so on index clients collapsed zones go uncounted (it says how many).

#### Example Lines (Quality of Life Panel)

- Built by the sending code (`ns.BuildShareWhisper`, the first message of `ns.BuildDungeonAnnouncement`, `ns.BuildSharePrint` with the sample count) and drawn by `ns.RenderSample` (`Options/Options-Utilities.lua`); under Seconds Between Shares and the whisper / dungeon announcement / dungeon sharing toggles, each hiding with its toggle.
- Only the "Example:" label (`SAMPLE_EXAMPLE`) takes the help color. Whisper and party lines draw as received: the client's `ChatTypeInfo` colors (fixed fallback), prefix (`CHAT_WHISPER_GET`, `CHAT_PARTY_GET`), class-colored sender, marker icon. Color is reopened after each `|r`: a panel falls back to white after a link where chat falls back to the channel color.
- Samples: `ns.SAMPLE_QUEST_IDS`, `ns.SAMPLE_DUNGEON_AREA_ID`, `ns.SAMPLE_ZONE_AREA_ID` (`Data/{Game}/Sample-Quests-{Game}.lua`), names via `C_Map.GetAreaInfo`; an unloaded title is requested (`C_QuestLog.RequestLoadQuestByID`) and shows `SAMPLE_QUEST_LOADING`. No samples, no rows.

### Dungeon Quests

`Features/Dungeon-Quests.lua` (when, who, what's been had) and `Features/Dungeon-Quest-Lookup.lua` (which dungeon, which quests): in a dungeon with a party, announce the player's quests still to do there and share the shareable ones. Settings `dungeonAnnounce`, `dungeonShare`.

- **Where.** Instance type in `INSTANCE_TYPES`, `IsInGroup()` and not `IsInRaid()`. Never in a raid group (spam); a party turned raid stops, and resumes if it turns back.
- **When.** `PLAYER_ENTERING_WORLD`, `GROUP_JOINED` and `GROUP_ROSTER_UPDATE` only start a `C_Timer.NewTicker` (`ns.DUNGEON_CHECK_INTERVAL`), and only with a setting on in a party dungeon. Setting and profile changes start it at once (`ns.dungeonQuests.Watch`, from `ns.ApplyQualityOfLifeSettings`, `ns:ApplyProfile`). Roster updates go to `ns.dungeonQuests:OnGroupRosterUpdate` since `Forever-Quest-Log.lua` owns `ns:OnGroupRosterUpdate`. The ticker stops when nothing is left or the player leaves.
- **Gathering.** A check waits until every online member still owed the announcement or shares is in range (`UnitInRange`), or `ns.DUNGEON_SHARE_MAX_WAIT` passes, so a gathered party gets them rather than whoever zoned first. WoW Forever hides party range, so there (`IsInRange`, `ns.FLAVOR == "Camelot"`) all count in range and both go on the first check.
- **Who counts.** Other party members (`GetNumSubgroupMembers`), online (`UnitIsConnected`), by GUID. An unfilled slot (around loading screens) is skipped so it never reads as leave-and-rejoin; so is a secret GUID or connection (`ns.IsReadable`).
- **What this group has had.** Keyed by instance ID (8th return of `GetInstanceInfo`): every instance of a dungeon shares a key, independent of Questie. Per key: announced, `sharedWith` GUIDs; memory only, dropped on `GROUP_LEFT`. So one announcement per dungeon per group, shares once per member per dungeon, nothing on re-zoning, and a run of their own for a later joiner. That run uses `QuestLogPushQuest`, which offers to the whole party; those who have the quest get "already on it", which earns no whisper. Members already shared with are never waited on; one still out of range when the wait ends starts a fresh wait.
- **Login and reload.** Not an arrival: `isInitialLogin` / `isReloadingUi` set `adoptPending`, and until `ns.DUNGEON_LOGIN_GRACE` after the first member appears (the roster fills late), each check marks the dungeon announced and members shared. Only if the player was grouped at that loading screen (`groupedAtLogin`); a group formed after is arriving. The next loading screen ends it.
- **Which quests** (`ns.DungeonQuests`; `ns.CurrentDungeon` gives name, key, Questie zone IDs, header names):
  - `header`: under a header named `GetRealZoneText()`, the instance name, or the area name of a Questie zone ID (an empty name while loading names nothing).
  - `Questie`: `zoneOrSort` is the dungeon, or an objective creature or object spawns there, an item drops there, or a kill credit, `triggerEnd`, extra objective or required source item is there. Catches class quests.
  - Zone IDs: `ZoneDB.instanceIdToAreaId`, plus alternatives from `ZoneDB:GetDungeons()` (Questie files some dungeons under a second ID).
  - World event quests (`QuestieEvent.IsEventQuest`) never count, even under the header: Questie can place one in an unrelated dungeon.
  - Every Questie read is `pcall`ed. No Questie, or a dungeon `ZoneDB` lacks: header only.
  - The header names also drive the current-zone mark in a dungeon (`ns.CurrentDungeonNames`).
- **Announcement**: skips ready and failed quests; to `ns:GetGroupChatChannel()`. Quests referenced as whispers do (`ns.FittingQuestReference`), joined by `LIST_SEPARATOR`, packed greedily, split only between quests so no link breaks. First message `DUNGEON_QUESTS_ANNOUNCE` (`_ONE` for one), later ones `DUNGEON_QUESTS_ANNOUNCE_CONTINUED`, each reading whole. Nothing to do, or chat lockdown: nothing sent, still counts as announced.
- **Sharing**: every matched `pushable` quest (`ns.LogQuests`), ready or not, to `ns.ShareQuests` with a `ns.BuildSharePrint` line naming the dungeon. None shareable: no print, members still marked. While `ns.sharingQuests`, it waits for the next check, members unmarked until it goes.
- **Diagnostics.** In a dungeon, Sharing Context shows the instance ID, key, zone IDs, raid flag, ticker, announced, wait so far, members' range and shares (`ns.DungeonShareStatus`), matched quests (`matchedBy`, state, shareability) and the announcement with bytes. Message Length flags announcement messages OVER. On index clients both swap `ns.DiagnosticLogQuests` in for `ns.LogQuests` during the call (`DungeonQuests`, `Manifests.lua`), so the log isn't expanded nor the selection moved; non-selected quests read "sharing not checked".

### Quest Text

Both quest logs and the quest giver window, every client, set quest text from shared files:

- `Quest-Display.lua`: naming. `ns.QuestListTitle` (tagged only while `showQuestLevels`), `ns.LevelTag`, `ns.QuestSuffix` (letter from the flavor's `ns.QUEST_TAG_SUFFIXES`; tag IDs mean different kinds per flavor, so they're data; E for an untagged elite), `ns.QuestLevelLegend` (only letters this client can show), `ns.StyleQuestID`.
- `Quest-Objectives.lua`: `ns.StyleObjective`, `ns.CheckIcon` / `ns.InlineIcon`, `ns.TwoSpacesWide`, `ns.ClearObjectiveCounts`.
- `Quest-Info-Style.lua`: `PrettyWideQuestLogSectionHeadingFont`, `ns.StyleQuestText` (line spacing `LAYOUT.LINE_SPACING`), `ns.RememberBlizzardStyle` / `ns.RestoreBlizzardStyle`, `ns.StyleQuestInfo` / `ns.RestoreQuestInfoStyle`, `ns.CreateRoomBelow`.
- `Quest-Details-Data.lua` (WoW Forever and Mists, after `Quest-Log-API.lua`): `ns.GetSelectedQuestDetails`, the selected quest as plain data.
- `Quest-Rewards.lua`: rewards wherever Blizzard's `QuestInfo` shows them.

Section heading font: `QuestTitleFont` less `SECTION_HEADING_SHRINK`, so the title reads as the one heading over Description / Rewards / Objectives. Under ElvUI (checked once at load) no shrink, since its title font is already small. Follows every `SetFont` / `SetShadowColor` / `SetShadowOffset` on `QuestTitleFont`, because skins set it after this file loads and again when their options change.

Spacing: every gap, margin and padding is a step of `LAYOUT.SPACE` (`Data/Data.lua`, each step double the last; the comment there says what each step is for). Free sizes follow the same doubling. Positions matched to Blizzard's art, and Blizzard's own control sizes, stay as they are. Named gaps (`TITLE_SPACE_BELOW`, `HEADING_SPACE_ABOVE` / `_BELOW`, `REWARD_BUTTONS_SPACE`, `REWARD_LINE_SPACE`, `MONEY_EXPERIENCE_SPACE`, `PAGE_TOP`, `QUEST_ID_GAP`, ...) are `LAYOUT` entries built from those steps.

#### Two Kinds of Details

- **Classic Era and TBC** (`Classic-Quest-Details.lua`, a wide quest log part): restyle Blizzard's `QuestLog*` regions in place.
  - Fonts and spacing set once (the quest log has them to itself); anchors set to the scale. The Description heading's gap is reset after every `QuestLog_UpdateQuestDetails`, because Blizzard re-anchors it each time.
  - `QuestFrameItems_Update` hook, `"QuestLog"` only (the quest giver window calls it too): Blizzard hangs each section's first reward button 3px left of the text and the captions 3px in; `Realign` zeroes those so two button columns fill the text column exactly, then `ns.SpaceAroundRewardButtons`.
  - Gold right-aligned two spaces in; `MONEY_RIGHT_PADDING` cancels the money frame's own inset.
  - Chain and quest ID go inside `QuestLogSpacerFrame` (Blizzard's spacer under the last piece), grown to hold them, placed again a frame later once the pane settles.
- **WoW Forever and Mists** (`Forever-Quest-Details.lua`): draws on frames of its own from `ns.GetSelectedQuestDetails`, never calling or borrowing `QuestInfo`, which the quest giver window and Blizzard's own details (map's on WoW Forever, `QuestLogFrame`'s on Mists) use, so none can blank or misstyle another's text.
  - `Place` stacks pieces down the column; `height` accumulates and the scroll child ends `PAGE_TOP` under the last. Order: title (name only, failed format if failed; icon and level are already in the list), objectives text, timer / group size / required gold, WoW Forever's next waypoint, objective lines, Description, Rewards, chain, quest ID.
  - Timer counts down from an `OnUpdate` on the scroll child (`timerExpires`), because only events repaint the pane.
  - Colors: `GetMaterialTextColors`, `"Stone"` plus its background atlas when Quest Text Contrast wants light text; finished objectives `FINISHED_COLOR`, as Mists grays them.
  - Reward buttons (`Forever-Quest-Details-Rewards.lua`, `ns.CreateRewardButtons` → `Fill(index, reward)`, `HideFrom(index)`): plain `LargeItemButtonTemplate`, made on first need, two per row. Quality-colored names, counts via `ns.FormatNumber`, unusable tinted. An unloaded item asks once (`ContinueOnItemLoad`) and calls `ns.RequestUpdate` on arrival. Hover re-selects the quest (`ns.SelectQuest`) before `SetQuestLogItem` / `SetQuestLogCurrency`, since those read the selection and something may have moved it; modified click links the item.
  - Gold (`CoinText`: `C_CurrencyInfo.GetCoinTextureString`, else the `GetCoinTextureString` global) right-aligned on the "You will receive:" line, experience under it (`MONEY_EXPERIENCE_SPACE` with gold, `SPACE.LINE` without).
  - Scroll bar is the list's `MinimalScrollBar`, because `ScrollFrameTemplate`'s bar differs per client.
- **`ns.GetSelectedQuestDetails`**: most calls read Blizzard's selection, so the pane selects first. Client-specific calls are chosen once at load, by-quest-ID variant first. WoW Forever only: group size, next waypoint, currency choices (`GetQuestLogChoiceInfoLootType`, indexed apart from items for their tooltips), `C_QuestInfoSystem.GetQuestRewardCurrencies`. Mists' reward currency indexes can skip, so it scans to `GetMaxRewardCurrencies()`. Spells skip known, boost and follower spells; objectives skip `spell` and `log` types, as Blizzard does. Choices, rewards, money and experience stay empty unless `C_QuestLog.ShouldShowQuestRewards`.

#### Shared Pieces

- **Objective lines** (`ns.StyleObjective`, both logs): description's font, not Blizzard's smaller one. Check (or same-size blank so names align), name, count right-aligned in its own column `SPACE.NEAR` clear. `SplitObjective` handles "8/8 Name" (WoW Forever), "Name: 8/8" (Classic) and zhCN/zhTW's full-width colon. Check sized in whole pixels and dropped `CHECK_DROP`, because self-sized it came out small and riding high in ElvUI's font. Skins recolor lines in hooks that may run after, so counts re-match their line's color a frame later.
- **Two spaces in** (`ns.TwoSpacesWide`): body text wraps short of the column edge, so a number flush to it looks like it runs past. Counts, gold, experience and quest ID end two spaces in, measured as "0  0" minus "00" because a FontString may not draw trailing spaces.
- **Quest ID** (`ns.StyleQuestID`): description's font less `QUEST_ID_FONT_SHRINK`, its color. Skins recolor the description later, so on first use it hooks the description's `SetTextColor` and recolors the ID and its chain icon (color baked into the text).
- **TBC daily reset line** (`DAILY_RESET`, `GetQuestResetTime`, in `Classic-Quest-Details.lua`): under the title, objectives `DAILY_RESET_SPACE_BELOW` under it while shown. Never shows on Classic Era (`ns.IsDailyFrequency` false without `LE_QUEST_FREQUENCY_DAILY`). Color follows the description's `SetTextColor`.

#### Blizzard's QuestInfo

Shared by the quest giver window's detail and reward pages (every client) and Blizzard's own details (WoW Forever, Mists). Follows the quest giver cleanup, not the Wide Quest Log switch.

- **Styled before layout**: `ns.ApplyQuestGiverCleanup` runs `ns.StyleQuestInfo` as saved settings load, before Blizzard first measures, so measurements match what's drawn; off → `ns.RestoreQuestInfoStyle`. Pieces a client lacks are skipped.
- **Experience and gold** (`QuestInfo_Display` hook, `Quest-Rewards.lua`): description's font and color instead of Blizzard's white outlined number font, for every caller while on; Blizzard's back for every caller while off.
  - Experience regrouped with `ns.FormatNumber` (`BreakUpLargeNumbers` can leave it ungrouped). ElvUI appends a level-share in bright green from a hook of unknown order, so only the leading number is regrouped; on dark (parchment) text every color code becomes `PARCHMENT_GAIN` after each `SetText` / `SetFormattedText`.
  - Gold: coin buttons get `PrettyWideQuestLogMoneyFont` (description's font, no shadow). Blizzard sizes coins when it lays them out, so after a font change `MoneyFrame_Update` reruns with `staticMoney`.
- **Rewards block** (`ns.SpaceRewardsBlock`, called from quest giver page spacing): `HEADING_SPACE_BELOW` under the heading, buttons `REWARD_BUTTONS_SPACE` clear of text, later lines `REWARD_LINE_SPACE` where Blizzard leaves `BLIZZARD_REWARD_LINE_GAP`, experience `MONEY_EXPERIENCE_SPACE` under gold or `SPACE.LINE` without gold (then "You will also receive:" is its own label). Block height grows by how far pieces moved; idempotent on the same layout.
- **Skin fixes** (`Quest-Giver-Skins.lua`, listed after `Quest-Giver.lua` so its `QuestInfo_Display` pass runs after the page is spaced):
  - Reward names: Blizzard draws them white on a dark plate; a skin hiding the plate leaves white-with-shadow on bare parchment. With the cleanup on and the plate hidden or alpha 0, names take the description's color, no shadow. Buttons are shared, so every display restyles every button, again a frame later because skins restyle in later hooks. Off → color and shadow kept in `namesBefore`.
  - Backdrop: see Quest Giver Window.

### Quest Giver Window

Gate: `ns.IsQuestGiverCleanupOn()` = Quality of Life switch and `giverCleanup` (`Quest-Giver.lua`), independent of the Wide Quest Log switch, so it works with Blizzard's quest log. `ns.ApplyQuestGiverCleanup` reapplies at once; called by Core as saved settings load, `ns:ApplyProfile`, and `ns.ApplyQualityOfLifeSettings` (`Options-Utilities.lua`, every Quality of Life toggle and both Quality of Life switches). An open window relays out on its next open.

- **Own text** (`StyleQuestGiverPages`): FontStrings the greeting/detail/progress/reward pages hold directly (chiefly the progress page, which no client draws with `QuestInfo`). Found by font, not name: title's font = heading, the one hung from the page top = the title. Blizzard's style kept on first change, restored when off. Styled at load, before first layout.
- **Shared `QuestInfo` text**: see Blizzard's QuestInfo. Page objective lines keep Blizzard's font, no check or count column.
- **Detail and reward page spacing** (`SpaceQuestGiverPage`, `QuestInfo_Display` hook, page + cleanup on only): walks `template.elements`, sets each piece's space above by `PIECE_KINDS` kind (first piece `PAGE_TOP`; heading `HEADING_SPACE_ABOVE`; rewards that plus `REWARDS_HEADING_RISE`; text `TITLE_SPACE_BELOW` / `HEADING_SPACE_BELOW`; detail pieces `SPACE.NEAR`; spacer 0), only on `TOPLEFT` anchors, then `ns.SpaceRewardsBlock`. The rise applies on WoW Forever and Mists, whose Rewards heading sits higher in its block; detected by `ns.LayOutQuestGiverPage` existing (only `Forever-Quest-Giver.lua` defines it). Blizzard lays pages out afresh, so off = left alone.
- **Greeting page** (`Quest-Giver-Pages.lua`): greeting `PAGE_TOP` down; Current/Available Quests a section under it (or right under when greeting empty); first line a heading's space under its heading, lines `QUEST_LINE_SPACE` apart. `QuestGreetingFrameHorizontalBreak` (hidden by ElvUI but still holding its place) becomes the whole section gap. Blizzard re-anchors all but the greeting each show, so off restores only the greeting (`greetingBlizzardY`). Runs from the panel's `OnShow` and `QuestFrameGreetingPanel_OnShow` (Blizzard calls it directly when already open). Buttons from `titleButtonPool` where present, else `QuestTitleButtonN`.
- **Progress page** (`Quest-Giver-Pages.lua`, `QuestFrameProgressItems_Update` hook): title `PAGE_TOP`, text `TITLE_SPACE_BELOW`, "Required items:" a section down, gold or first item row a heading's space under it, first row `SPACE.NEAR` under gold. Quest ID right-aligned `QUEST_ID_GAP` under the last shown thing (`LastShown`: left button of the last item row, else gold, heading, text), with `ns.CreateRoomBelow` because a scroll frame only scrolls to its last child. Off: title/text/heading/gold go back to offsets kept on first move (`blizzardY`; the first item row is re-anchored by Blizzard), quest ID hides.
- **Gossip** (`Gossip.lua`, every client): greeting styled from `GossipGreetingTextMixin.Setup`. The list measures rows with a hidden copy (`greetingTextFrame` in the greeting's data entry) that Blizzard never runs `Setup` on; unstyled, it measures a long greeting too short and the first option overlaps the text. So a `GossipFrame.Update` hook styles the copy and, if its height changed, calls the ScrollBox's `FullUpdate`. The copy persists, so later opens measure right first time.
- **Skinned backdrop** (`Quest-Giver-Skins.lua`, `ns.UpdateQuestGiverBackdrop`): ElvUI keeps the parchment but makes the window see-through, so trackers/nameplates show through. Cleanup on → opaque in the skin's color via `customBackdropAlpha = 1` (ElvUI honors it through color updates); off → the skin's alpha. Backdrop is on `QuestFrame` (WoW Forever, Mists) or `QuestFrame.backdrop` (Classic Era, TBC); an unskinned window has neither and is left alone. Skins apply after load, so checked on each `QuestFrame` `OnShow` and by `ns.ApplyQuestGiverCleanup`.
- **WoW Forever and Mists `QuestInfo` pages** (`Forever-Quest-Giver.lua`, `ns.LayOutQuestGiverPage` from its own `QuestInfo_Display` hook): gold and experience right-aligned two spaces in from `template.contentWidth` (`AlignRewardNumbers`); quest ID `QUEST_ID_GAP` under `LastShown` (`LAST_PIECES`, counting only pieces actually on this page, since one left showing from Blizzard's details belongs to that window). One quest ID, its room and its Wowhead button reparent to whichever page shows. Any other caller: quest ID hides, and gold/experience go back beside their labels only if this file moved them (`rewardNumbersMoved`).
- **Level tags** (`giverLevels`, sub-option of the cleanup; `ns.TagQuestLine`, `Quest-Giver.lua`): log-style tag before each quest line with a known level, line's own color, letter from `ns.GetQuestTagByID`. Gossip: hooks on `GossipSharedAvailableQuestButtonMixin.Setup` / `GossipSharedActiveQuestButtonMixin.Setup`, then the button's own `Resize`. Greeting page: `GetActiveLevel` / `GetAvailableLevel` and `GetActiveQuestID` / `GetAvailableQuestInfo`, button grown for the longer text. Blizzard may run either twice on the same text, so `levelTaggedText` prevents double tags. `Quest-Giver-Pages.lua` captures `ns.TagQuestLine` at load, so `Quest-Giver.lua` must load first.

### Quest Chain

Every client, Questie data only. `Quest-Chain-Data.lua` finds the chain; `Quest-Chain.lua` draws the section (`ns.CreateQuestChainSection`, `ns.UpdateQuestChainSection`), placed `HEADING_SPACE_ABOVE` under the rewards and above the quest ID. On Classic Era and TBC the details part builds it, so it exists only while the wide quest log runs.

- **Finding** (`ns.GetQuestChain`): `QueryQuestSingle` in `pcall` (Questie may be absent or not ready). Back: a part counts only as the quest's sole prerequisite (single `preQuestSingle`, no `preQuestGroup`) that names it as `nextQuestInChain`; forward: `nextQuestInChain`. Branches show only the straight run. Capped at `MAX_PARTS` (only a data loop reaches it); under two parts = no chain. Last hit cached in `lastChain` (details repaint in bursts; Questie data is fixed per session) and returned by reference, so callers only read. Misses aren't cached: before Questie's DB is ready every quest looks chainless.
- **Labels** (`ns.QuestChainPartLabel`): name from the client, else Questie, else the ID. Badge only when Questie's level > 0 and a color is known, regardless of `showQuestLevels`. Tag is Questie's corrected `GetQuestTagInfo` where present, else the client's; elite is always the client's. Tag names are never compared (localized).
- **Color** (`ns.QuestChainPartColor`): server difficulty (`C_PlayerInfo.GetContentDifficultyQuestForPlayer`) for a part in the log on WoW Forever, since the server rates only logged quests; else `GetQuestDifficultyColor` by level.
- **Rows**: heading `QUEST_CHAIN_PROGRESS` with position; rows `ROW_GAP` apart. Turned-in parts (`C_QuestLog.IsQuestFlaggedCompleted`) get `ns.CheckIcon` and `TURNED_IN_ALPHA`; the current part gets a band in the text's color (`CURRENT_PART_BAND_ALPHA`, `CURRENT_PART_BAND_MARGIN` for room around the badge). Check and badge have their own column so long names wrap under the name.
- **Badge** (`CreateBadge`): a pill with no art (two circle-masked caps plus a middle, one solid color so overlaps don't show). Text is the quest log color, a size down (`QUEST_ID_FONT_SHRINK`); the box is that color times `BADGE_SHADE`, because quest log colors are made for dark backgrounds and wash out on parchment. All badges share the widest possible width (`BadgeTextWidth`: doubled digit with each suffix in `BADGE_SUFFIXES`, cached per font) plus `BADGE_PAD_X` / `BADGE_PAD_Y`, so names align; a part with no level keeps the empty room.
- **Hover**: Questie's own tooltip (`QuestieLink:CreateQuestTooltip`, `questie:<questID>:<player GUID>`), skipped until `Questie.started` because before that it only prints a wait message to chat.
- **Fonts**: `CopyFont` reads font, color and shadow off the Description heading and text FontStrings, since skins set them there, not on font objects. ElvUI recolors those only after the details fill, so `FollowSourceColors` hooks `SetTextColor` / `SetShadowColor` on both (once) and recolors heading and rows.

### Ready to Turn In

`Turn-In-Line.lua`: total XP and gold waiting in ready quests, a line (`TURN_IN_SUMMARY`) centered between `ns.abandonButton` and `ns.shareButton`.

- Both numbers come from Questie's `QuestXP`, so no Questie = no line. `GetQuestLogRewardXP` takes `self`, `GetQuestRewardMoney` doesn't (matching Questie's definitions); both in `pcall`. Gold via `CoinText` (`C_CurrencyInfo.GetCoinTextureString`, else the `GetCoinTextureString` global; no gold part without either).
- Quests worth nothing are dropped; line hides when none remain. At `GetMaxPlayerLevel()` only gold shows.
- Classic Era and TBC count only quests under open zones (collapsed ones aren't listed); WoW Forever and Mists count all. Callers build `readyQuests` (`Classic-Quest-List.lua` inside its part, `Forever-Quest-List.lua`).
- Placed on first show, not on creation: on Classic Era and TBC `Classic-Quest-Log.lua` records Blizzard's buttons as `ns.abandonButton` / `ns.shareButton` only after the list part made the line.
- Tooltip: quests grouped by zone (`OTHER` for none), zones in first-seen order, under `TURN_IN_TOOLTIP`, in its own `PrettyWideQuestLogTurnInTooltip`, made opaque after every `Show` (NineSlice center and a skin's `backdrop`) because showing restores the see-through style and it opens over quest text.

### Wowhead Link

`Wowhead-Link.lua`, `ns.LinkQuestIDToWowhead(parent, text, getQuestID)`: every quest ID the add-on shows (both logs' details, progress page, WoW Forever / Mists quest giver pages) is clickable.

- Hover: `WOWHEAD_LINK_TOOLTIP`. Click: `PRETTYWIDEQUESTLOG_WOWHEAD` popup (`WOWHEAD_LINK_COPY`) with the address selected. Both act only while the ID text is shown. The edit box reverts any edit; Enter/Escape close.
- Address prefix is `ns.WOWHEAD_QUEST_URL`, one value per flavor in `Data/{Game}/Wowhead-{Game}.lua`, so the TOC picks the site section. Season of Discovery: the Classic Era TOC lists `Data/Discovery/` after `Data/Vanilla/`; each file returns early on the wrong side of `ns.IS_DISCOVERY`.
- No address → returns without a button: no error, just no link. Quest Log Context prints the address or `(none)`; Validate Data's row prints it or `TABLE MISSING`.
- Sets `text.linksToWowhead` so `ns.StyleQuestID` prefixes the chain icon (`ns.WOWHEAD_LINK_ICON`) in the ID's color. Returns the button so an ID that changes parents takes it along.

### Quest Map

`Features/Quest-Map.lua`: a map docked right of the window, every client. A quest log part, so on Classic Era and TBC it exists only while the wide quest log runs.
- `ns.hasQuestMap` is set at file scope, so it's true wherever the TOC lists the file; `ns.questMap` exists only once the part has run.
- Blizzard's map canvas (`MapCanvasFrameTemplate`) with a few of the world map's data providers, built the way the Battlefield Map is. It's the add-on's own frame: the world map is never opened or touched.
- The frame, `PrettyWideQuestLogMapFrame`, is declared in `Quest-Map.xml`: the canvas's `OnLoad` needs its `ScrollContainer` child to exist, which only XML can arrange (`BorderFrame` is what the canvas turns on to block the mouse while locked). The same file declares `PrettyWideQuestLogQuestMarkerPinTemplate` (WoW Forever and Mists).
- Size: `MAP_ASPECT` (the map art's proportions) at `HEIGHT_SHARE` of the visible window's height, art top border to bottom edge.
- `questMap.holder` (`BackdropTemplate`, dialog box backdrop) takes the mouse, so clicks never reach what's behind the map. Its placement is the `style` table (`edge`, `x`, `top`, `bottom`, `inset`), measured in game to meet the window art. `questMap.SetStyle` changes keys and lays out again, for a skin that draws the window differently (`Classic-ElvUI.lua`). Laid out again on every window `OnSizeChanged`.
- Wheel mode `MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_NONE`: no zoom, but the wheel stays enabled, so scrolling over the map doesn't zoom the camera either.
- The art is refitted (`canvas:OnFrameSizeChanged`) from the scroll container's own `OnSizeChanged`, once a new size has taken, not when it's asked for.
- **Combat.** The canvas calls `SetPassThroughButtons` on every pin it acquires, which WoW blocks from add-on code in combat. Every pin template of this map (marker, Questie's icons, area layer) takes `PrettyWideQuestLogPinMixin`, whose `SetPassThroughButtons` is a no-op, as HereBeDragons-Pins does for Questie's. It's defined at the top of `Quest-Map.lua`, outside the part, because the XML templates name it. These pins draw in combat; only Blizzard's layers wait (WoW Forever and Mists).

#### Load Order

Each TOC lists, after `Dungeon-Quests.lua`: `Quest-Map.xml`, `Quest-Map.lua`, `Questie-Map.xml`, `Questie-Map.lua`, `Questie-Map-Tooltip.lua`, `Questie-Map-Quest-Giver.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, the client's map file (`Classic-Quest-Map.lua` in Vanilla and TBC, `Forever-Quest-Map.lua` in Camelot and Mists), `Quest-Map-Reveal.lua`. Then `Routes/Routes.xml`, then `Classic-ElvUI.lua` (Vanilla, TBC) or `Mists-Quest-Portrait.lua` (Mists). Why:
- `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons` as it builds, and defines the pin mixin both XML files name.
- Every `Questie-Map-*` file reads `ns.questMap` as it builds. `Questie-Map-Tooltip.lua` also reads `questMap.QUESTIE_PIN_TEMPLATE`, set by `Questie-Map.lua`.
- The tooltip, quest giver, areas and area layer files only add functions (`ShowPinTooltip`, `QuestGiverMapID`, `ObjectiveAreas`, `SpotOutline`, `DrawObjectiveAreas`, `RemoveObjectiveAreas`), which `Questie-Map.lua` and the client's map file read only when drawing.
- `Classic-Quest-Map.lua` takes `questMap.RequestRefresh` by value as its `QuestLog_UpdateQuestDetails` hook.
- `Forever-Quest-Map.lua` reads `ns.questMap` and `ns.questLog` and hooks `ns.DisplayQuestDetails` at load.
- `Quest-Map-Reveal.lua` hooks the exploration pin the client's map file made.
- `Mists-Quest-Portrait.lua` reads `ns.questMap.holder` at load.

WoW Forever and Mists run all of it at file load (parts run at once there, `ns.questLogIsOwnWindow`; `Forever-Quest-Map.lua` isn't a part). Classic Era and TBC run the parts in the same order inside `ADDON_LOADED`. Routes needs none of these files: it draws on `WorldMapFrame` with templates of its own and reads nothing of `ns.questMap`.

#### First Draw and Picking a Map

- Each client's map file adds the layers, registers frame levels (`PIN_FRAME_LEVEL_QUEST_BLOB` for the objective areas, `PIN_FRAME_LEVEL_ACTIVE_QUEST` above it for Questie's pins) and defines `ns.questMap.FollowQuest`, which the canvas's `OnShow` calls. Every client goes through `ns.questMap.FollowQuestieQuest` first, with its own fallback map.
- **The canvas needs a map before it first draws**, as the Battlefield Map does: Blizzard's layers ask for zoom levels the scroll container builds only once it has a map, and drawing without them breaks Blizzard's map code. When `FollowQuest` leaves no map, `OnShow` tries `MapUtil.GetDisplayableMapForPlayer`, then `C_Map.GetFallbackWorldMapID` where it exists. It calls `MapCanvasMixin.OnShow` only once `ScrollContainer.zoomLevels` exists; until then `drawPending`, run by the first map `questMap.ShowMap` sets (a hide clears it).
- **Whether the canvas has a map is read from `canvas.mapID`, never `canvas:GetMapID()`**, which answers the player's map until one is set: trusting it skips `SetMapID` when the quest is in the player's zone, and the first draw finds no zoom levels.
- `questMap.CanShowMap` accepts only a map with art (`C_Map.GetMapArtLayers` not empty): a client can know a map it has no art for (some dungeons Questie names) and the canvas can't draw one. `questMap.ShowMap` climbs `parentMapID` to the nearest map with art, stays put when none has any, and returns whether the map moved (a move redraws every layer). The zone dropdown and the quest giver's zone filter with `CanShowMap` without climbing, so a quest whose icons sit only on artless maps counts as having none.

#### Show Map and Map Scale

- Show Map / Hide Map sits `LAYOUT.LIST_BUTTONS_GAP` after the last of `ns.listButtons`; the map has its own close button (`UIPanelCloseButtonNoScripts`) top right.
- `global.mapHidden`: one setting for every character, no default, cleared (nil) rather than set false when the map shows, so Reset Profile never hides or shows the map.
- An empty log hides the map and Show Map (`questMap.SetLogEmpty`, called by both list files on every update), leaving `mapHidden` alone.
- The map is the window's child, so it follows Window Scale. Map Scale (`global.mapScale`, Wide Quest Log panel) scales the holder on top through `ns.ApplyMapScale`, run on every window `OnShow` and from Reset Window, which puts it back. The panel hides the map's settings where `ns.hasQuestMap` isn't set (`MapHidden`) and grays them out while the wide quest log isn't running.

#### WoW Forever and Mists

`Features/Forever-Quest-Map.lua`, not a part.
- **Layers**, each only if the client has its mixin: Blizzard's exploration, fog of war (also needs `FogOfWarFrameMixin`; Mists has the provider but not the frame, so no fog), quest objective area (`QuestBlobDataProviderMixin`), dungeon entrances, flight points, then a marker layer of its own. Frame levels in the world map's order (the `levels:AddFrameLevel` block), `PIN_FRAME_LEVEL_QUEST_MARKER` over Questie's icons. Entrances and flight points keep Blizzard's own mouse handling (names on hover). No other world map layer.
- **Following.** A hook on `ns.DisplayQuestDetails` runs `ShowQuest` at once when `ns.questLog.selectedQuestID` changed, map showing or not, then always `RequestRefresh`, since Questie's icons can arrive after the log changes.
- `ShowQuest`'s fallback: `GetQuestUiMapID`, else (nil or 0) `questMap.QuestGiverMapID`, else the player's zone, handed to `FollowQuestieQuest`. Then `SetFocusedQuestID`, or `ClearFocusedQuestID` when Questie's icons have the quest or nothing is selected, and redraws the blob pin and the marker.
- **Never drawn twice.** Blizzard's objective area and the marker draw only `BlizzardQuestID`: the shown quest unless `questMap.questieQuestID` has it. `ShowQuest` redraws them only after `FollowQuestieQuest` has set `questieQuestID`, because a map move inside it redraws every layer while `questieQuestID` still names the last quest.
- **Blob pin `Refresh` is replaced on this map's copy**: Blizzard's redraw less its `questPOI` check, drawing `BlizzardQuestID` only. Questie turns `questPOI` off when its own objectives are chosen, which would leave a quest Questie has no icons for with no area. The CVar and the world map are left alone.
- **Marker** (`PrettyWideQuestLogQuestMarkerPinTemplate`), the add-on's own rather than Blizzard's quest provider: no mouse (drags pass through, a click runs nothing), and the pin mixin lets it draw in combat. Placed at the quest's entry in `C_QuestLog.GetQuestsOnMap` for the shown map, else `C_QuestLog.GetNextWaypointForMap` where it exists (WoW Forever). `MARKER_TEXTURE`, or `MARKER_TEXTURE_COMPLETE` once `ns.IsQuestComplete`. Scaling limits as Questie's icons.
- **Combat.** Every Blizzard provider's `RefreshAllData` is wrapped as it's added: in combat it marks `heldProviders` and returns; `questMap:OnPlayerRegenEnabled` (`PLAYER_REGEN_ENABLED`, Core `EVENTS`, owner `questMap`) runs each held one once. The marker isn't wrapped. Replacing a provider's `RefreshAllData` after the wrap drops the hold.
- Client differences are feature tests (each provider mixin, `FogOfWarFrameMixin`, `GetNextWaypointForMap`), never flavor checks.
- Quest Map Context shows which quest the objective area and marker draw for, whether combat is holding Blizzard's redraws, and WoW Forever's next waypoint.

#### Classic Era and TBC

`Features/Classic-Quest-Map.lua`. These clients have no Blizzard quest areas or markers, nor data to draw them from, so only the exploration layer; levels `PIN_FRAME_LEVEL_MAP_EXPLORATION`, `PIN_FRAME_LEVEL_QUEST_BLOB`, `PIN_FRAME_LEVEL_ACTIVE_QUEST`.
- The quest comes from Questie's icons alone. The fallback (`QuestGiverMapID`, else the player's zone) is passed as a function, so Questie's database is asked only when the quest has no icons.
- Selected quest: `GetQuestLogTitle(GetQuestLogSelection())`, a header counting as none. Follows through a `QuestLog_UpdateQuestDetails` hook that only asks for a refresh.

#### Unexplored Areas (Every Client)

`Features/Quest-Map-Reveal.lua`. The map art leaves out unexplored areas, so a quest in a new zone would show bare parchment. It hooks `RefreshOverlays` on this canvas's exploration pin (`MapExplorationPinTemplate`); after Blizzard draws the explored areas, it draws the rest that `ns.MAP_REVEAL_OVERLAYS` lists for the art ID (`C_Map.GetMapArtID`).
- Cut into tiles as Blizzard cuts explored ones: the current art layer's `tileWidth`/`tileHeight`, the last tile of a row or column fitted into the smallest power-of-two file (`PieceSize`). `ARTWORK` sublevel -1, under Blizzard's; joins the pin's `textureLoadGroup` on a full update.
- Entry key `"Width:Height:OffsetX:OffsetY"`, value the texture file IDs comma-separated, row by row. An area counts as explored when `C_MapExplorationInfo.GetExploredMapTextures` reports the same key.
- Only the client's own file IDs, so no art ships; the table ships, so no other map add-on is needed.
- Art IDs differ by client, so one `Data/{Game}/Map-Reveal-{Game}.lua` per flavor folder: Vanilla, TBC, Camelot, Mists by their own TOCs; Discovery by the Vanilla TOC after Vanilla, each of the pair guarded by `ns.IS_DISCOVERY` so one table is built; Wrath and Mainline empty, listed by no TOC, left out of the zip by `.pkgmeta`.
- Always on, no setting. The world map and Battlefield Map are untouched, so Leatrix Maps or any other reveal add-on never draws here, nor this there.
- Quest Map Context shows the art ID, areas listed vs explored, map arts listed, and exploration pins with `RefreshOverlays` to hook.

#### Questie's Icons (Every Client)

`Features/Questie-Map.lua`: a data provider redrawing the selected quest's Questie icons (objectives, turn-in) as `PrettyWideQuestLogQuestiePinTemplate` pins (`Questie-Map.xml`). Questie never draws on this map and isn't told it exists.
- **Source.** Questie's own HereBeDragons-Pins (`HereBeDragonsQuestie-Pins-2.0`): `worldmapPins` maps each icon to its `uiMapID` and world position, turned into zone coordinates by `HereBeDragonsQuestie-2.0`. Both through `LibStub`'s silent flag, once at build (Questie's libraries, not bundled; every TOC's `OptionalDeps: Questie` loads Questie first). Without them nothing draws.
- **`IsShownIcon` leaves out** route lines (`type == "line"`), icons at alpha 0, and manual icons (`isManualIcon`: townsfolk, Show on Map), whose `data.Id` is an NPC's or object's and can equal an unrelated quest's ID. The Quest Map Context counts skip manual icons too.
- **Kept on purpose:** icons Questie's settings hide (`hidden`), since this map shows the quest picked in the log whatever Questie shows elsewhere; and icons Routes hides on `WorldMapFrame` (`Routes-Map-Questie-Icons.lua`), since this map tests only the icon texture's alpha.
- **Size.** `ICON_SIZE` times Questie's scale for the icon's kind (`data:GetIconScale()`); Questie's Global Scale is left out, as it would shrink these with Questie's world map icons. `SetScalingLimits` as Questie's world map pins, so pins keep their size on screen instead of shrinking with this smaller canvas.
- **Glow.** With Questie's `alwaysGlowMap`, at `GLOW_SCALE` times the icon, never on `"available"` or `"complete"` icons. Color from `ObjectiveData.Color`, only the file from `icon.glowTexture`: Questie shows that texture only once the world map has been opened.

`ns.questMap.FollowQuestieQuest(questID, fallback)` picks, in order:
1. The dropdown's zone, while the same quest stays selected.
2. The player's zone (`MapUtil.GetDisplayableMapForPlayer`), if the quest has an icon there.
3. The zone with most of its icons.
4. The fallback: a map ID, or a function asked only when the quest has no icons.

It sets `questMap.questieQuestID` while Questie has icons for the quest, and returns whether it has any.

- **Zone dropdown** (`WowStyle2DropdownTemplate`, `ZONE_DROPDOWN_WIDTH`, `LAYOUT.SPACE.NEAR` in from the top-left) when icons span more than one zone, most icons first, ties to the lower map ID. A pick holds until another quest is selected; passed over while it has no icons, back if they return with the same quest selected.
- **Refreshing.** Hooks on Questie's pin library (`AddWorldMapIconMap`, `AddWorldMapIconWorld`, `RemoveWorldMapIcon`, `RemoveAllWorldMapIcons`), since Questie draws a little after the log changes and a batch at a time; the scroll container's resize (circles are sized for the map on screen); the client's map file; the Show Objective Areas toggle; `ns:ApplyProfile`. All only call `questMap.RequestRefresh`: at most once per `REFRESH_DELAY`, only while the canvas is visible (checked on asking and on running). It runs `FollowQuest`, then redraws Questie's provider unless the map moved, which already redrew every layer.

#### Pin Tooltip (Every Client)

`Features/Questie-Map-Tooltip.lua` defines `questMap.ShowPinTooltip`, which `AddPin` sets as each pin's `OnEnter`. Questie's own tooltips can't be reused: they gather neighbors from the world map's own pins.
- The quest's name, then every NPC or object on a pin within `CLUSTER_DISTANCE` (a share of the map, each axis apart, not yards); an area's marker stands for every NPC or object in its area (`pin.area.names`). Each is followed by its objectives, one per description.
- Row style: names and objective rows both indented `ROW_INDENT`, so the check slot (`ns.CheckIcon`, checked once done) lines up with the names; the count on the right (`AddDoubleLine`); done rows in `HELP`.

#### The Quest Giver's Zone (Every Client)

`Features/Questie-Map-Quest-Giver.lua`: `ns.questMap.QuestGiverMapID`, the zone a quest was given in, from Questie's database. The fallback for a quest with no Questie icons (Classic Era and TBC inside the fallback function; WoW Forever and Mists only when `GetQuestUiMapID` gives nil or 0). Quest Map Context shows its answer.
- `QuestieDB` and `ZoneDB` through `ns.ImportQuestieModule`; nil without Questie, `QueryQuestSingle` or `GetUiMapIdByAreaId`.
- Walks `startedBy`, NPCs then objects in Questie's order; for each, the area with most of its spawns (`BusiestArea`, ties to the lower area ID); the first whose zone the map can show wins.
- Else the quest's `zoneOrSort` when above 0 (covers item-started quests). Negative is a class or profession, so such a quest no NPC or object starts gets nil.
- `AreaMapID`: an area with a `ZoneDB` parent (`GetParentZoneId`) gives way to it before `GetUiMapIdByAreaId`; a map without art (`CanShowMap`) is skipped, not climbed.

#### Objective Areas (Every Client)

With Show Objective Areas on (`profile.showObjectiveAreas`), `Features/Questie-Map-Areas.lua` shades where each of the selected quest's objectives is found, as Questie's own areas do, and that objective's icons give way to one marker per area.
- The toggle (Wide Quest Log panel) is hidden without a map, grayed out without Questie (tooltip says why, saved choice kept), and asks for a map refresh.
- **Built from `icon.data.ObjectiveData.spawnList`** (every spawn in Questie's database), not Questie's icons, which Questie thins out where they crowd.
- **Spawns.** Kept where `ZoneDB:GetUiMapIdByAreaId` puts the area on exactly the shown map and `Phasing.IsSpawnVisible` agrees (without `Phasing`, all count); one per position and icon. Measured in yards from `GetZoneSize` (Questie's HereBeDragons). Grouped by Questie's icon, so objects and creatures never share an area. Each group sorted by position, so the same spawns always make the same areas.
- **Clustering** (`Cluster`): greedy, each untaken spawn takes later ones within `CLUSTER_RADIUS` of the moving center, two passes.
- **Shape** (`Outline`): convex hull grown through a ring of `PADDING_POINTS` around each corner, by `EDGE_PADDING` or more, so it reaches at least far enough from its middle to clear its marker by `SPOT_GAP` on screen. A lone spawn is a circle, a line of spawns a rounded bar.
- That least reach (`MinRadius`) is in yards from the zone's size and the canvas width at minimum zoom (`GetScaleForMinZoom` where the client has it, else the current scale; `FALLBACK_MIN_RADIUS` when either is unusable). So the gap is the same on every zone's map, and a map resize redraws the areas. No zone size: nothing shaded, every icon plain.
- **Merging** (`MergeTouching`): within one objective's group, shapes that overlap or come within `TOUCH_GAP` merge with a new hull until none touch (box check, then separating-axis test), so each blob has one marker, at the hull's centroid, in the look of the objective's icon of that kind. Different objectives, and one objective's objects vs creatures, may still overlap.
- **Circles.** Every icon left on the map, turn-in included, gets a circle clearing it by `SPOT_GAP` (`questMap.SpotOutline`) in its objective's color, or `TITLE` gold for the turn-in. Never merged with areas; not drawn with the setting off. An objective with no spawns placed on the shown map keeps Questie's icons, each circled.
- **Cache.** Per objective in a weak-keyed table (`built`) until the map, the least reach (map size on screen, marker size) or Questie's `spawnList` changes.

`Features/Questie-Map-Area-Layer.lua` draws them on one map-sized pin (`PrettyWideQuestLogAreaPinTemplate`) at `PIN_FRAME_LEVEL_QUEST_BLOB`, acquired only when there's something to shade; the pin zooms with the map.
- Fill: a fan of triangles from the centroid, each a white texture whose four corners `SetVertexOffset` moves onto the triangle's three, corners put counterclockwise first; `FILL_ALPHA`, objective color or `FALLBACK_COLOR`.
- Outline: a `Line` per edge at `OUTLINE_ALPHA`, thickness reset on `OnCanvasScaleChanged` so it stays `OUTLINE_WIDTH` on screen.
- Textures and lines are reused between draws, spares hidden. Neither takes the mouse.
- Quest Map Context shows the setting, `questMap.areaCount` (areas and circles shaded), and for when nothing is shaded: whether `ZoneDB` and `Phasing` were found, the zone's size, and each objective's spawns in the zone vs placed.

### Quest Giver Portrait (Mists)

`Features/Mists-Quest-Portrait.lua`: Blizzard's Mists quest log shows the giver's model beside itself, so this does the same for the window that stands in for it. Not a part. The Mists TOC lists it after every other Features file (after `Routes.xml`), since at load it reads `ns.questLogFrame`, `ns.questLog` and `ns.questMap.holder`, and hooks `ns.DisplayQuestDetails`, `ns.ApplyMapScale` and `ns.OnWindowResizeStopped` (an empty function in `Window.lua` that exists to be hooked).
- **Blizzard's model is left alone.** A `ModelScene` of its own (`PanningModelSceneMixinTemplate`) in a box with the map's border (`holder.backdropInfo`) and a `NAME_HEIGHT` strip for the giver's name. `Pose` follows `QuestFrame_ShowQuestPortrait`: -1 is the player, otherwise the giver, mounted if it has a mount.
- **Placement.** Map open: under the map (`GAP`), Blizzard's proportions (`MODEL_WIDTH`, `MODEL_HEIGHT`), ending level with the art's bottom (`LAYOUT.ART_INSET_BOTTOM`), no wider than the map. Measured through effective scales, since Map Scale applies to the map and not the box. Under `MIN_MODEL_HEIGHT` of room it hides rather than moving. Map closed: beside the window at Blizzard's size (`BESIDE_X`, `BESIDE_Y`).
- **What it reads.** `GetQuestLogPortraitGiver` reads Blizzard's selected quest, so nothing changes while `ns.GetSelectedQuestID` isn't the quest the window shows (a quest giver window took the quest text). No selected quest, no giver, or `QuestLogShouldShowPortrait` (where it exists) saying no hides the box. `posedAs` keeps a repaint from restarting the model; cleared when the window closes or nothing is selected.
- **Refit.** Map open/close, window resize and Map Scale refit it a frame later (`RequestRefit`), once the map has been laid out. Hidden during a grip drag (`frame.isResizing`), drawn once as it ends.

### ElvUI, VoiceOver and Spoken Quests

#### Classic Era and TBC

ElvUI and VoiceOver work on Blizzard's own quest log frames, so the Classic files make room for them rather than replacing what they draw. `Classic-ElvUI.lua` and `Classic-VoiceOver.lua` are parts, so neither acts with the Wide Quest Log switch off. The quest giver window's ElvUI backdrop is `Quest-Giver-Skins.lua`'s, on every client (see Quest Giver Window).
- **ElvUI's grip.** `Classic-Quest-Log.lua` removes Blizzard's art and draws its own either way, and on every show moves the resize grip to the skin's backdrop corner (`QuestLogFrame.backdrop`, `AnchorGrip`) when there is one.
- **ElvUI skins at login, after this add-on loads**, so `Classic-ElvUI.lua` checks on each `OnShow` until there's a backdrop and ElvUI's Skins module, then acts once. With ElvUI's quest skin off there's never a backdrop, and the window keeps the add-on's art.
  - `ns.HideQuestLogParchment` (`Classic-Quest-Log.lua`) hides that art and the "no active quests" parchment, and keeps them hidden.
  - The backdrop is ElvUI's see-through Transparent template, which shows Questie's tracker through the quest text, so it's made opaque in its own color; `customBackdropAlpha` is ElvUI's field for that and survives its color updates.
  - `HandleButton` on `ns.listButtons`, Show Map and `ns.zoneShareButton`; `HandleCloseButton` on the map's close button; `HandleDropDownBox` on the zone dropdown; the holder gets the Transparent template in place of its dialog border, made opaque the same way.
  - The map moves beside the skin's backdrop instead of the art (`questMap.SetStyle` with `MAP_GAP`, `MAP_INSET`).
  - The WoW Forever and Mists TOCs don't list this file; their window keeps its own art under ElvUI.
- **VoiceOver's title padding.** VoiceOver puts a play button over the start of each title. With it on, the list's row styling starts each title with `ns.VoiceOverTitlePrefix` (`Classic-VoiceOver.lua`): enough spaces to clear the button (measured once, else two). Spaces only: a tab draws as a missing glyph in some fonts, ElvUI's among them.
- **VoiceOver's buttons follow Blizzard's order**, row *i* to entry *i* + scroll offset. `ns.MatchVoiceOverButtons(order)` deals them out again by what each sorted row shows, through VoiceOver's own functions (`CreatePlayButton`; `UpdatePlayButton` for a quest a sound pack can read, else `UpdateQuestTitle` with the button disabled; `UpdatePlayButtonTexture`). `CanDealButtons` checks every VoiceOver field it calls first, so a VoiceOver update that renames one only leaves the buttons alone.
- **Row styling runs after the buttons.** VoiceOver's functions rewrite the title and move the check, so `UpdateList` (`Classic-Quest-List.lua`) runs `StyleQuestRows` right after `ns.MatchVoiceOverButtons`. VoiceOver's overlay `Update` can run after the `QuestLog_Update` hook and restyle the rows, so it's hooked to `ns.RestyleClassicQuestRows`: buttons and row styling again with the order the last update built (`currentOrder`), without rebuilding the order or rerunning the list's update. Hooked whether or not VoiceOver's quest log part is on yet, since that's read from its saved settings after this file loads.

**Spoken Quests** is a fork of VoiceOver that keeps the `VoiceOver` global and its quest log functions, so all of the above applies to it. `ns.GetVoiceOver` (`Features/Utilities.lua`) finds either (`ns.VOICEOVER_ADDON_NAMES`), returning the global only when it holds `QuestOverlayUI`, `DataModules` and `Enums` (read with `rawget`, since the global falls back to `_G`), and only while Spoken's quest log part is on (`Addon:IsPartOn`). Both are in the TOCs' `OptionalDeps`, so the global exists when the Classic file hooks it.

#### VoiceOver and Spoken Quests (WoW Forever and Mists)

VoiceOver or Spoken Quests puts its play buttons on Blizzard's quest list (the world map's on WoW Forever, `QuestLogFrame`'s on Mists), which the window stands in for, so they'd never show. `Features/Forever-VoiceOver.lua` puts one on each quest row of the add-on's list.
- `ns.ShowVoiceOverButton(row, questID)` places it at `LAYOUT.QUEST_TEXT_X` and returns `TITLE_INSET` (0 without a button), which `Forever-Quest-List.lua` moves the title over by.
- Made with VoiceOver's `MakePlayButton`, `BindPlayButton` and `SetPlayButtonState`, disabled for a quest no sound pack can read (`DataModules:PrepareSound`), and only when every one of those fields is there (`GetOverlay`).
- A set of its own, one per quest, reusing a button once its quest leaves the log (`TakeLeftoverButton`): Blizzard's list takes VoiceOver's own set back to its rows whenever it redraws.
- Rows are recycled, so each row lets go of its button (`ns.HideVoiceOverButton`) before it's set up again, unless another row already took it for the same quest (`button.row`).

### Routes

Routes on Zone Map and the Quest Arrow follow one route through the quests in the log, planned by `Features/Routes/`.

- **What it covers.** Only the player's zone (`routes.PlayerZone`) with the caves, buildings and cities inside it. Each objective not done offers a few places to do it: its Questie spawns clustered into blobs. Each done quest offers its turn-in; with `showUpcomingTurnIns`, so does one not done, after its objectives. With `partyQuests`, party quests the player lacks add their objectives (see Party Members' Quests).
- **Order.** Shortest open path from the origin, solved as a traveling salesman problem (`Routes-Solver.lua`).
- **Views.** `Routes-Map.lua` on `WorldMapFrame` (the "zone map" in player text), helped by `Routes-Map-Size.lua`, `Routes-Map-Line.lua`, `Routes-Map-Questie-Icons.lua`, `Routes-Map-Blizzard-Quests.lua`, `Routes-Map-Tooltip.lua` and `Routes-Camps.lua`. `Routes-Arrow.lua` points at the next waypoint.
- **Needs Questie.** Every place, objective and count comes from Questie's quest log and database; every distance from Questie's HereBeDragons (`HereBeDragonsQuestie-2.0`, `routes.HereBeDragons`, nil until Questie loads it), in world yards.
- **Not a quest log part.** Runs on every client whatever the Wide Quest Log switch says. Never draws on the add-on's own map (`ns.questMap`).
- **TomTom.** `Routes-TomTom.lua` stands TomTom's own quest arrow (its `"poi"` feature) down while the Quest Arrow shows, so a player with both never gets two arrows pointing at different places. Through TomTom's public `SuppressFeature`/`ReleaseFeature`, hooked on `routes.arrowFrame`'s `OnShow`/`OnHide`: session-only, TomTom's saved settings untouched. It checks for `IsCrazyArrowEmpty` and both functions because other add-ons create a `TomTom` table of their own. Routes Context reports both states.

#### Loading

Each TOC lists one line, `Features/Routes/Routes.xml`: after `Quest-Map-Reveal.lua`; before `Classic-ElvUI.lua` (Classic Era, TBC) or `Mists-Quest-Portrait.lua` (Mists); last Features line on WoW Forever; before Diagnostics and Options.

Leaving that line out removes the feature cleanly:

- `ns.routes` is nil.
- Core's `EVENTS` rows owned by `routes`, `routesMap`, `routesArrow` and `routesItems` find no handler, so register nothing.
- `ns:ApplyProfile` skips `ns.routes.ApplySettings`; `ns.RegisterOptionsPanels` registers neither Routes panel; `ns.OptionsRoutesToggle` hides the General panel's two Routes switches.
- `Diagnostics/Manifests.lua` adds no Routes API rows; Routes Context reports it not loaded.
- `Options/Options-Routes-Map.lua` and `Options/Options-Quest-Arrow.lua` are separate TOC lines that only define builders, so they load harmlessly.

`Routes.xml` order: Core, Planner, Ignore, Solver, Party, Geography, Questie, Blobs, Nodes, Pinning, Overlaps, Stops, Stop-Lines, Camps, Map-Size, Map-Line, Map-Questie-Icons, Map-Blizzard-Quests, Map-Tooltip, Map, the two pin templates, Arrow-Survey, Arrow, Arrow-List, Arrow-Item-Choice, Arrow-Items, Arrow-Menu, TomTom. Most files capture what they need by value at load, so each must follow what it reads:

- `Routes-Planner.lua`: `routes.Notify` (Core). Its `routes.OnLogin(UpdateWatcher)` must be the first login handler, so it stays right after Core.
- `Routes-Geography.lua`, `Routes-Questie.lua`, `Routes-Blobs.lua`: `routes.HereBeDragons` (Core).
- `Routes-Blobs.lua`: `IsInZone`, `IsInstanceMap` (Geography).
- `Routes-Nodes.lua`: `IsInstanceQuest`, `QuestLog`, `QuestState`, `IsEscort`, `ForEachObjective`, `HasSpawns` (Questie); `NewPoints`, `AddSpawns`, `Cluster`, `Candidates` (Blobs).
- `Routes-Pinning.lua`: `QuestLog`, `ForEachObjective` (Questie); `BlobKey` (Nodes).
- `Routes-Overlaps.lua`: `Unworked` (Nodes); `RIDE_REACH`/`RIDE_RADIUS` computed at load from `routes.AREA_REACH` (Core) and `routes.MIN_STOP_RADIUS` (Blobs).
- `Routes-Stops.lua`: `routes.MIN_STOP_RADIUS`, `routes.NAME_LIMIT` (Blobs).
- `Routes-Stop-Lines.lua`: `routes.IsArea` (Stops).
- `Routes-Camps.lua`: the five quest log helpers (Questie), `Cluster` (Blobs), `IsArea` (Stops).
- `Routes-Map.lua`: `KeepFullSize` (Map-Size), line mixin and update (Map-Line), icon functions (Map-Questie-Icons), `ApplyBlizzardQuests`/`HookBlizzardQuests` (Map-Blizzard-Quests), `routes.CORPSE_ICON` (Stop-Lines). It defines the global `PrettyWideQuestLogRoutePinMixin` that both XML templates name in `mixin=`, so it precedes them. `routes.AddStopTooltip` (Map-Tooltip) is looked up at call time.
- `Routes-Arrow.lua`: `routes.ArrowSurvey`, `routes.ArrowNearestPlace` (Arrow-Survey). `Routes-Arrow-List.lua`: `routes.arrowParts`, `routes.ARROW_LAYOUT` (Arrow).
- `Routes-Arrow-Item-Choice.lua` and `Routes-Arrow-Items.lua`: `routes.arrowFrame`, `routes.ARROW_LAYOUT` (Arrow), `routes.arrowTitleRows` (Arrow-List).
- `Routes-TomTom.lua`: hooks `routes.arrowFrame` (Arrow) at load.

Frames build at file load (planner, watcher, `PrettyWideQuestLogRouteArrow`). Anything needing saved settings or the world map registers via `routes.OnLogin(handler)`; `routes:OnPlayerLogin` runs the migrations, then the handlers in order: `UpdateWatcher` (Planner), Map's, Arrow's.

#### Settings

- Profile table `ns.db.profile.routes` (so Reset Profile restores it); keys and defaults in `ns.DATABASE_DEFAULTS.profile.routes` (`Data/Default-Settings.lua`), each commented. `routes.Settings()` returns the defaults table until `ns.db` exists.
- **Feature switches** `showMap`, `showArrow`: on the General panel and atop each own panel, whose other controls hide while it's off. `routes.IsWanted()` = either on; nothing plans and the watcher doesn't run otherwise.
- **Shared by both views:** `partyQuests` sits on Routes on Zone Map under Party, shown while either switch is on. `showUpcomingTurnIns` sits on the Quest Arrow panel but changes what both show. The arrow menu also toggles `partyQuests`, `showNextObjective`, `showUpcomingTurnIns`.
- **Choice lists:** Marker Size `MARKER_SIZES`/`MARKER_ORDER`, Line Speed `LINE_SPEEDS`/`LINE_SPEED_ORDER` (`Options-Routes-Map.lua`); Line Opacity, Arrow Size and Quests Listed ranges inline in the panel builders. `showItemButtons` hides with `showQuests`.
- **Writes** go through `routes.SetSetting(key, value)`: stores, `UpdateWatcher`, then while wanted notifies every listener (map, arrow `Refresh`, item buttons, `RefreshArrowMenu`) and plans at once when `showMap`/`showArrow` comes back with no route (`PlanIfShownAgain`); with neither on, `routes.Clear` (which calls `routes.CancelPlan` first, so a plan finishing later can't put the route back).
- **Trap: `partyQuests` and `showUpcomingTurnIns` change what's planned, but `SetSetting` doesn't plan.** The arrow menu plans right after (`routes.SetPartyQuests` in `Routes-Ignore.lua`); an Options switch waits for the signature (which includes both) to change and settle.
- `ns:ApplyProfile` → `routes.ApplySettings`: redraw and plan when wanted, else clear.
- **Arrow position** is presentation, account-wide so no profile change moves it: `ns.db.global.routesArrowPoint`, no default, saved as `{ "TOP", "BOTTOMLEFT", x, y }` so the list grows downward from the arrow's top middle. Offsets are screen units (frame offset × scale) and `PlaceFrame` divides by scale, so Arrow Size never moves it. Unsaved: `PlaceFrame`'s default spot above `UIParent`'s center. Reset: `routes.ResetArrowPosition` (behind a confirmation).
- **Migrations at `PLAYER_LOGIN`:** `MigrateSettings` (`Routes-Core.lua`, remove after 2026-12-06) moves old account-wide `global.routes` onto the profile, `arrowPoint` to `routesArrowPoint`, dropping keys with no default; Routes Context flags old settings still waiting. `DropRetiredSettings` (`Routes-Core.lua`, remove after 2026-12-07) drops `cycleSeconds` and `enabled`. `PlaceFrame` (`Routes-Arrow.lua`, remove after 2026-12-07) re-saves a spot stored by any point other than `TOP`.

#### Geography

`Routes-Geography.lua`; positions are world yards from HereBeDragons.

- **Zone.** `routes.PlayerZone` climbs from `C_Map.GetBestMapForUnit("player")` out of any `Enum.UIMapType.Micro` map, so a cave still routes the zone around it. `routes.IsUnitOutOfZone(unit)` compares the same way; false where the client can't place either unit (a member in a dungeon the player isn't in) or keeps the map secret (WoW Forever in combat, `ns.IsReadable`).
- **Origin.** `routes.Origin`: the player (`routes.PlayerPosition`) or a ghost's corpse (`routes.CorpsePosition`), with a flag (see Ghosts). The corpse is asked of the ghost's map, then each parent, since the graveyard can be a zone away.
- **`routes.IsInZone(mapID, zone)`** accepts a map whose parents (up to the continent) reach the zone, or whose (0,0) and (1,1) corners both fall on the zone's map. The second covers a city filed under the continent but drawn on a zone (the Exodar on Azuremyst Isle), whose NPCs Questie draws on the zone map, so their turn-ins belong on the route. Cached per zone (asked for every spawn).
- **`routes.IsInstanceMap(mapID)`**: the map or any parent up to the continent is `Enum.UIMapType.Dungeon`. Needed because the game can file a dungeon's map under its entrance zone, which `IsInZone` alone passes. Cached per map.

#### Nodes: Quests Into Route Points

`routes.BuildNodes(yield)` (`Routes-Nodes.lua`) returns nodes, the origin `{ x, y, instance, zone, corpse }` and the pins; nil while Questie isn't ready (`routes.IsQuestieReady`: `Questie.started` and HereBeDragons) or there's no position.

- **Log source.** `routes.QuestLog()` (`Routes-Questie.lua`) maps quest ID → Questie quest from `ns.QuestieLogEntries` (see Questie): on Questie 12.6.3+ a fresh table of each acceptance's `.quest`, skipping quests Questie's database lacks; before, Questie's own table.
- **Trap: never `pairs` the log across a yield.** Before 12.6.3 it's Questie's live table, which can change while a yield waits. `BuildNodes` and `routes.BuildCamps` walk `routes.LoggedQuestIDs(log)` (`Routes-Planner.lua`); `routes.PartyQuests` lists the party's quest IDs first the same way.

What each quest contributes, by `routes.QuestState` (`quest:IsComplete()` in a `pcall`: 1 done, -1 failed, 0 not yet):

- **0:** each objective not `Completed` → `"objective"` node keyed `questID:o<index>`; Questie's `SpecialObjectives` → `questID:s<index>`. No node for an objective with no spawns yet or on the ignore list (Routes Context counts those waiting on spawns).
  - With `showUpcomingTurnIns`: a `"turnIn"` node not `ready`, `requires` = its objective nodes, so the solver places it after them. None when any objective left has no node (the route couldn't finish the quest), nor for an instance quest. Never pinned (`IsPinnable`), so standing at its NPC doesn't put it first. Marker uses Questie's `ICON_TYPE_INCOMPLETE`.
- **1:** `"turnIn"` node `questID:turnIn`, `ready`, no requirements. Places: every spawn of every NPC/object in `Finisher` (`routes.ForEachFinisher`, `QueryNPCSingle`/`QueryObjectSingle`).
- **-1:** nothing, so a failed escort or timed quest drops off.
- **Turn-ins need the game's own log** (`routes.IsOnQuest`: `C_QuestLog.IsOnQuest`, else `GetQuestLogIndexByID`, else Questie's word): Questie can still list a quest a moment after turn-in or abandon, and only the player can hand in.

Quest kinds, cached until the quest log settles (`routes.ForgetQuestTags`, from the planner's `QUEST_LOG_DELAY` timer) because the client learns a tag only once it has loaded the quest:

- **Dungeon/raid** (`routes.IsInstanceQuest`): tag is `DUNGEON` or `RAID` in `ns.QUEST_TAG_SUFFIXES`, Questie's `QuestieDB.GetQuestTagInfo` first (its corrections), then `ns.GetQuestTagByID`. Questie gives up on a tag after one retry and caches "none", so the client's answer catches late loads; a quest with no tag from either isn't cached, so the signature replans once it loads. Objectives left off (inside the instance; Questie's icons for them stay). Its turn-in is a node only at places out in the world: `AddSpawns` with `outdoors` drops spawns on `routes.IsInstanceMap` maps. Outdoor turn-in blobs cache under their own version so a tag that loads late doesn't keep the old blobs.
- **Escort** (`routes.IsEscort`): Questie's `questTagIds.ESCORT`, or the `PARTY_ACCEPT` bit of `questFlags`, because most Classic escorts carry no tag.
- **Timed** (`routes.TimedQuests`): from the client, never cached (a timer starts/ends with no change Questie sees). WoW Forever: `C_QuestLog.GetQuestTimers`. Elsewhere: `GetQuestTimers` + `GetQuestIndexForTimer` + `GetQuestLogTitle`'s quest ID, so the log's selection is never touched.
- A timed or escort quest not failed marks its nodes `urgent` with `turnInDistance` (yards to its nearest turn-in blob in the zone, `math.huge` if none).
- **Party quests** (`routes.PartyQuests(ownLog, yield)`): `"objective"` nodes `questID:p<index>`, `party`, same blobs/candidates; never `urgent`, no turn-in, none for an instance quest.

Which spawns count (`Routes-Blobs.lua`'s `AddSpawns`):

- Questie's `{ [areaID] = { { x, y, phase }, ... } }`, 0–100 scale; negative coordinates (Questie's -1,-1 for unmapped) skipped.
- Counts only where `ZoneDB:GetUiMapIdByAreaId` lands inside the zone (`routes.IsInZone`), on the origin's continent, and `Phasing.IsSpawnVisible` shows it. So the zone a quest is filed under doesn't matter.
- An `"event"` objective's or event-icon spawn's names are dropped (`routes.SpawnName`): they only repeat the objective text.

Caching and order:

- Blobs cache in a weak-keyed table per Questie objective table (per quest for turn-ins), with zone, continent and a version (`routes.CountEntries` of `spawnList`), since spawns don't move. An objective's blobs carry its raw spawns (`blobs.spawns`) for "is the player among them".
- **Trap: nodes are sorted by `key` before anything else**, because Questie's log is a hash and the same quests must give the same route. Then `routes.LinkOverlaps`, then `routes.PinEngaged`, in that order.

#### Blobs and Candidates

`routes.Cluster` (`Routes-Blobs.lua`):

- Points live in flat arrays plus a count (`routes.NewPoints`), not a table each: an objective can have hundreds of spawns and per-spawn tables would dominate a plan's memory.
- Grid of `CLUSTER_RADIUS` squares keyed by number; densest first (ties by position); each untaken square absorbs squares whose middle is within `CLUSTER_RADIUS` of the blob's moving center.
- Last pass sets `radius` (at least `MIN_STOP_RADIUS`) and up to `NAME_LIMIT` sorted names. Returned densest first. Yields every `SPAWNS_PER_YIELD` spawns and after each blob.

`routes.Candidates(blobs, start, penalize)`:

- Up to `MAX_CANDIDATES` densest, the nearest to the origin swapped in for the last if absent.
- Objectives get a `penalty` up to `SPARSE_PENALTY` yards scaled by sparseness vs the densest, added to route length, so a thin camp loses unless on the way. Turn-ins: none.
- `routes.Unworked` (`Routes-Nodes.lua`) first drops camps on `routes.worked` unless none would remain; the node's `blobs` keep every blob so standing in a worked camp is still noticed.
- **Trap: a candidate is the cached blob table itself**, so `penalty` is per-plan state written onto shared data: `Candidates` resets it each plan, then `LinkOverlaps` and `PinEngaged` change it in place.

#### Two Objectives at Once

`routes.LinkOverlaps` (`Routes-Overlaps.lua`), after the sort and before `PinEngaged`, sends the player where one trip does two objectives. Only objective nodes with spawns and a blob.

- **Anchors and riders.** An objective with one blob in the zone can be done in one place only, so it anchors. Another with more than one blob, not `urgent` and not already riding, rides along when it has a spawn within `RIDE_REACH` of the anchor's blob or its blobs name a mob/object the anchor's names. Its only candidate becomes a new point at the anchor's place: no penalty, radius at least `RIDE_RADIUS` and count at least 2 so it's an area (`routes.IsArea`), names from its own nearest blob so the waypoint lists its mobs. `node.rider` = the anchor. The solver puts both at one place and `MakeStops` joins them. (Stolen Silver drops in one Sunscale camp, so Raptor Horns is done there.)
  - Key order decides: a rider follows the first anchor that claims it. A rider can't anchor (one blob vs many).
  - The rider keeps its own `blobs`/`spawns`, so area and pinning checks measure its own mobs; once the anchor is done, the rider plans from its own blobs again.
- **Shared camps.** For every other multi-blob objective, each `Unworked` blob counts other objectives with a blob within `RIDE_REACH`. The most shared joins the candidates (with the sparse penalty it would have had), then every candidate's penalty grows by `SHARED_CREDIT` per objective fewer than that blob serves.

#### Finishing What's Under Way

The shortest trip alone would walk the player out of a half-done camp. `routes.PinEngaged` (`Routes-Pinning.lua`) gives each node that goes first one candidate (penalty zeroed) and makes the rest wait via `node.requires` (`WaitOn`). Distances are from the origin (the corpse for a ghost).

1. **Timed and escort quests.** Every `urgent` node goes first: objectives then turn-in. Several: nearest turn-in first, each waiting on the one before (ties by quest ID; out-of-zone turn-in last). While any is on the route only their nodes can be pinned, and nothing else goes ahead: a timer or escorted NPC won't wait while the route tours the zone. Replanning on movement keeps the order following the player.
2. **What the player is working.** Otherwise every node whose blob the player is in and `IsPinnable` allows is pinned there. `IsPinnable` refuses a turn-in planned ahead; accepts whenever the node is `urgent`, is one place (one spawn, or any turn-in), or this is the first plan in a zone (`routes.start` nil). A spread-out objective is taken only when it's at the last plan's destination (`DestinationKeys`), was pinned already, or is being worked (`IsWorkingOn`); a rider only the first two, since what drops on the way isn't working it. So riding through an area planned for later doesn't take over the route (the arrow lists it under While You're Here). In a blob (`EngagedBlob`) means:
   - **In the objective's area** (`routes.InArea`): within `routes.AREA_REACH` of any spawn, plus `routes.AREA_GRACE` once in. Measures spawns, not blobs, so a zone-wide spread has no gaps; needs more than one spawn (a lone chest is a place). The nearest blob is pinned.
   - **Inside a blob's radius**, plus `AREA_GRACE` once engaged.
   - **Working it:** within `WORKING_REACH` of the blob's edge while its count rose in the last `WORKING_WINDOW`. `routes.NoteProgress` (each watcher check) records rises of `Collected`; a first look isn't progress. Standing in a camp only says "working" while there; loot objects and wandering mobs spread wider, so progress says it too.
3. **Nearby turn-ins.** Unless an urgent quest is on the route, every ready turn-in not pinned with a blob within `TURN_IN_REACH` is pinned to its nearest place, after step 2 and before the rest: a turn-in usually opens the next quest in its chain.

- A step-2 node also gets `node.inArea` when standing in its area (not just working from afar), which lets `MakeStops` join all such areas into one waypoint.
- Pins become `routes.engaged`, by key, `{ blob, collected }` (count when first pinned, kept while pinned): the "was in" state for the next plan's grace. `routes.EngagedSignature(nodes)` lists nodes the player is in now by the same rules, `IsPinnable` included, so walking through a later area doesn't replan; `routes.PinnedSignature()` lists what the plan pinned.
- **Worked camps.** At each plan start `BuildNodes` calls `routes.NoteLeftCamps`: a spread-out objective (more than one blob) not done, whose count rose since pinned and whose camp the player has left (past `EngagedBlob`'s reach with grace, `WORKING_REACH` while working), goes on `routes.worked` by `routes.BlobKey` for `WORKED_MEMORY` (`Routes-Nodes.lua`). Leaving a camp early moves on instead of pointing back. One-place objectives never go on it (nowhere else to do them). `routes.ResetObjectives` (`Routes-Ignore.lua`) clears it with `routes.engaged`, and cancels any plan underway first so one finishing with the old pins can't put them back (see Ignoring and Resetting).

#### Solving the Order

`ns.routesSolver.Solve(start, nodes, yield)` (`Routes-Solver.lua`): open path from the origin; each node picks one candidate (`node.choice`) and comes after everything in its `requires`. Nodes without candidates, and requirements on them, are dropped first.

1. **Cheapest insertion** (`Construct`): over every node whose requirements are placed, every candidate and every slot after its last placed requirement, add the cheapest.
2. **Local search** (`LocalSearch`), up to `MAX_PASSES`, until no move saves more than `EPSILON`. Per pass: `ImproveChoices` (best candidate between neighbors), `TryOrOpt` (move a run of up to `MAX_SEGMENT`, either way round; a single node may switch candidates), `TryTwoOpt` (reverse a stretch). Or-opt and 2-opt take the first improving move, so at most one each per pass.
   - **Trap: moves are weighed and validated (`IsValidMove` via `OrOptIndex`/`TwoOptIndex`) without building the route they'd make.** A large route weighs hundreds of thousands of moves; building each would make over 100 MB of garbage per plan.
3. **Shaking** (`Shake`), for three nodes or more: `min(SHAKES, max(MIN_SHAKES, floor(SHAKE_WORK / count)))` shakes, so longer routes get fewer. Each throws `THROWS` nodes to a random slot their requirements and dependents allow, on a random candidate, searches again, keeps the cheapest. The LCG uses a fixed seed inside `Shake`, so the same quests always give the same route and it never flickers between equal answers.

Cost = path length + each chosen candidate's penalty (`Solver.Cost`).

#### Waypoints

`routes.MakeStops(order, start)` (`Routes-Stops.lua`) folds ordered nodes into `routes.stops`:

- An objective joins the previous waypoint within `MERGE_RADIUS` of its first node's place, or when both are areas the player stands in (`node.inArea`), worked at once however far apart their middles.
- Turn-ins join only other turn-ins within `SAME_PLACE` (the same NPC), so the route hands in one giver's quests at a time; nothing else joins them.
- A ghost's route begins with the corpse, a waypoint of its own (`CORPSE_RADIUS`, inside the client's resurrect reach) nothing joins.
- A waypoint is an `area` when any place is (`routes.IsArea`: count over one and radius over `MIN_STOP_RADIUS`). Radius = largest of its places'; names gather up to `NAME_LIMIT` in a list of its own.
- Shape: `{ x, y, instance, radius, mapID, names, area, turnIns, inArea, corpse, tasks = { node, ... } }`; each node `key, kind ("objective"|"turnIn"|"corpse"), questID, questName, quest, objective, candidates, choice, blobs, spawns, ready, requires, urgent, party, rider, inArea`.
- **Trap: `routes.stops`, `routes.start`, `routes.nodes`, `routes.engaged` and `routes.camps` (see The Zone Map) are assigned together when a plan lands**, so the watcher never compares a new plan's pins with the old plan's nodes.

#### Planning and When to Plan Again

All in `Routes-Planner.lua`.

- **Planner.** A coroutine on a hidden frame: `routes.BuildNodes`, `ns.routesSolver.Solve`, `routes.MakeStops`, `routes.BuildCamps` (`Routes-Camps.lua`). `BuildNodes` returning nil keeps the route already drawn. Each frame the `Yield` passed to every stage yields once the slice passes the budget: `FRAME_SHARE` of the last frame's length, clamped to `MIN_BUDGET`..`MAX_BUDGET` ms (`debugprofilestop`). A share, not a fixed time, because a fixed budget would halve a high-refresh screen's frame rate while planning.
- `routes.RequestPlan` records the signature as it starts. While a plan runs, a request sets `replanQueued` (one more plan after). On a flight path it's dropped (landing plans anyway); in combat it waits (see Combat). Errors go to `geterrorhandler()`; each listener runs in its own `pcall` (`routes.Notify`, `Routes-Core.lua`).
- **Flights.** The watcher reads `UnitOnTaxi("player")` and `InCombatLockdown()` every frame, because no event says reliably when a flight starts (`PLAYER_CONTROL_LOST` precedes `UnitOnTaxi`, and also fires for fears and stuns). Taking off drops any plan (it would set out from the takeoff) and notifies (the arrow hides). Landing counts as a new area. On a flight with no camps yet (logging in mid-flight), a check builds the camps alone (`RequestCamps`/`PlanCamps`), so the map has markers in place of Questie's icons; the route stays undrawn until landing.
- **Watcher.** Runs only while wanted (`UpdateWatcher`, from login). Every `CHECK_INTERVAL`, with Questie ready, out of combat and off a flight, it runs `routes.NoteProgress` and plans when:
  - **The signature changed and settled.** `routes.Signature()` (`Routes-Questie.lua`): each quest's state and instance/timed flags, each objective's done flag and has-spawns, party objective done flags (`routes.PartyProgress`), ignored keys and members, online members in another zone, `showUpcomingTurnIns`, the zone, ghost or alive. Counts and position aren't in it. Questie's data arrives in pieces, so a change plans only when two checks in a row see the same one (`settling`); for `GROUP_SETTLE_DELAY` after the group size changes (`routes:OnGroupRosterUpdate`) it waits regardless, while the new log arrives.
    - **Trap: the signature must never ask Questie's database for spawns.** `PartyProgress` reads only the shared logs; party spawn lists, the slow part of joining a group, are worked out only inside the coroutine (`routes.PartyQuests(ownLog, yield)`), yielding after each.
  - **The player walked into or out of a camp:** `routes.EngagedSignature(routes.nodes)` ≠ `routes.PinnedSignature()` (urgent quests' nodes only, while any).
  - **The player moved far:** `REPLAN_INTERVAL` since the last plan and beyond `REPLAN_DISTANCE` from `routes.start`, or another continent, or no `routes.start`. A corpse start never counts as moved.
- **Events** (Core's dispatcher, owner `routes`):
  - `QUEST_LOG_UPDATE` restarts a `QUEST_LOG_DELAY` timer that, on firing, calls `routes.ForgetQuestTags` and forces the next check, giving Questie time to catch up.
  - `PLAYER_ENTERING_WORLD`, `ZONE_CHANGED_NEW_AREA` → `OnNewArea` (landing too): `routes.CancelPlan` (a finishing plan would restore the old `routes.start`), clear `routes.start`, force a check counted as past `REPLAN_INTERVAL`.
  - `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST` force a check.
  - `GROUP_ROSTER_UPDATE` starts the group hold on a size change. `GROUP_JOINED`/`GROUP_LEFT` clear the ignore list (`Routes-Ignore.lua`) and plan if anything was on it.
  - `PLAYER_LOGIN` (`Routes-Core.lua`) runs migrations and login handlers.
  - `routesMap:OnAddonLoaded` adds the data provider when `Blizzard_WorldMap` loads after login; `routesArrow`'s `GROUP_ROSTER_UPDATE`/`PLAYER_ENTERING_WORLD`/`ZONE_CHANGED_NEW_AREA` re-check hiding; `routesItems` rows belong to the item buttons.
- **Registration.** Core registers an event at `ADDON_LOADED` when any row has a handler by then (before the quest log parts run, and after). Routes' handlers are all file-scope, so with the TOC line they register on every client regardless of the Wide Quest Log switch. `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST`, `BAG_UPDATE_DELAYED`, `BAG_UPDATE_COOLDOWN` and `PLAYER_TARGET_CHANGED` are Routes' alone, and on Classic Era and TBC so is `QUEST_LOG_UPDATE`. `Classic-Quest-Log.lua` defines `ns:OnZoneChangedNewArea` inside its wide quest log part, so there the second pass registers `ZONE_CHANGED_NEW_AREA` with the switch on even without Routes.
- **View paces** (constants in each file): map line `UPDATE_INTERVAL` while the map shows (`Routes-Map-Line.lua`); arrow `TURN_INTERVAL`, `TEXT_INTERVAL`, `LIST_INTERVAL` (`Routes-Arrow.lua`); arrow menu `REFRESH_INTERVAL` while open; item buttons `CHECK_INTERVAL`, `RANGE_INTERVAL` (`Routes-Arrow-Items.lua`); hiding Questie's icons after Questie redraws coalesces to the next frame (`RequestApplyQuestieIcons`).

#### Combat

- **The route freezes.** The watcher's `SetInCombat` (every frame) drops any plan as a fight starts (it would set out from where the fight began) and checks nothing until it ends. `routes.RequestPlan` in combat (a skip, reset, setting) only sets `planAfterCombat`. After the fight it checks at once and plans if a plan was dropped or asked for. Nothing is printed. The planner's `OnUpdate` also returns in combat, covering the frame before the watcher notices. An objective ignored in combat stays at its waypoint until that plan; the arrow menu hides it meanwhile (`routes.skipped`).
- **Full-size map waits.** `KeepFullSize` (`Routes-Map-Size.lua`) never writes `miniWorldMap` in combat.
- **Pins don't pass clicks through.** The map canvas calls `SetPassThroughButtons` on every acquired pin, which WoW blocks in combat, so opening the map in combat would blame the add-on. `PrettyWideQuestLogRoutePinMixin` replaces it with a no-op (as HereBeDragons-Pins does for Questie's pins); safe because waypoint pins handle their own clicks and the line pin takes no mouse.
- **Secret values.** WoW Forever can keep unit maps and connection state secret in combat; `routes.IsUnitOutOfZone` and the party checks (`Routes-Party.lua`) test `ns.IsReadable` first and treat unreadable as in-zone or offline.
- **The arrow keeps working.** An ordinary unprotected frame: it turns, updates and drags in combat toward the frozen route's waypoint.
- **Use Item buttons hold still.** Secure, so in combat they keep item and place; one whose quest moved, or whose arrow moved or hid, fades until `PLAYER_REGEN_ENABLED` (see The Quest Arrow's Item Buttons). Nothing secure is ever anchored to the arrow, so it stays unprotected.

#### The Zone Map

`Routes-Map.lua`: a `MapCanvasDataProviderMixin` provider on `WorldMapFrame`, added at login or on `ADDON_LOADED` for `Blizzard_WorldMap` (loads on demand on some clients). Helpers in their own files, loaded first by `Routes.xml` and captured by value at load: `Routes-Map-Line.lua` (line), `Routes-Map-Questie-Icons.lua`, `Routes-Map-Blizzard-Quests.lua`, `Routes-Map-Tooltip.lua`, `Routes-Map-Size.lua`.

- Nothing draws with `showMap` off (`routes.IsMapShown`).
- The route (line + waypoints) draws only on its zone's map or a cave/building/city inside it (`IsRouteMap`, `routes.IsInZone`), and never on a flight path (`routes.IsOnTaxi`): the route is replanned from where the player lands, so mid-flight every map shows camp markers alone.
- Every map, continent's included, shows the camps.
- Positions come from `GetZoneCoordinatesFromWorldInstance` with positions past the map allowed: a waypoint off the map shown gets no marker, but the line still runs to it.

Camps (`Routes-Camps.lua`, `routes.camps`):

- `routes.BuildCamps` runs at the end of every plan, inside its coroutine, and its result is set along with the waypoints. Quest IDs are listed first (`routes.LoggedQuestIDs`), since Questie's log can change while a yield waits.
- A camp is a blob of one objective's spawns across the whole continent (`routes.AddWorldSpawns`, by world instance), shaped as a waypoint with `camp = true` and one task whose only candidate is the camp. So marker, tooltip and Questie hiding treat it as a waypoint.
- Dungeon/raid spawns (no world map shows them; Questie keeps most at -1, -1) go at the instance's entrances (`ZoneDB:GetDungeonLocation`), one count per spawn per entrance, so the camp keeps the spawns' weight. Other spawns on an instance map (`routes.IsInstanceMap`) are left out.
- Blobs cached in a weak-keyed table: by objective (versioned by `routes.CountEntries` of its spawn list) and by quest for a turn-in. A quest left behind lets go of its camps.
- Covers: each objective not done of the player's quests; each done quest's turn-in while `routes.IsOnQuest` agrees; with `partyQuests`, objectives of party quests from members not left out. A dungeon/raid quest's objectives get camps at the entrance marked `untracked` (the route never goes in); a party member's dungeon/raid quest gets none.
- An ignored objective keeps its camps: ignoring takes it off the route, not off the map.
- One marker per objective or turn-in per map, never one per camp. `Gathered` takes the camp with most spawns within `GATHER_REACH` and places the marker at the spawn-weighted middle of those camps, naming up to `routes.NAME_LIMIT`. If that middle falls just off the map, the objective's first camp on the map is used. Why: an objective spread thin reads as one marker in the thick of it.
- On the route's map, an objective with a waypoint gets no camp marker (the waypoint stands for it); one without (ignored, or route running to the corpse) draws at `CAMP_ALPHA` behind the waypoints. Untracked markers aren't dimmed; their ring says so. Other maps: full strength.
- Right-click on a camp (`RightClick`) ignores its objective (`routes.IgnoreTask`) or puts an ignored one back (`routes.UnignoreTask`); none for an `untracked` one.

Frame levels (`AddFrameLevels`):

- `PIN_FRAME_LEVEL_PWQL_ROUTE_LINE` below `PIN_FRAME_LEVEL_AREA_POI` (where HereBeDragons-Pins puts Questie's icons), `PIN_FRAME_LEVEL_PWQL_ROUTE_STOP` above it, `PIN_FRAME_LEVEL_PWQL_ROUTE_CAMP` just below the waypoints.
- Each insert in a `pcall`, falling back to `AddFrameLevel` on a map without that level.

The line (`PrettyWideQuestLogRouteLinePinTemplate`, `routes.RouteLinePinMixin` in `Routes-Map-Line.lua`):

- One canvas-sized pin that takes no mouse, so map drags and icon hovers pass through.
- Each leg is a `Line` with `Route-Dot` repeated, colored `ROUTE_LINE` at `lineOpacity`. A leg with an end on another continent hides.
- `LINE_WIDTH` and `DOT_SPACING` are divided by canvas scale on every zoom (`OnCanvasScaleChanged`) so they hold on screen.
- Dots march by sliding tex coords by `GetTime() * lineSpeed`: `lineSpeed` is dots per second, 0 holds still.
- First leg runs from the player's live position, moved every `UPDATE_INTERVAL` by the pin's `OnUpdate`, reusing one table (hot path while the map is open).
- `showLine` off: the pin gets no positions; markers only, nothing follows the player.

Markers (`PrettyWideQuestLogRouteStopPinTemplate`; `STOP_SIZE`/`STOP_ICON_SIZE` must match `Routes.xml`):

- `Route-Stop` disc tinted by the first task (`routes.TaskColor`).
- Icon: Questie's own for that objective/turn-in, taken from Questie's pin on the map shown (`routes.QuestieTextures`). If Questie hasn't drawn yet (it draws a while after a quest changes), `QuestieIcon` picks from `Questie.usedIcons` by icon type in the player's theme: the objective's `Icon`, else the first spawn's. Turn-in: `ICON_TYPE_INCOMPLETE` when planned ahead of being done (`showUpcomingTurnIns`), else `ICON_TYPE_COMPLETE`. Camps never hold an upcoming turn-in. Corpse: `routes.CORPSE_ICON`/`CORPSE_ICON_COORDS` (`Routes-Stop-Lines.lua`), the game's own gravestone cell.
- Ring, checked in order, swaps the disc for `Route-Stop-Fill` under a tinted `Route-Stop-Ring`: `IsUntracked` (every task `untracked` or on the ignore list) gets `ROUTE_ALERT_RING`; else `IsPartyStop` (every task a party member's) gets `ROUTE_PARTY_RING`; any of the player's own routed tasks keeps the disc's black ring.
- Size: `markerScale * UIParent:GetEffectiveScale() / map:GetEffectiveScale()`, times `WIDE_MAP_SCALE` on continent-or-wider maps (`IsWideMap`). `SetScalingLimits` only sets how fast a pin grows with zoom, so `markerScale` must go into the size. The effective-scale ratio is why markers look the same on every client (Classic Era/TBC draw the full-size map at a larger scale).
- Pins are recycled: every acquire sets alpha, frame level, textures, tex coords and ring, never only what differs from default.

Hovering a marker (`OnStopEnter`):

- Tooltip body: `routes.AddStopTooltip` (`Routes-Map-Tooltip.lua`), built from `routes.QuestsAt`/`routes.QuestObjectives` (`Routes-Stop-Lines.lua`). Each quest title nearest first, a blank line between quests, then its objectives at that waypoint, done or not, in log order: `ROW_INDENT`, `ns.CheckIcon` (or a same-size blank so names align), name, count on the right; done ones in `HELP`.
- With `routes.ShowsParty`: each quest split by player: the player first where it's their quest, then each sharing member (`routes.MemberProgress`, `routes.MemberObjective`), each under their name in class color (`routes.ClassColor`, white for a secret class), blank line between. Alone or with `partyQuests` off, no names.
- Only a turn-in left: one gold `ROUTES_TURN_IN_QUEST` line.
- Then blob names under a gold `ROUTES_LOOK_FOR` heading, one per line (grows down, not wide), then click hints (`routes.AddClickHints`).
- Sets `routes.hoveredStop`, which brings back Questie's icons for its tasks. `RemoveAllData` clears it: a pin can vanish under a mouse that never leaves it.

Clicking (`OnMouseUp`; pins aren't buttons): right-click on a waypoint ignores it whole (`routes.SkipStop`), on a camp works one objective (above), on the corpse nothing. Middle-click on any marker: `routes.ResetObjectives`.

Questie's icons (`Routes-Map-Questie-Icons.lua`):

- With `showMap` and `hideQuestieIcons`, `ApplyQuestieIcons` hides HereBeDragons pins (`HereBeDragonsPinsTemplateQuestie`) on every map whose icon is for something on the route or a camp, except the hovered marker's, plus every party member's objective icon (`IsPartyIcon`, `ObjectiveData.IsPartyObjective`): the route draws the ones it plans and leaves the rest out on purpose. Shows again what it hid (`pin.hiddenByRoute`). Available-quest icons are never touched.
- Matching: objective by Questie's objective table; party objective also by `routes.PartyObjectiveKey(questID, index)` (Questie's party icons hold an objective of its own making); turn-in by quest ID (`data.Type == "complete"`).
- Questie never shows/hides those pins itself, so its icon state is untouched and a recycled pin shows on its own.
- Re-apply triggers: post-hooks on the pin library's `worldmapProvider.RefreshAllData` and `HandlePin`, coalesced to one next-frame pass (`RequestApplyQuestieIcons`). `HandlePin` also checks the just-placed pin at once (`routes.ApplyToPlacedQuestieIcon`, pin found as `icon:GetParent()` with `pin.icon == icon`): Questie redraws party icons whenever progress arrives, and a frame's delay flashes them. The route/hover sets are rebuilt at most once a frame (`Sets`, keyed by `GetTime()`), since Questie places a batch at a time.
- Every provider redraw re-applies before it checks `showMap`, and a listener call re-applies with the map closed, so turning the route off brings icons back.

Blizzard's quest markers and objective areas (`Routes-Map-Blizzard-Quests.lua`):

- Why: WoW Forever's world map draws its own quest markers (`QuestDataProviderMixin`) and objective areas (`QuestBlobDataProviderMixin`) while the `questPOI` CVar is on; Questie flips that CVar per objective style, so the same objective could show two or three times under the route.
- `HookBlizzardQuests`, once from `AddToWorldMap`, finds those providers in `WorldMapFrame.dataProviders` by `IsFromMixin` (most of the mixin's functions are the provider's own, so one another add-on post-hooked still counts) and `hooksecurefunc`s each `RefreshAllData`. Clients without the mixins find none.
- `ApplyBlizzardQuests`, with `showMap` and `hideQuestieIcons` and anything on route/camps: hides marker pins (`GetPinTemplate()`) whose `questID` is a route/camp quest, objectives and turn-ins alike, and the objective layer's single `provider.pin` (draws every quest's area at once). Otherwise shows what it hid. Hover brings back Questie's icons only.
- Only `Hide`/`Show`; no Blizzard function or field written; hidden pins kept in its own weak table. So the map stays untainted, a pooled marker shows on its own, and it works in combat.
- `questPOI` itself is never touched: tracker, minimap and Questie's objective style (`QuestieOptionsUtils.DetermineTheme` reads it) stay as the player set them, and nothing needs restoring after a crash.
- Hooks coalesce to next frame (`RequestApplyBlizzardQuests`); the route's own redraw and listener call apply at once.
- The add-on's own quest map (`Forever-Quest-Map.lua`) keeps its own objective-area layer, unaffected.
- `routes.BlizzardQuestLayers` feeds Routes Context (with the `questPOI` CVar).

Full-size map (`Routes-Map-Size.lua`):

- With `fullSizeMap` and `showMap`, `routes.KeepFullSize` writes the map's own `miniWorldMap` CVar to `"0"` when it reads true; every client's map reads it on open to maximize. Silent, never in combat, through `ns.TrackerTaintStep` (logged by the tracker taint watch).
- Never calls the map's `Maximize`: that runs Blizzard's panel layout (`SetUIPanelAttribute`, `MaximizeUIPanel`) as add-on code.
- Map add-ons don't block it: Leatrix Maps and Mapster never read `miniWorldMap` and keep a scale/position per size, applied on `SynchronizeDisplayState`.
- Runs at login, on the world map's `OnHide` (a map the player shrank opens full next time), and on every listener call.

#### The Quest Arrow

Files: `Routes-Arrow-Survey.lua` looks around (`routes.ArrowSurvey`, `routes.ArrowNearestPlace`); `Routes-Arrow.lua` builds `PrettyWideQuestLogRouteArrow`, points it and decides when it shows; `Routes-Arrow-List.lua` lays out lines on pieces handed over in `routes.arrowParts`/`routes.ARROW_LAYOUT`; `Routes-Arrow-Item-Choice.lua` + `Routes-Arrow-Items.lua` add Use Item buttons; `Routes-Arrow-Menu.lua` the hover menu; `Routes-TomTom.lua` stands TomTom's arrow down.

- Frame: a `WIDTH`-wide button at `MEDIUM` strata, clamped. Arrow texture `ARROW_SIZE`, drawn pixel for pixel, anchored by its middle so the eye breathes in place. Distance line `SPACE.LINE` under the arrow's square (not under the art: turned, a corner reaches nearly to the square's edge). Distance via `routes.YardsText` in `HELP`; what the eye says replaces it, in `INFO`.

When it shows (`Refresh`):

- `showArrow` and a route; not on a flight path (`routes.IsOnTaxi`), not in a raid with `hideInRaids`, not in an instance with `hideInInstances` (`IsAway`): there it isn't questing.
- Runs on every listener call and on `GROUP_ROSTER_UPDATE`, `PLAYER_ENTERING_WORLD`, `ZONE_CHANGED_NEW_AREA` after login. Applies `arrowScale` when it changes (tracked in `appliedScale`: `GetScale()` returns a rounded value) and re-places the frame, since the saved spot is in screen units. Shown: zeroes timers so the new waypoint draws at once. Hidden: clears `routes.arrowTarget`/`routes.arrowNext`.

What it points at (`Survey`, every `LIST_INTERVAL`, while the player has position and facing on the route's continent):

- The route's target waypoint is the first with a task left.
- Every task left whose area the player is in (`routes.InArea`, held by `routes.AREA_GRACE` via `hereKeys`) is work (`here`) if at that waypoint or pinned (`routes.engaged`), else on the way (`passing`). Only an objective of more than one spawn has an area; a turn-in or lone chest is never work.
- `destination`: first waypoint with tasks left that aren't work; `afterDestination`: the next one with tasks left.
- Route starting at the corpse: nothing is work or passing; corpse is destination; nothing after.
- No survey answer: destination is the route's first waypoint.

Working an area: the eye (`Route-Eye`, upright, `INFO`, breathing by `BREATH_GROWTH` over `BREATH_PERIOD`), "Current Objective Area", the work listed, and a note (`AreaNote`) `SPACE.LINE` under, silver:

- "Finish Here Before Moving On": any of the work has only one blob in the zone.
- "More Along the Route": for every one, the route passes more of its spawns later, within `routes.AREA_REACH` of a later leg, excluding those within the waypoint's radius plus `AREA_REACH` (`MoreAhead`, cached per plan by the `routes.stops` table).
- Else nothing.

Otherwise the arrow points at the destination. Either way, passing objectives list dimmed under "While You're Here".

With `showNextObjective`, the list ends with the Next Objective: in an area, the destination; else `afterDestination`. Its own `NEXT_ARROW_SIZE` arrow aims at the corpse itself or the nearest place left there. Off: `routes.arrowNext` stays nil.

How it points (`Point`, the frame's `OnUpdate`):

- Turns every `TURN_INTERVAL`; distance rewritten every `TEXT_INTERVAL`.
- Aims at the nearest place still to do at the waypoint, or the nearest edge of an area (`NearestPlace`), `HBD:GetWorldVector` minus `GetPlayerFacing()`.
- Color by angle (`Shade`): `ARROW_ON_COURSE` within `ON_COURSE`, `ARROW_TURN` out to `OFF_COURSE`, `ARROW_WRONG_WAY` beyond; each boundary blends over `BLEND` so band middles stay solid and nothing snaps.
- Color is measured from `ColorHeading`, not always facing: the facing, unless the player's travel direction (`TravelHeading`, over `HEADING_WINDOW` from samples every `SAMPLE_INTERVAL`) differs by more than `FACING_TRUST`, then the travel direction. Why: backing up or strafing toward the target shouldn't read red; facing is kept otherwise because it answers a turn at once while travel lags. Movement under `MIN_TRAVEL` is standing; over `MAX_TRAVEL` is a teleport/load. Samples reset on an instance change. Rotation always uses facing. `routes.arrowColoredBy` reports which (Routes Context).
- The Next Objective's arrow turns and colors the same way.
- Within `SPOT_REACH` of a single place: eye, "You're There". At the corpse it keeps pointing and says "You're There" within the corpse waypoint's radius (`CORPSE_RADIUS`, `Routes-Stops.lua`).
- No position on that continent or no facing: arrow hides, distance blank, list stays. Waypoint on another continent: `ROUTES_OTHER_MAP` sits where the arrow would be.
- `showDistance` off: yards blank (Next Objective's too); eye labels still show.
- Ordinary unprotected frame: all of this keeps running in combat, toward the frozen route's waypoint.

Interaction:

- Drag moves it unless `lockArrow`, and closes the menu. On drop `HoldByTop` anchors `"TOP"` to `UIParent`'s `"BOTTOMLEFT"` so the list grows below a still arrow (`StopMovingOrSizing` alone anchors by the nearest corner and would move the arrow whenever the list changes height). Saved in screen units (offsets times scale) via `routes.SetArrowPoint` to `ns.db.global.routesArrowPoint`, account-wide, so profile changes never move it. `PlaceFrame` re-saves a spot saved by another point (migration). No spot: above screen center.
- Mouse over opens the menu unless dragging. Middle-click: `routes.ClearIgnored`.

TomTom (`Routes-TomTom.lua`):

- While the arrow shows (its `OnShow`/`OnHide` hooks), TomTom's own quest-objective waypoint feature (`"poi"`) is suppressed through TomTom's public `SuppressFeature`/`ReleaseFeature`, owner `L["ADDON_TITLE"]`. Why: two arrows pointing at different places. Suppression lasts the session only and leaves TomTom's saved settings alone.
- Only a real TomTom (has `IsCrazyArrowEmpty`, `SuppressFeature`, `ReleaseFeature`); other add-ons make a `TomTom` table of their own. `TomTom` is in every TOC's `OptionalDeps`.

#### The Quest Arrow's List

`ListQuests` (`Routes-Arrow-List.lua`, exported as `routes.ListArrowQuests`). Lines for one waypoint come from `routes.ForEachStopLine` (`Routes-Stop-Lines.lua`); the map tooltip has its own builder (`Routes-Map-Tooltip.lua`).

- `showQuests`: each quest at the waypoint, nearest first: title (`routes.QuestTitle`: tag letter from `ns.GetQuestTagByID`/`ns.QuestSuffix`, falling back to Questie's tag) in difficulty color, `GameFontNormal`; then, indented `SPACE.NEAR`, its objectives still to do there, nearest first, `GameFontHighlight`, count (`routes.CountText`) on the right in silver. No level: name alone in gold.
- `routes.ShowsParty`: each objective lists who still needs it, indented a further `SPACE.NEAR`: the player first where it's their quest, then each member (`routes.MemberProgress`) in class color with their own count. Anyone done is left off; the objective then has no count of its own.
- Turn-in only: one gold "Turn in [n] Name" line. Corpse: one line, gravestone sized to `GameFontNormal` + `ROUTES_CORPSE`.
- Past `questsListed` quests, a silver `ROUTES_MORE_TASKS` line, flush with titles (it stands for whole quests).
- Passing objectives: under a silver "While You're Here" heading led by an `ICON_SIZE` blue eye, at `DIM_ALPHA`; only with `showQuests`.
- Next Objective last, at `DIM_ALPHA`: silver heading, then only its first quest with objectives/counts/party names. Lines sit right of a column holding its arrow (level with the heading, full color) and its dimmed distance. Column width is that of `routes.YardsText(9999)` (or `NEXT_ARROW_SIZE`) plus `SPACE.GROUP`, so the block holds still as distance counts down.
- Spacing: `SPACE.GROUP` above each quest, heading and more-line; `SPACE.NEAR` under a heading (as the quest page); `SPACE.LINE` between a quest's lines. Titles and the rest are the same size: color, dimming and space carry hierarchy.
- Block left-aligned, width of the widest line rounded up to a whole pixel, centered under the arrow, lines cut past `WIDTH`. Counts align on the block's right edge, at least `SPACE.GROUP` from the text. The distance line keeps its room while blank, so the list doesn't jump on arrival.
- Layout keyed by every line's kind, text, colors, count, dim, icon, column, quest ID, plus the note: an unchanged second lays nothing out.
- Records each quest title's place for the item buttons (`routes.arrowTitleRows`, below); `ForEachStopLine` passes the quest ID as a title line's seventh value for this.
- Hit rect inset to arrow and block (`frame.hitInset`, also read by `routes.IsMouseOverArrow`), so the empty width passes the mouse through.

#### The Quest Arrow's Item Buttons

Use Item buttons beside the quests listed where the player is (the waypoint and "While You're Here"), as Questie's tracker has them, so the tracker isn't needed. Gated by `showItemButtons` (Quest Arrow panel, hidden with `showQuests` off). `Routes-Arrow-Item-Choice.lua` says which and where (`routes.WantedItemButtons`); `Routes-Arrow-Items.lua` owns the buttons.

Which items (per quest, up to `ITEMS_PER_QUEST`, in Questie's tracker order):

- The client's quest item, `GetQuestLogSpecialItemInfo(logIndex)` (feature-tested; Classic Era and TBC lack it), while in the bags. Once the quest is done, only if its `showItemWhenComplete` return says so.
- Then, while not done, items Questie's database names (`QuestieDB.GetQuest`): `sourceItemId`, `requiredSourceItems`, `ObjectiveData` entries of `Type` `"item"`. Each only while owned (`GetItemCount`, which counts equipped) and usable (`GetItemSpell`) or wearable (`IsEquippableItem`). The database list is cached per quest.
- Player's own quests only (`routes.IsOnQuest`, not `quest.party`): only the player's bags count. One item shared by two quests shows once.

Where:

- `routes.arrowTitleRows`: `rows` of `{ questID, top, room, dim }`, block `right` edge, `version` bumped per layout. The Next Objective's quest gets no row: the player isn't there.
- Button at `SPACE.NEAR` past the block's right edge, level with the title less `SPACE.TIGHT`; a second `SPACE.LINE` further. `BUTTON_SIZE` when the quest's lines leave room, else `SMALL_BUTTON_SIZE`, so a one-line quest's button clears the next quest's. Dimmed rows dim their buttons (`DIM_ALPHA`).
- `SecureActionButtonTemplate` (`type1` `"item"`, `item1` `"item:<id>"`), parented and anchored to `UIParent`, never to the arrow: a protected frame under or anchored to the arrow makes the arrow protected, and it couldn't move or hide in combat. Placed by the arrow's `GetLeft`/`GetTop` at the arrow's scale. A hook on the arrow's `OnUpdate` re-picks every `CHECK_INTERVAL` or when `version` changes, and re-places on any frame the arrow moved or rescaled (follows a drag). Arrow `OnHide` clears them. Clamped to screen.

Combat:

- Out of combat everything is set (`SetUp`, `Clear`). In combat item, size, place and visibility can't change, so `Sync` only compares: a mismatched button (item, place, or arrow moved/hid) fades to `STALE_ALPHA` and still uses its item. `routesItems:OnPlayerRegenEnabled` catches up if anything waited.
- Count (shown above 1), cooldown (`CooldownFrameTemplate`, `BAG_UPDATE_COOLDOWN`) and range tint are plain regions, so they update in combat. Used up in combat: desaturated until it can hide.
- Range: icon tinted `ARROW_WRONG_WAY` while `IsItemInRange(item, "target")` is false, every `RANGE_INTERVAL` and on `PLAYER_TARGET_CHANGED`. Not asked for a friendly target in combat (client won't answer). Secret values on WoW Forever (cooldown, range, friendliness) leave the display as it was: nothing may test them.

Clicking and the key:

- Left-click uses the item. Acts on the up half regardless of `ActionButtonUseKeyDown` (`RegisterForClicks("AnyUp", "AnyDown")`, `useOnKeyDown` false), so a macro's `/click` (up only) works too.
- `Bindings.xml` (loaded by the client itself, never in the TOCs) declares `CLICK PrettyWideQuestLogQuestItem1:LeftButton` (`routes.USE_ITEM_COMMAND`). `BINDING_HEADER_PRETTYWIDEQUESTLOG` and its `BINDING_NAME_` global are set in `Routes-Arrow-Items.lua`. Button 1 is created at load so the binding always finds it; others are made out of combat as needed and kept.
- Tooltip: item (`SetHyperlink`), then click hints, plus the bound key on button 1.
- `routes.ItemButtonsState` feeds Routes Context.

#### The Quest Arrow's Menu

`Routes-Arrow-Menu.lua` builds `PrettyWideQuestLogRouteMenu` at `DIALOG` strata. Plate: `Route-Menu.tga` drawn at `PLATE_SCALE` (sharp edges), nine-sliced with `PLATE_CORNER` corners so they never stretch, reaching past the menu by `PLATE_MARGIN` (its shadow).

- Opens under the list, or above the arrow when the arrow sits in the lower half of the screen, `SPACE.NEAR` away.
- Stays open while the mouse is over the arrow (`routes.IsMouseOverArrow`) or menu; closes `CLOSE_DELAY` after leaving both, at once when the arrow hides, and on Escape (`UISpecialFrames`).
- Rows, groups split by `SEPARATOR` lines:
  - Header: `TAB_QUEST_ARROW`, `ADDON_SHORT_NAME` muted.
  - `ROUTES_MENU_IGNORE` (label from `routes.TaskLabel`) for each task left at `routes.arrowTarget` and not already ignored, in the list's quest order, objectives in log order then turn-in; then the same for `routes.arrowNext`. A task in both offered once. None for the corpse. Ignored ones are filtered here because an ignored task stays at the waypoint until the next plan, which in combat waits for the fight to end.
  - Show Next Objective (`showNextObjective`, `routes.SetSetting`); off removes the Next Objective and its Ignore rows.
  - Show Upcoming Turn-Ins (`showUpcomingTurnIns`): `routes.SetSetting` then `routes.RequestPlan`, since it changes the route (it's in the signature).
  - Party only (`routes.IsInParty`, not raid): Show Party Objectives (`partyQuests`, `routes.SetPartyQuests`). On: each member (`routes.PartyMembers(true)`, offline included) as `ROUTES_MENU_MEMBER_OBJECTIVES` in class color, On/Off (`routes.SetMemberIgnored`). Unclickable status row instead, checked in order: Offline; No Questie (`routes.MemberHasQuestie`); Out of Zone (`routes.IsUnitOutOfZone`). The row keeps its place for when that changes.
  - Ignore list (`routes.IgnoredTasks`, ignore order), "Ignored" in `OFF`; click puts it back (`routes.UnignoreTask`).
  - Hints: Drag (only unlocked), Middle-Click clear ignore list.
- Rows are a line plus `SPACE.LINE` above/below; min `MIN_WIDTH`. Only actionable rows take the mouse; highlight at `HIGHLIGHT_ALPHA`.
- Refreshes every `REFRESH_INTERVAL` while open, on listener calls, after a click. Layout keyed by each row's kind and text. Actions rebound every refresh: a new plan makes new task tables.

#### Party Members' Quests

With `partyQuests`, in a party but not a raid (a raid's quests would swamp the route), `routes.PartyQuests` (`Routes-Party.lua`) reads `QuestieComms.remoteQuestLogs` (quest → member → objective `fulfilled`/`required`/`finished`).

- A quest some sharing member has and the player doesn't becomes a Questie-shaped quest (`party = true`, name/level from `QuestieDB.GetQuest`). Quest IDs listed before any work: Questie can add to its logs while a yield waits.
- A member counts (`IsSharing`) while not left out (`routes.ignoredMembers`), present (`IsPresent`: online and in the player's zone, cached once a frame since the arrow asks per quest and objective), and not hiding the quest (`CommsVisibility.ShouldShowPartyObjective`, `pcall`). A connection WoW Forever keeps secret in combat counts as offline. `routes.IsMemberOutOfZone`/`IsUnitOutOfZone` count a member as in zone when either map is unknown (dungeon) or secret.
- Objectives built once per index from `ObjectiveData`, yield after each (spawn list builder is the slow part): description from text or target name (`QueryNPCSingle` for monster/killcredit, `QueryObjectSingle`, `QueryItemSingle`); color from `QuestieLib:ColorWheel()`; `spawnList` from `QuestieQuest.private.objectiveSpawnListCallTable[Type]`.
- Count: fewest any still-needing member has; done when none needs it. `members`: sorted names still needing it.
- Quests kept while any member has them, so objective tables and their cached blobs last between plans.
- `routes.PartyProgress`: same progress without touching Questie's database, cheap enough for every check. The signature and ignore-list filter use it, never `routes.PartyQuests`.
- `routes.MemberHasQuestie(name)`: an entry under their name or short name in `remotePlayerClasses` or any `remoteQuestLogs` quest. The game tells nothing of others' quests, so a member without Questie adds nothing; one with no quests or no share yet reads the same.
- `routes.QuestieHasUnitOnQuest(unit, questID)`: for the quest list's party count (`Forever-Quest-List.lua`), independent of `partyQuests`; Questie's shares reach any distance, the game's only in range.
- Names (`routes.UnitFullName`): first name without realm, except WoW Forever (`ns.FLAVOR`), where `UnitName`'s second return is a surname and Questie keys "First Surname". Secret name gives nil. Questie keys compared after `Ambiguate(name, "short")`.
- Nodes and camps keyed `questID:p<index>`, marked `party`. Dungeon/raid quests left out. Turn-ins never routed (only the player can turn in); progress not noted for "working on it" (`routes.NoteProgress` reads only the player's log).
- Map: Questie's icons for every party objective are hidden with the route (see The Zone Map); marker ring `ROUTE_PARTY_RING`.

#### Ghosts

While a ghost, `routes.Origin` (`Routes-Geography.lua`) starts from the corpse (`routes.CorpsePosition`):

- `C_DeathInfo.GetCorpseMapPosition` asked of the ghost's map then each parent (graveyard can be a zone away). Outside 0-1, or 0,0, is no answer.
- Zone: deepest map at the corpse (`C_Map.GetMapInfoAtPosition`), raised from cave/building to zone.
- Route covers the corpse's zone, first waypoint the corpse (`routes.MakeStops`, radius `CORPSE_RADIUS`). `PlayerMovedFar` (`Routes-Planner.lua`) never replans for moving: the corpse stays put.
- Client won't say (corpse in a dungeon): route starts from the player.
- Signature ends "ghost"/"alive"; `PLAYER_DEAD`, `PLAYER_ALIVE`, `PLAYER_UNGHOST` bring the next check forward (`routes.OnPlayerDead` etc.), so release and resurrect both replan.
- Corpse can't be ignored: `routes.SkipStop` passes over it (silent when it's all a waypoint holds), `routes.IgnoreTask` refuses it, no right-click, no menu row.

#### Ignoring and Resetting

`Routes-Ignore.lua`. `routes.skipped`: task key → `{ label, questID, order }` (`routes.TaskLabel`, quest, ignore order for the menu). Every path goes through `Ignore`, which leaves an existing entry alone.

- `routes.SkipStop(stop)` (waypoint right-click): ignores each non-corpse task, prints `ROUTES_SKIPPED` with Questie links (`routes.QuestLink`, `Routes-Core.lua`, `QuestieLink` in a `pcall`, else the name).
- `routes.IgnoreTask(task)` (menu, camp right-click): one task, prints via `routes.BuildIgnoredMessage` (also drawn by the Quest Arrow panel's Example).
- `routes.UnignoreTask(key)`: prints `ROUTES_UNIGNORED`.
- `routes.IgnoredTasks()`: menu list sorted by `order`, only where the player still has the quest (for a `:p<index>` key, the party per `routes.PartyProgress`). Gone quests stay in `routes.skipped`, unlisted.
- `routes.ClearIgnored()` (arrow middle-click): empties `routes.skipped`, prints `ROUTES_IGNORE_CLEARED`. Ignored members, `routes.engaged`, `routes.worked` stay.
- `routes.SetMemberIgnored(name, ignored)`: leaves out every quest a member shares (`routes.ignoredMembers`, checked in `IsSharing`). Quests the player also has stay, minus that member's name.
- `routes.SetPartyQuests(on)`: switches `partyQuests` and replans.
- Ignored keys and members are in the signature, never saved; they last until cleared, reset, reload, or a group change.
- `GROUP_JOINED`/`GROUP_LEFT` (`routes:OnGroupJoined`/`OnGroupLeft`) empty both lists (the party they were ignored in is gone). Prints `ROUTES_GROUP_JOINED_CLEARED`/`..._LEFT_CLEARED` and replans only when something was ignored, so a login in a group says nothing. `routes.engaged` stays.
- Every call plans through `routes.RequestPlan`, so in combat it takes effect after the fight (see Combat).

`routes.ResetObjectives` (middle-click on any map marker): clears `routes.skipped`, `routes.ignoredMembers`, `routes.engaged` and `routes.worked`, so only a camp the player stands in now goes first. Prints `ROUTES_RESET`, then `routes.CancelPlan` (a plan underway was made with the old lists and would put them back) and replans.

#### Client Differences

Same files on all four clients. `ns.FLAVOR` is read in one place (`routes.UnitFullName`, WoW Forever surnames); everything else is a feature test or a measure:

- Turn-ins only for quests the game's log has (`routes.IsOnQuest`): `C_QuestLog.IsOnQuest`, else `GetQuestLogIndexByID`, else Questie's log stands.
- Timed quests (`routes.TimedQuests`): WoW Forever's `C_QuestLog.GetQuestTimers`, else `GetQuestTimers` + `GetQuestIndexForTimer` + `GetQuestLogTitle`'s quest ID, so the log selection is never touched.
- Secret values (WoW Forever) go through `ns.IsReadable`: names, classes, party connection, unit maps, item cooldown/range/friendliness.
- Marker size divided by the map's effective scale (Classic Era/TBC's larger full-size map).
- World map may load on demand (`ADDON_LOADED` row).
- Instance quests by each flavor's `ns.QUEST_TAG_SUFFIXES` (tag IDs differ by flavor).
- Blizzard quest layers hidden only where the mixins exist (WoW Forever); quest item from `GetQuestLogSpecialItemInfo` only where it exists; TomTom's `"poi"` only where TomTom offers `SuppressFeature`.

#### Questie

Without Questie there is no route:

- `routes.IsQuestieReady()` (`Routes-Questie.lua`) needs `Questie.started` and Questie's `HereBeDragonsQuestie-2.0` (via `LibStub` silent, `routes.HereBeDragons`).
- Until then nothing plans, no camps, the arrow has nothing; Options panels still show.

Modules come through `ns.ImportQuestieModule` (`Utilities.lua`), nil without `QuestieLoader` or for a non-table. Database queries, quest methods, comms visibility and the link builder are `pcall`ed; ZoneDB and Phasing lookups called directly once found. What Routes uses:

- Quest log: `routes.QuestLog` over `ns.QuestieLogEntries` (`Utilities.lua`): `ActiveQuests.GetAll` (Questie 12.6.3 on; each entry's `.quest`, an entry without one is a quest Questie's database lacks and is skipped), else `QuestiePlayer.currentQuestlog`. `ImportModule` returns an empty table for a missing module, so `GetAll` is the test. From each quest: `IsComplete`, `Objectives`, `SpecialObjectives`, `Finisher`, `name`, `level`.
- `QuestieDB.QueryNPCSingle`, `QueryObjectSingle`, `QueryItemSingle`, `QueryQuestSingle` (`questFlags`, escorts), `GetQuest` (party quests, item buttons), `GetQuestTagInfo`, `questTagIds`.
- `ZoneDB:GetUiMapIdByAreaId`, `ZoneDB:GetDungeonLocation`, `Phasing.IsSpawnVisible`.
- `QuestieComms.remoteQuestLogs`, `remotePlayerClasses`, `CommsVisibility`.
- `QuestieLib:ColorWheel`, `QuestieLink:GetQuestHyperLink`, `QuestieQuest.private.objectiveSpawnListCallTable`.
- `Questie.usedIcons`, `ICON_TYPE_COMPLETE`, `ICON_TYPE_INCOMPLETE`, `ICON_TYPE_EVENT`.
- HereBeDragons world positions, zone coordinates, `GetWorldVector`; `HereBeDragonsQuestie-Pins-2.0`'s `worldmapProvider` (`RefreshAllData`, `HandlePin(_, icon)`) and its `HereBeDragonsPinsTemplateQuestie` pins (`pin.icon`, `pin.icon.data`, `pin.icon.texture`, `ObjectiveData.IsPartyObjective`).

Without `ZoneDB` no objective has a place; without `Phasing` every spawn counts. Routes Context reports each, plus whether `QuestiePlayer` exists (needed only before 12.6.3).

### Resizing and Scale

- Grip: `ns.CreateResizeGrip` (`Window.lua`), bottom-right, `LAYOUT.GRIP_INSET` inside the border; under ElvUI's skin on Classic Era and TBC anchored inside `QuestLogFrame.backdrop` (`AnchorGrip`, `Classic-Quest-Log.lua`), since the frame's corner sits outside the visible window.
- `ns.ClampHeight`: whole list rows (`ns.GetQuestRowHeight` on Classic Era and TBC, `LAYOUT.QUEST_ROW_HEIGHT` on the window), at least `LAYOUT.BASE_HEIGHT`, no closer than `LAYOUT.MINIMUM_BOTTOM_CLAMP` to the screen bottom measured from the window's top (a lower window grows less). Window units: screen measures divided by scale.
- Panes get height less `LAYOUT.PANE_INSET` (window's details slightly more, `ApplyHeight`). On Classic Era and TBC that sets row capacity (`ns.SetQuestRowCount`) and reruns `QuestLog_Update` on change.
- `global.height` saves when the drag ends: mouse-up, button released elsewhere (grip `OnUpdate`), or grip hidden mid-drag; then `ns.OnWindowResizeStopped` (hooked by `Mists-Quest-Portrait.lua`).
- Saved height applies on every open, not at load: screen size and UI scale aren't settled at load, so the clamp would cut it. The clamped value is never saved, so a smaller screen shrinks the window, not the setting.
- Art: only the plain lower half of each upper piece stretches (`ns.CreateWindowArt`, `TOP_SPLIT`); the top half holds the border.
- Window Scale (`global.scale`, slider in `Options-Quest-Log.lua`): on open, in `ns:OnDatabaseReady` on the window clients, and via `ns.ApplyWindowScale` on slider move (re-clamping height while open).
- Map Scale (`global.mapScale`): the map holder's scale on top of the window's (the map is its child); `ns.ApplyMapScale` (`Quest-Map.lua`) on window show and slider move.
- Reset Window (`ns.ResetWindow`, confirmed): clears height (and `point` on the window clients), writes `scale` / `mapScale` from `ns.DATABASE_DEFAULTS` rather than clearing (AceDB fills plain defaults only at load). `mapHidden` stays.
- Classic Era and TBC: Blizzard's panel manager keeps `BOTTOM_CLAMP` below the window for the action bars; `BottomClamp` trades it a pixel per pixel of extra height down to `MINIMUM_BOTTOM_CLAMP`, the only room to grow at normal UI scale. Each height change sets the `height` and `bottomClampOverride` panel attributes, or the manager scales the window down to fit what it thinks it needs.
- WoW Forever and Mists: dragging within the top `LAYOUT.PANE_TOP` moves the window and saves `global.point`; none saved means `DEFAULT_POINT` (`Forever-Quest-Log.lua`).

### Moving from Wide Quest Log Plus

- This add-on continues Wide Quest Log Plus (folder `WideQuestLogPlus`) under a new name, folder and SavedVariables table. Both reshape the same Blizzard quest log, so they must never run together.
- While `ns.PREDECESSOR_ADDON_NAME` (`Data/Data.lua`) is loaded, `ns:WarnIfPredecessorLoaded()` (`Features/Core.lua`) prints `CHAT_PREDECESSOR_LOADED` on every login, whatever the welcome toggle: it's a conflict, not a greeting. It disables neither add-on.
- The old name lives only in that constant, that string's locale entries and one Quest Log Context line (`Diagnostics/Manifests.lua`). Don't carry it anywhere else, the old `/wqlp` and `/widequestlogplus` commands included. Its settings are in its own SavedVariables file and aren't carried over.

### Game Names

What the game names comes from the client, never `Locales/`; this add-on's lookups:

- **Quest tags**: `ns.QUEST_TAG_SUFFIXES` (`Data/{Game}/Quest-Tags-{Game}.lua`) maps tag IDs to the add-on's own letters (locale keys, `ns.QuestSuffix`). The tag comes from `ns.GetQuestTagByID` (`Quest-Log-API.lua`), or Questie's corrected tag first in the quest chain and Routes. A tag's localized name is never compared.
- **Sample quests and areas** (`ns.SAMPLE_QUEST_IDS`, `ns.SAMPLE_DUNGEON_AREA_ID`, `ns.SAMPLE_ZONE_AREA_ID`): `ns.GetQuestTitleByID` (requesting loads until they arrive) and `C_Map.GetAreaInfo`. Each has a Game Names row.
- **Maps**: the client's `uiMapID`, named by `C_Map.GetMapInfo` in the map's zone dropdown. Map art and texture file IDs name nothing a player reads.
- **Items, spells, classes**: the add-on stores no item or spell ID of its own; reward names and icons come from the quest log calls, Use Item buttons' items from the client or Questie's database. `ns.CLASS_COLORS` is keyed by class token, colors only.
- **Zone names** are the quest log's headers. The current-zone mark compares header text with `GetRealZoneText()` (`ns.IsCurrentZone`, `Quest-Sort.lua`), a name match, because neither quest log gives headers a map ID; dungeon quests also match the instance name and `C_Map.GetAreaInfo` of Questie's zone IDs (`Dungeon-Quest-Lookup.lua`).
- **Quest, NPC, object names** in tooltips, the chain, the turn-in line, the route and the Quest Arrow come from the client or Questie's data.
- **Blizzard's GlobalStrings** the add-on shows or matches (row tags, `QUEST_LOG`, the own window's buttons and headings, `ERR_QUEST_PUSH_*`) each have a Game Names row (`SHARED_LABELS`, `OWN_WINDOW_LABELS`, `OWN_WINDOW_STRINGS`, `QUEST_ID_LABELS` in `Diagnostics/Manifests.lua`). README-Notes lists the few labels deliberately kept as the add-on's own strings.

## Files That Change Together

- **New setting**: key in `ns.DATABASE_DEFAULTS.profile` (`global` only for reset-proof presentation, see Saved Variables) → control and locale keys on its feature's panel (`Options-Quest-Log.lua` builders `QuestLogToggle` / `SortSelect` / `SortSubOption` take `Hidden` and `Inactive`, map settings `MapHidden`; else `Options-Quality-of-Life.lua`) → read live at use (`ns.RefreshQuestLog()` or `ns.questMap.RequestRefresh()` from `set`; Quality of Life toggles already call `ns.ApplyQualityOfLifeSettings()`) → its context report line in `Diagnostics/Manifests.lua` (window size and scales: Display Context, `Settings-Reports.lua`). A Quality of Life setting read outside its panel also checks `enableQualityOfLife`.
- **New Routes setting**: key in `ns.DATABASE_DEFAULTS.profile.routes` → control in `Options-Routes-Map.lua` or `Options-Quest-Arrow.lua` via the panel's `Toggle` (wraps `ns.OptionsRoutesToggle`, description from `<KEY>_DESCRIPTION`) or `ns.OptionsRoutesControl`, with the panel's hidden gate → read via `routes.Settings()`, written only via `routes.SetSetting` → if it changes what's planned, `routes.Signature()` (`Routes-Questie.lua`) or `routes.RequestPlan()` → a `RouteSetting` line in Routes Context (`ArrowLines`, `ZoneMapLines`, `PartyLines`).
- **New event**: a row in `EVENTS` (`Features/Core.lua`), which the dispatcher and `ns.EVENT_NAMES` both read → handler at file scope or inside a Classic part; a second feature on the same event uses an owner table created at file scope and named in the row's third field. Never `RegisterEvent` in a feature file; an event one client lacks goes only in that client's files.
- **New API call**: the list in `Diagnostics/Manifests.lua` for the clients that call it (`SHARED_`, `GIVER_PAGE_`, `LOG_INDEX_`, `CLASSIC_`, `OWN_WINDOW_`, `QUEST_ID_`, `INDEX_WINDOW_`, `ROUTES_`, `ITEM_BUTTON_FUNCTIONS`, the map lists; Blizzard frames and mixins in the matching `_TABLES`; a call taken one of two ways gets its own `_ROUTE` row; a read one data kind makes in `KIND_API_CHECKS`, `Validate-Data.lua`) → the global in `.luacheckrc` `read_globals` (or `globals` if written). A function only hooked by name needs no entry.
- **New Routes file**: its place in `Features/Routes/Routes.xml`, after everything it captures by value → its file in the File Map. Nothing in the TOCs.
- **New Features or Options file**: every TOC that loads it, in dependency order.
- **New key binding**: `Bindings.xml` → `BINDING_HEADER_` / `BINDING_NAME_` globals set in the owning Lua file → those names in `.luacheckrc` `globals`. Renaming a binding loses players' keys.
- **New share result**: `FIXABLE_RESULTS` (`Share-Reminders.lua`) → `SHARED_LABELS` and `SHARE_RESULTS` (`Manifests.lua`) → `.luacheckrc` `read_globals`. A new whisper key also goes in `SHARE_WHISPER_KEYS` (`Localization-Reports.lua`); check Message Length in ruRU.
- **New quest tag kind**: its ID in each flavor's `Quest-Tags` file → `QUEST_SUFFIX_<KIND>` and `QUEST_TYPE_<KIND>` in `enUS.lua` → `LEGEND_ORDER` (`Quest-Display.lua`). Routes treats only `INSTANCE_KINDS` (`Routes-Questie.lua`) as instance quests.
- **Sample quests**: `Data/{Game}/Sample-Quests-{Game}.lua` in every folder, Vanilla and Discovery both; with quests listed both area IDs are required. An empty list hides the Example lines (`ns.NoSampleQuests`).
- **New data table**: `Data/{Game}/{Label}-{Game}.lua` in every folder (Vanilla/Discovery copies guarded by `ns.IS_DISCOVERY`) → every TOC, before `Data/Default-Settings.lua` → a row in `ns.DIAGNOSTIC_DATA_SOURCES` whose `label` matches the file name (`ns.DataSourceFileName`) and `kind` its ID kind (`kind = "value"` for a single setting).
- **New flavor**: TOC with `X-Flavor` → `ns.EXPANSION` in `Data/Flavor.lua` → its four data files (out of `.pkgmeta`'s ignore list) → its quest log file set by which API it has (Classic rows, or the own window with its own tracking and takeover, zone actions by quest-ID support) → `Routes.xml` after `Quest-Map-Reveal.lua`, before Diagnostics, plus the two Routes panels → check `OWN_WINDOW` and `QUEST_ID_API` rows separately.
- **Chat output change**: `Locales/enUS.lua` (one `%s` for the quest reference, no closing period) → Message Length report in ruRU against `ns.CHAT_MESSAGE_MAX_LENGTH`.
- **A string an options file formats at load** (`MARK_UNTRACKED_DESCRIPTION`, `SHOW_DISTANCE_DESCRIPTION`, `SHOW_NEXT_OBJECTIVE_DESCRIPTION`, `QUESTS_LISTED_DESCRIPTION`): keep its `-- TRANSLATORS:` comment and placeholders in step, since a mismatch breaks the whole panel.

## Saved Variables

- `PrettyWideQuestLogDB` (`ns.SAVED_VARIABLES_NAME`), AceDB-3.0, the only SavedVariables table: every setting and every remembered window spot.
- **Simple model** (`AceDB:New(..., true)`): nothing stored differs per character. Reset Profile returns the shared profile to install defaults, Routes' `routes` subtable included, and leaves `global` alone.
  - **Profile**: every setting, Routes' in its own `routes` subtable.
  - **`global`**: only presentation, kept from a profile reset or switch: the window's and map's scales, height, `mapHidden`, the own window's position (WoW Forever and Mists; Blizzard places Classic's) and the Quest Arrow's spot. Reset Window (`ns.ResetWindow`) and the Quest Arrow panel's Reset Arrow are the confirmed resets for those.
- `ns:ApplyProfile` (all three profile callbacks) re-applies the quest giver cleanup, the list and map while the wide quest log runs, Routes (`routes.ApplySettings`), the dungeon quests, and open panels.
- `PruneOtherClientCharacters` runs right after `AceDB:New` (standing cleanup, not a migration).
- No default lists are seeded.
- Diagnostic Tools' Saved Variables report dumps the whole table.

### Migration Chain

Run from Routes' `PLAYER_LOGIN` handler or as the arrow is placed; each tagged with its removal date in the code:

1. `MigrateSettings` (`Routes-Core.lua`): an account-wide `global.routes` table onto the profile's `routes` (keys with a default only), its `arrowPoint` to `global.routesArrowPoint` unless one is saved; Routes Context reports old settings still waiting.
2. `DropRetiredSettings` (`Routes-Core.lua`): drops retired keys from the profile's `routes`.
3. `PlaceFrame` (`Routes-Arrow.lua`): an arrow spot saved by a point other than `TOP` is re-saved by its top (`HoldByTop`).

## Pitfalls & Why

- **Hooking or reshaping Blizzard's quest log outside `ns.AddWideQuestLogPart` on Classic Era or TBC**: it runs with the Quest Log switch off, and can't be taken back. Every file that hooks `QuestLogFrame` or its functions wraps its body in a part; the only exceptions are the share whispers' `QuestLogPushQuest` post-hook and `Classic-Zone-Actions.lua`'s calls when invoked.
- **Calling a part's function from outside a part on Classic Era or TBC**: with the switch off it is nil. Check `ns.wideQuestLogActive`, or gate the control with `Inactive`.
- **Defining an event handler after `ADDON_LOADED`**: Core's last registration pass runs right after `StartWideQuestLog` runs the quest log parts, so a handler defined later (in a timer, a hook or `ns:OnDatabaseReady`) never registers an event no other handler has. Define handlers at file scope or in a part (see Adding a New Event).
- **Adding a quest log part after load on Classic Era or TBC**: Core drops its queue once `ADDON_LOADED` has run the parts, so a late `ns.AddWideQuestLogPart` throws. Call it only at file scope.
- **Reading `ns.db` at file scope**: it doesn't exist until `ADDON_LOADED`. Classic's quest log parts run after it exists, but the own-window files, the shared files and Routes build at file load. Read settings at use, as `ns.IsQuestGiverCleanupOn` and `ns.ShowTrackingMark` check `ns.db` first, or in `ns:OnDatabaseReady` on WoW Forever and Mists, or in a `routes.OnLogin` handler for Routes.
- **Defining a handler or `ns:OnDatabaseReady` a second time**: each is one slot on `ns`, so the later file silently replaces the earlier. Put a second handler on the feature's own table and name it in its `EVENTS` row's third field.
- **Creating an `EVENTS` owner table after the second registration pass**: an event whose only handlers live on it never registers. Create the table at file scope, as `ns.dungeonQuests`, `ns.shareReminders` and Routes' tables are.
- **Registering an event a client lacks**: throws. Add events through `EVENTS` in Core, never `RegisterEvent` in a feature file, and define the handler only in that client's files.
- **Resetting a setting that has a default by setting it to nil**: AceDB fills defaults only when the scope is first read, so the key reads nil until the next reload. `ns.ResetWindow` writes `scale` and `mapScale` from `ns.DATABASE_DEFAULTS` and clears only `height` and `point`, which have no default.
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
- **Loading `Classic-Quest-Log.lua` before `Classic-Quest-List.lua`**: the log's part calls `ns.GetQuestRowHeight()` as it builds, and the list's part defines it. The Vanilla and TBC TOCs list the list file first.
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
- **Calling `ns.LogQuests` from code meant to only read**: on Classic Era, TBC and Mists it expands every zone and selects every quest in turn. The reports read through `ns.DiagnosticLogQuests`, and Sharing Context swaps it in for `ns.LogQuests` for the length of its `ns.DungeonQuests` call.
- **Hiding Blizzard's side windows in combat**: some are protected, so `HideUIPanel` on them is blocked. `CloseLeftPanels` (`Forever-Quest-Log.lua`) does nothing in combat.
- **Selecting a quest from add-on code on every repaint (WoW Forever and Mists)**: a selection can mark Blizzard's objective tracker dirty and leave its next update tainted (see Taint). `ns.SelectQuest` selects only when the selection differs, through `ns.TrackerTaintStep`.
- **Changing the watch list in combat (WoW Forever and Mists)**: it taints the objective tracker. `ns.ToggleTracking` refuses in combat with Blizzard's `ERR_NOT_IN_COMBAT` (`RefusedInCombat`).
- **Sharing in combat on WoW Forever**: `QuestLogPushQuest` is blocked there for add-on code. A single share waits for `PLAYER_REGEN_ENABLED` (`ns.questLogApi`, `Quest-Log-API.lua`), and Share Quests pauses its run until combat ends (`Forever-Zone-Actions.lua`).
- **Loading `Quest-Log-Key.lua` before `Forever-Quest-Log.lua`**: it reads `ns.questLogFrame` as it loads, the frame that owns the override binding, and the client's key file reads `ns.questLog` too. The Camelot and Mists TOCs list it right after `Forever-Quest-Log.lua`, followed by that client's own key file.
- **Toggling the window from WoW Forever's `ToggleQuestLog` hook without asking `ns.WasClosedForPanel`**: the world map opening has already closed the window, so a toggle would reopen it and the micro menu button could never close it. `Forever-Quest-Log-Key.lua` toggles only when the window didn't just close for `WorldMapFrame`, and Mists keeps `openBeforeToggle` for the same reason.
- **Assuming the window means the quest ID API**: Mists has the window with only the older calls by index. Go through the `ns` accessors in `Features/Quest-Log-API.lua`, and in Diagnostics test `OWN_WINDOW` and `QUEST_ID_API` separately.
- **Asking Mists about a quest by ID in a loop**: `ns.GetLogIndexForQuestID`, `ns.IsQuestComplete` and the like walk the whole log each call. Read the entry's own `isComplete` and `isFailed`, and pass `questLogIndex` to `ns.IsTracked` and `ns.HasRoomToTrack` where the caller has it.
- **Treating Blizzard's selection as the window's on WoW Forever or Mists**: they can differ. `ns.DisplayQuestDetails` selects first, and `Mists-Quest-Portrait.lua` checks before it reads the giver.
- **Letting Blizzard's quest log close the window on Mists**: a panel in the left area closes the window, and Blizzard's would on every takeover. `ns.IsTakenOverPanel` exempts it while the takeover runs, out of combat only.
- **Forgetting `WatchFrame` on Mists**: it listens for no event a watch change fires. `Redraw` in `Mists-Tracking.lua` calls `WatchFrame_Update`.
- **Loading the tracking file after `Forever-Quest-Log.lua` on WoW Forever or Mists**: that file captures `ns.ToggleTracking` by value as it builds its Track button. The Camelot and Mists TOCs list `Forever-Tracking.lua` or `Mists-Tracking.lua` before it.
- **Skipping `AddQuestWatch` for a quest Blizzard already watches on WoW Forever**: Questie's tracker never learns about it. `Track` in `Forever-Tracking.lua` calls `C_QuestLog.AddQuestWatch` regardless; adding a watch that exists is harmless.
- **Loading `Mists-Quest-Portrait.lua` before the map**: it reads `ns.questMap.holder` and hooks `ns.DisplayQuestDetails`, `ns.ApplyMapScale` and `ns.OnWindowResizeStopped` at load. The Mists TOC lists it after every other Features file.
- **Sharing quests back to back**: a share within about 3 seconds of the last gets the party member reported as busy. Share Quests and the dungeon quests space them by `ns.GetShareInterval()`, whose slider stops at `ns.SHARE_INTERVAL_MIN`, and share one run at a time (`ns.sharingQuests`).
- **Matching share results against English text**: fails in every other language. `Share-Reminders.lua` builds its patterns from the client's own `ERR_QUEST_PUSH_*` strings.
- **Reading system messages during chat lockdown**: the message is secret and can't be read. `OnChatMsgSystem` and the dungeon quests return while `C_ChatInfo.InChatMessagingLockdown()` holds.
- **Counting a login or reload inside a dungeon as arriving**: the party gets the announcement and every quest again. `PLAYER_ENTERING_WORLD`'s `isInitialLogin` and `isReloadingUi` mark the party seen over `ns.DUNGEON_LOGIN_GRACE` as already served.
- **Waiting for party range on WoW Forever**: `UnitInRange` answers for no one there, so the dungeon quests would wait the full minute every time. `IsInRange` counts everyone as in range when `ns.FLAVOR` is `"Camelot"`.
- **Testing a party member's GUID or connection without checking for secrets**: on WoW Forever they can come back secret, and a secret value can't be tested or compared. `PartyMembers` leaves out a member whose answers `ns.IsReadable` flags.
- **Tracking dungeon shares per group instead of per member**: a newcomer would never get the quests, or everyone would get them again on every roster change. The dungeon state keeps the GUIDs shared with, per instance ID, until `GROUP_LEFT`.
- **Keying dungeon state by Questie's zone ID**: without Questie, or for a dungeon its `ZoneDB` doesn't know, there is none. The key is the game's instance ID, the 8th return of `GetInstanceInfo`.
- **Walking Questie's objective lists with `ipairs`**: they can have gaps, so `ipairs` stops early and misses objectives. `QuestieQuestIn` walks them with `pairs`.
- **Counting Questie's world event quests as a dungeon's**: Questie can place a holiday or Darkmoon Faire quest in a dungeon it has nothing to do with. `ns.DungeonQuests` leaves out anything `QuestieEvent.IsEventQuest` flags, even under the dungeon's header.
- **Sending a message over 255 bytes, or shortening one by characters**: `SendChatMessage` rejects the whole message, and the limit (`ns.CHAT_MESSAGE_MAX_LENGTH`) is in bytes, so cutting mid-character breaks the text. `ns.FittingQuestReference` picks a quest reference that fits, and `TrimToBytes` cuts the bracketed title on a UTF-8 boundary.
- **Splitting the dungeon announcement anywhere but between quests**: a quest link cut in two is broken text. `DungeonAnnouncementArguments` packs whole references and starts a new message, with its own lead, when the next one won't fit.
- **Stripping pipes from a message for other players**: the bodies carry quest links, which stripping breaks. `ns:BuildAnnounceMessage` keeps pipes.
- **Leading a message with a raid-marker token on WoW Forever**: the client blocks `{rtN}` tokens in chat there. `ns:BuildAnnounceMessage` leaves `ns.TARGET_MARKER` off on `"Camelot"`.
- **Drawing a chat line in an options panel as chat draws it**: after a link's `|r` a panel falls back to white, where chat falls back to the channel color. The Example lines' `Tint` (`Options-Utilities.lua`) reopens the color after every `|r`.
- **Treating every `QuestInfo_Display` call as a quest giver page's**: Blizzard's own quest details (the world map's on WoW Forever, the quest log's on Mists) call it too, so a hook that styles for one restyles both. Each hook checks `ns.IsQuestGiverPage(parentFrame)` and `ns.IsQuestGiverCleanupOn()`, and `ns.LayOutQuestGiverPage` puts the gold and experience back anywhere else it moved them (`rewardNumbersMoved`).
- **Styling Blizzard's quest text after it has been laid out**: Blizzard's measurements no longer match what's drawn. Style shared text as the saved settings load, as `ns.ApplyQuestGiverCleanup` does.
- **Moving a quest giver piece without keeping Blizzard's offset**: Blizzard anchors some pieces afresh on each show but others only once (the greeting page's greeting text, the progress page's title, text, items and heading), so those would keep the cleanup's offsets after it goes off. `Quest-Giver-Pages.lua` keeps each offset the first time it moves (`greetingBlizzardY`, `blizzardY`) and puts it back with the cleanup off.
- **Resizing or moving the gossip window's lines**: the gossip list measures its rows itself, so frames the add-on resized would overlap. `Gossip.lua` changes only the greeting's font and line spacing, and tags the quest lines through each button's own `Resize`.
- **Styling only the gossip greeting that shows**: the list places its rows by a hidden copy of the greeting (`greetingTextFrame`) whose `Setup` never runs, so a long styled greeting overlaps the first option. `Gossip.lua` styles that copy after each `GossipFrame.Update` and calls the ScrollBox's `FullUpdate` when its height changes.
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
- **Reusing a quest tag ID across flavors**: tag 1 means Elite on some and Group on others. Keep them in each flavor's `Quest-Tags` file.
- **Loading Vanilla and Discovery data without the guard**: the Vanilla TOC lists both, so the later would overwrite the earlier. Each Vanilla file returns early when `ns.IS_DISCOVERY` is set, and each Discovery file when it isn't.
- **Loading the map files out of order**: several files read another's output as they build. `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons`, and defines the `PrettyWideQuestLogPinMixin` that `Questie-Map.xml` names; `Classic-Quest-Map.lua` takes `questMap.RequestRefresh` (`Questie-Map.lua`) by value for its `QuestLog_UpdateQuestDetails` hook; `Forever-Quest-Map.lua` reads `ns.questMap` at load; and `Quest-Map-Reveal.lua` hooks the exploration pin the client's map file makes. `Questie-Map-Tooltip.lua` reads `questMap.QUESTIE_PIN_TEMPLATE`, which `Questie-Map.lua` sets. Each TOC lists the quest log and list files, then `Quest-Map.xml`, `Quest-Map.lua`, `Questie-Map.xml`, `Questie-Map.lua`, `Questie-Map-Tooltip.lua`, `Questie-Map-Quest-Giver.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, the client's map file, and `Quest-Map-Reveal.lua`, with `Routes/Routes.xml` after them.
- **Building the map canvas in Lua**: `MapCanvasFrameTemplate`'s `OnLoad` runs before Lua could add the `ScrollContainer` and `BorderFrame` it needs. The frame stays in `Quest-Map.xml`.
- **Trusting Blizzard's objective area to draw on the docked map**: Questie turns `questPOI` off for some objective styles, and Blizzard's blob pin then draws nothing. `Forever-Quest-Map.lua` replaces `Refresh` on its own copy of the pin, less that check; never touch the CVar or the world map's provider.
- **Drawing Questie's quest twice on WoW Forever or Mists**: Blizzard's objective area and marker would sit under Questie's icons. They're drawn only for a quest Questie has no icons for (`BlizzardQuestID`, against `questMap.questieQuestID`, which `FollowQuestieQuest` sets first).
- **Showing a map the client has no art for**: the canvas can't draw it. `questMap.ShowMap` climbs to the nearest parent map that passes `questMap.CanShowMap`, and the quest giver's map (`AreaMapID`, `Questie-Map-Quest-Giver.lua`) skips such maps.
- **Disabling the mouse wheel on the map to stop zooming**: the wheel then zooms the camera behind it. `SetMouseWheelZoomMode` with `MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_NONE` keeps it enabled.
- **Letting the canvas acquire pins in combat**: it calls `SetPassThroughButtons` on each, which WoW blocks from add-on code in combat. The add-on's own templates use `PrettyWideQuestLogPinMixin` and `PrettyWideQuestLogRoutePinMixin`, whose `SetPassThroughButtons` does nothing. On WoW Forever and Mists, the map's copies of Blizzard's providers are wrapped as they're added, so `RefreshAllData` waits for `PLAYER_REGEN_ENABLED` (`questMap:OnPlayerRegenEnabled`); replacing one's `RefreshAllData` after that would drop the hold.
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
- **Drawing the route mid-flight**: it's replanned from where the player lands. The map provider's `RefreshAllData` skips the route while `routes.IsOnTaxi()`.
- **Hiding Questie's party icons a frame late**: Questie redraws them as party progress arrives, and they flash. The `HandlePin` hook hides the placed pin at once (`routes.ApplyToPlacedQuestieIcon`), relying on HereBeDragons parenting the icon to its pin.
- **Suppressing TomTom through its saved settings**: it would outlive the session and show in TomTom's options as the player's choice. `Routes-TomTom.lua` uses `SuppressFeature` / `ReleaseFeature` only.
- **Moving the pin templates above `Routes-Map.lua`**: `mixin="PrettyWideQuestLogRoutePinMixin"` names a global that doesn't exist yet. The mixin is defined in `Routes-Map.lua`, listed before the `<Frame>` templates, and declared in `.luacheckrc`'s `globals`.
- **Listing `Routes.xml` after the Diagnostics files**: `Manifests.lua` checks `ns.routes` at file load to add the Routes API rows, and would add none. Each TOC lists it among the Features, before Diagnostics.
- **Reaching for `ns.routes` without checking it**: Routes is one TOC line a release can leave out. `ns:ApplyProfile`, `ns.RegisterOptionsPanels`, `ns.OptionsRoutesToggle` and Routes Context all check `ns.routes` first.
- **Treating `routes.Settings()` as the saved table before `ADDON_LOADED`**: it returns `ns.DATABASE_DEFAULTS.profile.routes` itself, and a write there changes the defaults. Write only once `ns.db` exists, as the panels do.
- **Yielding inside a `pcall` or a `table.sort` comparator**: Lua 5.1 can't yield across a C call, so the planning coroutine dies. `ForEachFinisher` (`Routes-Nodes.lua`) runs its Questie queries in a `pcall`, then calls `AddSpawns` (which yields) outside it.
- **Writing a plan's results one at a time**: the watcher could compare a new plan's pins with the old plan's nodes and replan in a loop. The planner's `OnUpdate` (`Routes-Planner.lua`) assigns `routes.stops`, `start`, `nodes`, `engaged` and `camps` together.
- **Walking Questie's log with `pairs` across a yield**: before Questie 12.6.3 the log is Questie's live table, and `next` breaks if it changes mid-walk. Walk `routes.LoggedQuestIDs(log)` (`Routes-Planner.lua`), as `BuildNodes`, `BuildCamps` and `PartyQuests` do.
- **A fixed per-frame planning budget**: halves the frame rate on a fast screen. The planner takes `FRAME_SHARE` of the last frame, clamped to `MIN_BUDGET`..`MAX_BUDGET` (`Routes-Planner.lua`).
- **Resetting or changing zones while a plan runs**: finishing, it would put back the old pins and `routes.start`. `routes.ResetObjectives` and the zone handlers call `routes.CancelPlan()` first.
- **Reading a party member's map or connection in combat on WoW Forever**: the answer can be secret. `routes.IsUnitOutOfZone` and `Routes-Party.lua` test it with `ns.IsReadable` first (unreadable counts as present / offline).
- **Detecting TomTom by its global alone**: other add-ons make a `TomTom` table of their own. `Routes-TomTom.lua` requires `IsCrazyArrowEmpty`, `SuppressFeature` and `ReleaseFeature`.
- **Building a moved route to weigh each move**: a 90-node route weighs hundreds of thousands of moves, over 100 MB of garbage a plan. `IsValidMove` and the searches work through index maps (`OrOptIndex`, `TwoOptIndex`), building only the move taken.
- **Using `math.random` in the solver**: equally good routes would flicker between plans. `Shake` uses its own generator from a fixed seed.
- **Leaving node order to Questie's log**: it's a hash, so the same quests would give different routes. `BuildNodes` sorts nodes by `key`.
- **Trusting a cached blob's `penalty`**: blobs are cached and shared between plans, and `PinEngaged` zeroes the pinned one's. `routes.Candidates` (`Routes-Blobs.lua`) rewrites every candidate's penalty each plan.
- **Calling the world map's `Maximize` for the full-size map**: it runs Blizzard's panel layout as add-on code. `KeepFullSize` (`Routes-Map-Size.lua`) sets the `miniWorldMap` CVar instead, never in combat.
- **Turning the `questPOI` CVar off for Blizzard's quest markers**: it also takes them off the tracker and the minimap, changes the objective style Questie's options read back, has to be put back after a crash, and Questie notes that `questPOI` off makes the map open at login. `ApplyBlizzardQuests` (`Routes-Map-Blizzard-Quests.lua`) hides the world map's pins instead.
- **Hiding Questie's icons through Questie**: its own icon state would change on its other maps. `ApplyQuestieIcons` (`Routes-Map-Questie-Icons.lua`) hides HereBeDragons' pins, marks them `hiddenByRoute`, shows them again itself, and re-applies after Questie's provider `RefreshAllData` and `HandlePin`.
- **Sizing markers by the canvas alone**: Classic Era and TBC draw the full-size map at about 1.8 times the UI's scale, so markers come out that much bigger. The size is multiplied by `UIParent:GetEffectiveScale() / map:GetEffectiveScale()`.
- **Saving the arrow's spot in its own scale, or by any point but its top**: changing Arrow Size would move it, and so would the list under it changing height. `HoldByTop` re-anchors the arrow by its `TOP` and saves the offsets times the scale, and `PlaceFrame` divides by it.
- **Routing a dungeon quest's objectives**: they're inside the instance, so they're shown on the map only. `IsInstanceQuest` leaves them out by the flavor's tag table. Its turn-in is routed once it's done, but never inside the instance: checking `routes.IsInZone` alone would pass a dungeon's map filed under its entrance zone, so the turn-in's spawns also go through `routes.IsInstanceMap`.
- **Answering escort or instance questions once per session**: the client learns a quest's tag only once it has loaded the quest. Both caches are wiped a second after the quest log settles (`routes.ForgetQuestTags`).
- **Trusting Questie's tag alone for instance quests**: Questie keeps "no tag" for good once its one retry finds none, so a dungeon quest whose tag loads late would be routed. `IsInstanceQuest` falls back to the client's `ns.GetQuestTagByID`, and doesn't cache a quest neither has a tag for.
- **Formatting a locale string with the wrong placeholders at file load**: a mismatched translation of a string an options file formats as it loads breaks the whole panel file (see Localization).
