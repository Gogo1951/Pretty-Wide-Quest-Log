# Pretty Wide Quest Log // Notes

> Where Pretty Wide Quest Log departs from the Gogo1951 add-on Style Guide, kept so no review raises it again.

## Exceptions

### Quest tag IDs in code

- **Departs from:** GAME NAMES, IDs living in the flavor folders.
- **Instead:** The quest tag IDs that pick the D, R, P, G and E letters stay in a table in `Features/Quest-Display.lua`.
- **Why:** They are fixed engine enum values, identical on every client, so a seven-folder data set would hold no information the code doesn't.

### No Data tab in Diagnostic Tools

- **Departs from:** DIAGNOSTIC TOOLS → Layout, the Data tab; TOC FILE FORMAT → File Group Order, `Diagnostics/Validate-Data.lua`.
- **Instead:** While the add-on ships no static game data, Diagnostic Tools has no Data tab and no TOC loads the Validate Data report.
- **Why:** With no data files the tab would hold no rows, and an empty tab only confuses players.

### Track All buttons use our own strings

- **Departs from:** GAME NAMES, a Blizzard UI label comes from the client.
- **Instead:** The Track All and Untrack All buttons use the add-on's own strings on every client, though WoW Forever has Blizzard labels for them.
- **Why:** The buttons read the same on every client.

### Whispers lead with the short name

- **Departs from:** MESSAGES, the name leading every message is `L["ADDON_TITLE"]`.
- **Instead:** Whispers to other players lead with `L["ADDON_SHORT"]` (PWQL) after the target marker.
- **Why:** A whisper is a short line read mid-play, and the full title would take up half of it before the message starts.

## Decisions

- Settings from Wide Quest Log Plus are not carried over: the move to Pretty Wide Quest Log started a new folder and SavedVariables table, and the game won't let one add-on read another's.
- While Wide Quest Log Plus is also loaded, a chat line asks the player to turn it off, on every login and regardless of the welcome toggle; the add-on doesn't disable either one itself.
- Declined: carrying the pre-AceDB saved window height into AceDB; a one-time return to the default height is acceptable.
- Declined: carrying the pre-AceDB WoW Forever window position and quest log key choice into AceDB, because the build that saved them never reached players.
- The Enable Quest Log Cleanup toggle takes effect at the next `/reload`, which the add-on offers when the Options window closes, so with it off the quest log key, the micro menu button and objective tracker clicks open Blizzard's own quest log (on WoW Forever, the one in the world map).
- The quest giver window's styling follows the Quality of Life switch and Enable Quest Giver Window Cleanup, not Enable Quest Log Cleanup, so it works alongside Blizzard's quest log too.
- `/pwql` is the add-on's only slash command and opens the options; resetting the window lives in the Quest Log panel, and the quest log key opens the quest log.
- Declined: a mini-map button, because the quest log key and `/pwql` already open the quest log and the options.
- The gap above each zone name is a single on/off toggle, on by default.
- Sorting works on every client; on Classic Era and TBC it redraws Blizzard's own rows in sorted order rather than replacing them, so the add-ons that hook those rows keep working.
- Zone order offers average quest level, highest first (the default) or lowest first, or alphabetical by full name; quest order offers level, highest first (the default) or lowest first, or alphabetical. The add-on sorts to these itself on every client, so the labels hold on WoW Forever too.
- Enable Quest Log Cleanup, on by default on every client, sits in the General panel's Features section and at the top of the Quest Log panel; with it off, the rest of the Quest Log panel is hidden. The Reset Size and Position button sits right-aligned, a quarter wider than a standard button for longer translations.
- `LICENSE` carries only the Gogo1951 line, dated from 2026, the year the add-on became Pretty Wide Quest Log.
- The map beside the quest log draws the selected quest from Questie's icons whenever Questie has any for it, on every client; on WoW Forever, Blizzard's objective area and marker for that quest show only when Questie has none, such as for new Forever content.
