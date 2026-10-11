# Pretty Wide Quest Log // Notes

> The maintainer's settled rulings for Pretty Wide Quest Log, kept so no review raises them again: exceptions to the Gogo1951 add-on Style Guide, and decisions it leaves open.

## Exceptions

### Quest tag IDs in code

- **Departs from:** GAME NAMES, IDs living in the flavor folders.
- **Instead:** The quest tag IDs that pick the D, R, P, G and E letters stay in a table in `Features/Quest-Display.lua`.
- **Why:** They are fixed engine enum values, identical on every client, so a seven-folder data set would hold no information the code doesn't.

### Quest log settings on the General panel

- **Departs from:** OPTIONS PANEL → Main Page Layout, the root panel's sections; FILE STRUCTURE, `Options/Options-{Feature-Name}.lua`.
- **Instead:** The quest log's settings sit in a Quest Log section of the General panel, with no feature panel of their own.
- **Why:** The add-on has a single feature, so one panel is simpler for players than a second panel holding all of its settings.

### No Data tab in Diagnostic Tools

- **Departs from:** DIAGNOSTIC TOOLS → Layout, the Data tab; TOC FILE FORMAT → File Group Order, `Diagnostics/Validate-Data.lua`.
- **Instead:** While the add-on ships no static game data, Diagnostic Tools has no Data tab and no TOC loads the Validate Data report.
- **Why:** With no data files the tab would hold no rows, and an empty tab only confuses players.

## Decisions

- Settings from Wide Quest Log Plus are not carried over: the move to Pretty Wide Quest Log started a new folder and SavedVariables table, and the game won't let one add-on read another's.
- While Wide Quest Log Plus is also loaded, a chat line asks the player to turn it off, on every login and regardless of the welcome toggle; the add-on doesn't disable either one itself.
- Declined: carrying the pre-AceDB saved window height into AceDB; a one-time return to the default height is acceptable.
- Declined: carrying the pre-AceDB WoW Forever window position and quest log key choice into AceDB, because the build that saved them never reached players.
- The Enable Pretty Wide Quest Log for This Profile toggle takes effect at the next `/reload`, which the add-on offers when the Options window closes, so with it off the quest log key, the micro menu button and objective tracker clicks open Blizzard's quest log in the world map.
- The quest text styling in the quest giver window and the world map's quest details stays on whether or not the wide quest log is enabled, because it is a feature of its own that Classic Era and TBC Anniversary get with no toggle.
- `/wide` is the add-on's only slash command; resetting the window and switching the quest log key live in the options panel, and the quest log key opens the quest log.
- Declined: a mini-map button, because the quest log key and `/wide` already open the quest log and the options.
- The gap above each zone name is a single on/off toggle, on by default.
- Sorting works on every client; on Classic Era and TBC it redraws Blizzard's own rows in sorted order rather than replacing them, so the add-ons that hook those rows keep working.
- Zone order offers average quest level, highest first (the default) or lowest first, or alphabetical by full name; quest order offers level, highest first (the default) or lowest first, or alphabetical. The add-on sorts to these itself on every client, so the labels hold on WoW Forever too.
- The options panel carries a WoW Forever-only Enable Pretty Wide Quest Log for This Profile toggle, on by default, under Enable Welcome Message; with it off, the whole Quest Log section is hidden. The Reset Size and Position button sits right-aligned, a quarter wider than a standard button for longer translations.
- `LICENSE` carries only the Gogo1951 line, dated from 2026, the year the add-on became Pretty Wide Quest Log.
- The Track All and Untrack All buttons use the add-on's own strings on every client, although WoW Forever has Blizzard labels for them, so the buttons read the same everywhere.
- The map beside the quest log draws the selected quest from Questie's icons whenever Questie has any for it, on every client; on WoW Forever, Blizzard's objective area and marker for that quest show only when Questie has none, such as for new Forever content.
