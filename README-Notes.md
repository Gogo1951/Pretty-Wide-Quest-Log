# Pretty Wide Quest Log // Notes

> Where Pretty Wide Quest Log departs from the Gogo1951 add-on Style Guide, kept so no review raises it again.

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

### Track All buttons use our own strings

- **Departs from:** GAME NAMES, a Blizzard UI label comes from the client.
- **Instead:** The Track All and Untrack All buttons use the add-on's own strings on every client, though WoW Forever has Blizzard labels for them.
- **Why:** The buttons read the same on every client.
