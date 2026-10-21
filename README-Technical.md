# Pretty Wide Quest Log // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Pretty Wide Quest Log. For end-user documentation, see [README.md](https://github.com/Gogo1951/Pretty-Wide-Quest-Log/blob/main/README.md).

## File Map

```
Pretty-Wide-Quest-Log/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── config.yml                 This add-on's New issue page: the blank-issue link, Discord and CurseForge
│   │   ├── defect.yml                 Shared, from Common-Core
│   │   └── request.yml                Shared, from Common-Core
│   └── workflows/
│       ├── ci.yml                     Calls Common-Core: CI checks on every PR and push to main
│       ├── issue-labels.yml           Calls Common-Core: labels a new Defect by its Issue Type
│       └── package.yml                Calls Common-Core: release packaging on a tag
├── .gitattributes                     Shared, from Common-Core
├── .gitignore                         Shared, from Common-Core
├── .luacheckrc
├── .pkgmeta                           Ace3 externals and the zip's ignore list, Data/Wrath, Data/Mists and Data/Mainline included
├── Pretty-Wide-Quest-Log_Vanilla.toc  Classic Era, Season of Discovery included
├── Pretty-Wide-Quest-Log_TBC.toc      TBC Anniversary
├── Pretty-Wide-Quest-Log_Camelot.toc  WoW Forever
├── Data/
│   ├── Flavor.lua                     Canonical flavor identity, copied byte for byte
│   ├── Data.lua                       Locale, links, Wowhead URL, palette, registry names, ns.LAYOUT geometry, tracking marks, chat limit, share and dungeon timings
│   ├── Default-Settings.lua           AceDB defaults
│   └── {Game}/Map-Reveal-{Game}.lua   The map's unexplored areas, one file in each of the seven flavor folders; Wrath, Mists and Mainline declare empty tables
├── Diagnostics/                       Diagnostic Tools from Magic Eraser, with no Data tab and no Validate-Data.lua
│   ├── Manifests.lua                  Per-client API and Game Names rows; the Quest Log, Tracking, Sharing and Quest Map Context probes
│   └── Localization-Reports.lua       Locale Context, Game Names, and Message Length for the whispers and the dungeon announcement
├── Features/
│   ├── Core.lua                       Version, event dispatcher, AceDB, the Quest Log switch, login notices
│   ├── Utilities.lua                  Colors, number grouping, Questie imports, quest tag and title lookups, VoiceOver, share interval, sorting
│   ├── Announcements.lua              Player prints (ns:PrintMessage), sent messages (ns:Announce) and the group channel
│   ├── Quest-Display.lua              Level tags, quest text styling, objective lines, quest ID
│   ├── Tracking-Mark.lua              The tracking mark in the list, and whether Questie's tracker has taken over
│   ├── Wowhead-Link.lua               The quest ID's Wowhead link and its copy popup
│   ├── Quest-Chain.lua                The Quest Chain section of the details, from Questie's database
│   ├── Quest-Giver.lua                The quest giver window's own pages and progress page, and level tags on its quest lines
│   ├── Window.lua                     Window art, height clamp, resize grip and list buttons, both quest logs
│   ├── Turn-In-Line.lua               The Ready to Turn In line and its tooltip, from Questie's quest data
│   ├── Classic-Tracking.lua           Classic Era and TBC: Track All and Untrack All
│   ├── Classic-Quest-Sort.lua         Classic Era and TBC: the sorted order, and Blizzard's rows redrawn to show it
│   ├── Classic-Quest-List.lua         Classic Era and TBC: list rows, zone gaps, row style, list buttons, zone name clicks
│   ├── Classic-VoiceOver.lua          Classic Era and TBC: VoiceOver's play buttons on the sorted rows
│   ├── Classic-Quest-Details.lua      Classic Era and TBC: detail pane layout, objectives, rewards, daily reset, quest ID
│   ├── Classic-Quest-Log.lua          Classic Era and TBC: widens Blizzard's window, art, resizing, scale, combat close
│   ├── Classic-Zone-Actions.lua       Classic Era and TBC: finding, sharing and abandoning by quest ID, and the whole log
│   ├── Zone-Menu.lua                  The right-click menu on a zone name, every client
│   ├── Share-Reminders.lua            The whisper when a quest share fails for a reason the party member can fix
│   ├── Dungeon-Quest-Lookup.lua       The dungeon the player is in, and which quests in the log are its
│   ├── Dungeon-Quests.lua             On entering a dungeon with a group, announces and shares its quests
│   ├── Quest-Map.xml                  The map's canvas frame, which only XML can build
│   ├── Quest-Map.lua                  The map beside the window, its layout and scale, Show Map / Hide Map
│   ├── Questie-Map.xml                The pin templates for Questie's icons and objective areas on the map
│   ├── Questie-Map.lua                Questie's icons on the map, their tooltip, the zone dropdown, refreshing
│   ├── Questie-Map-Areas.lua          Each objective's spawns clustered into the shapes of its areas
│   ├── Questie-Map-Area-Layer.lua     The layer the areas are shaded on
│   ├── Classic-Quest-Map.lua          Classic Era and TBC: the map's layers and following the selection
│   ├── Quest-Map-Reveal.lua           The map's unexplored areas, drawn so the whole zone shows
│   ├── Classic-ElvUI.lua              Classic Era and TBC: opaque ElvUI backdrop, ElvUI-styled buttons, map and dropdown
│   ├── Forever-Tracking.lua           WoW Forever: tracking and Track All, deferring to Questie's tracker
│   ├── Forever-Quest-Log.lua          WoW Forever: window, buttons, refresh, scale, combat close, quest log takeover
│   ├── Forever-Quest-List.lua         WoW Forever: list rows, sorting, list buttons, zone name clicks
│   ├── Forever-Quest-Details.lua      WoW Forever: detail pane on QuestInfo_Display
│   ├── Forever-Quest-Giver.lua        WoW Forever: the quest giver window's gold, experience and quest ID
│   ├── Forever-VoiceOver.lua          WoW Forever: Spoken Quests' play buttons on the list rows
│   ├── Forever-Zone-Actions.lua       WoW Forever: finding, sharing and abandoning by quest ID, and the whole log
│   └── Forever-Quest-Map.lua          WoW Forever: the map's layers, Blizzard's quest layers as the fallback, following the selection
├── Includes/
│   ├── Images/                        The icon, window art (PWQL_*.blp), untracked mark (PWQL_Untracked.tga), Wowhead link (PWQL_Link.tga)
│   └── Libraries/                     Vendored LibStub, CallbackHandler and Ace3, never edited
├── Locales/
│   ├── enUS.lua                       Source of truth
│   └── {langCode}.lua                 The other ten supported locales
├── Options/
│   ├── Options-Utilities.lua          Shared rows: feature switches, sub-option rows, status lines, the reload check
│   ├── Options-General.lua            Root panel, with both feature switches and the reload prompt
│   ├── Options-Quest-Log.lua          Quest Log panel: the switch, order, list, scale, Reset Size and Position
│   ├── Options-Quality-of-Life.lua    Quality of Life panel: the quest giver window, quest sharing, dungeon quests
│   ├── Options-Profiles.lua           Stock AceDBOptions
│   ├── Options-Feedback-Support.lua   Feedback & Support panel: the Level Up note, the four links and the version line
│   └── Options.lua                    Registration, opener, /pwql
├── LICENSE
├── README.md
├── README-Notes.md
├── README-Technical.md
└── README-Testing.md                  Manual test plan
```

Retired, so don't bring them back: an unsuffixed TOC; the root-level `Legacy.lua`, `Modern.lua`, `Common.lua`, `Layout.lua` and `img/`, whose code lives in `Features/` and art in `Includes/Images/`; `Features/Forever-Quest-Map.xml`, replaced by `Features/Quest-Map.xml`, which every client loads; and `Options/Options-Forever-Quest-Log.lua`, whose switch is now on the Quest Log panel on every client and whose reload prompt is in `Options/Options-General.lua`.

## Architecture

### Two Quest Logs, One Layout

