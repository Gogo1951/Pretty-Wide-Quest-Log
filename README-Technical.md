# Pretty Wide Quest Log // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Pretty Wide Quest Log. For end-user documentation, see [README.md](https://github.com/Gogo1951/Pretty-Wide-Quest-Log/blob/main/README.md).

## File Map

```
Pretty-Wide-Quest-Log/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── config.yml                   This add-on's New issue page: the blank-issue link, Discord and CurseForge
│   │   ├── defect.yml                   Shared, from Common-Core
│   │   └── request.yml                  Shared, from Common-Core
│   └── workflows/
│       ├── ci.yml                       Calls Common-Core: CI checks on every PR and push to main
│       ├── issue-labels.yml             Calls Common-Core: labels a new Defect by its Issue Type
│       └── package.yml                  Calls Common-Core: release packaging on a tag
├── .gitattributes                       Shared, from Common-Core
├── .gitignore                           Shared, from Common-Core
├── .luacheckrc                          Lint config
├── .pkgmeta                             Library externals and the zip's ignore list, Data/Wrath and Data/Mainline included
├── Pretty-Wide-Quest-Log_Vanilla.toc    Classic Era, Season of Discovery included
├── Pretty-Wide-Quest-Log_TBC.toc        TBC Anniversary
├── Pretty-Wide-Quest-Log_Camelot.toc    WoW Forever
├── Pretty-Wide-Quest-Log_Mists.toc      Mists of Pandaria Classic
├── Data/
│   ├── Flavor.lua                       The flavor from the TOC: ns.FLAVOR, ns.EXPANSION, ns.IS_DISCOVERY, ns.DATA_FOLDER
│   ├── Data.lua                         Locale, names, links, palette, registry names, ns.LAYOUT, marks, chat limit, share and dungeon timings
│   ├── Default-Settings.lua             AceDB defaults, Routes' subtable included
│   ├── {Game}/Map-Reveal-{Game}.lua     The map's unexplored areas, by map art ID; empty on Wrath and Mainline
│   ├── {Game}/Quest-Tags-{Game}.lua     Quest tag IDs to the level tag's letter, per flavor
│   ├── {Game}/Sample-Quests-{Game}.lua  The quests and areas the Example lines name; empty on Mainline
│   └── {Game}/Wowhead-{Game}.lua        The flavor's Wowhead quest address, a single setting
├── Diagnostics/                         Diagnostic Tools, with five tabs: Run Tests, Settings, Code, Data, Localization
│   ├── Diagnostics-Core.lua             Runtime state and the panel's strings
│   ├── Manifests.lua                    Per-client API rows, Validate Data sources, Game Names rows, the five Context reports
│   ├── Event-Log.lua                    The live Event Log
│   ├── Code-Reports.lua                 Event Registration, API Endpoints, Library Versions
│   ├── Settings-Reports.lua             Display Context, Other Add-ons, Saved Variables
│   ├── Validate-Data.lua                Checks each data file's IDs against the client, and prints the Wowhead address
│   ├── Localization-Reports.lua         Locale Context, Game Names, and Message Length for the whispers and the dungeon announcement
│   ├── Report-Runner.lua                The report registry, tab groupings and Run All
│   └── Options-Diagnostics.lua          The panel and its tabs
├── Features/
│   ├── Core.lua                         Version, event dispatcher, AceDB, the Wide Quest Log switch, login notices
│   ├── Utilities.lua                    Colors, number grouping, secret values, Questie imports, VoiceOver, share interval, tooltip lines
│   ├── Quest-Log-API.lua                Quest log calls by quest ID on every client, plus tags and titles
│   ├── Quest-Sort.lua                   The sort rules both quest logs share, and the current zone's match
│   ├── Announcements.lua                Player prints (ns:PrintMessage), the share print, sent messages (ns:Announce), group channel
│   ├── Quest-Display.lua                Level tags and their legend, quest text styling, objective lines, quest ID
│   ├── Quest-Rewards.lua                The rewards block's spacing, and experience and gold in the quest text's font
│   ├── Tracking-Mark.lua                The tracking mark in the list, and whether Questie's tracker has taken over
│   ├── Wowhead-Link.lua                 The quest ID's Wowhead link and its copy popup
│   ├── Quest-Chain.lua                  The Quest Chain section of the details, from Questie's database
│   ├── Quest-Giver.lua                  Quest giver window cleanup: its own text, page spacing, reward names, backdrop, level tags
│   ├── Gossip.lua                       The gossip window's line spacing, while the cleanup is on
│   ├── Quest-Giver-Pages.lua            The quest giver's greeting and progress pages
│   ├── Window.lua                       Window title, art, height clamp, resize grip and list buttons, both quest logs
│   ├── Turn-In-Line.lua                 The Ready to Turn In line and its tooltip, from Questie's quest data
│   ├── Classic-Tracking.lua             Classic Era and TBC: Track All and Untrack All
│   ├── Classic-Quest-Sort.lua           Classic Era and TBC: the sorted order, and Blizzard's rows redrawn to show it
│   ├── Classic-Quest-List.lua           Classic Era and TBC: list rows, row spacing, row style, list buttons, zone name hovers
│   ├── Classic-VoiceOver.lua            Classic Era and TBC: VoiceOver's play buttons on the sorted rows
│   ├── Classic-Quest-Details.lua        Classic Era and TBC: detail pane layout, objectives, rewards, daily reset, quest ID
│   ├── Classic-Quest-Log.lua            Classic Era and TBC: widens Blizzard's window, art, resizing, scale, combat close
│   ├── Classic-Zone-Actions.lua         Classic Era, TBC and Mists: finding and sharing by quest ID, and the whole log
│   ├── Zone-Share.lua                   The Share Quests button on a hovered zone name, every client
│   ├── Share-Reminders.lua              The whisper when a quest share fails for a reason the party member can fix
│   ├── Dungeon-Quest-Lookup.lua         The dungeon the player is in, and which quests in the log are its
│   ├── Dungeon-Quests.lua               In a dungeon with a party, announces its quests and shares them with each member once
│   ├── Quest-Map.xml                    The map's canvas frame, which only XML can build
│   ├── Quest-Map.lua                    The map beside the window: layout, scale, Show Map / Hide Map
│   ├── Questie-Map.xml                  Pin templates for Questie's icons and objective areas on the map
│   ├── Questie-Map.lua                  Questie's icons on the map, their tooltip, zone dropdown, refreshing
│   ├── Questie-Map-Areas.lua            Each objective's spawns clustered into the shapes of its areas
│   ├── Questie-Map-Area-Layer.lua       The layer the objective areas are shaded on
│   ├── Classic-Quest-Map.lua            Classic Era and TBC: exploration layer, following the selection
│   ├── Quest-Map-Reveal.lua             The map's unexplored areas, drawn so the whole zone shows
│   ├── Classic-ElvUI.lua                Classic Era and TBC: opaque ElvUI backdrop, ElvUI-styled buttons, map and dropdown
│   ├── Forever-Quest-Log.lua            WoW Forever and Mists: window, buttons, events, side windows, scale, combat close
│   ├── Quest-Log-Key.lua                WoW Forever and Mists: the quest log key, bound over to the window
│   ├── Forever-Quest-List-Entries.lua   WoW Forever and Mists: the list's entries, built from the log and sorted
│   ├── Forever-Quest-List.lua           WoW Forever and Mists: list rows, list buttons, zone name clicks
│   ├── Forever-Quest-Details.lua        WoW Forever and Mists: detail pane on QuestInfo_Display
│   ├── Forever-Quest-Giver.lua          WoW Forever and Mists: the quest giver window's gold, experience and quest ID
│   ├── Forever-VoiceOver.lua            WoW Forever and Mists: VoiceOver's or Spoken Quests' play buttons on the list rows
│   ├── Forever-Quest-Map.lua            WoW Forever and Mists: Blizzard's layers, quest fallback, following the selection
│   ├── Forever-Tracking.lua             WoW Forever: tracking and Track All by quest ID, deferring to Questie's tracker
│   ├── Forever-Quest-Log-Key.lua        WoW Forever: micro menu and tracker clicks taken over from the world map
│   ├── Forever-Zone-Actions.lua         WoW Forever: finding and sharing by quest ID, and the whole log
│   ├── Mists-Tracking.lua               Mists: tracking and Track All by log index, redrawing WatchFrame
│   ├── Mists-Quest-Log-Key.lua          Mists: micro menu and tracker clicks taken over from Blizzard's quest log
│   ├── Mists-Quest-Portrait.lua         Mists: the quest giver's model under the map, or beside the window
│   └── Routes/
│       ├── Routes.xml                   Lists the Routes files in order, and the two map pin templates
│       ├── Routes-Core.lua              Settings, listeners, the planner coroutine, the watcher, skipping
│       ├── Routes-Solver.lua            Orders the route: cheapest insertion, or-opt, 2-opt, seeded shakes
│       ├── Routes-Party.lua             Party members' quests from Questie's shared quest logs
│       ├── Routes-Questie.lua           Position, zone, corpse, Questie's log, escorts, instance quests, signature
│       ├── Routes-Blobs.lua             Spawns into blobs, and each objective's candidate places
│       ├── Routes-Nodes.lua             Objectives and turn-ins into nodes, and what goes first
│       ├── Routes-Stops.lua             Ordered nodes merged into waypoints, and each task's text and color
│       ├── Routes-Stop-Lines.lua        A waypoint's quests for the Quest Arrow and the map tooltip
│       ├── Routes-Map.lua               The route on the world map, Questie's icons, the full-size map
│       └── Routes-Arrow.lua             The Quest Arrow: pointing, the eye, its quest list, dragging
├── Includes/
│   ├── Images/                          The icon, window art (PWQL_*.blp), untracked mark, Wowhead link, Routes art (Route-*.tga)
│   └── Libraries/                       Vendored LibStub, CallbackHandler and Ace3, never edited
├── Locales/
│   ├── enUS.lua                         Source of truth
│   └── {langCode}.lua                   The other ten supported locales
├── Options/
│   ├── Options-Utilities.lua            Shared rows: feature and Routes switches, sub-option rows, status lines, the reload check and prompt
│   ├── Options-General.lua              Root panel: the welcome toggle and the four feature switches
│   ├── Options-Quest-Log.lua            Wide Quest Log panel: the switch, Sorting, Quest Rows, Window & Map, Handy Clicks
│   ├── Options-Quality-of-Life.lua      Quality of Life panel: the quest giver window, quest sharing, dungeon quests, Example lines
│   ├── Options-Routes-Map.lua           Routes on Zone Map panel: zone map, markers, route line, party
│   ├── Options-Quest-Arrow.lua          Quest Arrow panel: size, cycle, lock, position, text, hiding
│   ├── Options-Profiles.lua             Stock AceDBOptions
│   ├── Options-Feedback-Support.lua     Feedback & Support panel: the Level Up note, the four links and the version line
│   └── Options.lua                      Registration, opener, /pwql
├── LICENSE
├── README.md                            Player-facing overview
├── README-Notes.md                      Recorded exceptions to the style guide
├── README-Technical.md                  This document
└── README-Testing.md                    Manual test plan
```

Retired, so don't bring them back: an unsuffixed TOC; the root-level `Legacy.lua`, `Modern.lua`, `Common.lua`, `Layout.lua` and `img/`, whose code lives in `Features/` and art in `Includes/Images/`; `Features/Forever-Quest-Map.xml`, replaced by `Features/Quest-Map.xml`, which every client loads; `Features/Zone-Menu.lua`, replaced by `Features/Zone-Share.lua`; and `Options/Options-Forever-Quest-Log.lua`, whose switch is on the Wide Quest Log panel on every client and whose reload prompt is in `Options/Options-Utilities.lua`. The `WOWHEAD_QUEST_URLS` table in `Data/Data.lua` is retired too: each flavor's address is its own `Data/{Game}/Wowhead-{Game}.lua`.

## Architecture

### Two Quest Logs, One Layout

