# Pretty Wide Quest Log // Notes

> Where Pretty Wide Quest Log departs from the Gogo1951 add-on Style Guide, kept so no review raises it again.

## Exceptions

### Validate Data checks map art IDs

- **Departs from:** Build Reference → DIAGNOSTIC TOOLS → Validate Data, one kind per ID kind a client API can answer.
- **Instead:** The map reveal tables get a kind of their own, which checks each map art ID against the art the client's own maps are drawn on and flags one no map uses as `NO MAP`; the Data Review prunes a `NO MAP` row only when the client's `UiMapXMapArt` table on wago.tools has no map for that art either.
- **Why:** No client API looks up a map art ID, and a map reports only the art of the character's current phase, so the game alone can't tell a phased zone's other art from art the client lacks.

### Validate Data prints a single setting

- **Departs from:** Build Reference → DIAGNOSTIC TOOLS → Validate Data, a kind for each table of IDs in a data file.
- **Instead:** A data file holding one setting rather than a table gets a kind of its own, which prints the setting's value, or `TABLE MISSING` where this client's folder never set it.
- **Why:** A setting has no rows or IDs for the game to look up, yet every data file still needs its Validate Data row.

### Track All buttons and Show Quest Levels use our own strings

- **Departs from:** GAME NAMES, a Blizzard UI label comes from the client.
- **Instead:** The Track All and Untrack All buttons and the Show Quest Levels option use the add-on's own strings on every client, though WoW Forever has Blizzard labels for them.
- **Why:** The labels read the same on every client.

### Quest log title leads with Quest Log

- **Departs from:** ADD-ON NAMES, window titles shaped `Full Name // Title`.
- **Instead:** The quest log window's title is the game's own Quest Log label, then the Short Name (`Quest Log // PWQL`).
- **Why:** The window stands in for Blizzard's quest log, so its title leads with the game's own name for it.

### README Tips & Tricks carries pictures and a third section

- **Departs from:** README rules, the README carrying one image, the Showcase's, and Tips & Tricks holding at most two sub-sections beyond the CVar.
- **Instead:** The Showcase is the Quest Arrow, and Tips & Tricks holds three sections with pictures: Routes & the Quest Arrow with its Questie Routes fun fact and image, Quest Chains with a screenshot of a chain, and a quest log screenshot for each client, Forever and TBC & Era.
- **Why:** The README leads with routes, a chain's checked-off steps read faster in a picture than in words, and the two clients' quest logs are different windows that each get their own picture.

### README's Related Add-ons are hand-picked

- **Departs from:** README rules, Related Add-ons, each color's entries chosen by highest downloads among add-ons updated within the last 12 months.
- **Instead:** Pairs With holds Questie, TomTom, Spoken, VoiceOver and whichever of Guidelime and RestedXP Guide has more downloads, Alternatives always holds whichever Questie arrow add-on has the most downloads however long ago it was updated, and there is no Overlaps color.
- **Why:** These are the add-ons the maintainer wants players to install beside this one or weigh it against, the Quest Arrow stands in for a Questie arrow add-on, and add-ons that only overlap with it aren't worth calling out.

### Classic quest log reshaped in place

- **Departs from:** COMPATIBILITY, never calling `SetUIPanelAttribute` and writing nothing to a Blizzard panel; FILE STRUCTURE, named frames carrying the add-on's prefix.
- **Instead:** On Classic Era and TBC the wide quest log widens Blizzard's own quest log window: it gives the panel manager the window's new size through `SetUIPanelAttribute`, raises `QUESTS_DISPLAYED` and adds list rows named like Blizzard's for a taller window, and docks the map inside it.
- **Why:** Those clients' quest log is Blizzard's unprotected window, which the game and other add-ons keep using, so reshaping it in place reaches nothing protected and keeps them working.

### Quest giver windows restyled in place

- **Departs from:** COMPATIBILITY, writing nothing to a Blizzard panel.
- **Instead:** Quest Giver Window Cleanup restyles Blizzard's quest giver and gossip windows on every client, and parents its own pieces, such as the quest ID and its Wowhead button, onto their pages.
- **Why:** Those windows are unprotected, and pieces that live on a scrolling page must be its children to scroll and clip with it.