Classic Era and TBC still ship Blizzard's classic `QuestLogFrame`, so the `Features/Classic-*.lua` files widen it in place. They move Blizzard's own regions and rows, swap the art, and hook `QuestLog_Update` and `QuestLog_SetSelection` (the list file, which calls the sort file's order and row redraws) and `QuestLog_UpdateQuestDetails` and `QuestFrameItems_Update` (the details file) to restyle what Blizzard just drew; `Classic-Quest-Log.lua` owns the window itself, its art, resizing and scale. WoW Forever runs the Retail engine, which replaced that frame with a list docked in the world map, so there is nothing to widen. The `Features/Forever-*.lua` files build a window of their own instead. Each client's TOC lists only its own files, so no `Classic-*` or `Forever-*` file checks which client it is on. Shared feature code reads `ns.FLAVOR` in only three places (Diagnostics reads it too, to pick its rows): `ns.AddWideQuestLogPart` and the sent-message marker test for `"Camelot"`, and `ns.WOWHEAD_QUEST_URL` is looked up by flavor. The shared files (`Zone-Menu.lua`, `Share-Reminders.lua`, `Quest-Map.lua`, `Questie-Map.lua` and the rest) call into whichever side loaded through the same `ns` names: `ns.SelectedQuest`, `ns.ShareableZoneQuests`, `ns.ShareQuests`, `ns.questMap.FollowQuest`, `ns.questLogFrame`.

Both share `ns.LAYOUT` (`Data/Data.lua`) and `Features/Window.lua`, which is why the two look the same. The detail pane's text column is exactly two columns of reward buttons wide (147 + 1 + 147px), because reward buttons can't shrink. The window grows by `EXTRA_WIDTH`, whatever that column plus its margins needs beyond the classic parchment, and the art fills the difference with a strip cut from the last 8 pixels of the middle piece, so both seams continue the art on either side. Numbers in the details (objective counts, gold, experience, the quest ID) end two spaces inside the column (`ns.TwoSpacesWide`), because body text wraps short of the edge and a number flush against it looks like it runs past.

### The Quest Log Switch

`enableWideQuestLog` decides, once, as the saved settings load, whether the wide quest log runs this session; `Features/Core.lua` records the answer in `ns.wideQuestLogActive`. The two clients need it differently:

- **Classic Era and TBC.** Hooks on Blizzard's quest log can't be removed, so every Classic quest log file, and the map, ElvUI and VoiceOver files that build on it, wraps its whole body in `ns.AddWideQuestLogPart(function() ... end)`. Core queues those functions at file load and runs them, in TOC order, inside `ADDON_LOADED` right after `AceDB:New`, only when the switch is on. With it off, Blizzard's quest log window is never reshaped or hooked, with two deliberate exceptions that must work with the switch off: `Share-Reminders.lua` post-hooks `QuestLogPushQuest` at file scope, only to note which quest went out, and `Classic-Zone-Actions.lua` sits outside any part because the share whispers and the dungeon quests call its `ns.SelectedQuest`, `ns.LogQuests` and `ns.ShareQuests`; it touches the quest log only when called.
- **WoW Forever.** The quest log is the add-on's own window, which stays closed unless something opens it, so the `Forever-*.lua` files build at file scope, before `ns.db` exists, and `ns.AddWideQuestLogPart` runs the shared map files' parts at once. Only the takeover of the quest log key waits for the switch (see Taint).

Core drops its queue once the parts have run, so on Classic a part added after `ADDON_LOADED` throws. Everything a part defines is nil on Classic with the switch off: `ns.RefreshQuestLog`, `ns.ResetWindow`, `ns.ApplyWindowScale`, `ns.ApplyMapScale`, `ns.questLogFrame`, `ns.questMap`, `ns.listButtons`, `ns.abandonButton` and `ns.shareButton`. Code outside a part checks `ns.wideQuestLogActive` before reaching for them, as `ns:ApplyProfile` and `Tracking-Mark.lua` do, and the Quest Log panel's controls are disabled by its `Inactive` gate.

A change to the switch applies at the next `/reload`. `ns.IsQuestLogReloadPending()` compares the profile's value with `ns.wideQuestLogActive`, so a profile switch counts and flipping it back goes quiet. While it differs, a silver status line says so under the switch on both the General and Quest Log panels, and when the game's Options window closes, `PRETTYWIDEQUESTLOG_RELOAD` offers the reload. `ns.WatchOptionsForReload` hooks the Options window's `OnHide` the first time any of the add-on's panels shows inside it, because that window may not exist when the add-on loads, and because watching the window rather than the panels still prompts after the player has moved to another category. The Quest Log panel's settings hide while the switch is off, and gray out while it's on but not yet active.

The quest giver window styling, the share whispers, the dungeon quests and the login notices don't depend on the switch, so they run either way.

### Event Loop

`Features/Core.lua` owns the only event frame. Its `EVENTS` table pairs every event the add-on can handle with a handler named for the event; an event listed twice runs both handlers, in order. A handler is looked up as `ns[name]` and called as `handler(ns, ...)`, without the event name. Because one name holds one function, a second feature handling the same event keeps its handler on a table of its own, named in the row's third field (its owner), and is called as `handler(owner, ...)`: `GROUP_ROSTER_UPDATE` runs `ns:OnGroupRosterUpdate` (WoW Forever's bottom buttons) then `ns.dungeonQuests:OnGroupRosterUpdate`, and `GROUP_JOINED` and `GROUP_LEFT` run the dungeon quests' `ns:OnGroupJoined` / `ns:OnGroupLeft` then `ns.shareReminders`' handlers of the same names.

`ADDON_LOADED` for this add-on runs, in order: `AceDB:New`, the profile callbacks, the quest log parts, `ns.ApplyQuestGiverCleanup`, `ns.RegisterOptionsPanels`, `ns:OnDatabaseReady` (a single slot, defined only by `Forever-Quest-Log.lua`), and last the registration pass. That pass registers each event one of whose handlers a loaded file has defined by then, once; a handler defined later is never registered. So:

- **Classic Era and TBC** register `ADDON_LOADED`, `PLAYER_LOGIN`, `CHAT_MSG_SYSTEM` (the share whispers), and `PLAYER_ENTERING_WORLD`, `GROUP_JOINED`, `GROUP_LEFT` and `GROUP_ROSTER_UPDATE` (the dungeon quests, and `GROUP_JOINED` and `GROUP_LEFT` for the share whispers too), plus `ZONE_CHANGED_NEW_AREA` and `PLAYER_REGEN_DISABLED` when the wide quest log runs. The quest log itself works purely through hooks.
- **WoW Forever** also registers the quest events (`QUEST_LOG_UPDATE`, `QUEST_WATCH_LIST_CHANGED`, `QUEST_ACCEPTED`, `QUEST_REMOVED`, `QUEST_TURNED_IN`, `UNIT_QUEST_LOG_CHANGED`), `PLAYER_LEVEL_UP`, and `UPDATE_BINDINGS` and `PLAYER_REGEN_ENABLED` (the quest log key's override binding, see Taint), and registers `ZONE_CHANGED_NEW_AREA` and `PLAYER_REGEN_DISABLED` whatever the switch says, since their handlers sit at file scope in `Forever-Quest-Log.lua`.

What was registered is exported as `ns.EVENT_NAMES` for Diagnostics.

On WoW Forever every quest event funnels into `ns.RequestUpdate()`, which repaints at most once a frame and only while the window is open, because `QUEST_LOG_UPDATE` arrives in bursts. `PLAYER_LEVEL_UP` is there because the difficulty colors change with the player's level. `UNIT_QUEST_LOG_CHANGED` counts only for `"player"`. `GROUP_ROSTER_UPDATE` refreshes only the bottom buttons, because Share is enabled only in a group. A hook on Questie's tracker `Update` (installed in `ns:OnDatabaseReady`), and the `OnHide` of each window that borrows the quest detail elements, request the same repaint. On both clients `ZONE_CHANGED_NEW_AREA` redraws the list so the current zone's mark moves, without re-sorting the zones (see Sorting).

`PLAYER_LOGIN` prints the welcome, the predecessor warning (see Moving from Wide Quest Log Plus), and, `QUESTIE_NOTICE_DELAY` (20) seconds later so it isn't lost among the other login lines, `CHAT_QUESTIE_MISSING` if Questie isn't loaded. The last two ignore the welcome toggle, because they explain something rather than greet.

### Blizzard's Side Windows (WoW Forever)

Blizzard's windows that open on the left of the screen (quest giver, gossip, vendor, trainer, character pane) would open on top of the WoW Forever window, and the quest giver's takes the `QuestInfo` pieces the details are drawn with, leaving them blank. So the two make way for each other, as Blizzard's own windows do: a `ShowUIPanel` hook hides this window when a panel in the `left` or `doublewide` area opens, and opening this window first hides whatever holds those areas (`CloseLeftPanels`), so the details have their pieces back. Bags aren't panels in those areas and are left alone.

### Combat Lockdown

The options opener refuses during combat: it prints the mandated message and returns, never queues. The one thing that defers is WoW Forever's quest log key: its override binding can't change in combat, so a change that comes then waits for `PLAYER_REGEN_ENABLED` (see Taint). With Close When Combat Starts (`closeInCombat`) on, `PLAYER_REGEN_DISABLED` closes the quest log: `HideUIPanel` on Classic, whose quest log isn't a protected frame, and a plain `Hide` on WoW Forever. On WoW Forever, opening the window in combat leaves Blizzard's side windows open rather than hiding them, since some of them are protected; nothing is queued for later. For the same reason the micro menu button and tracker clicks leave Blizzard's world map open in combat instead of handing over to the window, while the quest log key, bound to the add-on's own button, opens the window either way (see Taint). The WoW Forever window is the add-on's own unprotected frame, and Classic's quest log, its scroll bar and the panel manager's positioning of it are unprotected, so both quest logs work in combat.

## Taint

Classic only hooks Blizzard's functions, but these things it does are seen by Blizzard's code as coming from an add-on:

- The window's new size goes to the panel manager through `SetUIPanelAttribute`, the interface Blizzard provides for this, rather than by replacing the `UIPanelWindows` entry.
- A taller window needs more list rows, so `QUESTS_DISPLAYED` (read by `QuestLog_Update`) is raised, the extra rows are created here, and `QuestLog_Update` runs when the row count changes.
- The zone gaps move Blizzard's list rows and widen the list's scroll range through `FauxScrollFrame_Update`.
- Blizzard's "All" toggle and the Track toggle beside it are faded out and unclickable, with Expand All running `QuestLogCollapseAllButton_OnClick`. Track All and Untrack All do what a shift-click does to each quest: `AutoQuestWatch_Insert` to track, and to untrack, `RemoveQuestWatch` after taking the quest out of `QUEST_WATCH_LIST`.
- The sorted order is drawn on Blizzard's own rows: each row's ID (`SetID`), text and textures are rewritten to the entry at its sorted place, and Blizzard's row handlers read that ID (see Sorting).
- Zone header rows take left clicks only (`RegisterForClicks`), so a right-click opens the zone menu instead of collapsing the zone. The zone menu selects, expands and collapses entries and calls `QuestLogPushQuest` and `SetAbandonQuest` / `AbandonQuest`, the same calls Blizzard's own buttons make.

None of it reaches anything protected on those clients.

On WoW Forever, Blizzard's code sees:

- No Blizzard function is replaced. Only when the wide quest log runs this session, `ns:OnDatabaseReady` (inside `ADDON_LOADED`) routes the ways into the quest log to the window; with it off, nothing is routed and the world map keeps the quest log key.
  - The quest log key (`TOGGLEQUESTLOG`) is bound over with `SetOverrideBindingClick`, owned by the window, to the add-on's own hidden `PrettyWideQuestLogToggleButton`, so it never opens the world map, in combat or out. Bindings can't change in combat, so the override is set again on `UPDATE_BINDINGS`, and one that came in combat waits for `PLAYER_REGEN_ENABLED`.
  - The micro menu button calls `ToggleQuestLog`, and the objective tracker (and Questie) call `QuestMapFrame_OpenToQuestDetails`. Both are post-hooked with `hooksecurefunc`, so Blizzard's own runs first and opens the world map; out of combat the hook closes it with `HideUIPanel` in the same frame and toggles the window, or for a tracker click shows that quest in it. In combat the map is left open, because hiding it goes through the panel manager. A quest that isn't in the log stays on Blizzard's map.
- `QuestInfo_Display` is Blizzard's detail renderer, shared with the quest giver window, the quest popup and the map's details, so the add-on calls it only while none of those is showing (`QuestInfoInUseElsewhere`). Each caller sets up everything it reads, so nothing carries over. A `hooksecurefunc` on it (`LayOutSharedPieces`, `Forever-Quest-Details.lua`) puts the shared objective lines back in Blizzard's font after anyone else uses them, and the reward positions back Blizzard's way for the map's details; on the quest giver window it hands over to `ns.LayOutQuestGiverPage` (`Forever-Quest-Giver.lua`) instead. `Quest-Display.lua` post-hooks it too, on every client, for the experience line (see Quest Text).
- Some of this is installed at file scope, so it runs whatever the Quest Log switch says: the `ShowUIPanel` hook, `LayOutSharedPieces`, and the `OnHide` hooks on the windows that borrow the quest detail elements.
- Every details repaint calls `C_QuestLog.SetSelectedQuest` with the window's selected quest.
- The window's name goes in `UISpecialFrames`, so Escape closes it. Blizzard reads that list through `securecall`.
- Opening the window calls `HideUIPanel` on Blizzard's side windows, only out of combat (see Blizzard's Side Windows).
- The bottom Abandon and Share buttons and the list's right-click quest menu call Blizzard's own `QuestMapQuestOptions_AbandonQuest` and `QuestMapQuestOptions_ShareQuest`; showing a quest calls `ExpandQuestHeader`, and the list's zone clicks call `ExpandQuestHeader` or `CollapseQuestHeader`.
- Tracking calls `C_QuestLog.AddQuestWatch` and `C_QuestLog.RemoveQuestWatch` (see Questie Tracking).
- The zone menu and the dungeon quests call `C_QuestLog.SetSelectedQuest`, `QuestLogPushQuest` and `C_QuestLog.SetAbandonQuest` / `AbandonQuest`, then select the quest the details show again.

