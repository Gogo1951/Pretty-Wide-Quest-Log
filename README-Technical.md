# Pretty Wide Quest Log // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Pretty Wide Quest Log. For end-user documentation, see [README.md](https://github.com/Gogo1951/Pretty-Wide-Quest-Log/blob/main/README.md).

## File Map

```
Pretty-Wide-Quest-Log/
├── .github/
│   └── workflows/
│       ├── ci.yml                     Calls Common-Core: CI checks on every PR and push to main
│       └── package.yml                Calls Common-Core: release packaging on a tag
├── .gitattributes                     Shared, from Common-Core
├── .gitignore                         Shared, from Common-Core
├── .luacheckrc
├── .pkgmeta                           Ace3 externals and the zip's ignore list
├── Pretty-Wide-Quest-Log_Vanilla.toc  Classic Era, Season of Discovery included
├── Pretty-Wide-Quest-Log_TBC.toc      TBC Anniversary
├── Pretty-Wide-Quest-Log_Camelot.toc  WoW Forever
├── Data/                              No flavor folders, since the add-on ships no static game data
│   ├── Flavor.lua                     Canonical flavor identity, copied byte for byte
│   ├── Data.lua                       Locale, palette, registry names, URLs, ns.LAYOUT geometry, tracking marks, chat limits
│   └── Default-Settings.lua           AceDB defaults
├── Diagnostics/                       Diagnostic Tools from Magic Eraser, with no Data tab
│   ├── Manifests.lua                  Per-client API and Game Names rows; the Quest Log, Tracking, Sharing and Map Context probes
│   └── Localization-Reports.lua       Locale Context, Game Names, and Message Length for the share whispers
├── Features/
│   ├── Core.lua                       Version, event dispatcher, AceDB, the Quest Log switch, login notices
│   ├── Utilities.lua                  Colors, number grouping, Questie and VoiceOver lookups, quest tags, sorting
│   ├── Announcements.lua              Player prints (ns:PrintMessage) and whispers (ns:Announce)
│   ├── Quest-Display.lua              Level tags, quest text styling, objective lines, quest ID
│   ├── Tracking-Mark.lua              The tracking mark in the list, and whether Questie's tracker has taken over
│   ├── Wowhead-Link.lua               The quest ID's Wowhead link and its copy popup
│   ├── Quest-Chain.lua                The Quest Chain section of the details, from Questie's database
│   ├── Quest-Giver.lua                The quest giver window's pages and progress page, and level tags on its quest lines
│   ├── Window.lua                     Window art, height clamp, resize grip and list buttons, both quest logs
│   ├── Turn-In-Line.lua               The Ready to Turn In line and its tooltip, from Questie's quest data
│   ├── Classic-Tracking.lua           Classic Era and TBC: Track All and Untrack All
│   ├── Classic-Quest-List.lua         Classic Era and TBC: list rows, sorting, zone gaps, list buttons, zone name clicks
│   ├── Classic-VoiceOver.lua          Classic Era and TBC: VoiceOver's play buttons on the sorted rows
│   ├── Classic-Quest-Details.lua      Classic Era and TBC: detail pane layout, objectives, rewards, daily reset, quest ID
│   ├── Classic-Quest-Log.lua          Classic Era and TBC: widens Blizzard's window, art, resizing, scale, combat close
│   ├── Classic-Zone-Actions.lua       Classic Era and TBC: the zone menu's finding, sharing and abandoning
│   ├── Zone-Menu.lua                  The right-click menu on a zone name, every client
│   ├── Share-Reminders.lua            The whisper when a quest share fails for a reason the party member can fix
│   ├── Quest-Map.xml                  The map's canvas frame, which only XML can build
│   ├── Quest-Map.lua                  The map beside the window, its layout and scale, Show Map / Hide Map
│   ├── Questie-Map.xml                The pin template for Questie's icons on the map
│   ├── Questie-Map.lua                Questie's icons on the map, their tooltip, the zone dropdown, refreshing
│   ├── Classic-Quest-Map.lua          Classic Era and TBC: the map's layers and following the selection
│   ├── Classic-ElvUI.lua              Classic Era and TBC: opaque ElvUI backdrop, ElvUI-styled buttons, map and dropdown
│   ├── Forever-Tracking.lua           WoW Forever: tracking and Track All, deferring to Questie's tracker
│   ├── Forever-Quest-Log.lua          WoW Forever: window, buttons, refresh, scale, combat close, quest log takeover
│   ├── Forever-Quest-List.lua         WoW Forever: list rows, sorting, list buttons, zone name clicks
│   ├── Forever-Quest-Details.lua      WoW Forever: detail pane on QuestInfo_Display
│   ├── Forever-Quest-Giver.lua        WoW Forever: the quest giver window's gold, experience and quest ID
│   ├── Forever-VoiceOver.lua          WoW Forever: Spoken Quests' play buttons on the list rows
│   ├── Forever-Zone-Actions.lua       WoW Forever: the zone menu's finding, sharing and abandoning
│   └── Forever-Quest-Map.lua          WoW Forever: the map's layers, Blizzard's quest layers as the fallback, following the selection
├── Includes/
│   ├── Images/                        The icon, window art (PWQL_*.blp), untracked mark (PWQL_Untracked.tga), Wowhead link (PWQL_Link.tga)
│   └── Libraries/                     Vendored Ace3, never edited
├── Locales/
│   ├── enUS.lua                       Source of truth
│   └── {langCode}.lua                 The other ten supported locales
├── Options/
│   ├── Options-Utilities.lua          Shared rows: feature switches, sub-option rows, status lines, the reload check
│   ├── Options-General.lua            Root panel, with both feature switches and the reload prompt
│   ├── Options-Quest-Log.lua          Quest Log panel: the switch, order, list, scale, Reset Size and Position
│   ├── Options-Quality-of-Life.lua    Quality of Life panel: the quest giver window, quest sharing
│   ├── Options-Profiles.lua           Stock AceDBOptions
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

Classic Era and TBC still ship Blizzard's classic `QuestLogFrame`, so the `Features/Classic-*.lua` files widen it in place. They move Blizzard's own regions and rows, swap the art, and hook `QuestLog_Update` and `QuestLog_SetSelection` (the list file) and `QuestLog_UpdateQuestDetails` and `QuestFrameItems_Update` (the details file) to restyle what Blizzard just drew; `Classic-Quest-Log.lua` owns the window itself, its art, resizing and scale. WoW Forever runs the Retail engine, which replaced that frame with a list docked in the world map, so there is nothing to widen. The `Features/Forever-*.lua` files build a window of their own instead. Each client's TOC lists only its own files, so neither side checks which client it is on. The shared files (`Zone-Menu.lua`, `Quest-Map.lua`, `Questie-Map.lua` and the rest) call into whichever side loaded through the same `ns` names: `ns.ShareableZoneQuests`, `ns.questMap.FollowQuest`, `ns.questLogFrame`.

Both share `ns.LAYOUT` (`Data/Data.lua`) and `Features/Window.lua`, which is why the two look the same. The detail pane's text column is exactly two columns of reward buttons wide (147 + 1 + 147px), because reward buttons can't shrink. The window grows by `EXTRA_WIDTH`, whatever that column plus its margins needs beyond the classic parchment, and the art fills the difference with a strip cut from the last pixels of the middle piece, so both seams continue the art on either side. Numbers in the details (objective counts, gold, experience, the quest ID) end two spaces inside the column (`ns.TwoSpacesWide`), because body text wraps short of the edge and a number flush against it looks like it runs past.

### The Quest Log Switch

`enableWideQuestLog` decides, once, as the saved settings load, whether the wide quest log runs this session; `Features/Core.lua` records the answer in `ns.wideQuestLogActive`. The two clients need it differently:

- **Classic Era and TBC.** Hooks on Blizzard's quest log can't be removed, so every Classic quest log file, and the map, ElvUI and VoiceOver files that build on it, wraps its whole body in `ns.AddWideQuestLogPart(function() ... end)`. Core queues those functions at file load and runs them, in TOC order, inside `ADDON_LOADED` right after `AceDB:New`, only when the switch is on. With it off, Blizzard's quest log is never touched.
- **WoW Forever.** The quest log is the add-on's own window, which stays closed unless something opens it, so `ns.AddWideQuestLogPart` builds at once and only the takeover of the quest log key waits for the switch (see Taint).

A change to the switch applies at the next `/reload`. `ns.IsQuestLogReloadPending()` compares the profile's value with `ns.wideQuestLogActive`, so a profile switch counts and flipping it back goes quiet. While it differs, a silver status line says so under the switch on both the General and Quest Log panels, and when the game's Options window closes, `PRETTYWIDEQUESTLOG_RELOAD` offers the reload. `ns.WatchOptionsForReload` hooks the Options window's `OnHide` the first time any of the add-on's panels shows inside it, because that window may not exist when the add-on loads, and because watching the window rather than the panels still prompts after the player has moved to another category. The Quest Log panel's settings hide while the switch is off, and grey out while it's on but not yet active.

The quest giver window styling, the share whispers and the login notices don't depend on the switch, so they run either way.

### Event Loop

`Features/Core.lua` owns the only event frame. Its `EVENTS` table pairs every event the add-on can handle with a handler name. An event is registered only once a loaded file defines that handler, and the check runs after the quest log parts have built, so:

- **Classic Era and TBC** register `ADDON_LOADED`, `PLAYER_LOGIN` and `CHAT_MSG_SYSTEM` (the share whispers), plus `ZONE_CHANGED_NEW_AREA` and `PLAYER_REGEN_DISABLED` when the wide quest log runs. The quest log itself works purely through hooks.
- **WoW Forever** also registers every quest event.

What was registered is exported as `ns.EVENT_NAMES` for Diagnostics.

On WoW Forever every quest event funnels into `ns.RequestUpdate()`, which repaints at most once a frame and only while the window is open, because `QUEST_LOG_UPDATE` arrives in bursts. `PLAYER_LEVEL_UP` is there because the difficulty colors change with the player's level. `GROUP_ROSTER_UPDATE` refreshes only the bottom buttons, because Share is enabled only in a group. A hook on Questie's tracker `Update`, and the `OnHide` of each window that borrows the quest detail elements, request the same repaint. On both clients `ZONE_CHANGED_NEW_AREA` redraws the list so the current zone's mark moves, without re-sorting the zones (see Sorting).

`PLAYER_LOGIN` prints the welcome, the predecessor warning (see Moving from Wide Quest Log Plus), and, `QUESTIE_NOTICE_DELAY` (20) seconds later so it isn't lost among the other login lines, `CHAT_QUESTIE_MISSING` if Questie isn't loaded. The last two ignore the welcome toggle, because they explain something rather than greet.

### Blizzard's Side Windows (WoW Forever)

Blizzard's windows that open on the left of the screen (quest giver, gossip, vendor, trainer, character pane) would open on top of the WoW Forever window, and the quest giver's takes the `QuestInfo` pieces the details are drawn with, leaving them blank. So the two make way for each other, as Blizzard's own windows do: a `ShowUIPanel` hook hides this window when a panel in the `left` or `doublewide` area opens, and opening this window first hides whatever holds those areas (`CloseLeftPanels`), so the details have their pieces back. Bags aren't panels in those areas and are left alone.

### Combat Lockdown

The options opener refuses during combat: it prints the mandated message and returns, never queues. Nothing else defers. With Close When Combat Starts (`closeInCombat`) on, `PLAYER_REGEN_DISABLED` closes the quest log: `HideUIPanel` on Classic, whose quest log isn't a protected frame, and a plain `Hide` on WoW Forever. On WoW Forever, opening the window in combat leaves Blizzard's side windows open rather than hiding them, since some of them are protected; nothing is queued for later. The WoW Forever window is the add-on's own unprotected frame, and Classic's quest log, its scroll bar and the panel manager's positioning of it are unprotected, so both quest logs work in combat.

## Taint

Classic only hooks Blizzard's functions, but these things it does are seen by Blizzard's code as coming from an add-on:

- The window's new size goes to the panel manager through `SetUIPanelAttribute`, the interface Blizzard provides for this, rather than by replacing the `UIPanelWindows` entry.
- A taller window needs more list rows, so `QUESTS_DISPLAYED` (read by `QuestLog_Update`) is raised, the extra rows are created here, and `QuestLog_Update` runs when the row count changes.
- The zone gaps move Blizzard's list rows and widen the list's scroll range through `FauxScrollFrame_Update`.
- Blizzard's "All" toggle and the Track toggle beside it are faded out and unclickable, with Expand All running `QuestLogCollapseAllButton_OnClick`. Track All and Untrack All do what a shift-click does to each quest: `AutoQuestWatch_Insert` to track, and to untrack, `RemoveQuestWatch` after taking the quest out of `QUEST_WATCH_LIST`.
- Zone header rows take left clicks only (`RegisterForClicks`), so a right-click opens the zone menu instead of collapsing the zone. The zone menu selects, expands and collapses entries and calls `QuestLogPushQuest` and `SetAbandonQuest` / `AbandonQuest`, the same calls Blizzard's own buttons make.

None of it reaches anything protected on those clients.

On WoW Forever, Blizzard's code sees:

- `ToggleQuestLog` and `QuestMapFrame_OpenToQuestDetails` are replaced at load, but only when the wide quest log runs this session; with it off, Blizzard's are never touched, so the world map never opens through add-on code. Their callers (the key binding, the micro menu button, and a click on a quest in the objective tracker) call them last thing, so the taint goes no further than that one keypress or click. A quest that isn't in the log still goes to Blizzard's original.
- `QuestInfo_Display` is Blizzard's detail renderer, shared with the quest giver window and the map's details, so the add-on calls it only while neither of those is using it (`QuestInfoInUseElsewhere`). Each caller sets up everything it reads, so nothing carries over. A `hooksecurefunc` on it (`LayOutSharedPieces`) puts the shared objective lines back in Blizzard's font after anyone else uses them, and the reward positions back Blizzard's way for the map's details; the quest giver window gets the quest details' gold, experience and quest ID instead (`Features/Forever-Quest-Giver.lua`).
- The window's name goes in `UISpecialFrames`, so Escape closes it. Blizzard reads that list through `securecall`.
- Opening the window calls `HideUIPanel` on Blizzard's side windows, only out of combat (see Blizzard's Side Windows).
- The zone menu calls `C_QuestLog.SetSelectedQuest`, `QuestLogPushQuest` and `C_QuestLog.SetAbandonQuest` / `AbandonQuest`, then selects the quest the details show again.

## Questie Tracking

### WoW Forever

Questie's tracker keeps its own list of tracked quests and only learns about new ones through `C_QuestLog.AddQuestWatch`. The client's automatic watch on accepting a quest bypasses that, so a quest can be watched by Blizzard yet missing from Questie's tracker. Questie's tracker also shows only quests in its database, which much of WoW Forever's new content isn't yet.

So while Questie's tracker is enabled, `Features/Forever-Tracking.lua` counts a quest as tracked only if Questie's tracker shows it. Tracking calls `AddQuestWatch` even when Blizzard already has the watch, since that call is what tells Questie. Untracking goes through Questie when Blizzard has no watch to remove. A quest Questie can't show is refused, with a one-time chat explanation per quest and a tooltip on the greyed-out Track button. Untracking from Questie's own menu doesn't always touch Blizzard's watch list, which is why the window also repaints on Questie's tracker updates.

### Classic Era and TBC

Questie's tracker removes Blizzard's watch as soon as it takes a quest, to stay clear of Blizzard's watch limit, so Blizzard's watch count stays at 0 however many quests Questie tracks. Untrack All therefore never walks Blizzard's watch list: it goes over the listed quests, untracks each one `IsQuestWatched` (which Questie replaces with its own tracking state) reports as tracked, and calls `RemoveQuestWatch`, which Questie hooks to untrack in its tracker too. Once Questie's tracker has started (`ns.IsQuestieTracking`), every quest is trackable and there's no limit; before that, Blizzard's rules hold (quests with objectives, up to `MAX_WATCHABLE_QUESTS`).

### Before Questie's Tracker Starts (Every Client)

Questie starts its tracker a few seconds after login, partway through its staged startup. Until then nothing reads as tracked: on WoW Forever Questie's quest list is still empty, and on Classic Era and TBC Anniversary Questie keeps no Blizzard watches and only later replaces `IsQuestWatched` with its own. With Mark Untracked Quests on, that would flash a red eye on every quest. So `ns.ShowTrackingMark` (`Features/Tracking-Mark.lua`) draws no marks while Questie's tracker is enabled but not yet `started`, and hooks `QuestieTracker:HookBaseTracker`, which Questie calls as the tracker starts, to redraw the quest log.

## Sorting

Both quest logs sort with the same rules in `Features/Utilities.lua`:

- **Zones** by `zoneSort`: average quest level, highest first by default, or lowest first, or alphabetical by full name. A zone whose level isn't known goes after the rest. With `currentZoneFirst`, the zone the player is in goes before them all.
- **Quests** within each zone by `questSort`: level, highest first by default, or lowest first, or alphabetical. With `completedFirst`, quests ready to turn in go before the rest, each group in the `questSort` order.

Ties fall back to the quest log's own order. The add-on sorts to every option itself, so each one holds the same on all three clients. `ns.SortZones` freezes the zone order the first time it sorts after the window opens, so turning in or dropping a quest doesn't reshuffle zones under the cursor; closing the window, or changing a setting (`ns.RefreshQuestLog`), clears it. That includes `currentZoneFirst`: crossing into a new zone moves the green check after its name (`ns.ZoneHeaderText`, `CURRENT_ZONE_MARK`) at once, but the zone only moves to the top the next time the window opens.

On WoW Forever, `BuildEntries` in `Features/Forever-Quest-List.lua` feeds the sorted entries to the add-on's own list, with the same visibility rules as the map's quest list: no hidden quests or world quests, and a bounty only once it's complete. The first time the window opens in a session, `ns.ExpandAllZones` opens every zone, so collapsing one lasts only until the next login or reload.

On Classic Era and TBC the rows are Blizzard's. `QuestLog_Update` fills row *i* with quest log entry *i* + scroll offset, and every row handler (click, shift-click track and link, collapse, the party tooltip, the zone menu) finds its entry from the row's ID plus that offset. So after Blizzard draws, `Features/Classic-Quest-List.lua` redraws each row with the entry at its sorted place, the way `QuestLog_Update` would, and sets the row's ID to match. Selecting a quest highlights its row by place in the list, so the highlight is moved again after `QuestLog_SetSelection`. A collapsed zone lists no quests, so it sorts by its average from when it was last seen open, or after the rest when it hasn't been. When the sorted order is the quest log's own (zones alphabetical, each zone's quests lowest level first), nothing is redrawn.

## Expand All, Track All and Show Map

Both quest logs put three buttons in a bar above the list. `ns.CreateListButtons` (`Features/Window.lua`) makes the first two, and `Features/Quest-Map.lua` hangs Show Map after them from `ns.listButtons`. Each toggles its label (Expand All or Collapse All, Track All or Untrack All, Show Map or Hide Map) and is sized the first time it shows, once the font is sure to be loaded, for the wider of its labels in this locale, so none changes size as its label switches. Expand All and Track All share one width, the widest of their four labels.

- **Track All** shows while a listed quest could still be tracked and the watch list has room, and Untrack All once none can. It tracks in list order, top down, so a nearly full watch list fills with the quests the player sees first, and stops with Blizzard's own "too many" error when the list is full.
- **Classic Era and TBC** (`Features/Classic-Tracking.lua`) track and untrack exactly as a shift-click on each quest would (see Taint and Questie Tracking). The buttons sit in the frame of Blizzard's "All" toggle, which Blizzard hides while the log is empty. The toggle itself is faded out and unclickable rather than removed, and Expand All runs its click, so Blizzard's record of whether everything is collapsed stays right.
- **WoW Forever** (`Features/Forever-Tracking.lua`, `ns.SetAllTracked`) skips quests Questie can't show, without the chat explanation a single Track click gives.

## Zone Menu

Hovering a zone name shows a one-line hint, and right-clicking it opens a context menu (`Features/Zone-Menu.lua`, `MenuUtil.CreateContextMenu`) titled with the zone:

- **Share N Quests** counts only the zone's quests the game lets the player share, and is left out when there are none. It is greyed out while solo (the tooltip says `ERR_NOT_IN_GROUP`) and while a share run is still going (`ns.sharingQuests`). It shares one quest every `ns.GetShareInterval()` seconds, a `C_Timer.After` chain using the interval as it was when the run began, re-finding each quest and checking it's still shareable before it goes. The interval is the Quality of Life panel's slider, between `SHARE_INTERVAL_MIN` (3) and `SHARE_INTERVAL_MAX` (10), because a share sooner than 3 seconds after the last gets the party member reported as busy. With the Quality of Life switch off, the default applies.
- **Abandon Gray Quests** is always there, so players know it exists, and greys out with a tooltip when the zone has none. "Gray" is how the list draws the quest: `GetQuestDifficultyColor` returning `QuestDifficultyColors.trivial` on Classic, the server's `Enum.RelativeContentDifficulty.Trivial` rating on WoW Forever (falling back to the level when it gives none). The confirmation (`PRETTYWIDEQUESTLOG_ABANDON_GRAY`) lists every quest with its level tag and carries their quest IDs as data, so it abandons exactly what it showed, wherever those quests have moved since.

Each client's Zone-Actions file does the work by quest ID. On Classic it's awkward, and the file exists to contain that:

- Share and abandon act on the **selected** quest, and only the selected quest can be asked whether it's shareable (`GetQuestLogPushable`), so each quest is selected in turn and the player's selection is put back afterwards.
- The quest log lists **no quests under a collapsed zone**, so the zone is expanded to look and collapsed again. Sharing leaves it open, as the later shares need to find their quests. Abandoning expands everything (`ExpandQuestHeader(0)`), then re-collapses the zones that were closed from the bottom up, so the indexes above each one still hold.

On WoW Forever the quest log lists a collapsed zone's quests too, so the zones are left as they are, and `C_QuestLog.IsPushableQuest` and `CanAbandonQuest` answer by quest ID.

## Share Reminders

When a share fails for a reason the party member can fix, `Features/Share-Reminders.lua` whispers them which quest it was. Failures they can't fix (not eligible, already on it, already done) get none.

- **Which results.** `FIXABLE_RESULTS` pairs the client's own result strings (`ERR_QUEST_PUSH_BUSY_S`, `ERR_QUEST_PUSH_TOO_FAR_S`, `ERR_QUEST_PUSH_LOG_FULL_S`) with a whisper key. Each string is turned into a pattern at load, its `%s` (or `%1$s`) catching the player's name, so `CHAT_MSG_SYSTEM` is matched in whatever language the client runs. A client without one of the strings skips it.
- **Which quest.** The result names the player but not the quest, so a `hooksecurefunc` on `QuestLogPushQuest`, which every way of sharing calls, notes the selected quest as each share goes out. A result counts only within `ns.GetShareInterval()` of that share, the gap the zone menu leaves between shares, and each player is whispered once per share.
- **When.** Only with the Quality of Life switch and `shareWhispers` both on. During chat lockdown on WoW Forever the system message is secret and can't be read (`C_ChatInfo.InChatMessagingLockdown`), so nothing is sent.

The whisper goes through `ns:Announce`, so it has the house sent-message shape, led by the short name (`L["ADDON_SHORT"]`) rather than the title. WoW Forever blocks raid-marker tokens in chat, so `ns:BuildAnnounceMessage` leaves the marker off there:

```
{rt3} PWQL // I tried to share [Quest Name] with you, but you looked busy. ...
```

The quest reference is the best one that keeps the whole whisper within `CHAT_MESSAGE_MAX_LENGTH` (255 bytes): Questie's native quest link (clickable for anyone), then Questie's bracketed text (a link for players who run Questie), then the title in brackets, cut on a UTF-8 character boundary with `...` when even that won't fit (`ns.ShareWhisperQuestReference`). The Localization tab's Message Length report builds each whisper for the longest quest title in the log and shows its byte count.

## Quest Text

Quest text is set the same way in both quest logs and in the quest giver window on every client (`Features/Quest-Display.lua`): lines `LAYOUT.LINE_HEIGHT` times the font size apart, and the Description and Rewards headings `SECTION_HEADING_SHRINK` smaller than the quest's title (no smaller under ElvUI, whose title font is already small). In the quest logs, objective lines also take the description's font rather than Blizzard's smaller one. The pixel spacings (`QUEST_LINE`, `HEADING_SPACE_ABOVE`, `QUEST_ID_GAP`) are worked out from the description's font at load by `ns.SetTextSpacing`, because that font differs between clients and languages.

- **Styled at load.** WoW Forever's shared `QuestInfo` text is styled at file load, before Blizzard first lays any of it out, so Blizzard measures the text as it will be drawn. The details restyle it before every repaint, in case something else restyled it since. The section heading font follows every change to `QuestTitleFont`, which skins set after this file loads.
- **Experience** is set in the description's font and colour with its thousands grouped by `ns.FormatNumber`, because `BreakUpLargeNumbers` can leave them ungrouped.
- **Skins recolor late.** ElvUI recolors objective lines in hooks that can run after the styling, so each count column matches its line's color again a frame later.
- **TBC's daily quests** get a line under the title saying when dailies reset (`GetQuestResetTime`), with the objectives hung below it while it shows. Classic Era has no daily quests, so it never shows there.

## Quest Giver Window

Everything here follows `ns.IsQuestGiverCleanupOn()`: the Quality of Life switch and `giverCleanup` both on. Turning it on or off, or changing profile, reapplies it at once (`ns.ApplyQuestGiverCleanup`); a quest giver window already open is laid out again the next time it opens.

- **Its own pages** (`Features/Quest-Giver.lua`), where the window doesn't use `QuestInfo`: all of them on Classic Era and TBC, the progress page on WoW Forever. Their text is found by font, not by name: text in the title's font is a heading, the one hung from the top of its page being the quest's title. Each piece's font and spacing is kept as Blizzard left it the first time it's changed, and put back when the cleanup goes off. They're styled as the saved settings load, before Blizzard first lays them out.
- **The progress page** gets the details' space around its required items heading, and the quest ID right-aligned under the last thing on it (the left button of the last row of items, else the gold, the heading or the text).
- **WoW Forever's `QuestInfo` pages** get the quest details' gold, experience and quest ID instead, from the `QuestInfo_Display` hook (`Features/Forever-Quest-Giver.lua`).
- **Level tags** (`giverLevels`, a sub-option of the cleanup) put the quest log's tag ("[36]", "[40D]") in front of each quest line in a quest giver's list: the gossip window through hooks on `GossipSharedAvailableQuestButtonMixin.Setup` and `GossipSharedActiveQuestButtonMixin.Setup`, and the greeting page through its `OnShow` and `QuestFrameGreetingPanel_OnShow`. Blizzard can run either more than once on the same text, so each button remembers the text it tagged (`levelTaggedText`) and isn't tagged twice.

## Quest Chain

When Questie knows the selected quest is part of a chain, the quest details show a Quest Chain section between the rewards and the quest ID, on every client (`Features/Quest-Chain.lua`), one row per part with the quest log's level tag. Parts already turned in (`C_QuestLog.IsQuestFlaggedCompleted`) get a check in the objectives' check column, and the selected quest's row sits on a faint band instead. Hovering a row shows Questie's own quest tooltip (`QuestieLink:CreateQuestTooltip`).

The chain comes from Questie's database through `QuestieDB.QueryQuestSingle`, every call in a `pcall` since Questie may not be loaded or ready. Walking back, a part counts as the one before only if it's the quest's sole prerequisite (`preQuestSingle` with one entry and no `preQuestGroup`) and names the quest as its `nextQuestInChain`; walking forward follows `nextQuestInChain`. So where a chain branches, only its straight run shows. A walk stops at `MAX_PARTS` (25), which only a loop in the data reaches. Tags come from Questie's corrected `GetQuestTagInfo` where it has one, else the client's. The section copies the Description heading's and text's font, colour and shadow from the FontStrings themselves, because skins set them there rather than on the font objects.

## Ready to Turn In

`Features/Turn-In-Line.lua` totals the XP and gold waiting in quests ready to turn in, in a line centred between Abandon Quest and Share Quest (`ns.abandonButton`, `ns.shareButton`). Both come from Questie's `QuestXP` module, so the line is hidden while Questie isn't loaded. At the level cap it shows only the gold, as quest XP stops there. It's placed the first time it shows rather than when it's made, because each client's quest log file makes those buttons after its list file makes the line. Hovering it lists each quest under its zone (`OTHER` for quests outside any zone) in a tooltip of its own, `PrettyWideQuestLogTurnInTooltip`, made opaque after every `Show`, since showing restores the see-through style and the list opens over the quest text.

## Wowhead Link

Every quest ID the add-on shows (both quest logs' details, the progress page, WoW Forever's quest giver pages) is clickable (`Features/Wowhead-Link.lua`): hovering says so, and clicking opens `PRETTYWIDEQUESTLOG_WOWHEAD` with the quest's Wowhead address selected, ready to copy. Its edit box puts the address back whenever it's edited, so it can't be lost. `ns.WOWHEAD_QUEST_URL` (`Data/Data.lua`) picks the part of Wowhead for the client: `/classic/` for Classic Era and for WoW Forever, whose quests are Classic Era's, and `/tbc/` for TBC. `ns.LinkQuestIDToWowhead` marks the FontString, so `ns.StyleQuestID` starts it with the chain icon tinted to the quest ID's own colour.

## Quest Map

`Features/Quest-Map.lua` docks a map to the right of the window on every client, two thirds of the window art's height (`HEIGHT_SHARE`) and in the map art's proportions. The map is Blizzard's map canvas (`MapCanvasFrameTemplate`) with a few of the world map's data providers on it, the way the Battlefield Map is built. It is the add-on's own frame, so the world map is never opened or touched. The canvas's `OnLoad` needs its `ScrollContainer` and `BorderFrame` children to exist, which only XML can arrange, so the frame is declared in `Quest-Map.xml` and set up in the Lua file. It reads `ns.questLogFrame` and `ns.listButtons` as it builds, so each TOC lists the client's quest log and list files before it.

Each client's own map file adds the layers and defines `ns.questMap.FollowQuest`, which the canvas calls as it shows to put the map on the selected quest. On every client that goes through `ns.questMap.FollowQuestieQuest` first (Questie's Icons below), with the client's own fallback map for a quest Questie has no icons for. `ns.questMap.SetStyle` moves the map and changes its border inset, for a skin that draws the window differently.

Show Map / Hide Map sits in the bar above the list, and the map has its own close button. Hiding it is remembered in `global.mapHidden`, one setting for every client. The map is the window's child, so it follows the Window Scale, and the Map Scale (`global.mapScale`) applies on top of that.

### WoW Forever

`Features/Forever-Quest-Map.lua` adds exploration, fog of war, quest objective areas (`QuestBlobDataProviderMixin`), quest markers (`QuestDataProviderMixin`), dungeon entrances, flight points and group members. A hook on `ns.DisplayQuestDetails` puts the map on the selected quest. When Questie has icons for it, the map follows them, as on Classic. Otherwise it goes to `GetQuestUiMapID` (the player's zone when that has none) and fires the canvas's `SetFocusedQuestID`, so that quest's objective area is drawn. The same hook asks for a Questie refresh, since Questie's icons can arrive after the quest log changes.

Blizzard draws objective areas and quest markers only while the `questPOI` setting is on, and Questie turns it off when its own objectives are chosen, so this map would show none for a quest Questie has no icons for. The map's own copies of the blob pin's `Refresh` and the quest provider's `RefreshAllData` are Blizzard's, less that check; the setting itself is left alone. Both also leave out the quest Questie's icons are drawing (`ns.questMap.questieQuestID`), so it is never drawn twice; other quests' Blizzard markers stay. Compare them with Blizzard's when a client update changes those providers.

### Classic Era and TBC

These clients' world maps draw no quest objective areas or quest markers of Blizzard's, and the clients have no quest objective data to draw them from, so `Features/Classic-Quest-Map.lua` adds only exploration and group members of Blizzard's layers. The quest itself comes from Questie's icons alone, and without them the map shows the player's zone. It follows the selection through a hook on `QuestLog_UpdateQuestDetails`.

### Questie's Icons (Every Client)

`Features/Questie-Map.lua` adds a data provider that draws the selected quest's icons from Questie's world map, its objectives and turn-in, again as pins on this map (`PrettyWideQuestLogQuestiePinTemplate`, in `Questie-Map.xml`), in Questie's textures and colours at `ICON_SCALE` times Questie's size, with Questie's coloured objective glow when its `alwaysGlowMap` setting is on. Questie never draws on this map and isn't told it exists. The add-on reads Questie's own copy of HereBeDragons-Pins (`HereBeDragonsQuestie-Pins-2.0`, the same name in every one of Questie's TOCs), whose `worldmapPins` maps each icon frame to its `uiMapID` and world position, which Questie's copy of HereBeDragons turns into the zone's coordinates. Route lines (`type == "line"`) and icons Questie's settings hide (`hidden`, or faded to nothing) are left out. The canvas draws pins at its own zoom, which would shrink them with this smaller map, so each pin takes the scaling limits Questie's world map pins use and keeps its size on screen. Questie's tooltips can't be reused, because they gather their neighbours from the world map's own pins, so hovering a pin shows the add-on's own: the quest, then every NPC or object within `CLUSTER_DISTANCE` with its objective progress.

`ns.questMap.FollowQuestieQuest` shows the player's zone if the selected quest has an icon there, otherwise the zone with the most of its icons, otherwise the client's fallback map. It sets `ns.questMap.questieQuestID` while Questie has icons for the quest, and returns whether it has any. When the quest has icons in more than one zone, a dropdown (`WowStyle2DropdownTemplate`, Blizzard's menu system) sits in the map's top-left corner listing them, most icons first; the zone picked there holds until another quest is selected or that zone has no icons left. Questie's icons are followed through hooks on its pin library's `AddWorldMapIconMap`, `AddWorldMapIconWorld`, `RemoveWorldMapIcon` and `RemoveAllWorldMapIcons`, because Questie draws a little after the quest log changes and a batch at a time. They, and each client's selection hook, only ask for a refresh (`ns.questMap.RequestRefresh`), done at most once per `REFRESH_DELAY` and only while the map is showing.

## ElvUI, VoiceOver and Spoken Quests

### Classic Era and TBC

ElvUI and VoiceOver work on Blizzard's own quest log frames, so the Classic files make room for them rather than replacing what they draw.

- **ElvUI** skins the window but can't know about this add-on's art. With ElvUI loaded, `Features/Classic-Quest-Log.lua` hides Blizzard's art and the "no active quests" parchment and draws none of its own, leaving the skin's backdrop.
- ElvUI skins the window at login, after this add-on loads, so `Features/Classic-ElvUI.lua` waits for the window's first `OnShow` and acts only if the skin left a backdrop (`QuestLogFrame.backdrop`). The skin's backdrop is ElvUI's see-through Transparent template, which lets Questie's tracker behind the window show through the quest text, so it is made opaque in the same colour; `customBackdropAlpha` is ElvUI's own field for that and survives its colour updates. Expand All, Track All and Show Map get ElvUI's `HandleButton`, the map's close button `HandleCloseButton`, the zone dropdown `HandleDropDownBox`, and the map an opaque ElvUI backdrop, moved beside the skin's backdrop rather than the art. The resize grip follows the skin's backdrop corner too.
- **VoiceOver** puts a play button over the start of each quest title. With it loaded, `Features/Classic-VoiceOver.lua` starts each title with as many spaces as clear 24px (spaces only, since a tab draws as a missing glyph in some fonts, ElvUI's among them).
- VoiceOver hands out its buttons by Blizzard's order, row *i* to entry *i* + scroll offset. With sorting on, `ns.MatchVoiceOverButtons` deals them out again by what each row now shows, through VoiceOver's own button functions. Those functions rewrite the title and move the check, so the row styling runs last, and the list's update (`ns.UpdateClassicQuestList`) also runs after VoiceOver's overlay `Update`, which can come after the `QuestLog_Update` hook.

**Spoken Quests** is a fork of VoiceOver that keeps the `VoiceOver` global and its quest log functions, so everything above applies to it too. `ns.GetVoiceOver` (`Features/Utilities.lua`) finds either one, and only while its quest log part is switched on in Spoken; both are in the TOCs' `OptionalDeps` so the global exists when the Classic file hooks it. That hook goes on whether or not the part is on yet, because Spoken reads the switch from its saved settings after this file loads.

### Spoken Quests (WoW Forever)

Spoken Quests puts its play buttons on the world map's quest list rows and its details panel, which this add-on's window stands in for, so with the window on they never appeared. `Features/Forever-VoiceOver.lua` puts one on each quest row of the add-on's own list, where the title would start, and moves the title over to clear it. It makes the buttons with Spoken's own `MakePlayButton`, `BindPlayButton` and `SetPlayButtonState`, but keeps its own set, one per quest, reusing a button once its quest leaves the log, because the map's list takes Spoken's set back to its own rows whenever it redraws. List rows are recycled, so each row lets go of its button before it's set up again, unless another row already took it for the same quest.

## Resizing and Scale

The grip in the bottom-right corner (`ns.CreateResizeGrip`, `Features/Window.lua`) drags the window taller. `ns.ClampHeight` snaps the height to whole list rows, never below the default height and never closer than `MINIMUM_BOTTOM_CLAMP` to the bottom of the screen; the screen's measures are divided by the window's scale, since heights are in the window's own units. The height is saved when the drag ends. It is applied every time the window opens, not at load, because the screen size and UI scale aren't settled at load and the clamp would cut it short. The clamped value is never written back, so a smaller screen shrinks the window, not the setting. Only the plain lower half of each upper art piece stretches; the top half carries the border and keeps its proportions.

Window Scale (`global.scale`, 70% to 130%) is applied as the window opens and, through `ns.ApplyWindowScale`, the moment the slider moves, which clamps the height to the screen again. The Quest Log panel's Reset Size and Position (`ns.ResetWindow`, confirmed) clears the height and, on WoW Forever, the position, and puts both scales back to their defaults.

On Classic the window belongs to Blizzard's panel manager, which keeps a 152px clamp below it to clear the action bars. `ApplyHeight` trades that clamp away a pixel for every pixel of extra height, down to `MINIMUM_BOTTOM_CLAMP`, because at a normal UI scale there's no other room to grow. It tells the panel manager the new height and clamp each time, or the manager scales the whole window down to fit the space it thinks the window needs. Under ElvUI the grip follows the skin's inset backdrop rather than the frame's own corner.

On WoW Forever the window is the add-on's own, so it also moves: dragging its title bar saves its position.

## Moving from Wide Quest Log Plus

This add-on is the continuation of Wide Quest Log Plus (folder `WideQuestLogPlus`), rehosted under a new name, folder and SavedVariables table. Both replace the same Blizzard quest log functions, so they must never run together: `ns:WarnIfPredecessorLoaded()` (`Features/Core.lua`) prints `CHAT_PREDECESSOR_LOADED` on every login while `ns.PREDECESSOR_ADDON_NAME` is loaded. It doesn't disable either add-on itself. In the code, the old name appears only there and in that string's locale entries. Don't carry it anywhere else, the old `/wqlp` and `/widequestlogplus` commands included.

## Saved Variables

`PrettyWideQuestLogDB`, managed by AceDB-3.0, is the only SavedVariables table and holds every setting. The add-on uses the **Simple** model: one shared Default profile, so Reset Profile restores every option on the profile.

The profile holds every panel's settings: the welcome toggle, both feature switches, and the Quest Log and Quality of Life panels' options. `global` holds only how the window and map sit on screen: their scales, the window's saved height, whether the map is hidden (`mapHidden`), and on WoW Forever the window's position. Height, position and `mapHidden` have no defaults. They are presentation, kept out of the profile's reach so a profile reset or switch never moves, resizes or rescales the window; Reset Size and Position returns them to defaults instead. Classic saves no position, since Blizzard's panel manager places that window.

AceDB applies `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`) whenever a key is missing, and handles an explicit `false` correctly. No default lists are seeded.

### Migration Chain

None. `PrettyWideQuestLogDB` started fresh with the move from Wide Quest Log Plus, so nothing older than AceDB can be in it. Wide Quest Log Plus's settings live in its own SavedVariables file, which this add-on can't read, so they aren't carried over.

## Adding a New Setting

1. Add the key and its default to `ns.DATABASE_DEFAULTS.profile` in `Data/Default-Settings.lua`. Only window and map state that a profile reset must not touch goes in `global`.
2. Add its control to the panel of the feature it belongs to, with its label and `desc` in `Locales/enUS.lua`: `Options/Options-Quest-Log.lua` for the quest log (its `QuestLogToggle` and `SortSelect` builders take the panel's `Hidden` and `Inactive` gates, so the control hides with the switch off and greys out while a reload is pending), or `Options/Options-Quality-of-Life.lua`, whose controls hide with that switch off.
3. Read it live where it applies. A Quest Log setting that changes the list calls `ns.RefreshQuestLog()` from its `set`; a Quality of Life setting that changes the quest giver window calls `ns.ApplyQuestGiverCleanup()`. `ns:ApplyProfile` calls both on profile changes. A Quality of Life setting read outside its panel also checks `enableQualityOfLife`, as `ns.IsQuestGiverCleanupOn` and `ns.GetShareInterval` do, so the switch turns the whole feature off.
4. Add it to the context report it explains in `Diagnostics/Manifests.lua`: Quest Log Context for the list and window, Tracking Context for tracking, Sharing Context for the zone menu's sharing and the whispers, Map Context for the map.

## Adding a New Event

Add `{ "EVENT_NAME", "OnEventName" }` to `EVENTS` in `Features/Core.lua` and define `ns:OnEventName` in the feature file that needs it. Core registers it on the clients whose files define the handler, and Diagnostics picks it up from `ns.EVENT_NAMES`. On Classic, a handler defined inside an `ns.AddWideQuestLogPart` function is registered only when the wide quest log runs.

## Adding a New API Call

1. Confirm the client has it: its branch of [wow-ui-source](https://github.com/Gethe/wow-ui-source), or an existing Diagnostics row. Don't gate on a client difference nobody has shown.
2. Add its path to `SHARED_FUNCTIONS`, `CLASSIC_FUNCTIONS` or `FOREVER_FUNCTIONS` in `Diagnostics/Manifests.lua`. A Blizzard frame, mixin or table a file reaches for at load goes in the matching `_TABLES` list; numbers and strings have their own `Rows` lines.
3. Add the global to `read_globals` in `.luacheckrc`.

## Adding a New Share Whisper

1. Add the client's result string and a new whisper key to `FIXABLE_RESULTS` in `Features/Share-Reminders.lua`, and the whisper's body to `Locales/enUS.lua` with one `%s` for the quest reference.
2. Add the result string to `SHARED_LABELS` and `SHARE_RESULTS` in `Diagnostics/Manifests.lua`, and the key to `SHARE_WHISPER_KEYS` in `Diagnostics/Localization-Reports.lua`.
3. Check the Message Length report in ruRU, the widest-encoding locale. The 255-byte limit is on the whole whisper; `ns.ShareWhisperQuestReference` only ever shortens the quest's title, so the body itself must leave room for one.

## Localization

- **`enUS.lua` is the source of truth** and the only locale passing the default-fallback flag. The other locale files belong to the Localization Review (`07 - Localization Review.md`); never hand-edit them.
- **Placeholders** (`%s`, `%d`) must match `enUS` in count, type and order in every locale, or the string errors at runtime.
- **Game names never go in `Locales/`.** Zone names in the list come from the quest log headers the client supplies, and the map's zone dropdown names each zone with `C_Map.GetMapInfo(uiMapID).name`. The current zone's mark compares the header text with `GetRealZoneText()`, a name match, because neither quest log gives its headers a map ID; a dungeon or class header never matches. The map's pin tooltips, the quest chain and the turn-in tooltip show the quest, NPC and object names from the client or Questie's own data. The tag at the right of a row (Elite, Dungeon) comes from the client's quest tag, or from Blizzard's `FAILED`, `COMPLETE`, `ELITE` and `DAILY`. Window labels such as Abandon Quest, Track, Share, Exit and Show Map (`SHOW_MAP`) are Blizzard's GlobalStrings too, and the share whispers match the client's own `ERR_QUEST_PUSH_*` strings. Every one the add-on shows or matches is a row in the `_LABELS` lists in `Diagnostics/Manifests.lua`, which feed the Localization tab's Game Names report, so a new one gets a row there. The quest-type letters (D, R, P, G, E) are the add-on's own words, so they are locale keys, picked by `QUEST_TAG_SUFFIX` in `Features/Quest-Display.lua` from the tag ID that `ns.GetQuestTagByID` returns (`C_QuestLog.GetQuestTagInfo` where the client has it, else `GetQuestTagInfo`).

## Common Pitfalls

- **Hooking Blizzard's quest log outside `ns.AddWideQuestLogPart` on Classic**: the hook runs with the Quest Log switch off, and can't be taken back. Every file that touches `QuestLogFrame` or its functions wraps its body in a part.
- **Reading `ns.db` at file scope**: it doesn't exist until `ADDON_LOADED`. Quest log parts run after it exists, but the shared files load before it; read settings at use, as `ns.IsQuestGiverCleanupOn` and `ns.ShowTrackingMark` check `ns.db` first, or in `ns:OnDatabaseReady` on WoW Forever.
- **Calling `QuestInfo_Display` while the quest giver window is open**: blanks it mid turn-in. Go through `ns.DisplayQuestDetails`, which checks `QuestInfoInUseElsewhere`.
- **Editing `QUEST_TEMPLATE_LOG` in place**: changes Blizzard's own quest detail panes. `LOG_TEMPLATE` is a `CopyTable` of it; change the copy.
- **Restyling every `QuestFrameItems_Update`**: the quest giver window lays out its rewards through it too. The hook acts only when `questState` is `"QuestLog"`.
- **Forgetting to re-anchor Classic rows**: `PositionRows` moved them for the zone gaps, and `QuestLog_Update` doesn't put them back. Every pass re-anchors every row, gap or not.
- **Re-entering `QuestLog_Update`**: widening the scroll range can scroll the list, which runs `QuestLog_Update` again. `extendingScroll` guards `ExtendScrollRange`.
- **Resizing Classic's window without telling the panel manager**: it scales the whole window down. `ApplyHeight` always sets the `height` and `bottomClampOverride` panel attributes with the frame's height.
- **Applying the saved height at load**: the screen isn't settled, so the clamp cuts it short. Apply it in `OnShow`, and never save the clamped value.
- **Matching Blizzard's art by file path**: current clients return nil from `GetTextureFilePath` for XML textures. `IdentifyBlizzardArt` checks the file ID first.
- **Leaving sort ties to `table.sort`**: it isn't stable, so equal rows swap between repaints. Every comparator ends on `sortIndex`.
- **Reading VoiceOver's fields by plain indexing**: the `VoiceOver` global falls back to `_G` for anything it doesn't hold, so a missing field reads as some unrelated global instead of nil. `ns.GetVoiceOver` checks its fields with `rawget`.
- **Counting Blizzard's watches to find tracked quests on Classic**: with Questie's tracker on, Blizzard's watch count stays at 0. Untrack All asks `IsQuestWatched` of each listed quest, which Questie replaces with its own state.
- **Asking Classic about a quest that isn't selected**: `GetQuestLogPushable`, `QuestLogPushQuest` and `AbandonQuest` act on the selected quest only. The Zone-Actions file selects each in turn and puts the player's selection back.
- **Looking for quests under a collapsed Classic zone**: the quest log lists none, and expanding or collapsing shifts every index below. Find quests by quest ID after expanding, and re-collapse from the bottom up.
- **Sharing quests back to back**: a share within about 3 seconds of the last gets the party member reported as busy. The zone menu spaces them by `ns.GetShareInterval()`, never below `SHARE_INTERVAL_MIN`.
- **Matching share results against English text**: fails in every other language. `Share-Reminders.lua` builds its patterns from the client's own `ERR_QUEST_PUSH_*` strings.
- **Reading system messages during WoW Forever's chat lockdown**: the message is secret and can't be read. `OnChatMsgSystem` returns while `C_ChatInfo.InChatMessagingLockdown()` holds.
- **Shortening a whisper by characters**: the chat limit is in bytes, and cutting mid-character breaks the text. `TrimToBytes` cuts on a UTF-8 boundary.
- **Hiding Blizzard's side windows in combat**: some are protected, so `HideUIPanel` on them is blocked. `CloseLeftPanels` does nothing in combat.
- **Styling Blizzard's quest text after it has been laid out**: Blizzard's measurements no longer match what's drawn. Style shared text at file load, as `Quest-Display.lua` and `Quest-Giver.lua` do.
- **Tagging a quest giver's quest line every time Blizzard sets it up**: Blizzard may run the setup again on text already tagged. `levelTaggedText` skips a line already done.
- **Registering an event a client lacks**: throws. Add events through `EVENTS` in Core, never `RegisterEvent` in a feature file.
- **Loading the map before the quest log**: `Quest-Map.lua` reads `ns.questLogFrame` and `ns.listButtons` as it builds. Each TOC lists the client's quest log and list files before `Features/Quest-Map.xml`.
- **Placing the turn-in line when it's made**: WoW Forever's Abandon and Share buttons don't exist yet. `PlaceTurnInLine` waits for its first show.
- **Building the map canvas in Lua**: `MapCanvasFrameTemplate`'s `OnLoad` runs before Lua could add the `ScrollContainer` and `BorderFrame` it needs. The frame stays in `Quest-Map.xml`.
- **Styling for ElvUI at load**: ElvUI skins the quest log after this add-on loads, so there's no backdrop yet. `Classic-ElvUI.lua` waits for the window's first `OnShow`.
- **Drawing Questie's quest twice on WoW Forever**: Blizzard's objective area and marker would sit under Questie's icons. The map's copies of those providers skip `ns.questMap.questieQuestID`.
- **Calling Questie's modules directly**: Questie may be missing, still loading, or have renamed a function. Every call goes through `ns.ImportQuestieModule`, checks the function's type, and runs in a `pcall`.

## Contributing

- **Issues**: [GitHub Issues](https://github.com/Gogo1951/Pretty-Wide-Quest-Log/issues).
- **Bug reports**: game client and version, locale, the character's class and level, which other quest add-ons are installed (Questie, ElvUI, VoiceOver, Spoken Quests), steps to reproduce, and the Diagnostic Tools' Settings tab output from Run All (Quest Log, Tracking, Sharing and Map Context, Display Context and the rest), plus the Event Log when the quest log didn't update. For a whisper problem, add the whisper as the party member received it and the Localization tab's Message Length report.
- **Discord**: [Pretty Wide Quest Log on Discord](https://discord.gg/eh8hKq992Q).
- **PR guidelines**: keep each PR to one change; run `stylua --syntax lua51`, `luac -p` and `luacheck .` before pushing (CI runs all three). Any change to the shape of saved data ships its own migration, tagged `MIGRATION (remove after YYYY-MM-DD)` 30 days past its release. Any change to a whisper or its body is measured in bytes against the 255-byte chat limit in ruRU, with the Message Length report. Update this document if the architecture, File Map or Saved Variables change.
- **PR descriptions say what a player will notice**, in plain language, the way release notes do; commit messages carry the developer detail.