Classic Era and TBC ship Blizzard's classic `QuestLogFrame`, so the `Features/Classic-*.lua` files widen it in place. They move Blizzard's own regions and rows, swap the art, and hook `QuestLog_Update` and `QuestLog_SetSelection` (the list file, which calls the sort file's order and row redraws) and `QuestLog_UpdateQuestDetails` and `QuestFrameItems_Update` (the details file) to restyle what Blizzard just drew; `Classic-Quest-Log.lua` owns the window itself, its art, resizing and scale. WoW Forever runs the Retail engine, which replaced that frame with a list docked in the world map, so there is nothing to widen, and the `Features/Forever-*.lua` files build a window of their own instead. Mists keeps a `QuestLogFrame`, but one without the `QuestLogTitle{N}` rows the Classic list file redraws, so it rides that same window.

So there are two quest logs and three sets of files. Each client's TOC picks its own, and no quest log file asks which flavor it's on:

- **Classic Era and TBC** list the `Classic-*.lua` files: tracking, sort, list, VoiceOver, details, log and zone actions, then the map and ElvUI files after the shared map files. Parts run in TOC order, so the log file comes after the list file whose row height it reads.
- **WoW Forever** lists the `Forever-*.lua` files (tracking, log, key, list entries, list, details, quest giver, VoiceOver, zone actions, map) and the shared `Quest-Log-Key.lua`, right after `Forever-Quest-Log.lua`.
- **Mists** lists the same window files (log, list entries, list, details, quest giver, VoiceOver, map) and `Quest-Log-Key.lua`, with `Mists-Tracking.lua` and `Mists-Quest-Log-Key.lua` in place of WoW Forever's tracking and takeover, `Classic-Zone-Actions.lua` in place of `Forever-Zone-Actions.lua` because its quest log calls are Classic's, and `Mists-Quest-Portrait.lua`, listed last.

The window reads and acts on the log by quest ID, through the `ns` accessors in `Features/Quest-Log-API.lua` (`ns.GetQuestLogEntry`, `ns.GetLogIndexForQuestID`, `ns.SelectQuest`, `ns.IsPushableQuest`, `ns.ShareQuest`, `ns.AskToAbandonQuest` and the rest), which every client loads. Where `C_QuestLog.GetInfo` exists (WoW Forever) they are the client's own calls. Elsewhere they walk the log by index, and those that act on a quest select it, act, then put the player's selection back (`WithQuestSelected`). The same file answers by quest ID on every client for a quest's tag (`ns.GetQuestTagByID`), its title (`ns.GetQuestTitleByID`) and whether a party member has it (`ns.IsUnitOnQuest`), choosing the client's call once at load. Where the two window clients differ, the shared file tests for the feature (`FogOfWarFrameMixin`, `GetQuestsOnMapCached`, `QUEST_INFO_BORROWERS`' nil holes) rather than the flavor. Shared feature code reads `ns.FLAVOR` in only two places, both testing for `"Camelot"`: the sent-message marker, which WoW Forever blocks, and the dungeon quests' range check, which WoW Forever answers for no one (see Dungeon Quests). Diagnostics reads it to label the client, for two TBC-only rows, and for Sharing Context's line about party range on WoW Forever. What differs only in data, such as the Wowhead address, comes from the flavor folder the TOC lists, never from a flavor check. The flavor always comes from the TOC's `X-Flavor` (`Data/Flavor.lua`), never from the client, because WoW Forever's `WOW_PROJECT_ID` has already changed value once. The shared files (`Zone-Share.lua`, `Share-Reminders.lua`, `Dungeon-Quests.lua`, `Quest-Map.lua`, `Questie-Map.lua` and the rest) call into whichever files loaded through the same `ns` names: `ns.SharedQuest`, `ns.ShareableZoneQuests`, `ns.ShareQuests`, `ns.LogQuests`, `ns.questMap.FollowQuest`, `ns.questLogFrame`.

Every client shares `ns.LAYOUT` (`Data/Data.lua`) and `Features/Window.lua`, which is why the two look the same. The detail pane's text column is exactly two columns of reward buttons wide (147 + 1 + 147px), because reward buttons can't shrink. The window grows by `EXTRA_WIDTH`, whatever that column plus its margins needs beyond the classic parchment, and the art fills the difference with a strip cut from the last 8 pixels of the middle piece, so both seams continue the art on either side. Numbers in the details (objective counts, gold, experience, the quest ID) end two spaces inside the column (`ns.TwoSpacesWide`), because body text wraps short of the edge and a number flush against it looks like it runs past.

### The Wide Quest Log Switch

`enableWideQuestLog` decides, once, as the saved settings load, whether the wide quest log runs this session; `Features/Core.lua` records the answer in `ns.wideQuestLogActive`, true only when the switch is on and a loaded file has a wide quest log to run (`ns.hasWideQuestLog`). The two quest logs need it differently:

- **Classic Era and TBC.** Hooks on Blizzard's quest log can't be removed, so every Classic quest log file, from `Classic-Tracking.lua` to `Classic-ElvUI.lua`, and the shared map files that build on it (`Quest-Map.lua`, `Questie-Map.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, `Quest-Map-Reveal.lua`), wraps its whole body in `ns.AddWideQuestLogPart(function() ... end)`. Core queues those functions at file load and runs them, in TOC order, inside `ADDON_LOADED` once `AceDB:New` and the profile callbacks are done, only when the switch is on. With it off, Blizzard's quest log window is never reshaped or hooked, with two deliberate exceptions that must work with the switch off: `Share-Reminders.lua` post-hooks `QuestLogPushQuest` at file scope, only to note which quest went out, and `Classic-Zone-Actions.lua` sits outside any part because the share whispers call its `ns.SharedQuest` and the dungeon quests its `ns.LogQuests` and `ns.ShareQuests`; it touches the quest log only when called.
- **WoW Forever and Mists.** The quest log is the add-on's own window, which stays closed unless something opens it, so `Forever-Quest-Log.lua` sets `ns.questLogIsOwnWindow`, the files build at file scope, before `ns.db` exists, and `ns.AddWideQuestLogPart` runs the shared map files' parts at once. Only the quest log takeover waits for the switch: `ns.TakeOverQuestLog()`, defined by `Forever-Quest-Log-Key.lua` or `Mists-Quest-Log-Key.lua`, routes the ways into the quest log to the window (see Taint). With the switch off the key opens Blizzard's own quest log: the world map's on WoW Forever, `QuestLogFrame` on Mists.

Core drops its queue once the parts have run, so on Classic Era and TBC a part added after `ADDON_LOADED` throws. Everything a part defines is nil on Classic Era and TBC with the switch off: `ns.RefreshQuestLog`, `ns.ResetWindow`, `ns.ApplyWindowScale`, `ns.ApplyMapScale`, `ns.ResetZoneOrder`, `ns.questLogFrame`, `ns.questMap`, `ns.listButtons`, `ns.abandonButton` and `ns.shareButton`. Code outside a part checks `ns.wideQuestLogActive` before reaching for them, as `ns:ApplyProfile` and `Tracking-Mark.lua` do, and the Wide Quest Log panel's controls are disabled by its `Inactive` gate.

A change to the switch applies at the next `/reload`. `ns.IsQuestLogReloadPending()` compares the profile's value with `ns.wideQuestLogActive`, so a profile switch counts and flipping it back goes quiet. While it differs, a silver status line says so under the switch on both the General and Wide Quest Log panels, and when the game's Options window closes, `PRETTYWIDEQUESTLOG_RELOAD` offers the reload. `ns.WatchOptionsForReload` (`Options/Options-Utilities.lua`, beside the prompt) hooks the Options window's `OnHide` the first time any of the add-on's panels shows inside it, because that window may not exist when the add-on loads, and because watching the window rather than the panels still prompts after the player has moved to another category. The Wide Quest Log panel's settings hide while the switch is off, and gray out while it's on but not yet active.

The quest giver window styling, the gossip window spacing, the share whispers, the dungeon quests, Routes and the login notices don't depend on the switch, so they run either way.

### Event Loop

`Features/Core.lua` owns the only event frame. Its `EVENTS` table pairs every event the add-on can handle with a handler named for the event; an event listed more than once runs every handler, in table order. A row with no third field names a handler on `ns`, called as `handler(ns, ...)`, without the event name. Because one name holds one function, each further feature handling the same event keeps its handler on a table of its own, named by its `ns` key in the row's third field (its owner), and is called as `handler(owner, ...)`. Handlers are looked up at every dispatch, and a row whose owner or handler doesn't exist is skipped:

- `GROUP_ROSTER_UPDATE` runs `ns:OnGroupRosterUpdate` (the window's bottom buttons on WoW Forever and Mists), then `ns.dungeonQuests:OnGroupRosterUpdate`, then `ns.routesArrow`'s.
- `GROUP_JOINED` and `GROUP_LEFT` run the dungeon quests' `ns:OnGroupJoined` / `ns:OnGroupLeft`, then `ns.shareReminders`' handlers of the same names.
- `PLAYER_LOGIN`, `PLAYER_ENTERING_WORLD`, `ZONE_CHANGED_NEW_AREA` and `QUEST_LOG_UPDATE` run the `ns` handler first, then Routes' (`ns.routes`, followed by `ns.routesArrow` for `PLAYER_ENTERING_WORLD` and `ZONE_CHANGED_NEW_AREA`). `PLAYER_DEAD`, `PLAYER_ALIVE` and `PLAYER_UNGHOST` belong to `ns.routes` alone.
- `ADDON_LOADED` runs `ns:OnAddonLoaded`, then `ns.routesMap:OnAddonLoaded`, which adds the route to `Blizzard_WorldMap` when that loads on demand after login.
- `PLAYER_REGEN_ENABLED` runs the quest log key's `ns:OnPlayerRegenEnabled`, then `ns.questMap:OnPlayerRegenEnabled` (`Forever-Quest-Map.lua`), which redraws the map layers held during combat (see Combat Lockdown).

Routes takes its events only through these rows. Each TOC lists it with the single line `Features/Routes/Routes.xml`; without that line its owner tables (`ns.routes`, `ns.routesMap`, `ns.routesArrow`) are nil and its rows are skipped.

`ADDON_LOADED` for this add-on runs, in order: `AceDB:New`, the profile callbacks (`OnProfileChanged`, `OnProfileReset` and `OnProfileCopied`, all to `ns:ApplyProfile`, which also reapplies Routes' settings through `ns.routes.ApplySettings`), the quest log parts (`ns.wideQuestLogActive` is set just before them), `ns.ApplyQuestGiverCleanup`, `ns.RegisterOptionsPanels`, `ns:OnDatabaseReady` (a single slot, defined only by `Forever-Quest-Log.lua`, which calls `ns.TakeOverQuestLog()` when the wide quest log runs), and last the registration pass. That pass registers, once each, every event with at least one row whose owner and handler a loaded file has defined by then; an event with no such row is never registered, whatever is defined later. So:

- **Classic Era and TBC** register `ADDON_LOADED`, `PLAYER_LOGIN`, `CHAT_MSG_SYSTEM` (the share whispers), `PLAYER_ENTERING_WORLD`, `GROUP_JOINED`, `GROUP_LEFT` and `GROUP_ROSTER_UPDATE` (the dungeon quests, with the share whispers and Routes on some), Routes' `QUEST_LOG_UPDATE`, `ZONE_CHANGED_NEW_AREA`, `PLAYER_DEAD`, `PLAYER_ALIVE` and `PLAYER_UNGHOST`, plus `PLAYER_REGEN_DISABLED` when the wide quest log runs. The quest log itself works purely through hooks; its only handlers, `ns:OnZoneChangedNewArea` and `ns:OnPlayerRegenDisabled`, are defined in `Classic-Quest-Log.lua`'s part, so they exist only when the wide quest log runs.
- **WoW Forever and Mists** also register the window's quest events (`QUEST_WATCH_LIST_CHANGED`, `QUEST_ACCEPTED`, `QUEST_REMOVED`, `QUEST_TURNED_IN`, `UNIT_QUEST_LOG_CHANGED`, and `QUEST_LOG_UPDATE`, shared with Routes), `PLAYER_LEVEL_UP`, `PLAYER_REGEN_DISABLED`, and `UPDATE_BINDINGS` and `PLAYER_REGEN_ENABLED` (the quest log key's override binding, see Taint, and the map's held redraws). Every handler is defined at file scope (`Forever-Quest-Log.lua`, `Quest-Log-Key.lua`, `Forever-Quest-Map.lua`), so all of these register whatever the switch says. With the switch off, the key's `UPDATE_BINDINGS` and `PLAYER_REGEN_ENABLED` handlers do nothing, because `ns.questLogTakenOver` is never set.

`ADDON_LOADED` itself is registered at file load, since it's what starts the rest, and the pass skips it. Its rows run for every add-on that loads, so each handler checks the name. A further handler's owner table (`ns.dungeonQuests`, `ns.shareReminders`, `ns.routes`, `ns.routesMap`, `ns.routesArrow`, `ns.questMap`) must exist by the pass, or its event isn't registered on its account. What was registered is exported as `ns.EVENT_NAMES` for Diagnostics. While Diagnostic Tools' Event Log is recording (`ns.diagnostics.logging`), the dispatcher hands each event to `ns:LogEvent` before its handlers; otherwise that costs one boolean check.

On WoW Forever and Mists every quest event funnels into `ns.RequestUpdate()`, which repaints at most once a frame and only while the window is open, because `QUEST_LOG_UPDATE` arrives in bursts. `PLAYER_LEVEL_UP` is there because the difficulty colors change with the player's level. `UNIT_QUEST_LOG_CHANGED` counts only for `"player"`. `GROUP_ROSTER_UPDATE` refreshes only the bottom buttons, because Share is enabled only in a group. A hook on Questie's tracker `Update` (installed in `ns:OnDatabaseReady`), the `OnHide` of each window that borrows the quest detail elements, and on Mists a `QuestInfo_Display` hook for Blizzard's own details (see Taint) request the same repaint. On both clients `ZONE_CHANGED_NEW_AREA` redraws the list so the current zone's mark moves, without re-sorting the zones (see Sorting).

`PLAYER_LOGIN` prints the welcome, the predecessor warning (see Moving from Wide Quest Log Plus), and, `QUESTIE_NOTICE_DELAY` (20) seconds later so it isn't lost among the other login lines, `CHAT_QUESTIE_MISSING_FEATURES` if Questie isn't loaded. The last two ignore the welcome toggle, because they explain something rather than greet. Routes' handler then migrates its settings and runs what Routes put off until the saved settings exist (`routes.OnLogin`).

### Blizzard's Side Windows (WoW Forever and Mists)

Blizzard's windows that open on the left of the screen (quest giver, gossip, vendor, trainer, character pane) would open on top of the add-on's window, and the quest giver's takes the `QuestInfo` pieces the details are drawn with, leaving them blank. So the two make way for each other, as Blizzard's own windows do: a `ShowUIPanel` hook hides this window when a panel in the `left` or `doublewide` area opens, and opening this window first hides whatever holds those areas (`CloseLeftPanels`), so the details have their pieces back. Bags aren't panels in those areas and are left alone. So is Blizzard's own quest log on Mists while the window is taking over from it out of combat (`ns.IsTakenOverPanel`, always false on WoW Forever), or opening it would close the window it's meant to open. `ns.WasClosedForPanel` remembers the panel the window last closed for until the next frame, which is how WoW Forever's `ToggleQuestLog` hook tells a close from an open.

### Combat Lockdown

The options opener refuses during combat: it prints the mandated message (`CHAT_OPTIONS_IN_COMBAT`) and returns, never queues. On WoW Forever and Mists two things wait for `PLAYER_REGEN_ENABLED`. The first is the quest log key's override binding, which can't change in combat, so a change that comes then waits (see Taint). The second is the docked map's layers: their `RefreshAllData` is held in combat and run once it ends (`Forever-Quest-Map.lua`), because the map canvas calls `SetPassThroughButtons` on every pin it acquires, which WoW blocks for add-on code in combat. Routes waits out combat on its own: a route being planned pauses until the fight ends, and the full-size map setting is never written in combat. With Close When Combat Starts (`closeInCombat`) on, `PLAYER_REGEN_DISABLED` closes the quest log: `HideUIPanel` on Classic Era and TBC, whose quest log isn't a protected frame, and a plain `Hide` on the add-on's own window. On WoW Forever and Mists, opening the window in combat leaves Blizzard's side windows open rather than hiding them, since some of them are protected; nothing is queued for later. For the same reason the micro menu button and tracker clicks leave Blizzard's window open in combat instead of handing over (the world map on WoW Forever, `QuestLogFrame` or `QuestLogDetailFrame` on Mists), while the quest log key, bound to the add-on's own button, opens the window either way (see Taint). On Mists `ns.IsTakenOverPanel` is false in combat, so Blizzard's quest log opening then closes the window as any other left-side panel does; if the key reopens it, Blizzard's log still holds the `QuestInfo` pieces, so `QuestInfoInUseElsewhere` keeps the window's details from drawing until Blizzard's closes. The add-on's window is its own unprotected frame, and Classic's quest log, its scroll bar and the panel manager's positioning of it are unprotected, so both quest logs work in combat.

## Taint

Classic Era and TBC only hook Blizzard's functions, but these things they do are seen by Blizzard's code as coming from an add-on:

- The window's new size goes to the panel manager through `SetUIPanelAttribute` (`width` once, `height` and `bottomClampOverride` whenever the height changes), the interface Blizzard provides for this, rather than by replacing the `UIPanelWindows` entry. A client without `SetUIPanelAttribute` gets no attributes.
- A taller window needs more list rows, so `QUESTS_DISPLAYED` (read by `QuestLog_Update`) is raised, the extra rows are created here, and `QuestLog_Update` runs when the row count changes.
- The row spacing moves Blizzard's list rows and widens the list's scroll range through `FauxScrollFrame_Update`.
- Blizzard's "All" toggle and the Track toggle beside it are faded out and unclickable, with Expand All running `QuestLogCollapseAllButton_OnClick`. Track All and Untrack All do what a shift-click does to each quest: `AutoQuestWatch_Insert` to track, and to untrack, `RemoveQuestWatch` after taking the quest out of `QUEST_WATCH_LIST`; both then call `QuestWatch_Update` and `QuestLog_Update`.
- The sorted order is drawn on Blizzard's own rows: each row's ID (`SetID`), text and textures are rewritten to the entry at its sorted place, and Blizzard's row handlers read that ID (see Sorting).
- Share Quests and the dungeon quests select, expand and collapse entries and call `QuestLogPushQuest`, the same call Blizzard's own Share button makes.

None of it reaches anything protected on those clients.

On WoW Forever, Blizzard's code sees:

- No Blizzard function is replaced. Only when the wide quest log runs this session does `ns:OnDatabaseReady` (inside `ADDON_LOADED`) call `ns.TakeOverQuestLog()` (`Forever-Quest-Log-Key.lua`), which routes the ways into the quest log to the window and sets `ns.questLogTakenOver`; with it off, nothing is routed and the world map keeps the quest log key.
  - The quest log key (`TOGGLEQUESTLOG`) is bound over with `SetOverrideBindingClick`, owned by the window, to the add-on's own hidden `PrettyWideQuestLogToggleButton` (`ns.RouteQuestLogKey`, `Quest-Log-Key.lua`, shared with Mists), so it never opens Blizzard's quest log, in combat or out. Bindings can't change in combat, so the override is set again on `UPDATE_BINDINGS`, and one that came in combat waits for `PLAYER_REGEN_ENABLED`.
  - The micro menu button calls `ToggleQuestLog`, and the objective tracker (and Questie) call `QuestMapFrame_OpenToQuestDetails`. Both are post-hooked with `hooksecurefunc`, so Blizzard's own runs first and opens the world map; out of combat the hook closes it with `HideUIPanel` in the same frame and toggles the window, or for a tracker click shows that quest in it. In combat the map is left open, because hiding it goes through the panel manager. A quest that isn't in the log stays on Blizzard's map.
- `QuestInfo_Display` is Blizzard's detail renderer, shared with the quest giver window, the quest popup and the map's details, so the add-on calls it only while none of those is showing (`QuestInfoInUseElsewhere`). Each caller sets up everything it reads, so nothing carries over. A `hooksecurefunc` on it (`LayOutSharedPieces`, `Forever-Quest-Details.lua`) puts the shared objective lines back in Blizzard's font after anyone else uses them, and the reward positions back Blizzard's way for the map's details; on the quest giver window it hands over to `ns.LayOutQuestGiverPage` (`Forever-Quest-Giver.lua`) instead. `Quest-Rewards.lua` (the experience and gold) and `Quest-Giver.lua` (the reward names and the quest giver pages' spacing) post-hook it too, on every client that has it (see Quest Text and Quest Giver Window).
- Some of this is installed at file scope, so it runs whatever the Wide Quest Log switch says: the `ShowUIPanel` hook, `LayOutSharedPieces`, the `OnHide` hooks on the windows that borrow the quest detail elements (and on the map's `QuestMapFrame.DetailsFrame`), the `UISpecialFrames` entry, and the hidden toggle button, which nothing is bound to while the switch is off. The hook on Questie's tracker `Update`, added in `ns:OnDatabaseReady`, is installed whatever the switch says too.
- Every details repaint that draws a quest calls `C_QuestLog.SetSelectedQuest` with the window's selected quest.
- The window's name goes in `UISpecialFrames`, so Escape closes it. Blizzard reads that list through `securecall`.
- Opening the window calls `HideUIPanel` on Blizzard's side windows, only out of combat (see Blizzard's Side Windows).
- The bottom Abandon and Share buttons and the list's right-click quest menu call Blizzard's own `QuestMapQuestOptions_AbandonQuest` and `QuestMapQuestOptions_ShareQuest` (`ns.AskToAbandonQuest`, `ns.ShareQuest`). Showing a quest calls `ExpandQuestHeader` on its zone, the window's first open in a session expands every collapsed zone (`ns.ExpandAllZones`), and the list's zone clicks and Expand All / Collapse All call `ExpandQuestHeader` or `CollapseQuestHeader`.
- Tracking calls `C_QuestLog.AddQuestWatch` and `C_QuestLog.RemoveQuestWatch` (see Questie Tracking).
- Share Quests and the dungeon quests call `C_QuestLog.SetSelectedQuest` and `QuestLogPushQuest`, then select the quest the details show again (`Forever-Zone-Actions.lua`).

On Mists the window's file-scope pieces are the same (the `ShowUIPanel` hook, `LayOutSharedPieces`, the `OnHide` hooks on the borrowers in `QUEST_INFO_BORROWERS`, which there are `QuestFrame`, `QuestLogFrame` and `QuestLogDetailFrame`, the `UISpecialFrames` entry and the hidden toggle button), and so is the key's override binding. The rest differs:

- No Blizzard function is replaced here either. `ns.TakeOverQuestLog()` (`Mists-Quest-Log-Key.lua`) has no world map to deal with, since everything opens Blizzard's `QuestLogFrame` through the panel manager: the micro menu button (`ToggleQuestLog`), Questie's tracker, and the objective tracker, which opens just the quest's details in `QuestLogDetailFrame` (`QuestLog_OpenToQuest`). So it post-hooks `ShowUIPanel`. Out of combat, `HideUIPanel` closes Blizzard's window in the same frame and the window shows the quest it opened to; a second tracker click on the quest already showing closes the window, as Blizzard's does. A `ToggleQuestLog` post-hook closes the window when it was already open as the toggle came, using `openBeforeToggle`, kept until the next frame. In combat Blizzard's stays.
- Questie opens a quest by showing Blizzard's quest log, then draws its details there, which takes the quest text back from the window. A `QuestInfo_Display` hook, for `QuestLogDetailScrollChildFrame`, requests a repaint (`ns.RequestUpdate`), which comes the next frame. `ns.TakeOverQuestLog()` installs it, so it exists only while the wide quest log runs.
- Reading the log selects quests. Every details repaint calls `SelectQuestLogEntry`, and `ns.IsPushableQuest`, `ns.ShareQuest` and `ns.AskToAbandonQuest` select each quest in turn around `GetQuestLogPushable`, `QuestLogPushQuest` and `SetAbandonQuest` (`GetAbandonQuestItems`, `GetAbandonQuestName`, then Blizzard's own `ABANDON_QUEST` or `ABANDON_QUEST_WITH_ITEMS` popup), restoring the selection after.
- Zones stay open in Blizzard's log. A collapsed zone there lists none of its quests, so `ns.ShowEveryQuestLogEntry` calls `ExpandQuestHeader(0)` as the list builds, and collapsing a zone in the window only changes `collapsedZones`, kept by name for the session (`Features/Quest-Log-API.lua`).
- Share Quests and the dungeon quests go through `Classic-Zone-Actions.lua`, which calls `SelectQuestLogEntry`, `ExpandQuestHeader`, `CollapseQuestHeader` and `QuestLogPushQuest`, and `QuestLog_Update` while Blizzard's log is open.
- Tracking calls `AddQuestWatch` and `RemoveQuestWatch` by index, then `WatchFrame_Update`, since `WatchFrame` listens for no event a watch change fires. None of its buttons is secure, so that's safe in combat.

## Questie Tracking

### WoW Forever

Questie's tracker keeps its own list of tracked quests and only learns about new ones through `C_QuestLog.AddQuestWatch`. The client's automatic watch on accepting a quest bypasses that, so a quest can be watched by Blizzard yet missing from Questie's tracker. Questie's tracker also shows only quests in its database, and many of WoW Forever's own quests aren't in it.

So while Questie's tracker is enabled (`Questie.db.profile.trackerEnabled`) and its `QuestieTracker` and `QuestiePlayer` modules import, `Features/Forever-Tracking.lua` counts a quest as tracked only if Questie's tracker shows it (`IsTrackedByQuestie`), and a quest is trackable only if it's in Questie's quest list (`QuestiePlayer.currentQuestlog`). Tracking calls `AddQuestWatch` even when Blizzard already has the watch, since that call is what tells Questie. Blizzard's watch cap still holds under Questie: once `C_QuestLog.GetNumQuestWatches()` reaches `Constants.QuestWatchConsts.MAX_QUEST_WATCHES`, Track refuses a quest not already watched with Blizzard's `OBJECTIVES_WATCH_TOO_MANY` (`ns.HasRoomToTrack`). Untracking goes through Questie's `UntrackQuestId` when Blizzard has no watch to remove. Otherwise, or when that Questie call is missing or throws, it goes through `C_QuestLog.RemoveQuestWatch`, but only while `QuestUtil.CanRemoveQuestWatch()` allows it (`ns.CanRemoveQuestWatch`). If `IsTrackedByQuestie` throws, a quest counts as tracked by Blizzard's watch. A quest Questie can't show is refused four ways: a one-time chat explanation per quest per session (`QUESTIE_CANNOT_SHOW`), a `QUESTIE_CANNOT_TRACK` error on every refused click, a tooltip on the grayed-out Track button, and a grayed-out Track item in the list's right-click menu. Untracking from Questie's own menu doesn't always touch Blizzard's watch list, so the window also repaints on Questie's tracker updates: `ns:OnDatabaseReady` (`Features/Forever-Quest-Log.lua`) post-hooks `QuestieTracker.Update`, on WoW Forever and Mists alike.

### Classic Era and TBC

Questie's tracker removes Blizzard's watch as soon as it takes a quest, to stay clear of Blizzard's watch limit, so Blizzard's watch count stays at 0 however many quests Questie tracks. Untrack All therefore never counts Blizzard's watches. It goes over the listed quests and untracks each one that `IsQuestWatched` reports as tracked (Questie replaces `IsQuestWatched` with its own tracking state): it takes the quest out of `QUEST_WATCH_LIST` and calls `RemoveQuestWatch`, which Questie hooks to untrack in its tracker too. Once Questie's tracker has started (`ns.IsQuestieTracking`, `Features/Tracking-Mark.lua`), every quest is trackable and there's no limit. Before that, Blizzard's rules hold: only quests with objectives (`GetNumQuestLeaderBoards`), up to `MAX_WATCHABLE_QUESTS`.

### Mists

Mists' watch calls take a quest log index, as Classic Era's do, so `Features/Mists-Tracking.lua` takes the quest IDs the window passes and looks up each index (`ns.GetLogIndexForQuestID`). Once Questie's tracker has taken over, it hooks `AddQuestWatch` and `RemoveQuestWatch` and replaces `IsQuestWatched`, so the same calls reach whichever tracker is in charge. No quest is refused, because `ns.CanTrack` and `ns.CanRemoveQuestWatch` are always true: unlike WoW Forever there's no chat explanation or grayed-out Track, and unlike Classic Era and TBC a quest with no objectives can be tracked before Questie starts. `ns.HasRoomToTrack` holds for a quest already tracked, while Questie is tracking, or under `MAX_WATCHABLE_QUESTS` until then. Past that, Track posts `QUEST_WATCH_TOO_MANY`. Every change ends in `Redraw`, which calls `WatchFrame_Update` and `ns.RequestUpdate`. `ns.IsTracked` and `ns.HasRoomToTrack` take an optional `questLogIndex`, because a lookup by quest ID walks the whole log; WoW Forever's versions ignore it.

### Before Questie's Tracker Starts (Every Client)

Questie starts its tracker a few seconds after login, partway through its staged startup. Until then nothing reads as tracked: on WoW Forever Questie's quest list is still empty, on the other clients `IsQuestWatched` is Blizzard's until Questie replaces it with its own, and on Classic Era and TBC Questie keeps no Blizzard watches. With Mark Untracked Quests on (`markUntracked`, the default), that would flash a red eye on every quest. So `ns.ShowTrackingMark` (`Features/Tracking-Mark.lua`) draws no marks while Questie's tracker is enabled but not yet `started`. The first time it sees that state, it hooks `QuestieTracker:HookBaseTracker`, which Questie calls as the tracker starts, to redraw the quest log through `ns.RefreshQuestLog` (which also clears the frozen zone order), only while the wide quest log runs (`ns.wideQuestLogActive`). Only the marks wait: WoW Forever's Track button and Track All read Questie's quest list whether or not the tracker has started, and Mists' follow Blizzard's cap until it does.

## Sorting

Both quest logs sort with the same rules in `Features/Quest-Sort.lua`, on records that carry `sortLevel`, `sortKey` (the lowercased title, `ns.NameSortKey`) and `sortIndex` (the quest log index). The settings are profile keys from the Wide Quest Log panel's Sorting section:

- **Zones** by `zoneSort`: average quest level (`ns.AverageLevel`), highest first by default (`LEVEL_HIGHEST_FIRST`), or lowest first, or alphabetical by full name, so The Hinterlands goes under T. A zone whose level isn't known goes after the rest. Zones tied on level fall back to their name, then to the quest log's order. With `currentZoneFirst` (on by default), the zone the player is in goes before them all.
- **Quests** within each zone by `questSort`: level, highest first by default, or lowest first, or alphabetical. With `completedFirst` (on by default), quests ready to turn in go before the rest, each group in the `questSort` order. Ties fall back to the quest log's order.
- **Quests outside any zone** list first, before every zone, in the same `questSort` order.

A quest's level is the one its tag shows: on WoW Forever and Mists the entry's `difficultyLevel`, or its `level` where it has none; on Classic Era and TBC the plain `GetQuestLogTitle` level.

The add-on sorts to every option itself, so each one holds the same on every client. The current zone is found by name: `ns.IsCurrentZone` compares a header's text with `GetRealZoneText()`, so a class or profession header never matches, and a dungeon's header matches only while the player is inside it. `ns.SortZones` freezes the zone order, as ranks keyed by zone title, the first time it sorts after the window opens, so turning in or dropping a quest doesn't reshuffle zones under the cursor. A zone the frozen order doesn't know (a quest picked up in a new zone) goes after all of them. The order clears (`ns.ResetZoneOrder`) when the window closes, a Quest Log setting or the profile changes, or Questie's tracker starts; the last three clear it through `ns.RefreshQuestLog`. The freeze includes `currentZoneFirst`: crossing into a new zone (`ZONE_CHANGED_NEW_AREA`) moves the green check after the zone's name (`ns.ZoneHeaderText`, `CURRENT_ZONE_MARK`) at once, but the zone only moves to the top the next time the window opens.

On WoW Forever and Mists, `ns.BuildQuestListEntries` (`Features/Forever-Quest-List-Entries.lua`) builds the sorted entries and `ns.UpdateQuestList` (`Features/Forever-Quest-List.lua`) draws them in the add-on's own list. The visibility rules match the map's quest list: no hidden quests, no task quests (world quests and bonus objectives), a bounty only once it's complete, and no zone whose quests are all left out. It also returns every quest that would show with its zone open, for Track All, the turn-in line and the empty-log check. The first time the window opens in a session, `ns.ExpandAllZones` opens every zone, so collapsing one lasts only until the next login or reload. On Mists the entries come from `GetQuestLogTitle` through `ns.GetQuestLogEntry` (`Features/Quest-Log-API.lua`), which adds `isComplete` and `isFailed`, read from the entry because asking by quest ID there walks the whole log.

While in a group, hovering a quest's row lists the party members who have it (Blizzard's `PARTY_QUEST_STATUS_ON`, names in class colors), or `PARTY_QUEST_STATUS_NONE`, as Blizzard's own rows do on Classic Era and TBC. For each `party`N unit up to `GetNumSubgroupMembers()` it asks `ns.IsUnitOnQuest` (`C_QuestLog.IsUnitOnQuest`, or `IsUnitOnQuest` by log index where that's missing), so in a raid it covers the player's subgroup only. It passes over a member whose answer, name or class WoW Forever hands back as a secret value (`ns.IsReadable`), and when any answer is secret it shows no "none" line, since that would be a guess.

On Classic Era and TBC the rows are Blizzard's. `QuestLog_Update` fills row *i* with quest log entry *i* + scroll offset, and every row handler (click, shift-click track and link, collapse, the party tooltip, Share Quests) finds its entry from the row's ID plus that offset. So after Blizzard draws, `Features/Classic-Quest-Sort.lua` redraws each row with the entry at its sorted place, the way `QuestLog_Update` would, and sets the row's ID to match. `Classic-Quest-List.lua`'s `QuestLog_Update` hook runs, in order: the sort (`ns.BuildClassicDisplayOrder`), the scroll range, the redraw, the row spacing, VoiceOver's buttons, each row's style, the list buttons, the turn-in line, and the map's empty-log check. Selecting a quest highlights its row by place in the list, so the highlight is moved again after `QuestLog_SetSelection`. A collapsed zone lists no quests, so it sorts by its average from when it was last seen open (kept for the session), or after the rest when it hasn't been. When the sorted order matches the quest log's own (zones alphabetical, each zone's quests lowest level first), nothing is redrawn and each row's ID is put back to its place.

Rows are padded on every client (`LAYOUT.ROW_PADDING`, 2px, in `Data/Data.lua`). A quest row is `QUEST_ROW_HEIGHT`, the row's text with 2px above and below, and a zone header `HEADER_ROW_HEIGHT`, tall enough for its Share Quests button with 2px above and below. With `zoneGap` (on by default), every zone header but the first gets `HEADER_GAP` (8px, half a row) above it. The quest details start level with the first quest row (`CONTENT_TOP`). On WoW Forever and Mists the scroll box's extent calculator gives each row its height, and the gap is a blank spacer entry. On Classic Era and TBC, Blizzard's rows keep their own height, and `RowTops` places each one centered in its slot, below the gap. `ExtendScrollRange` widens the scroll range until the last entry can be scrolled fully into view, and `PositionRows` hides the rows pushed past the bottom.

## Expand All, Track All and Show Map

Both quest logs put three buttons in a bar above the list. `ns.CreateListButtons` (`Features/Window.lua`) makes the first two, and `Features/Quest-Map.lua` hangs Show Map after them from `ns.listButtons`. Each toggles its label (Expand All or Collapse All, Track All or Untrack All, Show Map or Hide Map) and is sized the first time it shows, once the font is sure to be loaded: the wider of its labels in this locale plus `LAYOUT.LABEL_PADDING`, never narrower than `LAYOUT.BUTTON_WIDTH`, so no button changes size as its label switches. Expand All and Track All share one width, the widest of their four labels. Collapse All shows while any zone is open, and Expand All once every zone is collapsed.

- **Track All** shows while a listed quest could still be tracked and the watch list has room, and Untrack All once none can. Untrack All grays out when nothing is tracked. It tracks in list order, top down, so a nearly full watch list fills with the quests the player sees first, and stops when the list is full, posting Blizzard's own "too many" string to the error frame (`UIErrorsFrame:AddMessage`): `QUEST_WATCH_TOO_MANY` on Classic Era, TBC and Mists, `OBJECTIVES_WATCH_TOO_MANY` on WoW Forever. On those three the list is never full once Questie's tracker has taken over; on WoW Forever Blizzard's cap holds even then (see Questie Tracking).
- **Classic Era and TBC** (`Features/Classic-Tracking.lua`) track and untrack exactly as a shift-click on each quest would (see Taint and Questie Tracking): `AutoQuestWatch_Insert` with `QUEST_WATCH_NO_EXPIRE` to track, then `QuestWatch_Update` and `QuestLog_Update`, over the quest log's listed entries, so quests under a collapsed zone are passed by. The buttons sit in the frame of Blizzard's "All" toggle (`QuestLogExpandButtonFrame`), which Blizzard hides while the log is empty. The toggle itself, and Blizzard's Track toggle (`QuestLogTrack`), which would peek out between the buttons, are faded out and unclickable rather than removed. Expand All runs the toggle's click (`QuestLogCollapseAllButton_OnClick`) and takes its label from the toggle's `collapsed`, so Blizzard's record of whether everything is collapsed stays right.
- **WoW Forever** (`Features/Forever-Tracking.lua`, `ns.SetAllTracked`) covers every quest in the list, collapsed zones included, and skips quests Questie can't show, without the chat explanation a single Track click gives. Expand All is disabled while the list has no quests, and Untrack All also needs `QuestUtil.CanRemoveQuestWatch()`.
- **Mists** (`Features/Mists-Tracking.lua`, `ns.SetAllTracked`) covers every quest in the list, collapsed zones included, as WoW Forever does, skipping none, and redraws `WatchFrame` when done. Expand All is disabled while the list has no quests, and Untrack All is never refused.
- **Show Map** hides on every client while the log is empty (`questMap.SetLogEmpty`, called by both list files), along with the map, which comes back with the first quest. On WoW Forever and Mists "empty" means no quest the list would show; on Classic Era and TBC, no quest log entries. `mapHidden` isn't touched.

## Share Quests

Hovering a zone name shows a **Share Quests** button at the right end of its row (`Features/Zone-Share.lua`, every client). Zone rows are tall enough to hold it: `LAYOUT.HEADER_ROW_HEIGHT` is `LAYOUT.ZONE_SHARE_BUTTON_HEIGHT` (16) plus `LAYOUT.ROW_PADDING` above and below. There's one button, moved onto whichever zone row the mouse is over and parented to it, so it hides with the row. It hides as the mouse leaves both the row and the button (`ns.HideZoneShareButton`, and the button's own `OnLeave`), and each list file calls `ns.UpdateZoneShareButton` as it redraws a row, so a row recycled for a quest drops it. On Classic Era and TBC under ElvUI it's skinned with the list buttons (`ns.zoneShareButton`, `Classic-ElvUI.lua`).

It is grayed out while solo (the tooltip says `ERR_NOT_IN_GROUP`; in a group it says `SHARE_ZONE_QUESTS_TOOLTIP` with the interval) and while a share run is still going (`ns.sharingQuests`, which the dungeon quests' sharing sets too), checked every frame while it shows. Clicking finds the zone's quests the game lets the player share (`ns.ShareableZoneQuests`) and prints the line `ns.BuildSharePrint` (`Features/Announcements.lua`) builds: `CHAT_SHARING_ZONE_NONE` when there are none, `CHAT_SHARING_ZONE_ONE` for one, otherwise `CHAT_SHARING_ZONE` with the count, zone and interval. The button then grays itself out and hands the quest IDs to `ns.ShareQuests`, which shares one every `ns.GetShareInterval()` seconds: a `C_Timer.After` chain using the interval as it was when the run began, re-finding each quest and checking it's still shareable before it goes, and clearing `ns.sharingQuests` after the last. Which quests can be shared is only worked out on the click, because on Classic Era, TBC and Mists that means selecting each quest. The interval is the Quality of Life panel's `shareInterval` slider (default 3), between `SHARE_INTERVAL_MIN` (3) and `SHARE_INTERVAL_MAX` (10), because a share sooner than 3 seconds after the last gets the party member reported as busy. With the Quality of Life switch off, the default applies. Only the slider enforces the range; `ns.GetShareInterval` returns the saved value as it is.

A Zone-Actions file does the work by quest ID through four `ns` names: `ns.ShareableZoneQuests` (the zone's shareable quest IDs, and how many quests it holds), `ns.ShareQuests`, `ns.LogQuests` (every quest with its zone, state and whether it's shareable) and `ns.SharedQuest` (see Share Reminders). In `Classic-Zone-Actions.lua`, which Classic Era, TBC and Mists all load, that's awkward, and the file exists to contain it:

- Sharing acts on the **selected** quest, and only the selected quest can be asked whether it's shareable (`GetQuestLogPushable`), so each quest is selected in turn and the player's selection is put back afterwards. It's put back by its index once the zones are closed again, since every entry is then back where it was, so a selected zone header, or no selection, comes back too.
- The quest log lists **no quests under a collapsed zone**, so `ns.ShareableZoneQuests` expands the one zone to look and collapses it again. Sharing and listing the whole log (`ns.LogQuests`, for the dungeon quests) expand everything (`ExpandQuestHeader(0)`), then re-collapse the zones that were closed from the bottom up, so the indexes above each one still hold. Sharing does this for each quest as it goes, so a quest under a zone the player has collapsed is still found. Because `ns.LogQuests` expands every zone and selects every quest, the dungeon parts of the reports read `ns.DiagnosticLogQuests` (`Diagnostics/Manifests.lua`) instead, which reads only open zones and knows only the selected quest's shareability. The Message Length report's longest-title lookup and Sharing Context's zone lookup call the real one, and it restores everything after.

On Classic Era and TBC the button follows `OnEnter` / `OnLeave` hooks on Blizzard's rows (`Classic-Quest-List.lua`), and `StyleQuestRows` updates it on every pass. Zone rows keep Blizzard's own clicks, so a right-click collapses the zone as a left-click does.

On WoW Forever (`Forever-Zone-Actions.lua`) the quest log lists a collapsed zone's quests too, so the zones are left as they are, and `C_QuestLog.IsPushableQuest` answers by quest ID. It leaves out hidden and task quests as the list does, but counts a bounty that isn't complete, which the list doesn't show. Each share selects the quest, shares it, then selects the quest the window's details show again. On WoW Forever and Mists the list's `Row_OnEnter` / `Row_OnLeave` show and hide the button, and `InitRow` updates it; `Row_OnClick` toggles a zone on either mouse button, so a right-click collapses it there too. On Mists, `Classic-Zone-Actions.lua` restores Blizzard's selection, which can differ from the quest the window shows.

The button belongs to the wide quest log's list, so with the Wide Quest Log switch off there's none, and the Quality of Life panel says so under Quest Sharing (`ZONE_SHARE_NEEDS_WIDE_LOG`); dungeon quest sharing works either way. Both quest logs' Share Quest buttons explain why they're grayed out when the player isn't in a group (`ns.ExplainShareButton`, `Features/Utilities.lua`). The Wide Quest Log panel's Handy Clicks section lists the easy-to-miss clicks; its Right-Click a Quest row shows only on WoW Forever and Mists (`ns.questLogIsOwnWindow`), because on Classic Era and TBC a right-click on a quest stays Blizzard's.

## Share Reminders

When a share fails for a reason the party member can fix, `Features/Share-Reminders.lua` whispers them which quest it was. Failures they can't fix (not eligible, already on it, already done) get none.

- **Which results.** `FIXABLE_RESULTS` lists the client's own result strings (`ERR_QUEST_PUSH_BUSY_S`, `ERR_QUEST_PUSH_TOO_FAR_S`, `ERR_QUEST_PUSH_LOG_FULL_S`), read through `_G` by name. All three get the same whisper, which doesn't say why: the game already told them. Each string is turned into an anchored pattern at load, its `%s` (or `%1$s`) catching the player's name, so `CHAT_MSG_SYSTEM` is matched in whatever language the client runs. A client without one of the strings skips it.
- **Which quest.** The result names the player but not the quest, so a `hooksecurefunc` on `QuestLogPushQuest`, which every way of sharing calls, notes the quest as each share goes out through the loaded Zone-Actions file's `ns.SharedQuest`: the log entry it was passed, since WoW Forever's share menus pass one without selecting the quest, or else the selected quest. A zone header notes nothing. A result counts only within `ns.GetShareInterval()` of that share, the gap Share Quests leaves between shares, and each player is whispered once per share.
- **Which whisper.** A player's first failure gets the full whisper (`WHISPER_SHARE_FAILED`); every later one gets the short follow-up (`WHISPER_SHARE_FAILED_AGAIN`), naming just the quest. `told` remembers who has had the full one until the player joins or leaves a group (`GROUP_JOINED`, `GROUP_LEFT`, party or raid). The dungeon quests handle those events too, so these handlers sit on `ns.shareReminders`, named in their own `EVENTS` rows.
- **When.** Only with the Quality of Life switch and `shareWhispers` both on (both default on), and only in a party: never in a raid, a battleground or an arena, where it would be too much spam. Sharing itself still works there. During chat lockdown the system message is secret and can't be read (`C_ChatInfo.InChatMessagingLockdown`, checked on every client), so nothing is sent.

The whisper goes through `ns:Announce`, so it has the house sent-message shape: the marker (`ns.TARGET_MARKER`), the body (the strings for other players are written with no closing period), then ` // ` and the short name (`L["ADDON_SHORT_NAME"]`). WoW Forever blocks raid-marker tokens in chat, so `ns:BuildAnnounceMessage` leaves the marker off there:

```
{rt3} I tried to share [Quest Name] with you, but it didn't go through. ... // PWQL
{rt3} Same goes for [Quest Name] // PWQL
```

The quest reference is the best one that keeps the whole whisper within `ns.CHAT_MESSAGE_MAX_LENGTH` (255 bytes, past which `SendChatMessage` rejects the message), chosen by `ns.FittingQuestReference` (which `ns.ShareWhisperQuestReference` wraps for the whispers): Questie's native quest link (`QuestieLink.GetNativeQuestLinkStringById`, clickable for anyone), then Questie's bracketed text (`GetQuestLinkStringById`, a link for players who run Questie), then the title in brackets, cut on a UTF-8 character boundary to `[Title...]` when even that won't fit. The Localization tab's Message Length report builds each whisper for the longest quest title in the log and shows its byte count, marking it SHORTENED where the title had to be cut.

The Quality of Life panel's Example lines show what happens on this client. They sit under Seconds Between Shares and under the whisper, dungeon announcement and dungeon sharing toggles, each of the last three hiding while its toggle is off, and are built by the same code the features send with: `ns.BuildShareWhisper`, the first message of `ns.BuildDungeonAnnouncement`, and for the two print lines, `ns.BuildSharePrint` with the sample quest count, drawn by `ns.BuildPrintLine`. The silver is only the "Example:" label (`SAMPLE_EXAMPLE`). The whisper draws as the party member receives it and the announcement as party chat, each in the client's own chat colors (`ChatTypeInfo`, with a fixed color for a client that hasn't filled it in), with its prefix (`CHAT_WHISPER_GET`, `CHAT_PARTY_GET`), the player's character as a class-colored sender, and the marker as its icon. The color is reopened after each `|r`, because a panel falls back to white after a link where chat falls back to the channel color. The lines name real quests and areas from the flavor's `ns.SAMPLE_QUEST_IDS`, `ns.SAMPLE_DUNGEON_AREA_ID` and `ns.SAMPLE_ZONE_AREA_ID` (`Data/{Game}/Sample-Quests-{Game}.lua`; the slider's line falls back to the dungeon area), with area names from `C_Map.GetAreaInfo`. A title the client hasn't loaded is requested with `C_QuestLog.RequestLoadQuestByID` and shows `SAMPLE_QUEST_LOADING` until it arrives. A flavor with no samples hides the rows.

## Dungeon Quests

In a dungeon with a party, `Features/Dungeon-Quests.lua` tells the party which of the player's quests still need doing there and shares the ones the game lets them share. Both are Quality of Life settings, on by default: `dungeonAnnounce` and `dungeonShare`.

- **Where.** An instance of type `party` or `raid` (`GetInstanceInfo`), while in a party: `IsInGroup()` and not `IsInRaid()`. Nothing runs in a raid group, where announcing and sharing to everyone would be spam; a party that converts to a raid stops, and one that converts back picks up where it left off.
- **When.** `PLAYER_ENTERING_WORLD`, `GROUP_JOINED` and `GROUP_ROSTER_UPDATE` only start a `C_Timer.NewTicker` that checks every `ns.DUNGEON_CHECK_INTERVAL` (2) seconds, and only while one of the two settings is on in a party dungeon. `GROUP_ROSTER_UPDATE` goes to `ns.dungeonQuests:OnGroupRosterUpdate`, since `Forever-Quest-Log.lua` owns `ns:OnGroupRosterUpdate`. The ticker cancels itself once nothing is left to do or the player is no longer in a party dungeon. A check waits until every online party member is in range (`UnitInRange`), or `ns.DUNGEON_SHARE_MAX_WAIT` (60) seconds after the wait began, so the announcement and the shares reach a party that has actually gathered rather than whoever zoned in first. WoW Forever answers `UnitInRange` for no one, so there everyone counts as in range and both go out on the first check.
- **Who counts.** The other party members (`GetNumSubgroupMembers`) who are online (`UnitIsConnected`), by GUID. A slot the game hasn't filled in yet, as happens around a loading screen, is left out, so it never reads as someone leaving and coming back. On a client with `issecretvalue`, a member whose GUID or connection comes back secret is left out too (`ns.IsReadable`), since a secret value can't be tested.
- **What this group has had.** State is keyed by the dungeon's instance ID (the 8th return of `GetInstanceInfo`), so every instance of it, re-entered or reset, shares one key and the key never depends on Questie. Per key it holds whether the dungeon was announced, and the GUIDs its quests were shared with. All of it is held in memory and dropped on `GROUP_LEFT`. So the announcement goes out once per dungeon per group, and the shares once per party member per dungeon: zoning out and back in shares nothing, and someone who joins later gets a run of their own. That run goes through `QuestLogPushQuest`, which offers each quest to the whole party; those who already have it get the game's "already on it" result, which earns no whisper. A member still out of range when the wait ends starts a fresh wait, and is shared with once everyone is in range, or that wait runs out with them in range.
- **Login and reload.** A login or `/reload` inside a dungeon isn't arriving there: the group most likely had it already. `PLAYER_ENTERING_WORLD`'s `isInitialLogin` and `isReloadingUi` mark the party as served, so until `ns.DUNGEON_LOGIN_GRACE` (10) seconds after the first member shows up (the roster can fill in late after a login), each check marks the dungeon announced and every member seen as shared with. The next loading screen ends it; anyone who joins after the grace is shared with as usual.
- **Which quests** (`Features/Dungeon-Quest-Lookup.lua`, which also works out the dungeon and its key). A quest counts if it's listed under a quest log header with one of the dungeon's names (`GetRealZoneText()`, the instance name, or the area name of any of its Questie zone IDs), or if Questie places it there: filed under the dungeon (`zoneOrSort`), or a creature, object or item it asks for (creatures and objects by their spawns, items by what drops them), a kill credit, an explore trigger, an extra objective or a required source item found there. This is what catches class quests. The Questie zone ID comes from `ZoneDB.instanceIdToAreaId` on the instance ID, and Questie files some dungeons' quests under a second zone ID, so the dungeon's alternative IDs from `ZoneDB:GetDungeons()` count too. World event quests (holidays and the Darkmoon Faire, by `QuestieEvent.IsEventQuest`) never count, even under the dungeon's header, as Questie can place one in a dungeon it has nothing to do with. Without Questie, or for a dungeon Questie's `ZoneDB` doesn't know, the header alone decides.
- **The announcement** leaves out quests ready to turn in or failed, and goes to `ns:GetGroupChatChannel()` (instance chat or party, since it never runs in a raid). It's a parts list: each quest named as a share whisper names it (`ns.FittingQuestReference`), packed greedily and split only between quests, so a link is never broken. The first message says how many (`DUNGEON_QUESTS_ANNOUNCE`, or `DUNGEON_QUESTS_ANNOUNCE_ONE` for a single quest); every later one has a lead of its own (`DUNGEON_QUESTS_ANNOUNCE_CONTINUED`), so each message reads as a whole. Nothing is sent when no quest is left to do, or during chat lockdown (`C_ChatInfo.InChatMessagingLockdown`); the dungeon still counts as announced.
- **Sharing** takes every matched quest the game lets the player share (`pushable` from `ns.LogQuests`), ready to turn in or not, and hands them to `ns.ShareQuests`, Share Quests' paced run, with the same `ns.BuildSharePrint` line naming the dungeon. When none can be shared it prints nothing, and the members still count as shared with. While a run is still going (`ns.sharingQuests`, Share Quests' included), sharing waits for the next check, and the members it was for aren't marked until it goes. A failed share gets the usual whisper (see Share Reminders).

```
{rt3} I have 5 quests to do here: [Quest], [Quest], [Quest] // PWQL
{rt3} More quests to do here: [Quest], [Quest] // PWQL
```

Inside a dungeon, the Sharing Context report shows its instance ID, key and Questie zone IDs; whether the player is in a raid group, whether the ticker is watching, whether this group has had the announcement, and how long the party has been waited for (of the 60 seconds); each online party member with whether they're in range and have had the shares (with a line saying WoW Forever hides party range); each matched quest with what matched it (`header` or `Questie`), its state and whether it can be shared; and the announcement as it would be sent, with each message's byte count. The Message Length report also builds the announcement for every quest in the log still to do and flags any message over the limit (OVER). Where the log goes by index (Classic Era, TBC and Mists), the announcement and its matched quests read only open zones' quests (`ns.DiagnosticLogQuests`), so building them doesn't expand the log or move the selection; Sharing Context says how many zones are collapsed.

## Quest Text

Quest text is set the same way in both quest logs and in the quest giver window on every client (`Features/Quest-Display.lua`, with the rewards in `Features/Quest-Rewards.lua`). Lines are `LAYOUT.LINE_SPACING` apart. The section headings (Description, Rewards, and Objectives wherever the client's `QuestInfo` has that heading) are `SECTION_HEADING_SHRINK` (3) smaller than the quest's title, or the title's size under ElvUI, whose title font is already small. In the quest logs, objective lines also take the description's font rather than Blizzard's smaller one.

Every gap, margin and padding is a step on one scale, `LAYOUT.SPACE` in `Data/Data.lua` (`TIGHT` 2, `LINE` 4, `NEAR` 8, `GROUP` 16, `SECTION` 32), each step twice the last, so the space between two things says how closely they belong together: lines of a paragraph 4 apart, a heading 8 over its text, sections 32 apart. Sizes the add-on picks freely follow the same doubling (the Quest Arrow is 64px, its list 512px wide). Positions that line up with Blizzard's art, and Blizzard's own control sizes, stay as they are.

While the cleanup is on, the quest giver window's pages (greeting, detail, progress and reward) and the gossip window are put on the same scale, keeping Blizzard's anchors and changing only the space above each piece. The rewards block is spaced by `ns.SpaceRewardsBlock` (`Quest-Rewards.lua`), shared with the quest details on WoW Forever and Mists; the Classic Era and TBC details space their reward buttons with the same file's `ns.SpaceAroundRewardButtons`.

- **Styled before layout.** The shared `QuestInfo` text is the quest giver window's on every client, and on WoW Forever and Mists the quest details' too, so it follows the quest giver window cleanup (see Quest Giver Window): `ns.ApplyQuestGiverCleanup` styles it as the saved settings load, before Blizzard first lays any of it out, so Blizzard measures the text as it will be drawn, or with the cleanup off leaves it Blizzard's. A piece a client lacks is skipped. On WoW Forever and Mists the details restyle it before every repaint whatever the switch says, in case something else restyled it since. The section heading font (`PrettyWideQuestLogSectionHeadingFont`) follows every `SetFont`, `SetShadowColor` and `SetShadowOffset` on `QuestTitleFont`, which skins set after this file loads.
- **Experience and gold** are set in the description's font and color, rather than Blizzard's white outlined number font, from a `QuestInfo_Display` hook in `Quest-Rewards.lua`. The experience number's thousands are grouped by `ns.FormatNumber`, because `BreakUpLargeNumbers` can leave them ungrouped. Skins (ElvUI) add the share of a level after the number ("2,950 (+20.49%)") in a bright green made for their dark backdrop, in a hook that may run before or after this one, so only the number at the front is regrouped and the rest kept; while the description is dark (luminance under 0.5, as on the parchment), every color code in that text becomes `PARCHMENT_GAIN_COLOR` (`1d6b1d`) after each `SetText` and `SetFormattedText`. Gold gets a font object of its own (`PrettyWideQuestLogMoneyFont`, a copy of the description's with no shadow) on each coin button; Blizzard sizes each coin to its text when it lays the coins out, so after a change of font `MoneyFrame_Update` lays them out again for the same amount. The hook acts for every caller, the world map's details on WoW Forever and Blizzard's quest log on Mists included, except a quest giver page with the cleanup off, where both go back to Blizzard's.
- **Reward names**, wherever `QuestInfo` shows rewards (`Quest-Giver.lua`). Blizzard draws them white on a dark name plate, and a skin that hides the plate leaves them white with a shadow on the bare parchment, so with the plate hidden (or at alpha 0) they take the description's color without the shadow. The buttons are shared, so every display restyles every button it shows, and again a frame later because skins restyle them in hooks that may run after. On a quest giver page with the cleanup off they go back to the color and shadow they had.
- **Skins recolor late.** ElvUI recolors objective lines in hooks that can run after the styling, so each count column matches its line's color again a frame later. The quest ID copies the description's color the same way, and its chain link has that color written into the text, so `ns.StyleQuestID` hooks `SetTextColor` on the description the first time it styles a quest ID and redraws both whenever the color changes.
- **TBC's daily quests** get a line under the title saying when dailies reset (`GetQuestResetTime`), with the objectives hung `DAILY_RESET_SPACE_BELOW` below it while it shows. Classic Era has no daily quests, so it never shows there, and the line is in the Classic details file, so Mists and WoW Forever don't have it. Its color follows `SetTextColor` on the description, as the quest ID's does.
- **Mists' text width.** Mists sets the description and objectives text 270 wide whatever the template says, so `ns.DisplayQuestDetails` (`Forever-Quest-Details.lua`) sets their width back to the column's right after its own `QuestInfo_Display` call, on both window clients. Other callers' text (Blizzard's quest log on Mists, the quest giver pages) keeps Blizzard's width.

## Quest Giver Window

Everything here follows `ns.IsQuestGiverCleanupOn()`: the Quality of Life switch and `giverCleanup` both on, whatever the Wide Quest Log switch says. Turning it on or off, or changing profile, reapplies it at once through `ns.ApplyQuestGiverCleanup`, which every Quality of Life toggle's `set`, both Quality of Life switches (General and Quality of Life panels) and `ns:ApplyProfile` call, as does Core as the saved settings load. A quest giver window already open is laid out again the next time it opens.

- **Its own text** (`Features/Quest-Giver.lua`): the text the greeting, detail, progress and reward pages hold themselves rather than through `QuestInfo`, chiefly the progress page's, which no client draws with `QuestInfo`. It's found by font, not by name: text in the title's font is a heading, the one hung from the top of its page being the quest's title. Each piece's font and spacing is kept as Blizzard left it the first time it's changed, and put back when the cleanup goes off. It's styled as the saved settings load, before Blizzard first lays it out.
- **The shared `QuestInfo` text** of the detail and reward pages, on every client, is styled by `ns.StyleQuestInfo` with the cleanup on and put back by `ns.RestoreQuestInfoStyle` with it off (`Features/Quest-Display.lua`).
- **The detail and reward pages** are spaced from a `QuestInfo_Display` hook (`SpaceQuestGiverPage`), which walks the template's elements and sets each piece's space above by what it is (`PIECE_KINDS`): the first piece `PAGE_TOP` (16) down the page; a heading `HEADING_SPACE_ABOVE` (32) under what's above it, and the rewards that plus `REWARDS_HEADING_RISE` (3) on WoW Forever and Mists, as in their quest details; text `TITLE_SPACE_BELOW` or `HEADING_SPACE_BELOW` (8) under the title or heading that introduces it; the smaller pieces (special objectives, group size, timer, objectives frame) `SPACE.NEAR` under the text. Only `TOPLEFT` anchors move, and the rewards block then goes through `ns.SpaceRewardsBlock`. Blizzard lays each page out afresh, so with the cleanup off it's left alone.
- **The greeting page** (`Features/Quest-Giver-Pages.lua`) is for a quest giver with quests and nothing else to say. The greeting sits `PAGE_TOP` down; Current Quests and Available Quests sit a section under it, or right under it when the greeting is empty; each list's first line is a heading's space under its heading, and the lines `QUEST_LINE_SPACE` (8) apart. Blizzard's 32px break between the two lists (`QuestGreetingFrameHorizontalBreak`, hidden by skins such as ElvUI but still holding its place) becomes the whole section's space. Blizzard anchors everything but the greeting afresh on each show, so with the cleanup off only the greeting goes back, to the offset kept the first time. It runs from the panel's `OnShow` and from `QuestFrameGreetingPanel_OnShow`, which Blizzard calls directly when the page is already open. Its quest lines are pooled buttons (`titleButtonPool`) where the client has the pool, else `QuestTitleButton1`, `QuestTitleButton2` and so on.
- **The progress page** (`Features/Quest-Giver-Pages.lua`, every client) is spaced from a `QuestFrameProgressItems_Update` hook: the title `PAGE_TOP` down and its text `TITLE_SPACE_BELOW` under it, the "Required items:" heading a section down, the gold or the first row of items a heading's space under it, and the first row `SPACE.NEAR` under the gold when gold is asked for. The quest ID goes right-aligned, `QUEST_ID_GAP` (32) under the last thing on the page (the left button of the last row of items, else the gold, the heading or the text), and `ns.CreateRoomBelow` keeps `PAGE_TOP` of empty room under it, so scrolled to the bottom it sits clear of the page's edge. Blizzard anchors the first row of items afresh each time, so with the cleanup off the title, text, heading and gold go back to the offsets kept the first time each moved, and the quest ID hides.
- **The gossip window** (`Features/Gossip.lua`, every client, since all share Blizzard's gossip code) lists the greeting, two spacer rows, the available quests, a spacer, the active quests, a spacer and the options in one scrolling list, each line only as tall as its text and every spacer 16 tall. With the cleanup on, each quest and option line gets half of `QUEST_LINE_SPACE` above and below it, from hooks on each button mixin's `Setup` and on the button's own `Resize`, which runs whenever its text changes; the greeting sits `PAGE_TOP` down in the quest text's line spacing (`GossipGreetingTextMixin.Setup`); the two spacers under the greeting share a section's space, less the first line's padding, and the other spacers make a group's space, less the padding either side. The list measures rows through its extent calculator, not the frames, so `WrapGossipRowHeights` wraps the view's `elementExtentCalculator` once per list (at load and on each `GossipFrame` `OnShow`) to add the same, styling the greeting inside the wrap because the measuring frame is only ever given the text. With the cleanup off every row measures and sits as Blizzard has it.
- **A skinned window's backdrop.** ElvUI keeps the parchment but draws the window around it see-through, so Questie's tracker or a nameplate shows through above and below the page. With the cleanup on, the skin's backdrop is opaque in its own color (`customBackdropAlpha = 1`, which ElvUI keeps through its color updates); with it off, it goes back to the skin's own alpha. ElvUI puts the backdrop on `QuestFrame` itself on WoW Forever and Mists, and on `QuestFrame.backdrop` on Classic Era and TBC; a window no skin has touched has neither and is left alone. Skins style the window after this file loads, so it's checked on each `QuestFrame` `OnShow` and by `ns.ApplyQuestGiverCleanup`.
- **The `QuestInfo` pages on WoW Forever and Mists** get the quest details' gold and experience placement (`ns.AlignRewardNumbers`) and quest ID: `LayOutSharedPieces` in `Forever-Quest-Details.lua` calls `ns.LayOutQuestGiverPage` (`Features/Forever-Quest-Giver.lua`). The quest ID goes `QUEST_ID_GAP` under the last piece Blizzard showed on that page (spacer, rewards, objectives, reward text or description); a piece left showing from the quest details sits on the quest log, not the page, so it doesn't count. The one quest ID, its room below and its Wowhead button move to whichever page shows. Their objective lines stay in Blizzard's font (`QuestFontNormalSmall`) with no check or count column, cleanup or not, because `LayOutSharedPieces` puts them back for every caller but the add-on's own details. The map's details keep Blizzard's gold and experience placement.
- **On WoW Forever and Mists that shared text** is the quest details' too, so with the cleanup off it's put back to Blizzard's (`ns.RestoreQuestInfoStyle`, from the font and spacing `ns.RememberBlizzardStyle` kept) whenever the switch changes and whenever the add-on's window hides, which it does as a quest giver window opens, before that window lays the text out. The experience number and gold on a quest giver page stay Blizzard's too.
- **Level tags** (`giverLevels`, a sub-option of the cleanup) put the quest log's tag ("[36]", "[40D]") in front of each quest line in a quest giver's list whose level is known (above 0), in the line's own color, with the letter from `ns.GetQuestTagByID`: the gossip window through hooks on `GossipSharedAvailableQuestButtonMixin.Setup` and `GossipSharedActiveQuestButtonMixin.Setup`, which then call the line's `Resize`, and the greeting page through its `OnShow` and `QuestFrameGreetingPanel_OnShow` (`Quest-Giver-Pages.lua`), reading `GetActiveLevel` or `GetAvailableLevel` and `GetActiveQuestID` or `GetAvailableQuestInfo`'s fifth return. Blizzard can run either more than once on the same text, so each button remembers the text it tagged (`levelTaggedText`) and isn't tagged twice.

## Quest Chain

When Questie knows the selected quest is part of a chain, the quest details show a Quest Chain section between the rewards and the quest ID, on every client (`Features/Quest-Chain.lua`), one row per part, under a heading counting the selected quest's place (`QUEST_CHAIN_PROGRESS`, "Quest Chain (2 of 5)"). On Classic Era and TBC the details file builds it inside its part, so it exists only while the wide quest log runs.

Parts already turned in (`C_QuestLog.IsQuestFlaggedCompleted`) get a check in the objectives' check column and a faded name (`TURNED_IN_ALPHA`, 0.6), and the selected quest's row sits instead on a faint band in the Description text's own color (`CURRENT_PART_BAND_ALPHA`, 0.12), reaching `CURRENT_PART_BAND_MARGIN` (4) above and below the row so it leaves room around the badge. Rows are `ROW_GAP` (`LAYOUT.HEADER_GAP`, 8) apart, the first a heading's space under the heading.

After the check comes the part's level ("78D") on a badge, a size down from the Description's text (`QUEST_ID_FONT_SHRINK`, 2), in its quest log color: the server's rating for the player where the client rates the part (a part in the log on WoW Forever, through `C_PlayerInfo.GetContentDifficultyQuestForPlayer`), else its level against the player's (`GetQuestDifficultyColor`). The quest log colors are made for dark backgrounds and wash out as text on the parchment, so the badge's box is the same color darkened (`BADGE_SHADE`, 0.3 of each channel): dark green under a green level, dark red under a red one. That reads the same on the parchment and on any skin, and the name stays in the Description's color. The badge is a pill with no art of its own (`CreateBadge`): a cap at each end, a square as tall as the pill under the game's circle mask (`Interface\CharacterFrame\TempPortraitAlphaMask`), and a middle running between the caps' centers, all three one solid color so the overlaps don't show. Every badge is as wide as the widest tag could be, plus `BADGE_PAD_X` (8) each side (two of the widest digit and the widest suffix letter, measured once per font in `BadgeTextWidth`), so the names line up; a part with no level keeps the room empty. Hovering a row shows Questie's own quest tooltip (`QuestieLink:CreateQuestTooltip`, for a `questie:<questID>:<player GUID>` link).

The chain comes from Questie's database through `QueryQuestSingle`, every call in a `pcall` since Questie may not be loaded or ready. Walking back, a part counts as the one before only if it's the quest's sole prerequisite (`preQuestSingle` with one entry and no `preQuestGroup`) and names the quest as its `nextQuestInChain`; walking forward follows `nextQuestInChain`. So where a chain branches, only its straight run shows. Both walks together stop at `MAX_PARTS` (25), which only a loop in the data reaches, and a chain of fewer than two parts is no chain. `ns.GetQuestChain` keeps the last chain found (`lastChain`) and returns that table, so callers only read it. A miss isn't kept, because before Questie's database is ready every quest looks like it's in no chain. Each row's name comes from the client, else Questie's, else the quest ID; it carries a level badge only when Questie gives a level above 0 and a color is known, whatever `showQuestLevels` says, with the tag from Questie's corrected `GetQuestTagInfo` where it has one, else the client's (`ns.GetQuestTagByID`). Questie's gives a tag ID and a tag name, so the chain is the one place an elite step is told by name: Questie's tag name against Blizzard's `ELITE`.

The section copies the Description heading's and text's font, color and shadow from the FontStrings themselves, because skins set them there rather than on the font objects. ElvUI recolors those two only after the details are filled, so the section also follows them: the first time it fills, `FollowSourceColors` hooks `SetTextColor` and `SetShadowColor` on both and recolors the heading and every row whenever either changes, whichever runs first.

## Ready to Turn In

`Features/Turn-In-Line.lua` totals the XP and gold waiting in quests ready to turn in, in a line centered between Abandon Quest and Share Quest (`ns.abandonButton`, `ns.shareButton`). Both come from Questie's `QuestXP` module, so the line is hidden while Questie isn't loaded; a quest worth no XP and no gold is left out, and the line hides when none remain. On Classic Era and TBC it counts only quests under open zones, since the quest log lists none under a collapsed zone; WoW Forever and Mists count collapsed zones too. `GetQuestLogRewardXP` is called with `self` and `GetQuestRewardMoney` without, matching how Questie defines each, both in a `pcall`. At the level cap it shows only the gold, as quest XP stops there. On Classic Era and TBC the list file makes it inside its part, so it exists only while the wide quest log runs. It's placed the first time it shows rather than when it's made, because there the quest log file records Blizzard's Abandon and Share buttons as `ns.abandonButton` and `ns.shareButton` only after the list file has made the line. Hovering it lists each quest under its zone (`OTHER` for quests outside any zone) in a tooltip of its own, `PrettyWideQuestLogTurnInTooltip`, made opaque after every `Show`, since showing restores the see-through style and the list opens over the quest text.

## Wowhead Link

Every quest ID the add-on shows (both quest logs' details, the progress page on every client, the quest giver pages on WoW Forever and Mists) is clickable (`Features/Wowhead-Link.lua`): hovering says so, and clicking opens `PRETTYWIDEQUESTLOG_WOWHEAD` with the quest's Wowhead address selected, ready to copy. Both act only while the quest ID line is showing. The popup's edit box puts the address back whenever it's edited, so it can't be lost, and Enter or Escape closes it. The address before the quest ID is `ns.WOWHEAD_QUEST_URL`, a single setting in each flavor folder (`Data/{Game}/Wowhead-{Game}.lua`), so the TOC picks the part of Wowhead: `/classic/` for Classic Era, Season of Discovery and WoW Forever, whose quests are Classic Era's, `/tbc/` for TBC, and `/mop-classic/` for Mists (the Wrath and Mainline files, which no TOC lists, hold `/wotlk/` and the site root). With no address set, `ns.LinkQuestIDToWowhead` returns without making the link, so a missing file shows no error, only no link; Quest Log Context prints the address (or `(none)`), and the Data tab's Wowhead row prints it or `TABLE MISSING`. `ns.LinkQuestIDToWowhead` marks the FontString (`linksToWowhead`), so `ns.StyleQuestID` starts it with the chain icon (`ns.WOWHEAD_LINK_ICON`) tinted to the quest ID's own color, and returns the button, so a quest ID that moves between parents takes it along.

## Quest Map

`Features/Quest-Map.lua` docks a map to the right of the window on every client, `HEIGHT_SHARE` (0.66) of the window art's height and in the map art's proportions (`MAP_ASPECT`, 1002 / 668). It is a quest log part like the rest, so on Classic Era and TBC it exists only while the wide quest log runs. `ns.hasQuestMap` is set as the file loads, outside the part, so it is true on every client whose TOC lists the file; `ns.questMap` exists only once the part has run. The map is Blizzard's map canvas (`MapCanvasFrameTemplate`) with a few of the world map's data providers on it, the way the Battlefield Map is built. It is the add-on's own frame, so the world map is never opened or touched. The canvas's `OnLoad` needs its `ScrollContainer` child to exist, which only XML can arrange (the `BorderFrame` beside it is what the canvas turns on to block the mouse while the map is locked), so the frame, `PrettyWideQuestLogMapFrame`, is declared in `Quest-Map.xml` and set up in the Lua file. The mouse wheel doesn't zoom it: the scroll container's mode is `MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_NONE`, which leaves the wheel enabled, so scrolling over the map doesn't zoom the camera either. The map art is fitted again (`canvas:OnFrameSizeChanged`) from the scroll container's own `OnSizeChanged`, once a new size has taken rather than when it is asked for.

The canvas calls `SetPassThroughButtons` on every pin it acquires, and WoW blocks that in combat when add-on code runs it. So the add-on's own pin templates take `PrettyWideQuestLogPinMixin`, defined at the top of `Quest-Map.lua` outside the part, whose `SetPassThroughButtons` does nothing, as HereBeDragons-Pins does for Questie's pins.

Load order matters. Each TOC lists the map files after the client's quest log and list files and the sharing and dungeon files after them (the last is `Dungeon-Quests.lua`), in this order: `Quest-Map.xml`, `Quest-Map.lua`, `Questie-Map.xml`, `Questie-Map.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, the client's map file (`Classic-Quest-Map.lua` in the Vanilla and TBC TOCs, `Forever-Quest-Map.lua` in the Camelot and Mists TOCs), then `Quest-Map-Reveal.lua`. After it come `Features/Routes/Routes.xml` on every client, then `Classic-ElvUI.lua` on Classic Era and TBC and `Mists-Quest-Portrait.lua` on Mists. The reasons, file by file:
- `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons` as it builds, and defines the `PrettyWideQuestLogPinMixin` that `Questie-Map.xml`'s templates name.
- `Questie-Map.lua` defines `ns.questMap.RequestRefresh`, which `Classic-Quest-Map.lua` takes by value as its part runs, as the body of its `QuestLog_UpdateQuestDetails` hook.
- `Forever-Quest-Map.lua` reads `ns.questMap` and `ns.questLog` as it loads.
- `Quest-Map-Reveal.lua` hooks the exploration pin that the client's map file makes.

On WoW Forever and Mists all of it runs at file load, since parts run at once there (`ns.questLogIsOwnWindow`) and `Forever-Quest-Map.lua` isn't one. On Classic Era and TBC the parts run in the same order inside `ADDON_LOADED`, once the saved settings are loaded. Routes needs none of the map files: it draws on Blizzard's world map (`WorldMapFrame`), never on this canvas, and reads nothing of `ns.questMap`.

Each client's own map file adds the layers and defines `ns.questMap.FollowQuest`, which the canvas's `OnShow` calls to put the map on the selected quest. On every client that goes through `ns.questMap.FollowQuestieQuest` first (Questie's Icons below), with the client's own fallback map for a quest Questie has no icons for. Each client's map file also registers `PIN_FRAME_LEVEL_QUEST_BLOB`, the frame level the objective areas draw at, and `PIN_FRAME_LEVEL_ACTIVE_QUEST`, the one Questie's pins draw at above them. The canvas needs a map before it first draws, as the Battlefield Map does, because drawing with none breaks Blizzard's map code. When `FollowQuest` leaves it without one, `OnShow` tries the player's map, then `C_Map.GetFallbackWorldMapID` where the client has it, before calling `MapCanvasMixin.OnShow`. `ns.questMap.SetStyle` moves the map and changes its border inset (the `edge`, `x`, `top`, `bottom` and `inset` keys), for a skin that draws the window differently, as `Classic-ElvUI.lua` does.

Show Map / Hide Map sits in the bar above the list, after the last of `ns.listButtons`, and the map has its own close button in its top-right corner. Hiding it is remembered in `global.mapHidden`, one setting for every character. It has no default and is cleared rather than set false when the map shows, so Reset Profile never hides or shows the map. An empty log hides the map and Show Map too (`questMap.SetLogEmpty`, which each client's list file calls on every update), leaving `mapHidden` as it was. The map is the window's child, so it follows the Window Scale. The Map Scale (`global.mapScale`, default 1, 70% to 130% on the Wide Quest Log panel) applies on top of that through `ns.ApplyMapScale`, which runs on every window `OnShow` and from Reset Window, which puts it back to 1. The Wide Quest Log panel hides the map's settings where `ns.hasQuestMap` isn't set, and grays them out while the wide quest log isn't running this session.

`questMap.CanShowMap` accepts only a map with art, because a client can know a map it has no art for (`C_Map.GetMapArtLayers` comes back empty), as with some of the dungeons Questie names, and the canvas can't draw one. `questMap.ShowMap` climbs from such a map through `parentMapID` to the nearest map above it that has art (a dungeon's zone, a zone's continent). It leaves the canvas on the map it had when none has art. It returns whether the map moved, since a move redraws every layer. The dropdown and `AreaMapID` filter with `CanShowMap` without climbing, so a quest whose icons sit only on such maps counts as having no icons.

### WoW Forever and Mists

`Features/Forever-Quest-Map.lua` adds exploration, fog of war, quest objective areas (`QuestBlobDataProviderMixin`), quest markers (`QuestDataProviderMixin`), dungeon entrances and flight points, each only if the client has its mixins, and registers their frame levels in the world map's order. Mists has the fog layer's provider but not `FogOfWarFrameMixin`, so it gets no fog. A hook on `ns.DisplayQuestDetails` puts the map on the selected quest (`ns.questLog.selectedQuestID`) at once whenever the selection has changed, map showing or not. It then asks for a Questie refresh, since Questie's icons can arrive after the quest log changes. When Questie has icons for the quest, the map follows them, as on Classic Era and TBC. Otherwise the map goes to `GetQuestUiMapID`. When that gives nil or 0, it goes to the zone the quest was given in (`ns.questMap.QuestGiverMapID`), then to the player's zone. It then fires the canvas's `SetFocusedQuestID` (or `ClearFocusedQuestID` when Questie's icons have the quest or none is selected), and redraws the objective area and quest markers for it.

Blizzard draws objective areas and quest markers only while the `questPOI` setting is on, and Questie turns it off when its own objectives are chosen, so this map would show none for a quest Questie has no icons for. The map's own copies of the blob pin's `Refresh` and the quest provider's `RefreshAllData` are Blizzard's, less that check; the setting itself is left alone. Both also draw only the quest the map is showing, and nothing while Questie's icons are drawing it (`ns.questMap.questieQuestID`). When the quest's objectives are in another zone, the quest markers add one at its next waypoint. So other quests' areas and markers never crowd the map, and the selected quest is never drawn twice. That is why `ShowQuest` refreshes both only after `FollowQuestieQuest` has set `questieQuestID`. Compare these copies with Blizzard's when a client update changes those providers. The copies handle the client differences by feature test:
- `GetQuestsOnMapCached` on WoW Forever, where Mists asks `C_QuestLog.GetQuestsOnMap` each time.
- On Mists, where quest markers are numbered, `usedQuestNumbers` and `pinsMissingNumbers` are set up before the pins are added, and `AssignMissingNumbersToPins` runs after.
- The next-waypoint marker appears only where `C_QuestLog.GetNextWaypointForMap` exists, which is WoW Forever.

Blizzard's pin templates take the canvas's `SetPassThroughButtons`, which WoW blocks from add-on code in combat. So every provider this file adds has its `RefreshAllData` wrapped on this map's copy. In combat (`InCombatLockdown`) the redraw is held, and `questMap:OnPlayerRegenEnabled` runs each held one once combat ends (`PLAYER_REGEN_ENABLED`, listed in Core's `EVENTS` with the owner `questMap`). The wrapper goes on last, over the quest provider's own `RefreshAllData`, so the override keeps the hold. The blob pin's `Refresh`, which `ShowQuest` calls directly, isn't wrapped: it draws on the pin the provider made when it was added. The Quest Map Context report shows which quest Blizzard's objective area and quest marker are drawn for, on WoW Forever its next waypoint on the map shown, and whether combat is holding those layers' redraws.

### Classic Era and TBC

These clients' world maps draw no quest objective areas or quest markers of Blizzard's, and the clients have no quest objective data to draw them from. So `Features/Classic-Quest-Map.lua` adds only Blizzard's exploration layer, with the frame levels `PIN_FRAME_LEVEL_MAP_EXPLORATION`, `PIN_FRAME_LEVEL_QUEST_BLOB` and `PIN_FRAME_LEVEL_ACTIVE_QUEST`, bottom to top. The quest comes from Questie's icons alone. Without them the map shows the zone the quest was given in (`ns.questMap.QuestGiverMapID`), or the player's zone where Questie doesn't know it. That fallback is passed as a function, so Questie's database is asked only when the quest has no icons. The selected quest is read from `GetQuestLogTitle(GetQuestLogSelection())`, a header counting as none. The map follows the selection through a hook on `QuestLog_UpdateQuestDetails`, which only asks for a refresh.

### Unexplored Areas (Every Client)

The map art leaves out every area the character hasn't explored, so a quest in a new zone would show bare parchment. `Features/Quest-Map-Reveal.lua` hooks `RefreshOverlays` on this canvas's exploration pin (`MapExplorationPinTemplate`), made when each client's map file adds `MapExplorationDataProviderMixin`. After Blizzard draws the explored areas, the hook draws every other area that the flavor's `ns.MAP_REVEAL_OVERLAYS` lists for the map's art ID. Each area is cut into tiles of the current art layer's `tileWidth` and `tileHeight`, the way Blizzard cuts explored ones: the last tile in a row or column is fitted into the smallest power-of-two file from 16 up. The tiles draw at `ARTWORK` sublevel -1, under Blizzard's, and on a full update they join the pin's `textureLoadGroup`. Each entry's key is `"Width:Height:OffsetX:OffsetY"`, and its value is the area's texture file IDs, comma-separated, row by row. An area counts as explored when `C_MapExplorationInfo.GetExploredMapTextures` reports one with the same size and offset, which is the table's key. The table holds only the client's own texture file IDs, so no art ships with the add-on. The table itself ships inside the add-on, so it needs no other map add-on installed. Art IDs and overlays differ between clients, so each of the seven flavor folders has its own `Data/{Game}/Map-Reveal-{Game}.lua`:
- `Vanilla`, `TBC`, `Camelot` and `Mists` are each listed by their own TOC.
- `Discovery` is listed by the Vanilla TOC after `Vanilla`. Each file of that pair opens with its `ns.IS_DISCOVERY` guard, so one table is built.
- `Wrath` and `Mainline` declare empty tables, for flavors no TOC lists, and `.pkgmeta` leaves them out of the zip.

It's always on, with no setting. The world map and the Battlefield Map are left alone, so Leatrix Maps, or any other add-on that reveals the world map, never draws on this map, and this map never draws on theirs. The Quest Map Context report shows the map's art ID, how many areas the table lists for it and how many are explored, how many map arts the table lists, and how many exploration pins the canvas has with `RefreshOverlays` to hook.

### Questie's Icons (Every Client)

`Features/Questie-Map.lua` adds a data provider that draws the selected quest's icons from Questie's world map, its objectives and turn-in, again as pins on this map (`PrettyWideQuestLogQuestiePinTemplate`, in `Questie-Map.xml`). They draw in Questie's textures and colors at `ICON_SIZE` (24, near the size of Blizzard's quest markers) times Questie's scale for the icon's kind (`data:GetIconScale()`). Questie's Global Scale is left out, since it would shrink them along with Questie's own world map icons. Questie's colored objective glow shows when its `alwaysGlowMap` setting is on, sized `GLOW_SCALE` (1.13) times the icon and never on quest-giver or turn-in icons. Its color comes from the icon's `ObjectiveData.Color` rather than Questie's glow texture, which Questie shows only once the world map has been opened. The Quest Map Context report counts how many of the quest's icons carry Questie's scale for their kind; the rest draw at `ICON_SIZE`. Questie never draws on this map and isn't told it exists.

The add-on reads Questie's own copy of HereBeDragons-Pins (`HereBeDragonsQuestie-Pins-2.0`). Its `worldmapPins` maps each icon frame to its `uiMapID` and world position, which Questie's copy of HereBeDragons (`HereBeDragonsQuestie-2.0`) turns into the zone's coordinates. Both come through `LibStub`'s silent flag, looked up once as the part builds, since they are Questie's libraries rather than bundled ones; every TOC's `OptionalDeps: Questie` loads Questie first. Nothing is drawn without them. Route lines (`type == "line"`) and icons faded to nothing are left out. Icons Questie's settings hide on its own maps (`hidden`) are kept, since this map shows the quest picked in the quest log, whatever Questie shows elsewhere. For the same reason the icons Routes hides on the world map still draw here: Routes hides HereBeDragons' pins on `WorldMapFrame`, and this map tests only the icon's own texture. The canvas draws pins at its own zoom, which would shrink them with this smaller map, so each pin takes the scaling limits Questie's world map pins use (`SetScalingLimits(1, 1.0, 1.2)`) and keeps its size on screen. Questie's tooltips can't be reused, because they gather their neighbors from the world map's own pins. So hovering a pin shows the add-on's own tooltip: the quest, then every NPC or object within `CLUSTER_DISTANCE` with its objective progress. That distance (0.015) is a share of the map, tested on each axis apart, not yards like the area constants below.

`ns.questMap.FollowQuestieQuest` picks the zone to show in this order:
1. The zone picked from the dropdown, while the same quest stays selected.
2. The player's zone, if the selected quest has an icon there.
3. The zone with the most of its icons.
4. The client's fallback map (a map ID, or a function asked only when the quest has no icons).

It sets `ns.questMap.questieQuestID` while Questie has icons for the quest, and returns whether it has any.

`ns.questMap.QuestGiverMapID` finds the zone a quest was given in from Questie's database (`QuestieDB.QueryQuestSingle(questID, "startedBy")`):
- It takes the area holding most spawns of a starting NPC, then of a starting object (ties go to the lower area ID), keeping the first whose zone the map can show.
- Otherwise it takes the zone the quest is filed under (`zoneOrSort`), which covers a quest started from an item.
- An area with a parent in Questie's `ZoneDB` (`GetParentZoneId`) gives way to that parent, and a zone the map can't show is skipped.
- It returns nil without Questie, or for a quest filed under a class or profession that no NPC or object starts.

The Quest Map Context report shows its answer for the selected quest.

When the quest has icons in more than one zone, a dropdown (`WowStyle2DropdownTemplate`, Blizzard's menu system, `ZONE_DROPDOWN_WIDTH` 180) sits in the map's top-left corner listing them, most icons first. The zone picked there holds until another quest is selected. While it has no icons it's passed over, and it comes back if they return with the same quest still selected.

Questie's icons are followed through hooks on its pin library's `AddWorldMapIconMap`, `AddWorldMapIconWorld`, `RemoveWorldMapIcon` and `RemoveAllWorldMapIcons`, because Questie draws a little after the quest log changes, and a batch at a time. Those hooks, and a resize of the map's scroll container, ask only for a refresh (`ns.questMap.RequestRefresh`). So do the client's map file, the Show Objective Areas toggle and a profile change (`ns:ApplyProfile`). A refresh is done at most once per `REFRESH_DELAY` (0.2 seconds) and only while the map is showing, checked both when it is asked for and when it runs. It runs `FollowQuest` again, then redraws Questie's provider unless that moved the map, since a move has already redrawn every layer.

### Objective Areas (Every Client)

With Show Objective Areas on (`profile.showObjectiveAreas`, the default), `Features/Questie-Map-Areas.lua` shades where each of the selected quest's objectives is found, the way Questie's own objective areas do it, and Questie's icons for that objective give way to one marker in each area. The toggle is on the Wide Quest Log panel, grayed out while Questie isn't loaded, and redraws the map at once. The areas are built from the objective Questie hangs on every icon (`icon.data.ObjectiveData`), whose `spawnList` holds every spawn in Questie's database. Questie's icons can't be used for this, because Questie thins them out where they crowd.

Spawns are kept where Questie's `ZoneDB` (`GetUiMapIdByAreaId`) puts their area on exactly the map shown and Questie's `Phasing` (`IsSpawnVisible`) says they're visible. A spawn at the same position with the same icon is counted once. Spawns are measured in yards from the zone's size in Questie's copy of HereBeDragons (`GetZoneSize`). Objects and creatures are grouped apart, by the icon Questie gives them. Each group is sorted by position first, so the same spawns always make the same areas. It is then clustered greedily: a spawn not yet taken takes every other within `CLUSTER_RADIUS` (180 yards) of the cluster's moving center, over two passes.

Each cluster's shape is the convex hull of its spawns, grown through a ring of `PADDING_POINTS` (24) around each corner, which rounds it off. It grows by `EDGE_PADDING` (35 yards), or by more where the spawns sit close together, so it reaches at least far enough from its middle to clear its marker by `SPOT_GAP` (`LAYOUT.SPACE.LINE`, 4) on screen. A lone spawn comes out as a circle and a line of spawns as a rounded bar. That least reach is worked out in yards from the zone's size and the map's width on screen zoomed all the way out:
- The scale comes from the scroll container's `GetScaleForMinZoom` where the client has it, else the canvas's current scale.
- `FALLBACK_MIN_RADIUS` (80 yards) applies when either the scale or the canvas width isn't usable.

So the gap is the same on every zone's map, and a resize of the map redraws the areas. Without a zone size from HereBeDragons nothing is shaded and every icon draws plain.

Within one objective's group, any two clusters whose shapes overlap or come within `TOUCH_GAP` (15 yards) merge into one with a new hull, until none touch. The test is a bounding-box check, then a separating-axis test on the two convex shapes. So each blob has one marker, at the hull's centroid, drawn in the look of an icon of the objective with the area's icon kind. Different objectives' areas, and an objective's objects and creatures, may still overlap. Every icon of the quest left on the map, the turn-in among them, gets a circle of its own that clears it by `SPOT_GAP` (`ns.questMap.SpotOutline`), in its objective's color, or the turn-in's gold. These circles never merge with the areas, and with the setting off they aren't drawn either. Areas are cached per objective until the map, the least reach (the map's size on screen, or the marker's size), or Questie's spawn list changes.

`Features/Questie-Map-Area-Layer.lua` draws the areas on one pin as large as the map (`PrettyWideQuestLogAreaPinTemplate`, in `Questie-Map.xml`), at `PIN_FRAME_LEVEL_QUEST_BLOB`. `Classic-Quest-Map.lua` registers that level under Questie's icons, and `Forever-Quest-Map.lua` registers it with Blizzard's layers. The pin zooms with the map. Each area's fill is a fan of triangles from its centroid. Each triangle is a white texture whose four corners are moved onto the triangle's three with `SetVertexOffset`, its corners put in counterclockwise order first, at `FILL_ALPHA` (0.3) in the objective's color. The outline is a `Line` per edge at `OUTLINE_ALPHA` (0.75), its thickness reset on every zoom so it stays `OUTLINE_WIDTH` (1.5) on screen. Textures and lines are reused from one draw to the next, and the spare ones hidden. Neither takes the mouse. A marker's tooltip lists every NPC or object in its area. An objective with no spawns placed on the map shown keeps Questie's icons, each with its circle. The Quest Map Context report shows the setting and how many areas and icon circles are shaded (`questMap.areaCount`). For when nothing is shaded, it also shows whether Questie's `ZoneDB` and `Phasing` were found, the zone's size in yards, and each objective's spawns in the zone against those placed.

## Quest Giver Portrait (Mists)

Blizzard's Mists quest log shows the quest giver's model beside itself, so `Features/Mists-Quest-Portrait.lua` does the same for the window that stands in for it. The Mists TOC lists the file after every other Features file, because at load it reads `ns.questLogFrame`, `ns.questLog` and `ns.questMap.holder`, and hooks `ns.DisplayQuestDetails`, `ns.ApplyMapScale` and `ns.OnWindowResizeStopped` (an empty function in `Window.lua` that exists to be hooked).

- **Blizzard's model is left alone.** It's a `ModelScene` of the add-on's own (`PanningModelSceneMixinTemplate`) in a box with the map's border (`holder.backdropInfo`) and a strip under it for the giver's name (`NAME_HEIGHT`, 20). `Pose` follows `QuestFrame_ShowQuestPortrait`: a portrait of -1 is the player, otherwise the giver, on its mount if it has one.
- **Where it goes.** With the map open, under the map (`GAP`, 4), in Blizzard's 198:230 proportions, ending level with the bottom of the window's art (`LAYOUT.ART_INSET_BOTTOM`) and no wider than the map. Measures go through effective scales, since Map Scale applies to the map and not the box. With under `MIN_MODEL_HEIGHT` (60) of room it hides rather than moving. With the map closed, beside the window at Blizzard's own size (`BESIDE_X`, `BESIDE_Y`).
- **What it reads.** `GetQuestLogPortraitGiver` reads the selected quest, so nothing changes while Blizzard's selection isn't the quest the window shows (a quest giver window had the quest text). No selected quest, no giver, or `QuestLogShouldShowPortrait` (where the client has it) saying no hides the box. `posedAs` keeps a repaint from starting the model over, and clears when the window closes.
- **When it refits.** Opening or closing the map, resizing the window, or a new Map Scale refit it a frame later (`RequestRefit`), once the map has been laid out to match. During a grip drag (`frame.isResizing`) it hides, and is drawn once as the drag ends.

## ElvUI, VoiceOver and Spoken Quests

### Classic Era and TBC

ElvUI and VoiceOver work on Blizzard's own quest log frames, so the Classic files make room for them rather than replacing what they draw. `Classic-ElvUI.lua` and `Classic-VoiceOver.lua` are wide quest log parts, so neither acts while the Wide Quest Log switch is off. The quest giver window's ElvUI backdrop is handled on every client by `Quest-Giver.lua` (see Quest Giver Window).

- **ElvUI** skins the window but can't know about this add-on's art. `Features/Classic-Quest-Log.lua` removes Blizzard's art and draws its own either way, and on every show moves the resize grip to the skin's backdrop corner (`QuestLogFrame.backdrop`) when there is one.
- ElvUI skins the window at login, after this add-on loads, so `Features/Classic-ElvUI.lua` checks on each `OnShow` until the skin has left a backdrop and ElvUI's Skins module is there, then acts once. With ElvUI's quest skin off there's never a backdrop, so the window keeps the add-on's art. `ns.HideQuestLogParchment` hides that art and the "no active quests" parchment. The skin's backdrop is ElvUI's see-through Transparent template, which lets Questie's tracker behind the window show through the quest text, so it is made opaque in the same color; `customBackdropAlpha` is ElvUI's own field for that and survives its color updates. Expand All, Track All, Show Map and the zone Share Quests button (`ns.zoneShareButton`) get ElvUI's `HandleButton`, the map's close button `HandleCloseButton`, the zone dropdown `HandleDropDownBox`, and the map an opaque ElvUI backdrop, moved beside the skin's backdrop rather than the art (`questMap.SetStyle`, `MAP_GAP` 4 from it, the map `MAP_INSET` 2 inside its own). The WoW Forever and Mists TOCs don't list this file, so their window keeps its own art under ElvUI.
- **VoiceOver** puts a play button over the start of each quest title. With it on, `Features/Classic-VoiceOver.lua` starts each title with as many spaces as clear 24px (up to 20, measured once), spaces only, since a tab draws as a missing glyph in some fonts, ElvUI's among them.
- VoiceOver hands out its buttons by Blizzard's order, row *i* to entry *i* + scroll offset. On every list update, `ns.MatchVoiceOverButtons` deals them out again by what each row now shows, through VoiceOver's own button functions. Those functions rewrite the title and move the check, so the row styling runs after them (only the list buttons, the turn-in line and `questMap.SetLogEmpty` follow it), and the list's update (`ns.UpdateClassicQuestList`) also runs after VoiceOver's overlay `Update`, which can come after the `QuestLog_Update` hook.

**Spoken Quests** is a fork of VoiceOver that keeps the `VoiceOver` global and its quest log functions, so everything above applies to it too. `ns.GetVoiceOver` (`Features/Utilities.lua`) finds either one (`AI_VoiceOver` or `Spoken_Quests`), and only while its quest log part is switched on in Spoken; both are in the TOCs' `OptionalDeps` so the global exists when the Classic file hooks it. That hook goes on whether or not the part is on yet, because Spoken reads the switch from its saved settings after this file loads.

### VoiceOver and Spoken Quests (WoW Forever and Mists)

VoiceOver, or its fork Spoken Quests, puts its play buttons on Blizzard's quest list (the world map's on WoW Forever, `QuestLogFrame`'s on Mists), which this add-on's window stands in for, so with the window on they never appeared. `Features/Forever-VoiceOver.lua` puts one on each quest row of the add-on's own list, at `LAYOUT.QUEST_TEXT_X` where the title would start, and moves the title over to clear it (`TITLE_INSET`, 24: VoiceOver's 20px button and a `SPACE.LINE` gap). It makes the buttons with VoiceOver's own `MakePlayButton`, `BindPlayButton` and `SetPlayButtonState`, grayed out for a quest no sound pack has a reading of (`DataModules:PrepareSound`), but keeps its own set, one per quest, reusing a button once its quest leaves the log, because Blizzard's list takes VoiceOver's set back to its own rows whenever it redraws. List rows are recycled, so each row lets go of its button before it's set up again, unless another row already took it for the same quest.

## Routes

Routes on Zone Map and the Quest Arrow follow one route through the quests in the log, planned by the files in `Features/Routes/`.

- **What the route covers.** Only the zone the player is in (`routes.PlayerZone`), with the caves, buildings and cities inside it. Each objective not yet done offers a few places to do it, which are its Questie spawns clustered into blobs. Each done quest offers its turn-in.
- **How it is ordered.** A solver puts these in the shortest open path from where the player stands, as a traveling salesman problem.
- **Where it shows.** `Routes-Map.lua` draws the route on Blizzard's world map (`WorldMapFrame`, the "zone map" in player-facing text). `Routes-Arrow.lua` points at its next waypoint.
- **What it needs.** Both need Questie. Every place, objective and count comes from Questie's quest log and database, and every distance comes from Questie's copy of HereBeDragons (`HereBeDragonsQuestie-2.0`), in world yards.
- **What it doesn't touch.** Routes is not a quest log part, so it runs on every client whatever the Wide Quest Log switch says. It never draws on the add-on's own map beside the window (`ns.questMap`).

### Loading

Each TOC lists one line, `Features/Routes/Routes.xml`:

- It comes after `Quest-Map-Reveal.lua`.
- It comes before `Classic-ElvUI.lua` on Classic Era and TBC, and before `Mists-Quest-Portrait.lua` on Mists.
- It comes before the Diagnostics and Options files.

Leaving that line out removes the feature cleanly:

- `ns.routes` is nil.
- Core's `EVENTS` rows owned by `routes`, `routesMap` and `routesArrow` find no handler and never register.
- `ns:ApplyProfile` skips `ns.routes.ApplySettings`.
- `ns.RegisterOptionsPanels` registers neither Routes panel.
- `ns.OptionsRoutesToggle` hides the General panel's two Routes switches.
- `Diagnostics/Manifests.lua` adds no Routes API rows.
- Routes Context reports the feature as not loaded.

`Options/Options-Routes-Map.lua` and `Options/Options-Quest-Arrow.lua` are listed separately in each TOC and only define builders, so they load harmlessly either way.

Inside `Routes.xml` the order is: Core, Solver, Party, Questie, Blobs, Nodes, Stops, Stop-Lines, Map, the two pin templates, then Arrow. Most files capture the functions they need by value as they load, so each must follow what it reads:

- `Routes-Blobs.lua` takes `routes.IsInZone` from `Routes-Questie.lua`.
- `Routes-Nodes.lua` takes `IsInstanceQuest`, `QuestLog`, `QuestState`, `IsEscort`, `ForEachObjective` and `HasSpawns` from `Routes-Questie.lua`, and `NewPoints`, `AddSpawns`, `Cluster` and `Candidates` from `Routes-Blobs.lua`.
- `Routes-Stops.lua` takes `routes.MIN_STOP_RADIUS` and `routes.NAME_LIMIT` from `Routes-Blobs.lua`.
- `Routes-Stop-Lines.lua` takes `routes.IsArea` from `Routes-Stops.lua`.
- `Routes-Map.lua` defines the global `PrettyWideQuestLogRoutePinMixin`, which both XML templates name in `mixin=`, so it is listed before them.

Everything builds at file load: the planner and watcher frames, and the arrow frame (`PrettyWideQuestLogRouteArrow`). Things that need the saved settings or the world map wait for `PLAYER_LOGIN`. They register through `routes.OnLogin(handler)`, and `routes:OnPlayerLogin` runs them after the settings migration. `Routes-Map.lua`'s handler is registered first, then `Routes-Arrow.lua`'s.

### Settings

Routes keeps its settings in a table of its own on the profile, `ns.db.profile.routes`, so Reset Profile restores them. Defaults:

- **Switches:** `enabled` true, `showMap` true, `showArrow` true.
- **Zone map:** `hideQuestieIcons` true, `fullSizeMap` true, `markerScale` 1, `showLine` true, `lineSpeed` 1.5, `lineOpacity` 0.8.
- **Quest Arrow:** `arrowScale` 1, `lockArrow` false, `showDistance` true, `cycleSeconds` 12, `showQuests` true, `questsListed` 4, `hideInRaids` true, `hideInInstances` true.
- **Party:** `partyQuests` true.

How the switches work:

- `showMap` and `showArrow` are the two feature switches. Each sits on the General panel (orders 15 and 16) and at the top of its own panel.
- `enabled` has no control in Options. It gates everything, through `routes.IsWanted()`: `enabled and (showMap or showArrow)`. Nothing plans unless that holds.

How settings are read and written:

- `routes.Settings()` returns the profile table, or `ns.DATABASE_DEFAULTS.profile.routes` until `ns.db` exists.
- The panels write through `routes.SetSetting(key, value)`. It stores the value, notifies every listener (the map's data provider and the arrow's `Refresh`), and plans at once when `showMap` or `showArrow` comes back on with no route.
- A setting that changes what's planned is not planned at once. `partyQuests` is the case: `routes.Signature` includes the party's quests, so the watcher plans again within `CHECK_INTERVAL`.
- `ns:ApplyProfile` calls `routes.ApplySettings`, which redraws and plans when the route is wanted, and otherwise clears it (`routes.Clear`).

Where the Quest Arrow sits is presentation, kept for the whole account so a profile change never moves it:

- It is stored in `ns.db.global.routesArrowPoint`, with no default.
- Its shape is `{ point, relativePoint, x, y }`. The offsets are in screen units (the frame's offset times its scale), and `PlaceFrame` divides by the scale again, so changing Arrow Size never moves the arrow.
- With nothing saved, the arrow's `TOP` sits a quarter of the screen's height above `UIParent`'s center.
- The Reset button (`routes.ResetArrowPosition`) clears the saved spot and places the arrow again.

A migration tagged `MIGRATION (remove after 2026-12-06)`, in `Routes-Core.lua`, runs at `PLAYER_LOGIN`:

- It moves an old account-wide `global.routes` table onto the profile.
- Its `arrowPoint` goes to `routesArrowPoint`.
- Keys that have no default (`planTurnIns`) are dropped.
- Routes Context says when old settings are still waiting to move.

### Nodes: Quests Into Route Points

`routes.BuildNodes(yield)` (`Routes-Nodes.lua`) turns Questie's quest log (`QuestiePlayer.currentQuestlog`) into nodes. It returns nil while Questie isn't ready (`routes.IsQuestieReady`) or the client won't give a position. It also returns the origin, `{ x, y, instance, zone, corpse }`, which is the player, or a ghost's corpse (see Ghosts).

Each quest's Questie state (`quest:IsComplete()` in a `pcall`: 1 done, -1 failed, 0 not yet) decides what it contributes:

- **Not yet done (0), and not a dungeon or raid quest.** Every objective not `Completed` becomes an `"objective"` node, keyed `questID:o<index>`. Questie's extra `SpecialObjectives` become nodes too, keyed `questID:s<index>`. An objective with no spawns yet has no place and is left out. Routes Context counts how many objectives are waiting on spawns.
- **Done (1).** Its turn-in becomes a `"turnIn"` node keyed `questID:turnIn`, marked `ready`. Its places are every spawn of every NPC and object in the quest's `Finisher`, looked up with `QueryNPCSingle` or `QueryObjectSingle` for `"spawns"` and `"name"`. A quest not yet done is never routed to its turn-in, so until it's done the route is its objectives.
- **Failed (-1).** Contributes nothing, so a failed escort drops off.

Two kinds of quest are recognized from Questie's database. Both answers are cached until the quest log next settles (`routes.ForgetQuestTags`), because the client learns a quest's tag only once it has loaded the quest.

- **Dungeon or raid quests** (`IsInstanceQuest`). The game's tag, through `QuestieDB.GetQuestTagInfo` and the flavor's `ns.QUEST_TAG_SUFFIXES`, reads `DUNGEON` or `RAID`. Their objectives are inside the instance, so the route and the arrow pass them by and Questie's icons for them stay. Their turn-in, out in the world, is still routed once the quest is done.
- **Escorts** (`IsEscort`). Questie's `questTagIds.ESCORT` tag counts, and so does the `PARTY_ACCEPT` (2) bit of `questFlags`, because most Classic escorts carry no tag.

Which spawns count:

- Spawns come from Questie as `{ [areaID] = { { x, y, phase }, ... } }`, with x and y on a 0 to 100 scale.
- A spawn counts only where `ZoneDB:GetUiMapIdByAreaId` puts its area inside the player's zone (`routes.IsInZone`), on the same continent, and where `Phasing.IsSpawnVisible` shows it.
- `routes.IsInZone` accepts a map whose parents, followed up to the continent, reach the zone: a cave or a building. It also accepts a map whose two corners both fall on the zone's map. That covers a city the game files under the continent, as the Exodar is filed while drawn on Azuremyst Isle. Answers are cached per zone, since the question is asked for every spawn.
- So the zone a quest is filed under doesn't matter. A quest from elsewhere with mobs here is on the route, and a quest of this zone's whose mobs are all elsewhere isn't.
- For an `"event"` objective, or a spawn with Questie's event icon, the spawn names are dropped, because they only repeat the objective text.

Blobs are cached per Questie objective table (or per quest, for turn-ins) in a weak-keyed table. They are worked out again only when the zone or continent changes, or when Questie's `spawnList` changes its entry count, since spawns don't move. Nodes are sorted by `key` before solving, because Questie's log is a hash, and the same quests must always give the same route.

### Blobs and Candidates

`routes.Cluster` (`Routes-Blobs.lua`) gathers points into blobs:

- Points are kept as three flat arrays plus a count, not a table each, because an objective can have hundreds of spawns and per-spawn tables would be most of a plan's memory.
- Spawns go into a grid of `CLUSTER_RADIUS` (180 yards) squares, each keyed by a number rather than a string.
- The squares are sorted densest first, with ties broken by position.
- Each square not yet taken absorbs every other square whose middle lies within 180 yards of the blob's moving center.
- A last pass over the spawns sets each blob's `radius` (at least `MIN_STOP_RADIUS`, 30 yards) and up to `NAME_LIMIT` (4) NPC or object names, sorted.
- Blobs are returned densest first.
- Planning yields every `SPAWNS_PER_YIELD` (64) spawns and after each blob.

`routes.Candidates` offers the solver up to `MAX_CANDIDATES` (6) of a node's blobs:

- They are the densest, with the blob nearest the player swapped in for the last if it isn't already one of them.
- For objectives, each candidate carries a `penalty` of up to `SPARSE_PENALTY` (300 yards), scaled by how much sparser it is than the densest blob. The solver adds that to the route's length, so a thin camp loses to a dense one unless it's on the way.
- Turn-ins carry no penalty.

### Finishing What's Under Way

The shortest trip alone would happily walk the player out of a camp half done. `routes.PinEngaged` decides what goes first, giving each such node one candidate and making everything else wait on it through `node.requires`.

1. **An escort under way.** Its objectives go first, and during an escort only its own nodes can be pinned. The escorted NPC won't wait while the route tours the zone.
2. **Anything the player is in.** Otherwise, every objective or turn-in whose blob the player is in is pinned to that blob, with its penalty zeroed. The player counts as in a blob in three cases:
   - **In the objective's area** (`routes.InArea`): within `AREA_REACH` (200 yards) of any of its spawns, and once in, until `AREA_GRACE` (20 yards) further. It measures spawns, not blobs, so a zone-wide spread of mobs has no gaps. It needs more than one spawn, because a lone chest or NPC is a place, not an area.
   - **Inside a blob's radius**, plus `AREA_GRACE` once engaged.
   - **Working on the objective**: within `WORKING_REACH` (400 yards) of the blob's edge while its count went up in the last `WORKING_WINDOW` (180 seconds). `routes.NoteProgress`, run at every check, records when each `Collected` count rises, and a first look doesn't count as progress.
3. **Nearby turn-ins.** Then, except during an escort, every ready turn-in within `TURN_IN_REACH` (400 yards) is pinned to its nearest place, because a turn-in usually opens the next quest in its chain.

The keys pinned to the player's blob become `routes.engaged`, the "was in" state for the next plan's grace.

### Solving the Order

`ns.routesSolver.Solve(start, nodes, yield)` (`Routes-Solver.lua`) treats the route as an open path that starts at the player. Each node chooses one of its candidates (`node.choice`), and a node may come only after every node in its `requires`. The solver supports requirements generally, but `BuildNodes` produces them only through `PinEngaged`, since a turn-in is a node only once its quest is done. Before solving, nodes without candidates are dropped, along with any requirement on one.

The steps:

1. **Cheapest insertion** (`Construct`) builds a first route. Of every node whose requirements are placed, every candidate and every allowed slot, it adds the one that lengthens the route least.
2. **Local search** (`LocalSearch`) improves it, up to `MAX_PASSES` (300) passes, until no move saves more than `EPSILON` (0.01 yards). Each pass runs three moves:
   - `ImproveChoices` gives each node the candidate that fits best between its neighbors.
   - `TryOrOpt` moves a run of one to `MAX_SEGMENT` (3) nodes elsewhere, either way round. A single node may also switch candidates where it lands.
   - `TryTwoOpt` reverses a stretch.
   Each search takes the first improving move it finds. Moves are weighed and checked against the requirements (`IsValidMove`, through `OrOptIndex` or `TwoOptIndex`) without building the route they would make. A 90-node route weighs hundreds of thousands of moves, and building each would make over 100 MB of garbage per plan.
3. **Shaking** (`Shake`) gets out of the local optimum the search stops at:
   - The route is shaken `min(SHAKES, max(MIN_SHAKES, floor(SHAKE_WORK / count)))` times, which is 16, 4 and 800, so a longer route gets fewer shakes.
   - Each shake throws `THROWS` (2) nodes to a random allowed slot on a random candidate, then searches again, keeping whichever route is cheapest.
   - The randomness is a linear congruential generator from the fixed seed `20261105`, so the same quests always give the same route and it never flickers between equally good answers.

Cost is the path length plus each chosen candidate's penalty (`Solver.Cost`).

### Waypoints

`routes.MakeStops(order, start)` (`Routes-Stops.lua`) folds the ordered nodes into waypoints, `routes.stops`:

- A node joins the waypoint before it when it's an objective within `MERGE_RADIUS` (100 yards) of that waypoint's position, or when both are areas the player is standing in, which the player works at once however far apart their middles are.
- Turn-ins join only other turn-ins within `SAME_PLACE` (1 yard), the same NPC, so the route hands in one quest giver's quests at a time. Nothing else joins them.
- A ghost's route begins with the corpse, a waypoint of its own with radius `CORPSE_RADIUS` (30 yards, inside the client's reach to resurrect), which nothing joins.
- A waypoint is an `area` (`routes.IsArea`) when one of its blobs has more than one spawn and a radius over `MIN_STOP_RADIUS`. Anywhere else it's a point.

```lua
-- One waypoint in routes.stops (x, y, radius in world yards)
{ x, y, instance, radius, mapID, names = { "Boar", ... }, area = true, turnIns = nil, inArea = nil, corpse = nil,
  tasks = { node, ... } } -- each node: key, kind ("objective" | "turnIn" | "corpse"), questID, questName, quest, objective, candidates, choice, party
```

`routes.start` is where the plan set out from, and `routes.nodes` and `routes.engaged` are the plan's nodes and pins. The planner assigns all four together, so the watcher never compares a new plan's pins with the old plan's nodes.

### Planning and When to Plan Again

Planning runs as a coroutine on a hidden frame (`planner`, `Routes-Core.lua`):

- Each frame it resumes the plan, and the `Yield` passed down to every stage yields once the slice passes `FRAME_BUDGET` (4 ms, measured with `debugprofilestop`).
- A request made while a plan is underway sets `replanQueued`, and one more plan runs when the current one finishes.
- An error inside the plan goes to `geterrorhandler()` rather than breaking the frame.
- Each listener runs in its own `pcall` (`Notify`), so a broken view can't stop the others.

A watcher frame checks every `CHECK_INTERVAL` (2 seconds), only while the route is wanted and Questie is ready. It runs `routes.NoteProgress`, then plans again when any of these holds:

- **The signature changed.** `routes.Signature()` is a text of what moves the route: each quest's state and whether it's an instance quest, each objective's done flag and whether it has spawns, the same for the party's quests, the skipped keys, the player's zone, and ghost or alive. Counts and position aren't in it.
- **The player walked into or out of a camp.** `routes.EngagedSignature(routes.nodes)`, the blobs the player is in now, differs from `routes.PinnedSignature()`, what the plan pinned. During an escort, only the escort's own nodes count.
- **The player moved far.** At least `REPLAN_INTERVAL` (30 seconds) has passed and the player is more than `REPLAN_DISTANCE` (400 yards) from where the plan set out, or on another continent. A corpse start never counts as moved.

Events speed this up. They all arrive through Core's dispatcher with owner `routes`:

- `QUEST_LOG_UPDATE` restarts a `QUEST_LOG_DELAY` (1 second) timer. When it fires, it forgets the cached escort and instance answers and forces the next check, giving Questie time to catch up.
- `PLAYER_ENTERING_WORLD` and `ZONE_CHANGED_NEW_AREA` clear `routes.start` and force a check that counts as past `REPLAN_INTERVAL`.
- `PLAYER_DEAD`, `PLAYER_ALIVE` and `PLAYER_UNGHOST` force a check.
- `PLAYER_LOGIN` runs the migration and the login handlers.

`routesMap:OnAddonLoaded` (`ADDON_LOADED`) adds the data provider when `Blizzard_WorldMap` loads after login. `routesArrow`'s handlers for `GROUP_ROSTER_UPDATE`, `PLAYER_ENTERING_WORLD` and `ZONE_CHANGED_NEW_AREA` re-check whether the arrow hides.

Because every handler is defined at file scope, these events register on every client with the line, whatever the Wide Quest Log switch says. On Classic Era and TBC that newly registers `QUEST_LOG_UPDATE`, makes `ZONE_CHANGED_NEW_AREA` register with the switch off too, and adds `PLAYER_DEAD`, `PLAYER_ALIVE` and `PLAYER_UNGHOST` everywhere.

The views keep their own pace:

| What | How often |
|---|---|
| Map line's player end and marching dots | Every `UPDATE_INTERVAL` (0.05 s) while the map shows |
| Arrow turning | Every `TURN_INTERVAL` (0.03 s) |
| Arrow distance text | Every `TEXT_INTERVAL` (0.25 s) |
| Arrow survey of surroundings and quest list | Every `LIST_INTERVAL` (1 s) |
| Hiding Questie's icons after Questie redraws | Coalesced to the next frame |

### Combat

- **Planning waits.** The planner's `OnUpdate` returns while `InCombatLockdown()` holds and resumes the same coroutine once the fight ends. The watcher may still request a plan in combat, which only queues it.
- **The full-size map waits.** `KeepFullSize` never writes the map's CVar in combat.
- **Pins don't pass clicks through.** The map canvas calls `SetPassThroughButtons` on every pin it acquires, which WoW blocks in combat, so opening the map in combat would blame the add-on. `PrettyWideQuestLogRoutePinMixin` replaces it with an empty function, as HereBeDragons-Pins does for Questie's pins. That's safe because the waypoint pins handle their own right and middle clicks and the line pin takes no mouse.
- **The arrow keeps working.** It is an ordinary unprotected frame, so it turns, updates and drags in combat.

### The Zone Map

`Routes-Map.lua` adds a `MapCanvasDataProviderMixin` provider to `WorldMapFrame`. It is added at login, or on `ADDON_LOADED` for `Blizzard_WorldMap`, which loads on demand on some clients. The route is drawn on whatever map the world map shows, zone or continent. Each waypoint is placed with `GetZoneCoordinatesFromWorldInstance`, which allows positions outside the map, so a waypoint off the map shown gets no marker but the line still runs to it.

Frame levels:

- `AddFrameLevels` inserts `PIN_FRAME_LEVEL_PWQL_ROUTE_LINE` below `PIN_FRAME_LEVEL_AREA_POI`, where HereBeDragons-Pins puts Questie's icons, and `PIN_FRAME_LEVEL_PWQL_ROUTE_STOP` above it.
- Each insert is in a `pcall`, falling back to `AddFrameLevel` on a map without that level.

The line (`PrettyWideQuestLogRouteLinePinTemplate`):

- It is one pin as large as the canvas, which takes no mouse.
- Each leg is a `Line` textured with `Route-Dot` repeated along its length, in `ROUTE_LINE` (`333333`) at the `lineOpacity` alpha.
- Thickness is `LINE_WIDTH` (`SPACE.NEAR`, 8px) and each dot plus its gap is `DOT_SPACING` (`SPACE.GROUP`, 16px). Both are divided by the canvas scale on every zoom, so they hold on screen.
- The dots march by sliding the texture coordinates by `GetTime() * lineSpeed`, so `lineSpeed` is dots per second and 0 holds them still.
- The first leg runs from the player's live position. It reuses one table, because it updates 20 times a second.
- With `showLine` off, only the markers draw.

Markers (`PrettyWideQuestLogRouteStopPinTemplate`, 42px with a 24px icon):

- A marker is the `Route-Stop` disc tinted in the first task's color: Questie's color for the objective, `TITLE` gold for a turn-in, `TEXT` white for the corpse.
- On it sits Questie's icon for that objective or turn-in, taken from Questie's own pin on the map. If Questie hasn't drawn yet, it comes from `Questie.usedIcons` by icon type, in the player's Questie theme. The corpse shows the skull (`UI-TargetingFrame-Skull`).
- A waypoint made only of party members' objectives draws `Route-Stop-Fill` with the white `Route-Stop-Ring` over it in place of the disc's black ring.
- Size is `markerScale` times `UIParent:GetEffectiveScale() / map:GetEffectiveScale()`, with `SetScalingLimits(1, 1.0, 1.2)`, so markers keep their size on screen as the map zooms. They look the same size on every client, even though Classic Era and TBC draw the full-size map at about 1.8 times the UI's scale.

Hovering a marker:

- The tooltip is `routes.AddStopTooltip`: each quest's title, then its objectives at that waypoint. Each objective line has a one-space indent, the quest log's check (or a same-size blank), the name, and "4 / 12" on the right.
- In a party, each quest is split by player: the player first, then each member Questie shares a quest log for, names in class colors when readable (`ns.IsReadable`).
- A quest with nothing left at that waypoint but its turn-in is one gold line, "Turn in [2] Wayward Weapons".
- The blob's NPC or object names follow, then the click hints (`routes.AddClickHints`).
- Hovering also shows Questie's icons for that waypoint again.

Clicking a marker: right-click reroutes around it (`routes.SkipStop`), and middle-click resets all routes. The pins use `OnMouseUp`, since they aren't buttons.

Questie's icons:

- With `hideQuestieIcons`, `ApplyQuestieIcons` hides the HereBeDragons pins (`HereBeDragonsPinsTemplateQuestie`) whose icon is for something on the route, and shows again the ones it hid that no longer are. An objective matches by its Questie objective table, a party member's by `routes.PartyObjectiveKey(questID, index)`, and a turn-in by quest ID (`data.Type == "complete"`).
- Questie never shows or hides those pins itself, so its own icon state is untouched and a recycled pin shows on its own.
- Questie draws in batches, so the add-on post-hooks its pin library's `worldmapProvider.RefreshAllData` and `HandlePin` and re-applies on the next frame.
- Turning the route off re-applies even with the map closed, so the icons come back.

Full-size map:

- With `fullSizeMap` on (and the route on the map), `KeepFullSize` sets the map's own `miniWorldMap` CVar to `"0"`, which every client's world map reads as it opens to maximize itself. It prints nothing.
- It stands aside entirely while an add-on that sizes the map itself is loaded (`ns.MAP_SIZE_ADDONS`: Leatrix Maps, Mapster), and the option is hidden then. Leatrix Maps keeps the map windowed and scales it up, so a maximized map under it overflows the screen.
- It runs at login, on the world map's `OnHide`, and on every listener call.
- It never calls the map's `Maximize`, which would run Blizzard's panel layout (`SetUIPanelAttribute`, `MaximizeUIPanel`) as add-on code.

### The Quest Arrow

`Routes-Arrow.lua` builds `PrettyWideQuestLogRouteArrow`, a 512px-wide button at `MEDIUM` strata, clamped to the screen. On it are the 64px arrow (`Route-Arrow`, drawn pixel for pixel), a distance line under it, and a block of quest lines.

When it shows:

- Only with `enabled`, `showArrow` and a route.
- Not in a raid group with `hideInRaids`, and not in an instance with `hideInInstances` (`IsInInstance()`).
- `Refresh` decides this on every listener call and on the group and zone events.

What it points at. Once a second, `Survey` looks around:

- Every task left on the route whose area the player is in (`routes.InArea`, with the same grace) becomes `here`, from any waypoint.
- The first waypoint with tasks left that aren't among those becomes the next one to point at (the code's `destination`).

In an objective area it takes turns, each half of `cycleSeconds`:

- **The eye.** `Route-Eye`, upright, in the add-on's `INFO` blue, breathing up to `BREATH_GROWTH` (30%) bigger over `BREATH_PERIOD` (2.5 seconds). It says "Objective Area" and lists what's around.
- **The arrow.** It points on to the next waypoint and lists that.

How it points:

- Toward a waypoint, it aims at the nearest place still to do there, or at the nearest edge of an area, using `HBD:GetWorldVector` minus `GetPlayerFacing()`.
- It is yellow (`ARROW_FAR`) beyond `CLOSE` (50 yards, measured to an area's edge) and green (`ARROW_CLOSE`) within it. There is no red, which reads as an error.
- Within `SPOT_REACH` (10 yards) of a single place, the eye says "You're there".
- At the corpse it keeps pointing and says "You're there" within the corpse's 30 yards.
- Without a position on that continent, or a facing, the arrow texture hides but the list stays.
- With `showDistance` off the yards are blank, but "Objective Area" and "You're there" still show.

The list (`routes.ForEachStopLine`, `Routes-Stop-Lines.lua`):

- With `showQuests`, it holds each quest at the waypoint, nearest first: its "[13] Name" title (letter from `ns.GetQuestTagByID` and `ns.QuestSuffix`, falling back to Questie's tag ID) in difficulty color and `GameFontNormal`, then indented by `SPACE.NEAR` its objectives still to do there, nearest first, in `GameFontHighlight`.
- A quest only turned in there is one gold "Turn in [2] Name" line.
- Past `questsListed` quests, a silver "+%d more here" line counts the rest.
- Spacing is 16px (`SPACE.GROUP`) above each quest and 4px (`SPACE.LINE`) between its lines. The block is left-aligned and centered under the arrow, and lines are cut short past 512px.
- The layout is keyed by its text and colors, so a second with nothing changed lays nothing out.
- The hit rect is inset to the arrow and the block, so the empty width either side passes the mouse through.

Interaction:

- Drag moves it, unless `lockArrow`.
- Right-click reroutes around what it shows (`routes.arrowTarget`, or the first waypoint).
- Middle-click resets all routes.
- Its tooltip is only the click hints. Because a tooltip's first line uses the header font, `routes.AddClickHints` sets that line to the body font and puts the header font back on `OnTooltipCleared`, hooked once per tooltip.

### Party Members' Quests

With `partyQuests` on, in a party but not a raid group (a raid's every quest would swamp the route), `routes.PartyQuests` (`Routes-Party.lua`) reads Questie's shared logs, `QuestieComms.remoteQuestLogs` (by quest, then by member, then each objective's `fulfilled`, `required` and `finished`).

- A quest some online member shows and the player doesn't have becomes a quest shaped like Questie's own. A member hidden by `CommsVisibility.ShouldShowPartyObjective` is passed over.
- Its objectives are built once per index from `QuestieDB.GetQuest(questID).ObjectiveData`:
  - The description is the objective text, or its target's name by query.
  - The color comes from `QuestieLib:ColorWheel()`.
  - The `spawnList` comes from Questie's own builder for a party member's objectives, `QuestieQuest.private.objectiveSpawnListCallTable[Type]`.
- Each objective's count is the fewest any member who still needs it has, and it is done when no member needs it.
- These quests are kept while any member has them, so their objective tables, and the blobs cached on them, last between plans.
- Their nodes are keyed `questID:p<index>` and marked `party`. Dungeon and raid quests are left out, as the player's own are. Their turn-ins are never routed, and their progress is not noted for "working on it".

### Ghosts

While the player is a ghost, `routes.Origin` sets out from the corpse:

- `C_DeathInfo.GetCorpseMapPosition` is asked of the ghost's map and then each parent, since the graveyard can be a zone away.
- The zone comes from the deepest map at the corpse (`C_Map.GetMapInfoAtPosition` where the client has it).
- The route covers the corpse's zone, starts with the corpse waypoint, and never replans for moving.
- Where the client won't say (a corpse in a dungeon), the route sets out from the player.
- Rerouting the corpse waypoint does nothing.

### Rerouting and Resetting

`routes.SkipStop(stop)`:

- Adds each task's key to `routes.skipped`, prints `ROUTES_SKIPPED` with each quest's Questie link (`routes.QuestLink`, through `QuestieLink.GetQuestHyperLink` in a `pcall`, else the quest name), and plans again.
- Skipped keys are in the signature and last until a reset or a reload. They are never saved.

`routes.ResetObjectives` clears `routes.skipped` and `routes.engaged`, so only a camp the player stands in now goes first again. It prints `ROUTES_RESET` and plans again.

### Client Differences

Routes runs on all four clients from the same files and never reads `ns.FLAVOR`. The differences are handled by feature tests:

- `C_DeathInfo.GetCorpseMapPosition`, `C_Map.GetMapInfoAtPosition`, `Ambiguate` and `UnitIsConnected` are used only where they exist.
- The markers' size is divided by the map's effective scale, so Classic Era and TBC's larger full-size map doesn't draw them bigger.
- The world map may load on demand, which the `ADDON_LOADED` row covers.
- Instance quests go by each flavor's own `ns.QUEST_TAG_SUFFIXES`, since tag IDs differ by flavor.

### Questie

Without Questie there is no route:

- `routes.IsQuestieReady()` needs `Questie.started`, `HereBeDragonsQuestie-2.0` (found through `LibStub`'s silent flag) and the `QuestiePlayer` module.
- Until then nothing plans, the arrow has nothing to show, and the panels still show.

Every Questie module comes through `ns.ImportQuestieModule`, and every call that can throw is wrapped in a `pcall`. The ones Routes uses:

- `QuestiePlayer.currentQuestlog` and each quest's `IsComplete`, `Objectives`, `SpecialObjectives` and `Finisher`.
- `QuestieDB.QueryNPCSingle`, `QueryObjectSingle`, `QueryItemSingle`, `QueryQuestSingle`, `GetQuest`, `GetQuestTagInfo` and `questTagIds`.
- `ZoneDB:GetUiMapIdByAreaId` and `Phasing.IsSpawnVisible`.
- `QuestieComms.remoteQuestLogs` and `CommsVisibility`.
- `QuestieLib:ColorWheel`, `QuestieLink:GetQuestHyperLink` and `QuestieQuest.private.objectiveSpawnListCallTable`.
- `Questie.usedIcons`, `Questie.ICON_TYPE_COMPLETE` and `Questie.ICON_TYPE_EVENT`.
- The pin library `HereBeDragonsQuestie-Pins-2.0`'s `worldmapProvider`.

Without `ZoneDB` no objective has a place. Without `Phasing` every spawn counts. Routes Context shows each of these.

## Resizing and Scale

The grip in the bottom-right corner (`ns.CreateResizeGrip`, `Features/Window.lua`) drags the window taller. It sits `GRIP_INSET` inside the drawn border, or with ElvUI's skin on Classic Era and TBC, inside the skin's backdrop (`AnchorGrip`). `ns.ClampHeight` snaps the height to whole list rows, never below the default (`LAYOUT.BASE_HEIGHT`, 513) and never closer than `MINIMUM_BOTTOM_CLAMP` (16px) to the bottom of the screen, measured down from the window's top, so a window of the add-on's own dragged lower has less room to grow. Heights are in the window's own units, so the screen's measures are divided by the window's scale. Both panes take the window's height less `LAYOUT.PANE_INSET` (151px). The height is saved to `global.height` when the drag ends, when the mouse is let go anywhere else, or when the grip hides mid-drag. It is applied every time the window opens, not at load, because the screen size and UI scale aren't settled at load and the clamp would cut it short. The value clamped as the window opens is never written back, so a smaller screen shrinks the window, not the setting. Only the plain lower half of each upper art piece stretches; the top half carries the border and keeps its proportions.

Window Scale (`global.scale`, 70% to 130% in 5% steps, default 100%) is applied as the window opens, on WoW Forever and Mists also as the saved settings load (`ns:OnDatabaseReady`, along with the saved position), and through `ns.ApplyWindowScale` the moment the slider moves, which, while the window is open, clamps the height to the screen again. The Wide Quest Log panel's Reset Window button (`ns.ResetWindow`, confirmed) clears the height and, on WoW Forever and Mists, the position. It writes Window Scale and Map Scale back from `ns.DATABASE_DEFAULTS` rather than clearing them, because AceDB copies plain defaults in only as the saved settings load. It leaves `mapHidden` alone.

On Classic Era and TBC the window belongs to Blizzard's panel manager, which keeps a 152px clamp below it (`BOTTOM_CLAMP`, 140 + 12) to clear the action bars. `ApplyHeight` trades that clamp away a pixel for every pixel of extra height, down to `MINIMUM_BOTTOM_CLAMP`, because at a normal UI scale there's no other room to grow. Whenever the height changes it tells the panel manager the new height and clamp (the `height` and `bottomClampOverride` panel attributes), or the manager scales the whole window down to fit the space it thinks the window needs.

On WoW Forever and Mists the window is the add-on's own, so it also moves: dragging its title bar (the top `PANE_TOP` pixels, 75) saves its position to `global.point`.

## Moving from Wide Quest Log Plus

This add-on is the continuation of Wide Quest Log Plus (folder `WideQuestLogPlus`), rehosted under a new name, folder and SavedVariables table. Both hook and reshape the same Blizzard quest log, so they must never run together. While `ns.PREDECESSOR_ADDON_NAME` (`Data/Data.lua`) is loaded, `ns:WarnIfPredecessorLoaded()` (`Features/Core.lua`) prints `CHAT_PREDECESSOR_LOADED` on every login and reload, whatever the welcome toggle says. It doesn't disable either add-on itself. Outside comments, the old name appears in the code only in that constant, that string's locale entries, and one line in the Quest Log Context report (`Diagnostics/Manifests.lua`) saying whether it's loaded. Don't carry it anywhere else, the old `/wqlp` and `/widequestlogplus` commands included.

## Saved Variables

`PrettyWideQuestLogDB`, managed by AceDB-3.0, is the only SavedVariables table and holds every setting. The add-on uses the **Simple** model (`AceDB:New(ns.SAVED_VARIABLES_NAME, ns.DATABASE_DEFAULTS, true)`): it stores nothing that differs from character to character, so every character starts on one shared Default profile. The stock profiles panel still lets a player make others, and `OnProfileChanged`, `OnProfileReset` and `OnProfileCopied` all call `ns:ApplyProfile`, so any change applies live.

Reset Profile clears every option on the profile, Routes' `routes` table included, and leaves `global` alone.

- **The profile** holds the settings: the welcome toggle, the Quest Log and Quality of Life switches and their panels' options, and Routes' own table, `routes`: its switches, the zone map's and the Quest Arrow's options, and party quests (see Routes, Settings).
- **`global`** holds only how things sit on screen: Window Scale and Map Scale (`scale` and `mapScale`, default 1, set on the Wide Quest Log panel but stored here), the window's saved `height`, whether the map is hidden (`mapHidden`), on WoW Forever and Mists the window's position (`point`), and where the Quest Arrow was dragged (`routesArrowPoint`). The last four have no defaults. They are presentation, kept out of the profile's reach so a profile reset or switch never moves, resizes, rescales or hides anything: Reset Window returns the height, position and both scales to their defaults, and the Quest Arrow panel's Reset puts the arrow back. Classic Era and TBC save no window position, since Blizzard's panel manager places that window.

AceDB copies the plain defaults in `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`) into the saved tables as the saved settings load, keeps an explicit `false`, and strips values equal to their defaults at logout. A key set to nil after that reads nil until the next reload, so code that resets a setting with a default writes the default, as `ns.ResetWindow` does for `scale` and `mapScale`. No default lists are seeded.

### Migration Chain

One migration is in the code: `MigrateSettings` in `Features/Routes/Routes-Core.lua`, tagged `MIGRATION (remove after 2026-12-06)`, which Routes' `PLAYER_LOGIN` handler runs before its login handlers.

1. It moves an account-wide `global.routes` table onto the profile's `routes`, keeping only keys that have a default, so `planTurnIns` is dropped.
2. Its `arrowPoint` goes to `global.routesArrowPoint`, unless a spot is already saved there.
3. `global.routes` is cleared. Routes Context says when old settings are still waiting to move.

Nothing else migrates. `PrettyWideQuestLogDB` holds only AceDB's data, and Wide Quest Log Plus's settings live in its own SavedVariables file, which this add-on can't read, so they aren't carried over.

## Adding a New Setting

1. Add the key and its default to `ns.DATABASE_DEFAULTS.profile` in `Data/Default-Settings.lua`. Only how something sits on screen, which a profile reset must not touch, goes in `global`. A Routes setting goes in the `routes` table instead (see Adding a New Routes Setting).
2. Add its control to the panel of the feature it belongs to, with its label and `desc` in `Locales/enUS.lua`: `Options/Options-Quest-Log.lua` for the quest log, in its section (Sorting, Quest Rows, Window & Map; each has its own band of `order` numbers, and Handy Clicks, built by `AddHandyClicks`, takes 50 and up). Its `QuestLogToggle`, `SortSelect` and `SortSubOption` builders take the panel's `Hidden` and `Inactive` gates, so the control hides with the switch off and grays out while a reload is pending; a control built without `Inactive` can call a part's function that doesn't exist. A map setting uses `MapHidden`, which also hides it on a client with no map (`ns.hasQuestMap`). Otherwise `Options/Options-Quality-of-Life.lua`, whose controls hide with that switch off.
3. Read it live where it applies. A Quest Log setting that changes the list calls `ns.RefreshQuestLog()` from its `set`; one that changes only the map calls `ns.questMap.RequestRefresh()` instead, as Show Objective Areas does; every Quality of Life toggle's `set` already calls `ns.ApplyQuestGiverCleanup()`. `ns:ApplyProfile` calls all three on profile changes, the first two only while the wide quest log runs, and the map's only with a map. A Quality of Life setting read outside its panel also checks `enableQualityOfLife`, as `ns.IsQuestGiverCleanupOn` and `ns.GetShareInterval` do, so the switch turns the whole feature off.
4. Add it to the context report it explains: in `Diagnostics/Manifests.lua`, Quest Log Context for the list, whether the window is open, the feature switches, the welcome toggle and the quest giver window; Tracking Context for tracking; Sharing Context for Share Quests, the whispers and the dungeon quests; Quest Map Context for the map; Routes Context for Routes; in `Diagnostics/Settings-Reports.lua`, Display Context for the window's saved size, scales and position.

## Adding a New Routes Setting

1. Add the key and its default to `ns.DATABASE_DEFAULTS.profile.routes` in `Data/Default-Settings.lua`. Only where something sits on screen goes in `global`, as `routesArrowPoint` does.
2. Add its control to `Options/Options-Routes-Map.lua` or `Options/Options-Quest-Arrow.lua`, in that panel's section and `order` band. Build it with `ns.OptionsRoutesToggle` (a switch) or `ns.OptionsRoutesControl` (a slider, choice or button: pass the key, or nil for a button). Give it the panel's hidden gate (`MapHidden`, `LineHidden`, `RouteHidden`, `ArrowHidden`, `QuestsHidden`). Put the label and `<KEY>_DESCRIPTION` in `Locales/enUS.lua`, under the panel's section.
3. Read it at use through `routes.Settings()`. Both builders write through `routes.SetSetting`, which notifies every listener, so a setting that only changes how the route looks is redrawn by `Routes-Map.lua`'s listener (`provider:RefreshAllData`) or the arrow's `Refresh`.
4. If it changes what's planned, add it to `routes.Signature()` in `Routes-Questie.lua` so the watcher plans again, or call `routes.RequestPlan()`.
5. A new view of the route registers with `routes.AddListener(fn)` for changes and `routes.OnLogin(fn)` for setup that needs the saved settings.
6. Add a `RouteSetting(lines, label, key)` line to the matching part of Routes Context in `Diagnostics/Manifests.lua`: `ArrowLines`, `ZoneMapLines`, `PartyLines`, or the switches at the top of `ns:BuildRoutesContextReport`.

## Adding a New Event

Add `{ "EVENT_NAME", "OnEventName" }` to `EVENTS` in `Features/Core.lua` and define `ns:OnEventName` in the feature file that needs it, at file scope or in a quest log part, so it exists by the registration pass at the end of `ADDON_LOADED`. Core registers it on the clients whose files define the handler, and Diagnostics picks it up from `ns.EVENT_NAMES`. On Classic Era and TBC, a handler defined inside an `ns.AddWideQuestLogPart` function is registered only when the wide quest log runs. A handler in a shared file is defined, and its event registered, on every client, so an event one client lacks belongs only in that client's files.

A further feature handling an event keeps the same handler name on a table of its own and gets an `EVENTS` row naming that table's `ns` key as its third field, after the rows already there, since rows run in table order. The table must exist by the registration pass: `ns.dungeonQuests`, `ns.shareReminders`, `ns.questMap`, and Routes' `ns.routes`, `ns.routesMap` and `ns.routesArrow` are the owners so far. Routes' handlers are all at file scope, so their events register on every client whose TOC lists `Routes.xml`, whatever the Wide Quest Log switch says.

## Adding a New API Call

1. Confirm the client has it: its branch of [wow-ui-source](https://github.com/Gethe/wow-ui-source), or an existing Diagnostics row. Don't gate on a client difference nobody has shown.
2. Add its path to the list in `Diagnostics/Manifests.lua` for the clients that call it:
   - `SHARED_FUNCTIONS`: every client.
   - `GIVER_PAGE_FUNCTIONS`: the quest giver and gossip pages Quest Giver Window Cleanup restyles.
   - `LOG_INDEX_FUNCTIONS`: the clients with no `C_QuestLog.GetInfo` (Classic Era, TBC and Mists).
   - `CLASSIC_FUNCTIONS`: Classic Era and TBC.
   - `OWN_WINDOW_FUNCTIONS`: WoW Forever and Mists.
   - `QUEST_ID_FUNCTIONS`: WoW Forever.
   - `INDEX_WINDOW_FUNCTIONS`: Mists.
   - `ROUTES_FUNCTIONS`: Routes, whose rows are added only when `ns.routes` exists.
   - For the map: `OWN_WINDOW_MAP_FUNCTIONS`, `FOREVER_MAP_FUNCTIONS` or `MISTS_MAP_FUNCTIONS`.

   A Blizzard frame, mixin or table a file reaches for at load goes in the matching `_TABLES` list (`SHARED_TABLES`, `GIVER_PAGE_TABLES`, `CLASSIC_TABLES`, `OWN_WINDOW_TABLES`, `QUEST_ID_TABLES`, `INDEX_WINDOW_TABLES`, `ROUTES_TABLES`, or `OWN_WINDOW_MAP_TABLES` for the map, since the per-client map lists have none). Numbers and strings have their own `Rows` lines, Routes' in `ROUTES_NUMBERS`. A call the add-on takes one of two ways, whichever the client has, gets a row with its own test, as in `QUEST_LOOKUP_ROUTES` and `REWARDS_HEADING_ROUTE`. A read only a data kind makes goes in `KIND_API_CHECKS` (`Diagnostics/Validate-Data.lua`).
3. Add the global to `read_globals` in `.luacheckrc`, or to `globals` if the add-on writes it (`QUESTS_DISPLAYED`, the `StaticPopupDialogs` fields, `PrettyWideQuestLogRoutePinMixin`). A function only hooked by name (`hooksecurefunc("QuestLog_UpdateQuestDetails", ...)`) is never read as a global and needs no entry.

## Adding a New Share Result

1. Add the client's result string to `FIXABLE_RESULTS` in `Features/Share-Reminders.lua`. It gets the same two whispers as the others, so it needs no new locale key.
2. Add the result string to `SHARED_LABELS` and `SHARE_RESULTS` in `Diagnostics/Manifests.lua`.
3. Add it to `read_globals` in `.luacheckrc`, beside the other three.
4. A change to a whisper's body goes in `Locales/enUS.lua`, with one `%s` for the quest reference and no closing period, for the Localization Review to carry to the other locales; a new whisper key goes in `SHARE_WHISPER_KEYS` in `Diagnostics/Localization-Reports.lua` too.
5. Check the Message Length report in ruRU, the widest-encoding locale. The 255-byte limit is on the whole whisper; `ns.FittingQuestReference` only ever shortens the quest's title, so the body itself must leave room for one.

## Adding a New Quest Tag or Sample Quest

**A quest tag:**

1. Add its ID to `ns.QUEST_TAG_SUFFIXES` in each flavor's `Data/{Game}/Quest-Tags-{Game}.lua` that has it, mapped to its kind (`"DUNGEON"`, `"RAID"`, `"GROUP"`, `"ELITE"` or `"PVP"`). Tag IDs aren't the same across flavors: tag 1 is Elite on Classic Era, Season of Discovery and WoW Forever, and Group from TBC on.
2. A new kind of tag also needs `L["QUEST_SUFFIX_<KIND>"]` and `L["QUEST_TYPE_<KIND>"]` in `Locales/enUS.lua`, and an entry in `LEGEND_ORDER` in `Features/Quest-Display.lua`. The quest chain's badge width picks it up on its own. Routes treats only `DUNGEON` and `RAID` as instance quests (`INSTANCE_KINDS` in `Features/Routes/Routes-Questie.lua`).
3. The Data tab's report only counts these, so the IDs themselves aren't checked in game.

**A sample quest:**

1. Edit `ns.SAMPLE_QUEST_IDS`, `ns.SAMPLE_DUNGEON_AREA_ID` or `ns.SAMPLE_ZONE_AREA_ID` in each flavor's `Data/{Game}/Sample-Quests-{Game}.lua`, Vanilla and Discovery both. With quests, the dungeon area is required and the zone area optional (the zone Example falls back to the dungeon). An empty list hides the Example lines.
2. Validate Data and Game Names rows follow on their own. Run the Data tab on that client.

## Adding a New Data Table

1. Add `Data/{Game}/{Label}-{Game}.lua` in every flavor folder, and list it in each TOC before the feature that reads it. The Vanilla and Discovery copies each open with an `ns.IS_DISCOVERY` guard, so the later file doesn't overwrite the earlier.
2. Add a row to `ns.DIAGNOSTIC_DATA_SOURCES` in `Diagnostics/Manifests.lua`. The Data tab's report follows from it, and its `label` must match the file name, since Validate Data looks for `{DATA_FOLDER}/{label}-{DATA_FOLDER}.lua`. Give each source the kind of ID it holds (`mapArt`, `area`, `quest`, `other` or `uiLabel`); a file holding one setting rather than a table, as the Wowhead files do, takes `kind = "value"`, which prints the value.

## Adding a New Flavor

1. Add `Pretty-Wide-Quest-Log_{Flavor}.toc` with its `X-Flavor`, and an `ns.EXPANSION` entry in `Data/Flavor.lua`.
2. List its four data files in the TOC (`Map-Reveal`, `Quest-Tags`, `Sample-Quests` and `Wowhead`, the last holding its part of Wowhead), before `Features/Quest-Display.lua`, which reads the tags at load. If its folder is in `.pkgmeta`'s ignore list, take it out.
3. Pick its quest log by which files the TOC lists: `Classic-*.lua` if it has the `QuestLogTitle{N}` rows, otherwise the `Forever-*.lua` window files with tracking and takeover files of its own, as Mists has. The `ns` accessors in `Features/Quest-Log-API.lua` cover whichever quest log calls it has.
4. List `Features/Routes/Routes.xml` after `Quest-Map-Reveal.lua` and before the Diagnostics files, and the two Routes options files with the other panels. Routes tests for features rather than flavors, so it needs nothing else.
5. Check the new client's Diagnostics rows, because a Mists-style split shows up there: `OWN_WINDOW` and `QUEST_ID_API` in `Diagnostics/Manifests.lua` are tested separately, since the window doesn't imply the API.

## Localization

- **`enUS.lua` is the source of truth** and the only locale passing the default-fallback flag. The other locale files belong to the Localization Review (`07 - Localization Review.md`); never hand-edit them.
- **Placeholders** (`%s`, `%d`) must match `enUS` in count, type and order in every locale, or the string errors at runtime. The share whispers take one `%s`, the quest reference; `DUNGEON_QUESTS_ANNOUNCE` takes `%d` then `%s`, the count then the list, and `DUNGEON_QUESTS_ANNOUNCE_ONE` and `DUNGEON_QUESTS_ANNOUNCE_CONTINUED` take the list alone. Routes' are `ROUTES_YARDS` and `ROUTES_MORE_TASKS` (`%d`), `ROUTES_TURN_IN_QUEST` and `ROUTES_SKIPPED` (`%s`), `QUESTS_LISTED_DESCRIPTION` (`%s`) and `SHOW_DISTANCE_DESCRIPTION` (`%s` then `%s`). The last two are formatted as `Options/Options-Quest-Arrow.lua` loads, so a mismatch there breaks the whole panel file, not one line.
- **Game names never go in `Locales/`.** The add-on stores no spell, item, skill or class ID.
  - **Quest tags.** The quest tag IDs that pick the D, R, P, G and E letters are `ns.QUEST_TAG_SUFFIXES` in `Data/{Game}/Quest-Tags-{Game}.lua`, which `ns.QuestSuffix` (`Features/Quest-Display.lua`) turns into locale keys, because the same tag means different things across flavors. E also comes from an elite flag (`ELITE_SUFFIX`), but only from one the client gives as a flag: `C_QuestLog.GetQuestTagInfo`'s `isElite` or `C_QuestLog.IsEliteQuest`, where the client has them. Classic's list reads the tag ID straight from the client, and most others go through `ns.GetQuestTagByID` (`Features/Quest-Log-API.lua`: `C_QuestLog.GetQuestTagInfo` where the client has it, else `GetQuestTagInfo`, whose branch reports no elite flag, so the tag ID alone picks the letter and the tag's localized name is never matched). The quest chain tries Questie's corrected tag first, and only there is a tag name matched, Questie's against Blizzard's `ELITE`. Those letters are the add-on's own words, so they are locale keys.
  - **Other IDs.** The sample quest and area IDs (`ns.SAMPLE_QUEST_IDS`, `ns.SAMPLE_DUNGEON_AREA_ID`, `ns.SAMPLE_ZONE_AREA_ID`) are named by the client, the areas through `C_Map.GetAreaInfo`, each with a Game Names row. The other IDs it keeps name nothing a player reads: the map art IDs keying `ns.MAP_REVEAL_OVERLAYS` (`C_Map.GetMapArtID`), and texture file IDs for the reveal tiles and Blizzard's quest log art.
  - **Zone names.** Zone names in the list come from the quest log headers the client supplies, and the map's zone dropdown names each zone with `C_Map.GetMapInfo(uiMapID).name`. The current zone's mark compares the header text with `GetRealZoneText()` (`IsCurrentZone`, `Features/Quest-Sort.lua`), a name match, because neither quest log gives its headers a map ID. A class or profession header never matches, and a dungeon's header matches only while the player is inside it, which the dungeon quests rely on. The dungeon quests match headers against `GetRealZoneText()`, the instance name and `C_Map.GetAreaInfo` of the dungeon's Questie zone IDs.
  - **Quest, NPC and object names.** The map's pin tooltips, the quest chain, the turn-in tooltip, the route's waypoint tooltips and the Quest Arrow's list show the quest, NPC and object names from the client or Questie's own data.
  - **Blizzard's strings.** The tag at the right of a row (Elite, Dungeon) comes from the client's quest tag, or from Blizzard's `FAILED`, `COMPLETE`, `ELITE` and `DAILY`. The window title's Quest Log (`QUEST_LOG`) and window labels such as Abandon Quest, Track, Share, Exit and Show Map (`SHOW_MAP`) are Blizzard's GlobalStrings too, and the share whispers match the client's own `ERR_QUEST_PUSH_*` strings. Every one the add-on shows or matches is a Game Names row in `Diagnostics/Manifests.lua`, from the `_LABELS` lists or added beside them, so a new one gets a row there.

## Common Pitfalls

- **Hooking or reshaping Blizzard's quest log outside `ns.AddWideQuestLogPart` on Classic Era or TBC**: it runs with the Wide Quest Log switch off, and can't be taken back. Every file that hooks `QuestLogFrame` or its functions wraps its body in a part; the only exceptions are the share whispers' `QuestLogPushQuest` post-hook and `Classic-Zone-Actions.lua`'s calls when invoked.
- **Calling a part's function from outside a part on Classic Era or TBC**: with the switch off it is nil. Check `ns.wideQuestLogActive`, or gate the control with `Inactive`.
- **Reading `ns.db` at file scope**: it doesn't exist until `ADDON_LOADED`. Classic's quest log parts run after it exists, but the own-window files, the shared files and Routes build at file load. Read settings at use, as `ns.IsQuestGiverCleanupOn` and `ns.ShowTrackingMark` check `ns.db` first, or in `ns:OnDatabaseReady` on WoW Forever and Mists, or in a `routes.OnLogin` handler for Routes.
- **Defining a handler or `ns:OnDatabaseReady` a second time**: each is one slot on `ns`, so the later file silently replaces the earlier. Put a second handler on the feature's own table and name it in its `EVENTS` row's third field.
- **Adding a quest log part after load on Classic Era or TBC**: Core drops its queue once `ADDON_LOADED` has run the parts, so a late `ns.AddWideQuestLogPart` throws. Call it only at file scope.
- **Creating an `EVENTS` owner table after the registration pass**: an event whose only handlers live on it never registers. Create the table at file scope, as `ns.dungeonQuests`, `ns.shareReminders` and Routes' tables are.
- **Registering an event a client lacks**: throws. Add events through `EVENTS` in Core, never `RegisterEvent` in a feature file, and define the handler only in that client's files.
- **Calling `QuestInfo_Display` on WoW Forever or Mists while the quest giver window is open**: blanks it mid turn-in. Go through `ns.DisplayQuestDetails`, which checks `QuestInfoInUseElsewhere`.
- **Editing `QUEST_TEMPLATE_LOG` in place**: changes Blizzard's own quest detail panes. `LOG_TEMPLATE` is a `CopyTable` of it; change the copy.
- **Restyling every `QuestFrameItems_Update`**: the quest giver window lays out its rewards through it too. The hook acts only when `questState` is `"QuestLog"`.
- **Forgetting to re-anchor Classic rows**: `PositionRows` moved them for the row spacing, and `QuestLog_Update` doesn't put them back. Every pass re-anchors every row below the first, which anchors the rest.
- **Re-entering `QuestLog_Update`**: widening the scroll range can scroll the list, which runs `QuestLog_Update` again. `extendingScroll` guards `ExtendScrollRange`.
- **Resizing Classic's window without telling the panel manager**: it scales the whole window down. `ApplyHeight` sets the `height` and `bottomClampOverride` panel attributes whenever the height changes.
- **Applying the saved height at load**: the screen isn't settled, so the clamp cuts it short. Apply it in `OnShow`, and never save the clamped value.
- **Matching Blizzard's art by file path**: current clients return nil from `GetTextureFilePath` for XML textures. `IdentifyBlizzardArt` checks the file ID first.
- **Leaving sort ties to `table.sort`**: it isn't stable, so equal rows swap between repaints. `ns.SortQuests` and `ns.SortZones` (`Quest-Sort.lua`) end on `sortIndex`, the quest log index.
- **Loading `Classic-Quest-Log.lua` before `Classic-Quest-List.lua`**: the log's part calls `ns.GetQuestRowHeight()` as it builds, and the list's part defines it. The Vanilla and TBC TOCs list the list file first.
- **Leaving extra Classic rows shown when the window shrinks**: `QuestLog_Update` fills only up to `QUESTS_DISPLAYED`, so rows made for a taller window keep drawing past the bottom edge. `SetQuestRowCount` hides every made row past the new count.
- **Measuring a Classic row's title as Blizzard left it**: Blizzard sized it for its old position and cut it short there. `StyleQuestRows` sets the width to 0, measures the whole title, then shortens it to clear the tag.
- **Testing `GetQuestLogTitle`'s `isComplete` for truth**: a failed quest's is -1, which Lua counts as true. Compare it with 1, or with 0, as `BuildDisplayOrder` and `ns.GetQuestLogEntry` do.
- **Styling Classic's rows before VoiceOver's buttons**: VoiceOver's button functions rewrite the title and move the check. `UpdateList` runs `StyleQuestRows` last, after `ns.MatchVoiceOverButtons`.
- **Dragging Classic's window taller without re-hanging its bottom buttons**: some are anchored to the window's top edge, so they stay behind. `Classic-Quest-Log.lua` re-hangs off the bottom edge any child anchored to the top more than 60% of `BASE_HEIGHT` down.
- **Measuring a button label's width at load**: the font may not be loaded yet. `ns.CreateListButtons` fits the list buttons the first time they show.
- **Counting Blizzard's watches to find tracked quests on Classic Era or TBC**: with Questie's tracker on, Blizzard's watch count stays at 0. Untrack All asks `IsQuestWatched` of each listed quest, which Questie replaces with its own state.
- **Placing the turn-in line when it's made**: on Classic Era and TBC, `Classic-Quest-List.lua` makes the line before `Classic-Quest-Log.lua` records `ns.abandonButton` and `ns.shareButton`. `PlaceTurnInLine` waits for the first update that shows the line.
- **Asking Classic Era, TBC or Mists about a quest that isn't selected**: `GetQuestLogPushable`, `QuestLogPushQuest` and `SetAbandonQuest` act on the selected quest only. `Classic-Zone-Actions.lua` and the `ns` accessors in `Quest-Log-API.lua` select each in turn and put the player's selection back.
- **Looking for quests under a collapsed zone on Classic Era, TBC or Mists**: the quest log lists none, and expanding or collapsing shifts every index below. Find quests by quest ID after expanding, re-collapse from the bottom up, and put the selection back by its index only once every zone is back as it was. On Mists the window keeps Blizzard's zones open for this reason (`ns.ShowEveryQuestLogEntry`) and tracks its own collapsing.
- **Hiding Blizzard's side windows in combat**: some are protected, so `HideUIPanel` on them is blocked. `CloseLeftPanels` does nothing in combat.
- **Loading `Quest-Log-Key.lua` before `Forever-Quest-Log.lua`**: it reads `ns.questLogFrame` as it loads, the frame that owns the override binding, and `Mists-Quest-Log-Key.lua` also reads `ns.questLog`. The Camelot and Mists TOCs list it right after `Forever-Quest-Log.lua`, followed by that client's own key file.
- **Toggling the window from WoW Forever's `ToggleQuestLog` hook without asking `ns.WasClosedForPanel`**: the world map opening has already closed the window, so a toggle would reopen it and the micro menu button could never close it. `Forever-Quest-Log-Key.lua` toggles only when the window didn't just close for `WorldMapFrame`, and Mists keeps `openBeforeToggle` for the same reason.
- **Assuming the window means the quest ID API**: Mists has the window with only the older calls by index. Go through the `ns` accessors in `Features/Quest-Log-API.lua`, and in Diagnostics test `OWN_WINDOW` and `QUEST_ID_API` separately.
- **Asking Mists about a quest by ID in a loop**: `ns.GetLogIndexForQuestID`, `ns.IsQuestComplete` and the like walk the whole log each call. Read the entry's own `isComplete` and `isFailed`, and pass `questLogIndex` to `ns.IsTracked` and `ns.HasRoomToTrack` where the caller has it.
- **Treating Blizzard's selection as the window's on Mists**: they can differ. `ns.DisplayQuestDetails` selects first, and `Mists-Quest-Portrait.lua` checks before it reads the giver.
- **Letting Blizzard's quest log close the window on Mists**: a panel in the left area closes the window, and Blizzard's would on every takeover. `ns.IsTakenOverPanel` exempts it while the takeover runs, out of combat only.
- **Forgetting `WatchFrame` on Mists**: it listens for no event a watch change fires. `Redraw` in `Mists-Tracking.lua` calls `WatchFrame_Update`.
- **Loading the tracking file after `Forever-Quest-Log.lua` on WoW Forever or Mists**: that file captures `ns.ToggleTracking` by value as it builds its Track button. The Camelot and Mists TOCs list `Forever-Tracking.lua` or `Mists-Tracking.lua` before it.
- **Skipping `AddQuestWatch` for a quest Blizzard already watches on WoW Forever**: Questie's tracker never learns about it. `Track` in `Forever-Tracking.lua` calls `C_QuestLog.AddQuestWatch` regardless; adding a watch that exists is harmless.
- **Iterating `QUEST_INFO_BORROWERS` with `ipairs`**: each client has nil holes where it lacks a frame. It's read with `pairs`.
- **Resetting a setting that has a default by setting it to nil**: AceDB copies plain defaults in only as the saved settings load, so the key reads nil until the next reload. `ns.ResetWindow` writes `scale` and `mapScale` from `ns.DATABASE_DEFAULTS` and clears only `height` and `point`, which have no default.
- **Calling `ns.LogQuests` from code meant to only read**: on Classic Era, TBC and Mists it expands every zone and selects every quest in turn. The reports read the dungeon quests through `ns.DiagnosticLogQuests` for that reason, and Sharing Context swaps it in for `ns.LogQuests` for the length of its `ns.DungeonQuests` call.
- **Putting the selection back by quest ID on Classic Era, TBC or Mists**: a selected zone header, or no selection, is lost. `Classic-Zone-Actions.lua` re-collapses first, so every entry is back where it was, then passes the saved index to `SelectQuestLogEntry`.
- **Sharing quests back to back**: a share within about 3 seconds of the last gets the party member reported as busy. Share Quests and the dungeon quests space them by `ns.GetShareInterval()`, whose slider stops at `SHARE_INTERVAL_MIN`, and share one run at a time (`ns.sharingQuests`).
- **Matching share results against English text**: fails in every other language. `Share-Reminders.lua` builds its patterns from the client's own `ERR_QUEST_PUSH_*` strings.
- **Reading system messages during chat lockdown**: the message is secret and can't be read. `OnChatMsgSystem` returns while `C_ChatInfo.InChatMessagingLockdown()` holds.
- **Counting a login or reload inside a dungeon as arriving**: the party gets the announcement and every quest again. `PLAYER_ENTERING_WORLD`'s `isInitialLogin` and `isReloadingUi` mark the party seen over `ns.DUNGEON_LOGIN_GRACE` as already served.
- **Waiting for party range on WoW Forever**: `UnitInRange` answers for no one there, so the dungeon quests would wait the full minute every time. `IsInRange` counts everyone as in range when `ns.FLAVOR` is `"Camelot"`.
- **Testing a party member's GUID or connection without checking for secrets**: on WoW Forever they can come back secret, and a secret value can't be tested or compared. `PartyMembers` leaves out a member whose answers `ns.IsReadable` flags.
- **Tracking dungeon shares per group instead of per member**: a newcomer would never get the quests, or everyone would get them again on every roster change. The dungeon state keeps the GUIDs shared with, per instance ID, until `GROUP_LEFT`.
- **Keying dungeon state by Questie's zone ID**: without Questie, or for a dungeon its `ZoneDB` doesn't know, there is none. The key is the game's instance ID, the 8th return of `GetInstanceInfo`.
- **Walking Questie's objective lists with `ipairs`**: they can have gaps, so `ipairs` stops early and misses objectives. `QuestieQuestIn` walks them with `pairs`.
- **Counting Questie's world event quests as a dungeon's**: Questie can place a holiday or Darkmoon Faire quest in a dungeon it has nothing to do with. `ns.DungeonQuests` leaves out anything `QuestieEvent.IsEventQuest` flags, even under the dungeon's header.
- **Sending a message over 255 bytes, or shortening one by characters**: `SendChatMessage` rejects the whole message, and the limit is in bytes, so cutting mid-character breaks the text. `ns.FittingQuestReference` picks a quest reference that fits, and `TrimToBytes` cuts the bracketed title on a UTF-8 boundary.
- **Splitting the dungeon announcement anywhere but between quests**: a quest link cut in two is broken text. `DungeonAnnouncementArguments` packs whole references and starts a new message, with its own lead, when the next one won't fit.
- **Stripping pipes from a message for other players**: the bodies carry quest links, which stripping breaks. `ns:BuildAnnounceMessage` keeps pipes.
- **Drawing a chat line in an options panel as chat draws it**: after a link's `|r` a panel falls back to white, where chat falls back to the channel color. The Example lines' `Tint` reopens the color after every `|r`.
- **Treating every `QuestInfo_Display` call as the add-on's own**: the quest giver window, the world map's details on WoW Forever and Blizzard's quest log on Mists call it too, so a hook that styles for one restyles them all. Each hook checks `ns.IsQuestGiverPage(parentFrame)` and `ns.IsQuestGiverCleanupOn()`, and `LayOutSharedPieces` skips only the add-on's own scroll child.
- **Styling Blizzard's quest text after it has been laid out**: Blizzard's measurements no longer match what's drawn. Style shared text as the saved settings load, as `ns.ApplyQuestGiverCleanup` does.
- **Moving a quest giver piece without keeping Blizzard's offset**: Blizzard anchors some pieces afresh on each show but others only once (the greeting text, the gossip greeting, the progress page's title, text, heading and gold), so those would keep the cleanup's offsets after it goes off. Each is kept the first time it moves (`greetingBlizzardY`, `blizzardGreetingY`, `blizzardY`) and put back with the cleanup off.
- **Sizing a gossip line's frame to space the list**: the scroll list measures rows through its extent calculator, not the frames, so the rows overlap. `WrapGossipRowHeights` wraps `elementExtentCalculator` once per list, and styles the greeting inside it, since the measuring frame is only given the text.
- **Hanging the quest giver page's quest ID under any shown `QuestInfo` piece**: a piece left showing from the quest details belongs to the quest log, not the quest giver page. `LastShown` in `Forever-Quest-Giver.lua` counts only pieces whose parent chain reaches that page.
- **Tagging a quest giver's quest line every time Blizzard sets it up**: Blizzard may run the setup again on text already tagged. `levelTaggedText` skips a line already done.
- **Changing a coin button's font without laying the coins out again**: Blizzard sizes each coin to its text when it lays the coins out, so the amounts no longer fit. `ns.StyleRewardMoney` calls `MoneyFrame_Update` with the frame's `staticMoney` after any font change.
- **Regrouping the whole experience text**: ElvUI appends the share of a level in a hook that may run before or after the add-on's, and regrouping it would mangle the share. `Quest-Rewards.lua` regroups only the number at the front.
- **Styling for ElvUI at load**: ElvUI skins the quest log and the quest giver window after this add-on loads, so there's no backdrop yet. `Classic-ElvUI.lua` checks on each `QuestLogFrame` `OnShow` until it can act, and `Quest-Giver.lua` checks the quest giver window's backdrop on each `QuestFrame` `OnShow`.
- **Reading a skin's shadow from the font object**: ElvUI sets shadows on the FontStrings themselves, so a copy loses the Description's look. `CopyFont` in `Quest-Chain.lua` reads font, color and shadow off the FontString.
- **Caching a quest chain miss**: before Questie's database is ready every quest looks like it's in no chain, and the miss would stick for the session. `ns.GetQuestChain` keeps only a chain found (`lastChain`).
- **Calling Questie's modules directly**: Questie may be missing, still loading, or have renamed a function. Modules come through `ns.ImportQuestieModule`, which imports in a `pcall` and returns nil on failure; callers check each function exists before calling it, and wrap calls that can throw in a `pcall`, as the quest chain does for every database query.
- **Reading VoiceOver's fields by plain indexing**: the `VoiceOver` global falls back to `_G` for anything it doesn't hold, so a missing field reads as some unrelated global instead of nil. `ns.GetVoiceOver` checks its fields with `rawget`. The one deliberate exception is `Classic-VoiceOver.lua` reading `GetQuestLogTitle` through it, where falling back to the global is the point.
- **Leaving VoiceOver's own play buttons on the add-on's rows (WoW Forever and Mists)**: Blizzard's list takes them back to its rows whenever it redraws. `Forever-VoiceOver.lua` makes a set of its own with VoiceOver's `MakePlayButton`.
- **Making the turn-in tooltip opaque once**: every `Show` restores the see-through style. `MakeOpaque` runs after each `Show`.
- **Trusting the template's width for Mists' quest text**: the client sets it 270 wide whatever the template says. `Forever-Quest-Details.lua` sets the width again after `QuestInfo_Display`.
- **Loading `Mists-Quest-Portrait.lua` before the map**: it reads `ns.questMap.holder` and hooks `ns.DisplayQuestDetails`, `ns.ApplyMapScale` and `ns.OnWindowResizeStopped` at load. The Mists TOC lists it after every other Features file.
- **Reusing a quest tag ID across flavors**: tag 1 means Elite on some and Group on others. Keep them in each flavor's `Quest-Tags` file.
- **Loading the map files out of order**: several files read another's output as they build. `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons`, and defines the `PrettyWideQuestLogPinMixin` that `Questie-Map.xml` names; `Classic-Quest-Map.lua` takes `ns.questMap.RequestRefresh` by value for its `QuestLog_UpdateQuestDetails` hook; `Forever-Quest-Map.lua` reads `ns.questMap` at load; and `Quest-Map-Reveal.lua` hooks the exploration pin the client's map file makes. Each TOC lists the quest log and list files, then `Quest-Map.xml`, `Quest-Map.lua`, `Questie-Map.xml`, `Questie-Map.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, the client's map file, and `Quest-Map-Reveal.lua`, with `Routes/Routes.xml` after them.
- **Building the map canvas in Lua**: `MapCanvasFrameTemplate`'s `OnLoad` runs before Lua could add the `ScrollContainer` and `BorderFrame` it needs. The frame stays in `Quest-Map.xml`.
- **Drawing Questie's quest twice on WoW Forever or Mists**: Blizzard's objective area and marker would sit under Questie's icons. The map's copies of those providers draw nothing while Questie has icons for the selected quest (`ns.questMap.questieQuestID`), and are refreshed only after `FollowQuestieQuest` sets it.
- **Showing a map the client has no art for**: the canvas can't draw it. `questMap.ShowMap` climbs to the nearest parent map that passes `questMap.CanShowMap`, and the dropdown and `AreaMapID` skip such maps.
- **Disabling the mouse wheel on the map to stop zooming**: the wheel then zooms the camera behind it. `SetMouseWheelZoomMode` with `MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_NONE` keeps it enabled.
- **Loading Vanilla and Discovery data without the guard**: the Vanilla TOC lists both, so the later would overwrite the earlier. Each Vanilla file returns early when `ns.IS_DISCOVERY` is set, and each Discovery file when it isn't.
- **Letting the canvas acquire pins in combat**: it calls `SetPassThroughButtons` on each, which WoW blocks from add-on code in combat. The add-on's own templates use `PrettyWideQuestLogPinMixin`, whose `SetPassThroughButtons` does nothing. On WoW Forever and Mists, Blizzard's providers' `RefreshAllData` waits for `PLAYER_REGEN_ENABLED`.
- **Overriding a Blizzard provider's `RefreshAllData` after the combat wrapper**: the override would drop the combat hold. `Forever-Quest-Map.lua` wraps every provider last, over its own overrides.
- **Showing the canvas with no map set**: drawing with none breaks Blizzard's map code. The canvas's `OnShow` sets one first (the quest's, then the player's, then `C_Map.GetFallbackWorldMapID`) before `MapCanvasMixin.OnShow`.
- **Building objective areas from Questie's icons**: Questie thins its icons out where they crowd, so the areas would miss spawns. `Questie-Map-Areas.lua` reads every spawn from `icon.data.ObjectiveData.spawnList`.
- **Reading the glow from Questie's glow texture**: Questie shows that texture only once the world map has been opened. `SetGlow` takes the color from `icon.data.ObjectiveData.Color` and only the texture file from `icon.glowTexture`.
- **Capturing a Routes function before the file that defines it loads**: the local is nil and the first plan throws. `Routes.xml` lists Core, Solver, Party, Questie, Blobs, Nodes, Stops, Stop-Lines, Map, the templates, then Arrow. Keep a new file after everything it captures by value.
- **Moving the pin templates above `Routes-Map.lua`**: `mixin="PrettyWideQuestLogRoutePinMixin"` names a global that doesn't exist yet. The mixin is defined in `Routes-Map.lua`, listed before the `<Frame>` templates, and declared in `.luacheckrc`'s `globals`.
- **Listing `Routes.xml` after the Diagnostics files**: `Manifests.lua` checks `ns.routes` at file load to add the Routes API rows, and would add none. Each TOC lists it among the Features, before Diagnostics.
- **Reaching for `ns.routes` without checking it**: Routes is one TOC line a release can leave out. `ns:ApplyProfile`, `ns.RegisterOptionsPanels`, `ns.OptionsRoutesToggle` and Routes Context all check `ns.routes` first.
- **Yielding inside a `pcall` or a `table.sort` comparator**: Lua 5.1 can't yield across a C call, so the planning coroutine dies. `GatherTurnInBlobs` runs its Questie queries in a `pcall`, then calls `AddSpawns` (which yields) outside it.
- **Writing a plan's results one at a time**: the watcher could compare a new plan's pins with the old plan's nodes and replan in a loop. The planner assigns `routes.stops`, `start`, `nodes` and `engaged` in one statement.
- **Building a moved route to weigh each move**: a 90-node route weighs hundreds of thousands of moves, over 100 MB of garbage a plan. `IsValidMove` and the searches work through index maps (`OrOptIndex`, `TwoOptIndex`), building only the move taken.
- **Using `math.random` in the solver**: equally good routes would flicker between plans. `Shake` uses its own generator from a fixed seed.
- **Leaving node order to Questie's log**: it's a hash, so the same quests would give different routes. `BuildNodes` sorts nodes by `key`.
- **Trusting a cached blob's `penalty`**: blobs are cached and shared between plans, and `PinEngaged` zeroes the pinned one's. `routes.Candidates` rewrites every candidate's penalty each plan.
- **Calling the world map's `Maximize` for the full-size map**: it runs Blizzard's panel layout as add-on code. `KeepFullSize` sets the `miniWorldMap` CVar instead, and never in combat.
- **Letting the canvas set pass-through buttons on the route's pins**: `SetPassThroughButtons` is blocked in combat, so opening the map then blames the add-on. `PrettyWideQuestLogRoutePinMixin.SetPassThroughButtons` is an empty function.
- **Hiding Questie's icons through Questie**: its own icon state would change on its other maps. `ApplyQuestieIcons` hides HereBeDragons' pins, marks them `hiddenByRoute`, shows them again itself, and re-applies after Questie's provider `RefreshAllData` and `HandlePin`.
- **Sizing markers by the canvas alone**: Classic Era and TBC draw the full-size map at about 1.8 times the UI's scale, so markers come out that much bigger. The size is multiplied by `UIParent:GetEffectiveScale() / map:GetEffectiveScale()`.
- **Saving the arrow's offsets in its own scale**: changing Arrow Size would move it. `OnDragStop` saves offsets times the scale, and `PlaceFrame` divides by it.
- **Treating `routes.Settings()` as the saved table before `ADDON_LOADED`**: it returns `ns.DATABASE_DEFAULTS.profile.routes` itself, and a write there changes the defaults. Write only once `ns.db` exists, as the panels do.
- **Formatting a locale string with the wrong placeholders at file load**: `Options-Quest-Arrow.lua` formats `SHOW_DISTANCE_DESCRIPTION` (two `%s`) and `QUESTS_LISTED_DESCRIPTION` (one `%s`) as it loads, so a mismatched translation breaks the whole panel file. Keep their placeholders matching `enUS`.
- **Routing a dungeon quest's objectives**: they're inside the instance, where the arrow can't help. `IsInstanceQuest` leaves them out by the flavor's tag table, and their turn-ins stay on the route.
- **Answering escort or instance questions once per session**: the client learns a quest's tag only once it has loaded the quest. Both caches are wiped a second after the quest log settles (`routes.ForgetQuestTags`).

## Contributing

- **Issues**: [GitHub Issues](https://github.com/Gogo1951/Pretty-Wide-Quest-Log/issues).
- **Bug reports**: game client and version, locale, the character's class and level, which other quest add-ons are installed (Questie, ElvUI, VoiceOver, Spoken Quests), steps to reproduce, and the Diagnostic Tools' Settings tab output from Run All (Quest Log, Tracking, Sharing, Quest Map and Routes Context, Display Context and the rest), plus the Event Log when the quest log didn't update. For a whisper or dungeon announcement problem, add the message as the party received it and the Localization tab's Message Length report. For a route or Quest Arrow problem, add Routes Context taken where the route went wrong, and the quests involved.
- **Discord**: [Pretty Wide Quest Log on Discord](https://discord.gg/eh8hKq992Q).
- **PR guidelines**: keep each PR to one change; run `stylua --syntax lua51`, `luac -p` and `luacheck .` before pushing (CI runs all three). Any change to the shape of saved data ships its own migration, tagged `MIGRATION (remove after YYYY-MM-DD)` 30 days past its release. Any change to a whisper, the dungeon announcement or their bodies is measured in bytes against the 255-byte chat limit in ruRU, with the Message Length report. Update this document if the architecture, File Map or Saved Variables change.
- **PR descriptions say what a player will notice**, in plain language, the way release notes do; commit messages carry the developer detail.