## Questie Tracking

### WoW Forever

Questie's tracker keeps its own list of tracked quests and only learns about new ones through `C_QuestLog.AddQuestWatch`. The client's automatic watch on accepting a quest bypasses that, so a quest can be watched by Blizzard yet missing from Questie's tracker. Questie's tracker also shows only quests in its database, which much of WoW Forever's new content isn't yet.

So while Questie's tracker is enabled, `Features/Forever-Tracking.lua` counts a quest as tracked only if Questie's tracker shows it (`IsTrackedByQuestie`), and a quest is trackable only if it's in Questie's quest list (`QuestiePlayer.currentQuestlog`). Tracking calls `AddQuestWatch` even when Blizzard already has the watch, since that call is what tells Questie. Untracking goes through Questie's `UntrackQuestId` when Blizzard has no watch to remove, and through `C_QuestLog.RemoveQuestWatch` otherwise. A quest Questie can't show is refused: a one-time chat explanation per quest per session, a `QUESTIE_CANNOT_TRACK` error on every refused click, a tooltip on the grayed-out Track button, and a grayed-out Track item in the list's right-click menu. Untracking from Questie's own menu doesn't always touch Blizzard's watch list, which is why the window also repaints on Questie's tracker updates.

### Classic Era and TBC

Questie's tracker removes Blizzard's watch as soon as it takes a quest, to stay clear of Blizzard's watch limit, so Blizzard's watch count stays at 0 however many quests Questie tracks. Untrack All therefore never counts Blizzard's watches: it goes over the listed quests, untracks each one `IsQuestWatched` (which Questie replaces with its own tracking state) reports as tracked, takes it out of `QUEST_WATCH_LIST`, and calls `RemoveQuestWatch`, which Questie hooks to untrack in its tracker too. Once Questie's tracker has started (`ns.IsQuestieTracking`), every quest is trackable and there's no limit; before that, Blizzard's rules hold (quests with objectives, up to `MAX_WATCHABLE_QUESTS`).

### Before Questie's Tracker Starts (Every Client)

Questie starts its tracker a few seconds after login, partway through its staged startup. Until then nothing reads as tracked: on WoW Forever Questie's quest list is still empty, and on Classic Era and TBC Anniversary Questie keeps no Blizzard watches and only later replaces `IsQuestWatched` with its own. With Mark Untracked Quests on, that would flash a red eye on every quest. So `ns.ShowTrackingMark` (`Features/Tracking-Mark.lua`) draws no marks while Questie's tracker is enabled but not yet `started`, and the first time it sees that, hooks `QuestieTracker:HookBaseTracker`, which Questie calls as the tracker starts, to redraw the quest log through `ns.RefreshQuestLog` (which also clears the frozen zone order), only while the wide quest log runs. Only the marks wait: WoW Forever's Track button and Track All read Questie's quest list whether or not the tracker has started.

## Sorting

Both quest logs sort with the same rules in `Features/Utilities.lua`:

- **Zones** by `zoneSort`: average quest level, highest first by default, or lowest first, or alphabetical by full name. A zone whose level isn't known goes after the rest. Zones tied on level fall back to their name, then to the quest log's order. With `currentZoneFirst`, the zone the player is in goes before them all.
- **Quests** within each zone by `questSort`: level, highest first by default, or lowest first, or alphabetical. With `completedFirst`, quests ready to turn in go before the rest, each group in the `questSort` order. Ties fall back to the quest log's order.

The add-on sorts to every option itself, so each one holds the same on all three clients. `ns.SortZones` freezes the zone order the first time it sorts after the window opens, so turning in or dropping a quest doesn't reshuffle zones under the cursor; a zone the frozen order doesn't know (a quest picked up in a new zone) goes after all of them. Closing the window, or changing a setting (`ns.RefreshQuestLog`), clears it (`ns.ResetZoneOrder`). That includes `currentZoneFirst`: crossing into a new zone moves the green check after its name (`ns.ZoneHeaderText`, `CURRENT_ZONE_MARK`) at once, but the zone only moves to the top the next time the window opens.

On WoW Forever, `BuildEntries` in `Features/Forever-Quest-List.lua` feeds the sorted entries to the add-on's own list, with the same visibility rules as the map's quest list: no hidden quests and no task quests (world quests and bonus objectives), a bounty only once it's complete, and no zone whose quests are all left out. The first time the window opens in a session, `ns.ExpandAllZones` opens every zone, so collapsing one lasts only until the next login or reload.

On Classic Era and TBC the rows are Blizzard's. `QuestLog_Update` fills row *i* with quest log entry *i* + scroll offset, and every row handler (click, shift-click track and link, collapse, the party tooltip, the zone menu) finds its entry from the row's ID plus that offset. So after Blizzard draws, `Features/Classic-Quest-Sort.lua` redraws each row with the entry at its sorted place, the way `QuestLog_Update` would, and sets the row's ID to match. `Classic-Quest-List.lua` then runs, in order: the scroll range, the redraw, the zone gaps, VoiceOver's buttons, each row's style, the list buttons and the turn-in line. Selecting a quest highlights its row by place in the list, so the highlight is moved again after `QuestLog_SetSelection`. A collapsed zone lists no quests, so it sorts by its average from when it was last seen open (kept for the session), or after the rest when it hasn't been. When the sorted order is the quest log's own (zones alphabetical, each zone's quests lowest level first), nothing is redrawn.

## Expand All, Track All and Show Map

Both quest logs put three buttons in a bar above the list. `ns.CreateListButtons` (`Features/Window.lua`) makes the first two, and `Features/Quest-Map.lua` hangs Show Map after them from `ns.listButtons`. Each toggles its label (Expand All or Collapse All, Track All or Untrack All, Show Map or Hide Map) and is sized the first time it shows, once the font is sure to be loaded, for the wider of its labels in this locale and never narrower than `LAYOUT.BUTTON_WIDTH`, so none changes size as its label switches. Expand All and Track All share one width, the widest of their four labels.

- **Track All** shows while a listed quest could still be tracked and the watch list has room, and Untrack All once none can. Untrack All grays out when nothing is tracked. It tracks in list order, top down, so a nearly full watch list fills with the quests the player sees first, and stops when the list is full, posting Blizzard's own "too many" string to the error frame (`UIErrorsFrame:AddMessage`).
- **Classic Era and TBC** (`Features/Classic-Tracking.lua`) track and untrack exactly as a shift-click on each quest would (see Taint and Questie Tracking), over the quest log's listed entries, so quests under a collapsed zone are passed by. The buttons sit in the frame of Blizzard's "All" toggle, which Blizzard hides while the log is empty; Show Map hangs from the window, so it stays. The toggle itself is faded out and unclickable rather than removed, and Expand All runs its click, so Blizzard's record of whether everything is collapsed stays right.
- **WoW Forever** (`Features/Forever-Tracking.lua`, `ns.SetAllTracked`) covers every quest in the list, collapsed zones included, and skips quests Questie can't show, without the chat explanation a single Track click gives. Expand All is disabled while the log is empty, and Untrack All also needs `QuestUtil.CanRemoveQuestWatch()`.

## Zone Menu

Hovering a zone name shows a one-line hint, and right-clicking it opens a context menu (`Features/Zone-Menu.lua`, `MenuUtil.CreateContextMenu`) titled with the zone, then:

