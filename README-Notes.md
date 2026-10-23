# Pretty Wide Quest Log // Notes

> Where Pretty Wide Quest Log departs from the Gogo1951 add-on Style Guide, kept so no review raises it again.

## Exceptions

### No Data tab in Diagnostic Tools

- **Departs from:** DIAGNOSTIC TOOLS → Layout, the Data tab; TOC FILE FORMAT → File Group Order, `Diagnostics/Validate-Data.lua`.
- **Instead:** Diagnostic Tools has no Data tab and no TOC loads the Validate Data report. The only static game data is the map reveal tables (`Data/{Game}/Map-Reveal-{Game}.lua`).
- **Why:** Validate Data checks item, spell and quest IDs, and the reveal tables hold map art and texture file IDs it has no check for, so the tab would hold no rows that mean anything.

### Map reveal data carries no Last Validated date

- **Departs from:** DATA → Data File Layout, a Last Validated date no more than six months old in every folder a TOC lists.
- **Instead:** The map reveal tables (`Data/{Game}/Map-Reveal-{Game}.lua`) keep `Never.` under Last Validated, and manual testing of the quest map on each client stands in for a Validate Data report.
- **Why:** Validate Data has no check for map art or texture file IDs, so no report could ever date these files.

### Track All buttons use our own strings

- **Departs from:** GAME NAMES, a Blizzard UI label comes from the client.
- **Instead:** The Track All and Untrack All buttons use the add-on's own strings on every client, though WoW Forever has Blizzard labels for them.
- **Why:** The buttons read the same on every client.

### Messages to other players lead with the short name

- **Departs from:** MESSAGES, the name leading every message is `L["ADDON_TITLE"]`.
- **Instead:** Whispers and the dungeon quest announcement in group chat lead with `L["ADDON_SHORT"]` (PWQL) after the target marker.
- **Why:** Both are short lines read mid-play, and the full title would take up half of one before the message starts; the announcement also needs every byte it can get for quest links.

### README title carries the short name

- **Departs from:** README rules, the H1 being the Short Name alone.
- **Instead:** The README's H1 adds the abbreviation in parentheses after the name.
- **Why:** Players meet the abbreviation first, at the head of every whisper and group announcement the add-on sends, so the title has to tie it back to the add-on.

### README Showcase has a screenshot per client

- **Departs from:** README rules, the Showcase under the TL;DR showing the add-on in a single item.
- **Instead:** The Showcase holds a screenshot under a heading for each client, Forever and TBC & Era, with the quest map's feature lines above the TBC & Era one.
- **Why:** The two clients' quest logs are different windows that look different, so each gets its own picture, and the maintainer keeps the map's lines beside the one they caption.

### Classic quest log reshaped in place

- **Departs from:** COMPATIBILITY, never calling `SetUIPanelAttribute` and writing nothing to a Blizzard panel; FILE STRUCTURE, named frames carrying the add-on's prefix.
- **Instead:** On Classic Era and TBC the wide quest log widens Blizzard's own quest log window: it gives the panel manager the window's new size through `SetUIPanelAttribute`, raises `QUESTS_DISPLAYED` and adds list rows named like Blizzard's for a taller window, and docks the map inside it.
- **Why:** Those clients' quest log is Blizzard's unprotected window, which the game and other add-ons keep using, so reshaping it in place reaches nothing protected and keeps them working.