- **Share N Quests** counts only the zone's quests the game lets the player share, and is left out when there are none. It is grayed out while solo (the tooltip says `ERR_NOT_IN_GROUP`) and while a share run is still going (`ns.sharingQuests`, which the dungeon quests' sharing sets too). Clicking finds the shareable quests again, then shares one every `ns.GetShareInterval()` seconds, a `C_Timer.After` chain using the interval as it was when the run began, re-finding each quest and checking it's still shareable before it goes. The interval is the Quality of Life panel's `shareInterval` slider, between `SHARE_INTERVAL_MIN` (3) and `SHARE_INTERVAL_MAX` (10), because a share sooner than 3 seconds after the last gets the party member reported as busy. With the Quality of Life switch off, the default applies. Only the slider enforces the range; `ns.GetShareInterval` returns the saved value as it is.
- **Abandon Gray Quests** is always there, so players know it exists, and grays out with a tooltip when the zone has none. "Gray" is how the list draws the quest: `GetQuestDifficultyColor` returning `QuestDifficultyColors.trivial` on Classic, the server's `Enum.RelativeContentDifficulty.Trivial` rating on WoW Forever (falling back to the level when it gives none). The list is taken as the menu opens. The confirmation (`PRETTYWIDEQUESTLOG_ABANDON_GRAY`) lists every quest with its level tag and carries their quest IDs as data, so it abandons exactly what it showed, wherever those quests have moved since. WoW Forever skips any quest `C_QuestLog.CanAbandonQuest` refuses; Classic has no such check.
- **Cancel** closes the menu.

Each client's Zone-Actions file does the work by quest ID. On Classic it's awkward, and the file exists to contain that:

- Share and abandon act on the **selected** quest, and only the selected quest can be asked whether it's shareable (`GetQuestLogPushable`), so each quest is selected in turn and the player's selection is put back afterwards. Opening the menu already does this, to count the zone's shareable quests; finding the gray ones needs no selection, only the zone expanded.
- The quest log lists **no quests under a collapsed zone**, so the zone is expanded to look and collapsed again. Sharing, abandoning and listing the whole log (`ns.LogQuests`, for the dungeon quests) expand everything (`ExpandQuestHeader(0)`), then re-collapse the zones that were closed from the bottom up, so the indexes above each one still hold. Sharing does this for each quest as it goes, so a quest under a zone the player has collapsed is still found. Because `ns.LogQuests` expands every zone and selects every quest, Diagnostics swaps it out rather than call it.

On Classic the menu is opened by the list file (`Classic-Quest-List.lua`), from an `OnMouseUp` hook on the rows. Header rows register left clicks only, and quest rows left and right clicks, on every pass, because Blizzard recycles rows between the two; a header left registered for right clicks would collapse instead of opening the menu.

On WoW Forever the quest log lists a collapsed zone's quests too, so the zones are left as they are, and `C_QuestLog.IsPushableQuest` and `CanAbandonQuest` answer by quest ID. Its zone menu counts a bounty that isn't complete, which the list doesn't show.

## Share Reminders

When a share fails for a reason the party member can fix, `Features/Share-Reminders.lua` whispers them which quest it was. Failures they can't fix (not eligible, already on it, already done) get none.

- **Which results.** `FIXABLE_RESULTS` lists the client's own result strings (`ERR_QUEST_PUSH_BUSY_S`, `ERR_QUEST_PUSH_TOO_FAR_S`, `ERR_QUEST_PUSH_LOG_FULL_S`). All three get the same whisper, which doesn't say why: the game already told them. Each string is turned into a pattern at load, its `%s` (or `%1$s`) catching the player's name, so `CHAT_MSG_SYSTEM` is matched in whatever language the client runs. A client without one of the strings skips it.
- **Which quest.** The result names the player but not the quest, so a `hooksecurefunc` on `QuestLogPushQuest`, which every way of sharing calls, notes the selected quest (`ns.SelectedQuest`) as each share goes out. A result counts only within `ns.GetShareInterval()` of that share, the gap the zone menu leaves between shares, and each player is whispered once per share.
- **Which whisper.** A player's first failure gets the full whisper (`WHISPER_SHARE_FAILED`); every later one gets the short follow-up (`WHISPER_SHARE_FAILED_AGAIN`), naming just the quest. `told` remembers who has had the full one until you join or leave a group (`GROUP_JOINED`, `GROUP_LEFT`, party or raid).
- **When.** Only with the Quality of Life switch and `shareWhispers` both on, and only in a party: never in a raid, a battleground or an arena, where it would be too much spam. Sharing itself still works there. During chat lockdown on WoW Forever the system message is secret and can't be read (`C_ChatInfo.InChatMessagingLockdown`), so nothing is sent.

The whisper goes through `ns:Announce`, so it has the house sent-message shape, led by the short name (`L["ADDON_SHORT"]`) rather than the title. WoW Forever blocks raid-marker tokens in chat, so `ns:BuildAnnounceMessage` leaves the marker off there:

```
{rt3} PWQL // I tried to share [Quest Name] with you, but it didn't go through. ...
{rt3} PWQL // Same goes for [Quest Name].
```

The quest reference is the best one that keeps the whole whisper within `CHAT_MESSAGE_MAX_LENGTH` (255 bytes), chosen by `ns.FittingQuestReference` (which `ns.ShareWhisperQuestReference` wraps for the whispers): Questie's native quest link (clickable for anyone), then Questie's bracketed text (a link for players who run Questie), then the title in brackets, cut on a UTF-8 character boundary to `[Title...]` when even that won't fit. The Localization tab's Message Length report builds each whisper for the longest quest title in the log and shows its byte count.

The Quality of Life panel's silver Example lines under Share Whispers and Dungeon Announcements are built by `ns:BuildAnnounceMessage` from the same locale keys, with the marker drawn as its icon, so they always read as what is sent on this client.

## Dungeon Quests

On entering a dungeon or raid with a group, `Features/Dungeon-Quests.lua` tells the group which of the player's quests still need doing there and shares the ones the game lets them share. Both are Quality of Life settings, on by default: `dungeonAnnounce` and `dungeonShare`.

- **When.** `PLAYER_ENTERING_WORLD` into an instance of type `party` or `raid` while grouped, or `GROUP_JOINED` while inside one, waits `ns.DUNGEON_QUESTS_DELAY` (8) seconds so the group has a moment to load in, then runs only if the player is still in the same dungeon and still grouped. A login or `/reload` inside a dungeon isn't arriving, so it doesn't count, and since that dungeon is never marked done, roster changes there don't reshare either.
- **Once per group per dungeon.** Each dungeon is keyed by Questie's zone ID for it (`ZoneDB.instanceIdToAreaId` on the 8th return of `GetInstanceInfo`), or by its name when Questie isn't loaded or doesn't know the instance, so every instance of it, re-entered or reset, shares one key. The keys done are held in memory until `GROUP_LEFT`. A dungeon is marked done before its sharing starts.
- **Which quests** (`Features/Dungeon-Quest-Lookup.lua`, which also works out the dungeon and its key). A quest counts if it's listed under a quest log header with one of the dungeon's names (`GetRealZoneText()`, the instance name, or the area name of any of its Questie zone IDs), or if Questie places it there: filed under the dungeon (`zoneOrSort`), or a creature, object or item it asks for (creatures and objects by their spawns, items by what drops them), a kill credit, an explore trigger, an extra objective or a required source item found there. This is what catches class quests. Questie files some dungeons' quests under a second zone ID, so the dungeon's alternative IDs from `ZoneDB:GetDungeons()` count too. Without Questie, the header alone decides.
- **The announcement** leaves out quests ready to turn in or failed, and goes to `ns:GetGroupChatChannel()` (instance chat, raid or party). It's a parts list: each quest named as a share whisper names it (`ns.FittingQuestReference`), packed greedily and split only between quests, so a link is never broken. The first message says how many (`DUNGEON_QUESTS_ANNOUNCE`, or `DUNGEON_QUESTS_ANNOUNCE_ONE` for a single quest); every later one repeats the format with just the names (`DUNGEON_QUESTS_ANNOUNCE_MORE`). Nothing is sent when no quest is left to do, or during chat lockdown on WoW Forever.
- **Sharing** takes every matched quest the game lets the player share, ready to turn in or not, and hands them to `ns.ShareQuests`, the zone menu's paced run, with the same chat line. On arrival it's skipped, for good, while a zone menu run is still going. A failed share gets the usual whisper (see Share Reminders).
- **Resharing.** In a dungeon this group has already had, anyone joining or leaving (`GROUP_ROSTER_UPDATE`, compared by GUID against the roster last seen) runs the sharing again `ns.DUNGEON_QUESTS_DELAY` seconds after the last change, so a burst of roster updates gives one run. A run still going is waited out. The announcement isn't repeated.

```
{rt3} PWQL // I have 5 quests to do here: [Quest], [Quest], [Quest]
{rt3} PWQL // [Quest], [Quest]
```

The Sharing Context report shows, inside a dungeon, its key and zone IDs, whether this group has had it, each matched quest and what matched it, and the announcement as it would be sent with each message's byte count. The Message Length report also builds the announcement for every quest in the log still to do and flags any message over the limit.

## Quest Text

Quest text is set the same way in both quest logs and in the quest giver window on every client (`Features/Quest-Display.lua`): lines `LAYOUT.LINE_HEIGHT` times the font size apart, and the section headings (Description, Rewards, and on WoW Forever Objectives) `SECTION_HEADING_SHRINK` smaller than the quest's title (no smaller under ElvUI, whose title font is already small). In the quest logs, objective lines also take the description's font rather than Blizzard's smaller one. The pixel spacings (`QUEST_LINE`, `HEADING_SPACE_ABOVE`, `QUEST_ID_GAP`) are worked out from the description's font by `ns.SetTextSpacing`, because that font differs between clients and languages: by the details file (at file load on WoW Forever, inside its part on Classic), or, on Classic with the Quest Log switch off, from `QuestProgressText` the first time the quest giver window's progress page is styled.

- **Styled before layout.** WoW Forever's shared `QuestInfo` text is also the quest giver window's, so it follows the quest giver window cleanup (see Quest Giver Window): `ns.ApplyQuestGiverCleanup` styles it as the saved settings load, before Blizzard first lays any of it out, so Blizzard measures the text as it will be drawn, or with the cleanup off leaves it Blizzard's. The details restyle it before every repaint whatever the switch says, in case something else restyled it since. The section heading font follows every change to `QuestTitleFont`, which skins set after this file loads.
- **Experience** is set in the description's font and color with its thousands grouped by `ns.FormatNumber`, from a `QuestInfo_Display` hook in this file, because `BreakUpLargeNumbers` can leave them ungrouped. The hook acts for every caller, the world map's details included, except a quest giver page with the cleanup off.
- **Skins recolor late.** ElvUI recolors objective lines in hooks that can run after the styling, so each count column matches its line's color again a frame later.
- **TBC's daily quests** get a line under the title saying when dailies reset (`GetQuestResetTime`), with the objectives hung below it while it shows. Classic Era has no daily quests, so it never shows there.

## Quest Giver Window

Everything here follows `ns.IsQuestGiverCleanupOn()`: the Quality of Life switch and `giverCleanup` both on, whatever the Quest Log switch says. Turning it on or off, or changing profile, reapplies it at once (`ns.ApplyQuestGiverCleanup`, which every Quality of Life toggle's `set` calls); a quest giver window already open is laid out again the next time it opens.

- **Its own pages** (`Features/Quest-Giver.lua`), where the window doesn't use `QuestInfo`: all of them on Classic Era and TBC, the progress page on WoW Forever. Their text is found by font, not by name: text in the title's font is a heading, the one hung from the top of its page being the quest's title. Each piece's font and spacing is kept as Blizzard left it the first time it's changed, and put back when the cleanup goes off. They're styled as the saved settings load, before Blizzard first lays them out.
- **The progress page** gets the details' space around its required items heading, and the quest ID right-aligned under the last thing on it (the left button of the last row of items, else the gold, the heading or the text).
- **WoW Forever's `QuestInfo` pages** get the quest details' gold and experience placement (`ns.AlignRewardNumbers`) and quest ID: `LayOutSharedPieces` in `Forever-Quest-Details.lua` calls `ns.LayOutQuestGiverPage` (`Features/Forever-Quest-Giver.lua`). Their objective lines stay in Blizzard's font with no check or count column, cleanup or not, because `LayOutSharedPieces` puts them back for every caller but the add-on's own details.
- **WoW Forever's shared `QuestInfo` text** is the quest details' too, so with the cleanup off it's put back to Blizzard's (`ns.RestoreQuestInfoStyle`, from the font and spacing `ns.RememberBlizzardStyle` kept) whenever the switch changes and whenever the add-on's window hides, which it does as a quest giver window opens, before that window lays the text out. The experience number on a quest giver page stays Blizzard's too.
- **Level tags** (`giverLevels`, a sub-option of the cleanup) put the quest log's tag ("[36]", "[40D]") in front of each quest line in a quest giver's list whose level is known (above 0): the gossip window through hooks on `GossipSharedAvailableQuestButtonMixin.Setup` and `GossipSharedActiveQuestButtonMixin.Setup`, and the greeting page through its `OnShow` and `QuestFrameGreetingPanel_OnShow`. Blizzard can run either more than once on the same text, so each button remembers the text it tagged (`levelTaggedText`) and isn't tagged twice.

## Quest Chain

When Questie knows the selected quest is part of a chain, the quest details show a Quest Chain section between the rewards and the quest ID, on every client (`Features/Quest-Chain.lua`), one row per part. On Classic Era and TBC the details file builds it inside its part, so it exists only while the wide quest log runs. Parts already turned in (`C_QuestLog.IsQuestFlaggedCompleted`) get a check in the objectives' check column, and the selected quest's row sits on a faint band instead. Hovering a row shows Questie's own quest tooltip (`QuestieLink:CreateQuestTooltip`).

The chain comes from Questie's database through `QuestieDB.QueryQuestSingle`, every call in a `pcall` since Questie may not be loaded or ready. Walking back, a part counts as the one before only if it's the quest's sole prerequisite (`preQuestSingle` with one entry and no `preQuestGroup`) and names the quest as its `nextQuestInChain`; walking forward follows `nextQuestInChain`. So where a chain branches, only its straight run shows. Both walks together stop at `MAX_PARTS` (25), which only a loop in the data reaches. Each row's name comes from the client, else Questie's, else the quest ID; it carries the quest log's level tag only when Questie gives a level above 0, whatever `showQuestLevels` says, with the tag from Questie's corrected `GetQuestTagInfo` where it has one, else the client's. The section copies the Description heading's and text's font, color and shadow from the FontStrings themselves, because skins set them there rather than on the font objects.

## Ready to Turn In

`Features/Turn-In-Line.lua` totals the XP and gold waiting in quests ready to turn in, in a line centered between Abandon Quest and Share Quest (`ns.abandonButton`, `ns.shareButton`). Both come from Questie's `QuestXP` module, so the line is hidden while Questie isn't loaded; a quest worth no XP and no gold is left out, and the line hides when none remain. `GetQuestLogRewardXP` is called with `self` and `GetQuestRewardMoney` without, matching how Questie defines each. At the level cap it shows only the gold, as quest XP stops there. On Classic Era and TBC the list file makes it inside its part, so it exists only while the wide quest log runs. It's placed the first time it shows rather than when it's made, because there the quest log file records Blizzard's Abandon and Share buttons as `ns.abandonButton` and `ns.shareButton` only after the list file has made the line. Hovering it lists each quest under its zone (`OTHER` for quests outside any zone) in a tooltip of its own, `PrettyWideQuestLogTurnInTooltip`, made opaque after every `Show`, since showing restores the see-through style and the list opens over the quest text.

## Wowhead Link

Every quest ID the add-on shows (both quest logs' details, the progress page, WoW Forever's quest giver pages) is clickable (`Features/Wowhead-Link.lua`): hovering says so, and clicking opens `PRETTYWIDEQUESTLOG_WOWHEAD` with the quest's Wowhead address selected, ready to copy. Its edit box puts the address back whenever it's edited, so it can't be lost. `ns.WOWHEAD_QUEST_URL` (`Data/Data.lua`) picks the part of Wowhead for the client: `/classic/` for Classic Era and for WoW Forever, whose quests are Classic Era's, and `/tbc/` for TBC; a flavor with no entry gets no link. `ns.LinkQuestIDToWowhead` marks the FontString, so `ns.StyleQuestID` starts it with the chain icon tinted to the quest ID's own color.

## Quest Map

`Features/Quest-Map.lua` docks a map to the right of the window on every client, two thirds of the window art's height (`HEIGHT_SHARE`) and in the map art's proportions. It is a quest log part like the rest, so on Classic Era and TBC it exists only while the wide quest log runs. The map is Blizzard's map canvas (`MapCanvasFrameTemplate`) with a few of the world map's data providers on it, the way the Battlefield Map is built. It is the add-on's own frame, so the world map is never opened or touched. The canvas's `OnLoad` needs its `ScrollContainer` child to exist, which only XML can arrange (the `BorderFrame` beside it is what the canvas turns on to block the mouse while the map is locked), so the frame is declared in `Quest-Map.xml` and set up in the Lua file.

Load order matters, and each TOC lists the map files after the client's quest log and list files in this order: `Quest-Map.xml`, `Quest-Map.lua`, `Questie-Map.xml`, `Questie-Map.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, the client's map file, then `Quest-Map-Reveal.lua` (and on Classic, `Classic-ElvUI.lua` after it). `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons` as it builds; `Questie-Map.lua` defines `ns.questMap.RequestRefresh`, which `Classic-Quest-Map.lua` hooks by value as it loads; and `Quest-Map-Reveal.lua` hooks the exploration pin the client's map file makes. On WoW Forever all of it runs at file load, since parts run at once there and `Forever-Quest-Map.lua` isn't one; on Classic the parts run in the same order inside `ADDON_LOADED`.

Each client's own map file adds the layers and defines `ns.questMap.FollowQuest`, which the canvas calls as it shows to put the map on the selected quest. On every client that goes through `ns.questMap.FollowQuestieQuest` first (Questie's Icons below), with the client's own fallback map for a quest Questie has no icons for. Each client's map file also registers `PIN_FRAME_LEVEL_ACTIVE_QUEST`, the frame level Questie's pins draw at. `ns.questMap.SetStyle` moves the map and changes its border inset, for a skin that draws the window differently.

Show Map / Hide Map sits in the bar above the list, and the map has its own close button. Hiding it is remembered in `global.mapHidden`, one setting for every client. The map is the window's child, so it follows the Window Scale, and the Map Scale (`global.mapScale`) applies on top of that.

### WoW Forever

`Features/Forever-Quest-Map.lua` adds exploration, fog of war, quest objective areas (`QuestBlobDataProviderMixin`), quest markers (`QuestDataProviderMixin`), dungeon entrances and flight points, each only if the client has its mixin. A hook on `ns.DisplayQuestDetails` puts the map on the selected quest at once whenever the selection has changed, map showing or not, then asks for a Questie refresh, since Questie's icons can arrive after the quest log changes. When Questie has icons for the quest, the map follows them, as on Classic. Otherwise it goes to `GetQuestUiMapID` (when that has none, the zone the quest was given in, from `ns.questMap.QuestGiverMapID`, then the player's zone) and fires the canvas's `SetFocusedQuestID`, so that quest's objective area is drawn.

Blizzard draws objective areas and quest markers only while the `questPOI` setting is on, and Questie turns it off when its own objectives are chosen, so this map would show none for a quest Questie has no icons for. The map's own copies of the blob pin's `Refresh` and the quest provider's `RefreshAllData` are Blizzard's, less that check; the setting itself is left alone. Both also leave out the quest Questie's icons are drawing (`ns.questMap.questieQuestID`), so it is never drawn twice; other quests' Blizzard markers stay. That is why `ShowQuest` refreshes the quest provider only after `FollowQuestieQuest` has set `questieQuestID`. Compare these copies with Blizzard's when a client update changes those providers.

### Classic Era and TBC

These clients' world maps draw no quest objective areas or quest markers of Blizzard's, and the clients have no quest objective data to draw them from, so `Features/Classic-Quest-Map.lua` adds only Blizzard's exploration layer. The quest itself comes from Questie's icons alone, and without them the map shows the zone the quest was given in (`ns.questMap.QuestGiverMapID`), or the player's zone where Questie doesn't know it. It follows the selection through a hook on `QuestLog_UpdateQuestDetails`, which only asks for a refresh.

### Unexplored Areas (Every Client)

The map art leaves out every area the character hasn't explored, so a quest in a new zone would show bare parchment. `Features/Quest-Map-Reveal.lua` hooks `RefreshOverlays` on this canvas's exploration pin, made when each client's map file adds `MapExplorationDataProviderMixin`. After Blizzard draws the explored areas, the hook draws every other area the flavor's `ns.MAP_REVEAL_OVERLAYS` lists for the map's art ID, cut into tiles the way Blizzard cuts explored ones, one draw sublevel below them. An area counts as explored when `C_MapExplorationInfo.GetExploredMapTextures` reports one with the same size and offset, which is the table's key. The table holds only the client's own texture file IDs, so no art ships with the add-on, and it ships inside the add-on, so it needs no other map add-on installed. Art IDs differ between clients, so each of the seven flavor folders has its own `Data/{Game}/Map-Reveal-{Game}.lua`: `Vanilla`, `TBC` and `Camelot` each listed by its own TOC, `Discovery` listed by the Vanilla TOC after `Vanilla`, each of that pair opening with its `ns.IS_DISCOVERY` guard so one table is built, and `Wrath`, `Mists` and `Mainline` declaring empty tables for flavors with no TOC yet. It's always on, with no setting. The world map and the Battlefield Map are left alone, so Leatrix Maps, or any other add-on that reveals the world map, never draws on this map, and this map never draws on theirs. The Quest Map Context report shows the map's art ID, how many areas the table lists for it and how many are explored.

### Questie's Icons (Every Client)

`Features/Questie-Map.lua` adds a data provider that draws the selected quest's icons from Questie's world map, its objectives and turn-in, again as pins on this map (`PrettyWideQuestLogQuestiePinTemplate`, in `Questie-Map.xml`), in Questie's textures and colors at `ICON_SCALE` (1.75) times Questie's size, with Questie's colored objective glow when its `alwaysGlowMap` setting is on. Questie never draws on this map and isn't told it exists. The add-on reads Questie's own copy of HereBeDragons-Pins (`HereBeDragonsQuestie-Pins-2.0`, the same name in every one of Questie's TOCs), whose `worldmapPins` maps each icon frame to its `uiMapID` and world position, which Questie's copy of HereBeDragons turns into the zone's coordinates. Both come through `LibStub`'s silent flag, since they are Questie's libraries rather than bundled ones, and nothing is drawn without them. Route lines (`type == "line"`) and icons Questie's settings hide (`hidden`, or faded to nothing) are left out. The canvas draws pins at its own zoom, which would shrink them with this smaller map, so each pin takes the scaling limits Questie's world map pins use and keeps its size on screen. Questie's tooltips can't be reused, because they gather their neighbors from the world map's own pins, so hovering a pin shows the add-on's own: the quest, then every NPC or object within `CLUSTER_DISTANCE` with its objective progress. That distance (0.015) is a share of the map, tested on each axis apart, not yards like the area constants below.

`ns.questMap.FollowQuestieQuest` shows the zone picked from the dropdown while the same quest stays selected, else the player's zone if the selected quest has an icon there, else the zone with the most of its icons, else the client's fallback map. It sets `ns.questMap.questieQuestID` while Questie has icons for the quest, and returns whether it has any. `ns.questMap.QuestGiverMapID` finds the zone a quest was given in from Questie's database: the zone holding most spawns of the first NPC, then object, that starts it, otherwise the zone it is filed under (`zoneOrSort`), which covers a quest started from an item; a subzone or alternative dungeon area gives way to its parent, and a zone the map can't show is skipped. When the quest has icons in more than one zone, a dropdown (`WowStyle2DropdownTemplate`, Blizzard's menu system) sits in the map's top-left corner listing them, most icons first; the zone picked there holds until another quest is selected or that zone has no icons left. Questie's icons are followed through hooks on its pin library's `AddWorldMapIconMap`, `AddWorldMapIconWorld`, `RemoveWorldMapIcon` and `RemoveAllWorldMapIcons`, because Questie draws a little after the quest log changes and a batch at a time. Those hooks ask only for a refresh (`ns.questMap.RequestRefresh`), done at most once per `REFRESH_DELAY` (0.2 seconds) and only while the map is showing.

### Objective Areas (Every Client)

With Show Objective Areas on (`profile.showObjectiveAreas`, the default), `Features/Questie-Map-Areas.lua` shades where each of the selected quest's objectives is found, the way Questie's own objective areas (Questie PR #8073) do it, and Questie's icons for that objective give way to one marker in each area. It works from the objective Questie hangs on every icon (`icon.data.ObjectiveData`), whose `spawnList` holds every spawn in Questie's database. Questie's icons can't be used for this, because Questie leaves out icons that sit close together. Spawns are kept where Questie's `ZoneDB` puts their area on the map shown and Questie's `Phasing` says they're visible, and are measured in yards from the zone's size in Questie's copy of HereBeDragons. Objects and creatures are grouped apart, by the icon Questie gives them. Each group is clustered greedily: a spawn not yet taken takes every other within `CLUSTER_RADIUS` (180 yards) of the cluster's moving center, over two passes. Each cluster's shape is the convex hull of its spawns, grown through a ring of `PADDING_POINTS` (24) around each corner, which rounds it off. It grows by `EDGE_PADDING` (35 yards), or by more where the spawns sit close together, so it reaches at least far enough from its middle to clear its marker by `SPOT_GAP` (3) on screen: a lone spawn comes out as a circle and a line of spawns as a rounded bar. That least reach is worked out in yards from the zone's size and the map's width on screen zoomed all the way out (the scroll container's `GetScaleForMinZoom`, where the client has it, else `FALLBACK_MIN_RADIUS`, 80 yards), so the gap is the same on every zone's map, and a resize of the map redraws them. Without a zone size from HereBeDragons nothing is shaded and every icon draws plain. Any two clusters whose shapes overlap or come within `TOUCH_GAP` (15 yards), by a separating-axis test on the two convex shapes, merge into one with a new hull, until none touch, so each blob has one marker, at the hull's centroid. Every icon of the quest left on the map, the turn-in among them, gets a circle of its own that clears it by `SPOT_GAP` (`ns.questMap.SpotOutline`), in its objective's color, or the turn-in's gold. These circles never merge with the areas, and with the setting off they aren't drawn either. Areas are cached per objective until the map, its size on screen, or Questie's spawn list changes.

`Features/Questie-Map-Area-Layer.lua` draws them on one pin as large as the map (`PrettyWideQuestLogAreaPinTemplate`, in `Questie-Map.xml`), at `PIN_FRAME_LEVEL_QUEST_BLOB`, which `Classic-Quest-Map.lua` registers under Questie's icons and `Forever-Quest-Map.lua` already has. The pin zooms with the map. Each area's fill is a fan of triangles from its centroid, each a white texture whose four corners are moved onto the triangle's three with `SetVertexOffset`, at `FILL_ALPHA` (0.3) in the objective's color. The outline is a `Line` per edge at `OUTLINE_ALPHA` (0.75), its thickness reset on every zoom so it stays `OUTLINE_WIDTH` on screen. Neither takes the mouse. A marker's tooltip lists every NPC or object in its area. An objective with no spawns on the map, such as one whose icon marks a dungeon entrance or a patrol, keeps Questie's icons. The Quest Map Context report shows the setting and how many areas and icon circles are shaded (`questMap.areaCount`).

## ElvUI, VoiceOver and Spoken Quests

### Classic Era and TBC

ElvUI and VoiceOver work on Blizzard's own quest log frames, so the Classic files make room for them rather than replacing what they draw.

- **ElvUI** skins the window but can't know about this add-on's art. With ElvUI loaded, `Features/Classic-Quest-Log.lua` hides Blizzard's art and the "no active quests" parchment and draws none of its own, leaving the skin's backdrop. That check is only whether ElvUI is loaded, so with ElvUI's quest skin turned off the window has no art at all. On every show, the resize grip moves to the skin's backdrop corner (`QuestLogFrame.backdrop`) when there is one.
- ElvUI skins the window at login, after this add-on loads, so `Features/Classic-ElvUI.lua` checks on each `OnShow` until the skin has left a backdrop and ElvUI's Skins module is there, then acts once. The skin's backdrop is ElvUI's see-through Transparent template, which lets Questie's tracker behind the window show through the quest text, so it is made opaque in the same color; `customBackdropAlpha` is ElvUI's own field for that and survives its color updates. Expand All, Track All and Show Map get ElvUI's `HandleButton`, the map's close button `HandleCloseButton`, the zone dropdown `HandleDropDownBox`, and the map an opaque ElvUI backdrop, moved beside the skin's backdrop rather than the art. The WoW Forever TOC doesn't list this file.
- **VoiceOver** puts a play button over the start of each quest title. With it loaded, `Features/Classic-VoiceOver.lua` starts each title with as many spaces as clear 24px (spaces only, since a tab draws as a missing glyph in some fonts, ElvUI's among them).
- VoiceOver hands out its buttons by Blizzard's order, row *i* to entry *i* + scroll offset. On every list update, `ns.MatchVoiceOverButtons` deals them out again by what each row now shows, through VoiceOver's own button functions. Those functions rewrite the title and move the check, so the row styling runs after them (only the list buttons and the turn-in line follow it), and the list's update (`ns.UpdateClassicQuestList`) also runs after VoiceOver's overlay `Update`, which can come after the `QuestLog_Update` hook.

**Spoken Quests** is a fork of VoiceOver that keeps the `VoiceOver` global and its quest log functions, so everything above applies to it too. `ns.GetVoiceOver` (`Features/Utilities.lua`) finds either one (`AI_VoiceOver` or `Spoken_Quests`), and only while its quest log part is switched on in Spoken; both are in the TOCs' `OptionalDeps` so the global exists when the Classic file hooks it. That hook goes on whether or not the part is on yet, because Spoken reads the switch from its saved settings after this file loads.

### Spoken Quests (WoW Forever)

Spoken Quests puts its play buttons on the world map's quest list rows and its details panel, which this add-on's window stands in for, so with the window on they never appeared. `Features/Forever-VoiceOver.lua` puts one on each quest row of the add-on's own list, where the title would start, and moves the title over (`TITLE_INSET`, 22px) to clear it. It makes the buttons with Spoken's own `MakePlayButton`, `BindPlayButton` and `SetPlayButtonState`, but keeps its own set, one per quest, reusing a button once its quest leaves the log, because the map's list takes Spoken's set back to its own rows whenever it redraws. List rows are recycled, so each row lets go of its button before it's set up again, unless another row already took it for the same quest.

## Resizing and Scale

The grip in the bottom-right corner (`ns.CreateResizeGrip`, `Features/Window.lua`) drags the window taller. `ns.ClampHeight` snaps the height to whole list rows, never below the default height and never closer than `MINIMUM_BOTTOM_CLAMP` (20px) to the bottom of the screen, measured down from the window's top, so a WoW Forever window dragged lower has less room to grow; the screen's measures are divided by the window's scale, since heights are in the window's own units. The height is saved when the drag ends, or when the mouse is let go anywhere else. It is applied every time the window opens, not at load, because the screen size and UI scale aren't settled at load and the clamp would cut it short. The clamped value is never written back, so a smaller screen shrinks the window, not the setting. Only the plain lower half of each upper art piece stretches; the top half carries the border and keeps its proportions.

Window Scale (`global.scale`, 70% to 130%) is applied as the window opens and, through `ns.ApplyWindowScale`, the moment the slider moves, which clamps the height to the screen again. The Quest Log panel's Reset Size and Position (`ns.ResetWindow`, confirmed) clears the height and, on WoW Forever, the position, and puts Window Scale and Map Scale back to their defaults. It leaves `mapHidden` alone.

On Classic the window belongs to Blizzard's panel manager, which keeps a 152px clamp below it to clear the action bars. `ApplyHeight` trades that clamp away a pixel for every pixel of extra height, down to `MINIMUM_BOTTOM_CLAMP`, because at a normal UI scale there's no other room to grow. Whenever the height changes it tells the panel manager the new height and clamp, or the manager scales the whole window down to fit the space it thinks the window needs.

On WoW Forever the window is the add-on's own, so it also moves: dragging its title bar (the top `PANE_TOP` pixels) saves its position.

## Moving from Wide Quest Log Plus

This add-on is the continuation of Wide Quest Log Plus (folder `WideQuestLogPlus`), rehosted under a new name, folder and SavedVariables table. Both hook and reshape the same Blizzard quest log, so they must never run together: `ns:WarnIfPredecessorLoaded()` (`Features/Core.lua`) prints `CHAT_PREDECESSOR_LOADED` on every login while `ns.PREDECESSOR_ADDON_NAME` (`Data/Data.lua`) is loaded. It doesn't disable either add-on itself. Outside comments, the old name appears only in that constant, that string's locale entries, and the Quest Log Context report's line saying whether it's loaded. Don't carry it anywhere else, the old `/wqlp` and `/widequestlogplus` commands included.

## Saved Variables

`PrettyWideQuestLogDB`, managed by AceDB-3.0, is the only SavedVariables table and holds every setting. The add-on uses the **Simple** model (`AceDB:New` with `true`): it stores nothing that differs from character to character, so every character shares one Default profile, and Reset Profile restores every option on the profile.

The profile holds the settings: the welcome toggle, both feature switches, and the Quest Log and Quality of Life panels' options. `global` holds only how the window and map sit on screen: Window Scale and Map Scale (set on the Quest Log panel but stored here), the window's saved height, whether the map is hidden (`mapHidden`), and on WoW Forever the window's position (`point`). Height, position and `mapHidden` have no defaults. They are presentation, kept out of the profile's reach so a profile reset or switch never moves, resizes or rescales the window; Reset Size and Position returns height, position and both scales to defaults instead. Classic saves no position, since Blizzard's panel manager places that window.

AceDB applies `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`) whenever a key is missing, and handles an explicit `false` correctly. No default lists are seeded.

There is no migration chain. `PrettyWideQuestLogDB` started fresh with the move from Wide Quest Log Plus, so nothing older than AceDB can be in it. Wide Quest Log Plus's settings live in its own SavedVariables file, which this add-on can't read, so they aren't carried over.

## Adding a New Setting

1. Add the key and its default to `ns.DATABASE_DEFAULTS.profile` in `Data/Default-Settings.lua`. Only window and map state that a profile reset must not touch goes in `global`.
2. Add its control to the panel of the feature it belongs to, with its label and `desc` in `Locales/enUS.lua`: `Options/Options-Quest-Log.lua` for the quest log (its `QuestLogToggle` and `SortSelect` builders take the panel's `Hidden` and `Inactive` gates, so the control hides with the switch off and grays out while a reload is pending; a control built without `Inactive` can call a part's function that doesn't exist), or `Options/Options-Quality-of-Life.lua`, whose controls hide with that switch off.
3. Read it live where it applies. A Quest Log setting that changes the list calls `ns.RefreshQuestLog()` from its `set`; every Quality of Life toggle's `set` already calls `ns.ApplyQuestGiverCleanup()`. `ns:ApplyProfile` calls both on profile changes. A Quality of Life setting read outside its panel also checks `enableQualityOfLife`, as `ns.IsQuestGiverCleanupOn` and `ns.GetShareInterval` do, so the switch turns the whole feature off.
4. Add it to the context report it explains: in `Diagnostics/Manifests.lua`, Quest Log Context for the list, whether the window is open, the feature switches, the welcome toggle and the quest giver window; Tracking Context for tracking; Sharing Context for the zone menu's sharing, the whispers and the dungeon quests; Quest Map Context for the map; in `Diagnostics/Settings-Reports.lua`, Display Context for the window's saved size, scales and position.

## Adding a New Event

Add `{ "EVENT_NAME", "OnEventName" }` to `EVENTS` in `Features/Core.lua` and define `ns:OnEventName` in the feature file that needs it, at file scope or in a quest log part, so it exists before `ADDON_LOADED` ends. Core registers it on the clients whose files define the handler, and Diagnostics picks it up from `ns.EVENT_NAMES`. On Classic, a handler defined inside an `ns.AddWideQuestLogPart` function is registered only when the wide quest log runs. A handler in a shared file is defined, and its event registered, on every client, so an event one client lacks belongs only in that client's files. A second feature handling an existing event keeps the same handler name on a table of its own (`ns.dungeonQuests`, `ns.shareReminders`) and gets a second `EVENTS` row naming that table's key as its third field.

## Adding a New API Call

1. Confirm the client has it: its branch of [wow-ui-source](https://github.com/Gethe/wow-ui-source), or an existing Diagnostics row. Don't gate on a client difference nobody has shown.
2. Add its path to `SHARED_FUNCTIONS`, `CLASSIC_FUNCTIONS` or `FOREVER_FUNCTIONS` in `Diagnostics/Manifests.lua`. A Blizzard frame, mixin or table a file reaches for at load goes in the matching `_TABLES` list; numbers and strings have their own `Rows` lines.
3. Add the global to `read_globals` in `.luacheckrc`, or to `globals` if the add-on writes it (`QUESTS_DISPLAYED`, the `StaticPopupDialogs` fields). A function only hooked by name (`hooksecurefunc("QuestLog_Update", ...)`) is never read as a global and needs no entry.

## Adding a New Share Result

1. Add the client's result string to `FIXABLE_RESULTS` in `Features/Share-Reminders.lua`. It gets the same two whispers as the others, so it needs no new locale key.
2. Add the result string to `SHARED_LABELS` and `SHARE_RESULTS` in `Diagnostics/Manifests.lua`.
3. A change to a whisper's body goes in `Locales/enUS.lua`, with one `%s` for the quest reference, for the Localization Review to carry to the other locales; a new whisper key goes in `SHARE_WHISPER_KEYS` in `Diagnostics/Localization-Reports.lua` too.
4. Check the Message Length report in ruRU, the widest-encoding locale. The 255-byte limit is on the whole whisper; `ns.FittingQuestReference` only ever shortens the quest's title, so the body itself must leave room for one.

## Localization

- **`enUS.lua` is the source of truth** and the only locale passing the default-fallback flag. The other locale files belong to the Localization Review (`07 - Localization Review.md`); never hand-edit them.
- **Placeholders** (`%s`, `%d`) must match `enUS` in count, type and order in every locale, or the string errors at runtime. The share whispers take one `%s`, the quest reference; `DUNGEON_QUESTS_ANNOUNCE` takes `%d` then `%s`, the count then the list, and `DUNGEON_QUESTS_ANNOUNCE_ONE` and `DUNGEON_QUESTS_ANNOUNCE_MORE` take the list alone.
- **Game names never go in `Locales/`.** The add-on stores no spell, item, skill or class ID. The quest tag IDs that pick the D, R, P and G letters are `QUEST_TAG_SUFFIX` in `Features/Quest-Display.lua`, and E comes from the elite flag (`ELITE_SUFFIX`). The quest lists read the tag straight from the client; the quest giver window, the quest chain and Classic's gray-quest list go through `ns.GetQuestTagByID` (`C_QuestLog.GetQuestTagInfo` where the client has it, else `GetQuestTagInfo`). Those letters are the add-on's own words, so they are locale keys. The other IDs it keeps name nothing a player reads: the map art IDs keying `ns.MAP_REVEAL_OVERLAYS` (`C_Map.GetMapArtID`), and texture file IDs for the reveal tiles and Blizzard's quest log art. Zone names in the list come from the quest log headers the client supplies, and the map's zone dropdown names each zone with `C_Map.GetMapInfo(uiMapID).name`. The current zone's mark compares the header text with `GetRealZoneText()`, a name match, because neither quest log gives its headers a map ID. A class or profession header never matches, and a dungeon's header matches only while the player is inside it, which the dungeon quests rely on. The dungeon quests match headers against `GetRealZoneText()`, the instance name and `C_Map.GetAreaInfo` of the dungeon's Questie zone IDs. The map's pin tooltips, the quest chain and the turn-in tooltip show the quest, NPC and object names from the client or Questie's own data. The tag at the right of a row (Elite, Dungeon) comes from the client's quest tag, or from Blizzard's `FAILED`, `COMPLETE`, `ELITE` and `DAILY`. The Quest Log panel's name (`QUEST_LOG`) and window labels such as Abandon Quest, Track, Share, Exit and Show Map (`SHOW_MAP`) are Blizzard's GlobalStrings too, and the share whispers match the client's own `ERR_QUEST_PUSH_*` strings. Every one the add-on shows or matches is a Game Names row in `Diagnostics/Manifests.lua`, from the `_LABELS` lists or added beside them, so a new one gets a row there.

## Common Pitfalls

- **Hooking or reshaping Blizzard's quest log outside `ns.AddWideQuestLogPart` on Classic**: it runs with the Quest Log switch off, and can't be taken back. Every file that hooks `QuestLogFrame` or its functions wraps its body in a part; the only exceptions are the share whispers' `QuestLogPushQuest` post-hook and `Classic-Zone-Actions.lua`'s calls when invoked.
- **Calling a part's function from outside a part on Classic**: with the switch off it is nil. Check `ns.wideQuestLogActive`, or gate the control with `Inactive`.
- **Reading `ns.db` at file scope**: it doesn't exist until `ADDON_LOADED`. Classic's quest log parts run after it exists, but WoW Forever's files and the shared files build at file load; read settings at use, as `ns.IsQuestGiverCleanupOn` and `ns.ShowTrackingMark` check `ns.db` first, or in `ns:OnDatabaseReady` on WoW Forever.
- **Defining a handler or `ns:OnDatabaseReady` a second time**: each is one slot on `ns`, so the later file silently replaces the earlier. Put a second handler on the feature's own table and name it in its `EVENTS` row's third field.
- **Adding a quest log part after load on Classic**: Core drops its queue once `ADDON_LOADED` has run the parts, so a late `ns.AddWideQuestLogPart` throws. Call it only at file scope.
- **Calling `ns.LogQuests` from code meant to only read**: on Classic it expands every zone and selects every quest in turn. Diagnostics swaps it out for that reason.
- **Calling `QuestInfo_Display` while the quest giver window is open**: blanks it mid turn-in. Go through `ns.DisplayQuestDetails`, which checks `QuestInfoInUseElsewhere`.
- **Editing `QUEST_TEMPLATE_LOG` in place**: changes Blizzard's own quest detail panes. `LOG_TEMPLATE` is a `CopyTable` of it; change the copy.
- **Restyling every `QuestFrameItems_Update`**: the quest giver window lays out its rewards through it too. The hook acts only when `questState` is `"QuestLog"`.
- **Forgetting to re-anchor Classic rows**: `PositionRows` moved them for the zone gaps, and `QuestLog_Update` doesn't put them back. Every pass re-anchors every row below the first, which anchors the rest, gap or not.
- **Leaving Classic row clicks as Blizzard last set them**: rows are recycled between headers and quests, so a header may still take right clicks and collapse instead of opening the zone menu. Every pass sets each row's `RegisterForClicks`.
- **Re-entering `QuestLog_Update`**: widening the scroll range can scroll the list, which runs `QuestLog_Update` again. `extendingScroll` guards `ExtendScrollRange`.
- **Resizing Classic's window without telling the panel manager**: it scales the whole window down. `ApplyHeight` sets the `height` and `bottomClampOverride` panel attributes whenever the height changes.
- **Applying the saved height at load**: the screen isn't settled, so the clamp cuts it short. Apply it in `OnShow`, and never save the clamped value.
- **Matching Blizzard's art by file path**: current clients return nil from `GetTextureFilePath` for XML textures. `IdentifyBlizzardArt` checks the file ID first.
- **Leaving sort ties to `table.sort`**: it isn't stable, so equal rows swap between repaints. Every comparator ends on `sortIndex`.
- **Reading VoiceOver's fields by plain indexing**: the `VoiceOver` global falls back to `_G` for anything it doesn't hold, so a missing field reads as some unrelated global instead of nil. `ns.GetVoiceOver` checks its fields with `rawget`. The one deliberate exception is `Classic-VoiceOver.lua` reading `GetQuestLogTitle` through it, where falling back to the global is the point.
- **Counting Blizzard's watches to find tracked quests on Classic**: with Questie's tracker on, Blizzard's watch count stays at 0. Untrack All asks `IsQuestWatched` of each listed quest, which Questie replaces with its own state.
- **Asking Classic about a quest that isn't selected**: `GetQuestLogPushable`, `QuestLogPushQuest` and `AbandonQuest` act on the selected quest only. The Zone-Actions file selects each in turn and puts the player's selection back.
- **Looking for quests under a collapsed Classic zone**: the quest log lists none, and expanding or collapsing shifts every index below. Find quests by quest ID after expanding, and re-collapse from the bottom up.
- **Sharing quests back to back**: a share within about 3 seconds of the last gets the party member reported as busy. The zone menu and the dungeon quests space them by `ns.GetShareInterval()`, whose slider stops at `SHARE_INTERVAL_MIN`, and share one run at a time (`ns.sharingQuests`).
- **Matching share results against English text**: fails in every other language. `Share-Reminders.lua` builds its patterns from the client's own `ERR_QUEST_PUSH_*` strings.
- **Reading system messages during WoW Forever's chat lockdown**: the message is secret and can't be read. `OnChatMsgSystem` returns while `C_ChatInfo.InChatMessagingLockdown()` holds.
- **Shortening a whisper by characters**: the chat limit is in bytes, and cutting mid-character breaks the text. `TrimToBytes` cuts on a UTF-8 boundary.
- **Hiding Blizzard's side windows in combat**: some are protected, so `HideUIPanel` on them is blocked. `CloseLeftPanels` does nothing in combat.
- **Styling Blizzard's quest text after it has been laid out**: Blizzard's measurements no longer match what's drawn. Style shared text as the saved settings load, as `ns.ApplyQuestGiverCleanup` does.
- **Tagging a quest giver's quest line every time Blizzard sets it up**: Blizzard may run the setup again on text already tagged. `levelTaggedText` skips a line already done.
- **Registering an event a client lacks**: throws. Add events through `EVENTS` in Core, never `RegisterEvent` in a feature file, and define the handler only in that client's files.
- **Loading the map files out of order**: `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons` as it builds, and `Classic-Quest-Map.lua` hooks `ns.questMap.RequestRefresh` by value. Each TOC lists the quest log and list files, then `Quest-Map.xml`, `Quest-Map.lua`, `Questie-Map.xml`, `Questie-Map.lua`, `Questie-Map-Areas.lua`, `Questie-Map-Area-Layer.lua`, the client's map file, and `Quest-Map-Reveal.lua`.
- **Placing the turn-in line when it's made**: on Classic Era and TBC the Abandon and Share buttons don't exist yet. `PlaceTurnInLine` waits for its first show.
- **Building the map canvas in Lua**: `MapCanvasFrameTemplate`'s `OnLoad` runs before Lua could add the `ScrollContainer` and `BorderFrame` it needs. The frame stays in `Quest-Map.xml`.
- **Styling for ElvUI at load**: ElvUI skins the quest log after this add-on loads, so there's no backdrop yet. `Classic-ElvUI.lua` checks on each `OnShow` until it can act.
- **Drawing Questie's quest twice on WoW Forever**: Blizzard's objective area and marker would sit under Questie's icons. The map's copies of those providers skip `ns.questMap.questieQuestID`, refreshed only after `FollowQuestieQuest` sets it.
- **Calling Questie's modules directly**: Questie may be missing, still loading, or have renamed a function. Modules come through `ns.ImportQuestieModule`, which imports in a `pcall` and returns nil on failure; callers check each function exists before calling it, and wrap calls that can throw in a `pcall`, as the quest chain does for every database query.

## Contributing

- **Issues**: [GitHub Issues](https://github.com/Gogo1951/Pretty-Wide-Quest-Log/issues).
- **Bug reports**: game client and version, locale, the character's class and level, which other quest add-ons are installed (Questie, ElvUI, VoiceOver, Spoken Quests), steps to reproduce, and the Diagnostic Tools' Settings tab output from Run All (Quest Log, Tracking, Sharing and Quest Map Context, Display Context and the rest), plus the Event Log when the quest log didn't update. For a whisper or dungeon announcement problem, add the message as the party received it and the Localization tab's Message Length report.
- **Discord**: [Pretty Wide Quest Log on Discord](https://discord.gg/eh8hKq992Q).
- **PR guidelines**: keep each PR to one change; run `stylua --syntax lua51`, `luac -p` and `luacheck .` before pushing (CI runs all three). Any change to the shape of saved data ships its own migration, tagged `MIGRATION (remove after YYYY-MM-DD)` 30 days past its release. Any change to a whisper, the dungeon announcement or their bodies is measured in bytes against the 255-byte chat limit in ruRU, with the Message Length report. Update this document if the architecture, File Map or Saved Variables change.
- **PR descriptions say what a player will notice**, in plain language, the way release notes do; commit messages carry the developer detail.
