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

### Quest log window keeps Blizzard's layout

- **Departs from:** WINDOWS, the title at the left of the title bar and Reset Position putting the window back in the center.
- **Instead:** The quest log window centers its title on the title bar, and Reset Position puts it back where Blizzard's quest log opens, at the top left.
- **Why:** The window stands in for Blizzard's quest log, so it keeps that window's title placement and opening spot.

### Classic quest log reshaped in place

- **Departs from:** COMPATIBILITY, never calling `SetUIPanelAttribute` and writing nothing to a Blizzard panel; FILE STRUCTURE, named frames carrying the add-on's prefix.
- **Instead:** On Classic Era and TBC the wide quest log widens Blizzard's own quest log window: it gives the panel manager the window's new size through `SetUIPanelAttribute`, raises `QUESTS_DISPLAYED` and adds list rows named like Blizzard's for a taller window, and docks the map inside it.
- **Why:** Those clients' quest log is Blizzard's unprotected window, which the game and other add-ons keep using, so reshaping it in place reaches nothing protected and keeps them working.

### Quest giver windows restyled in place

- **Departs from:** COMPATIBILITY, writing nothing to a Blizzard panel.
- **Instead:** Quest Giver Window Cleanup restyles Blizzard's quest giver and gossip windows on every client, and parents its own pieces, such as the quest ID and its Wowhead button, onto their pages.
- **Why:** Those windows are unprotected, and pieces that live on a scrolling page must be its children to scroll and clip with it.

### Party whispers are fixed text

- **Departs from:** MESSAGES → Editable Messages, a message sent straight to one player is the player's to word.
- **Instead:** The Zone Share Offer whisper and the whisper sent when a quest share fails go out as the add-on's own localized text, with no message box, Send Messages In or Send Test to Me.
- **Why:** They are short, fixed notices about a quest share, not messages written in the player's voice.

### Per-character state on the Simple model

- **Departs from:** SAVED VARIABLES → The Two Models, an add-on storing per-character data uses Per-Character.
- **Instead:** Settings live on one shared profile, while what one character has done or chosen in play (its ignores and added pick-ups, Zone Info's picks, the flight paths and flight maps it knows, the party members it has offered quests, and its last route in each zone) lives in AceDB's per-character section, which Reset Profile doesn't clear.
- **Why:** Every character shares the same settings, but what a character has done in play belongs to that character alone.

### Quest Arrow and map marker menus name every click

- **Departs from:** MINIMAP MENU → Button Clicks, at most one other click, a Right-Click, and no other row names a click.
- **Instead:** The Quest Arrow and the world map's route markers keep every click they answer to, and their menus name each one on its row's right in gray (Drag, Right-Click, Middle-Click).
- **Why:** The maintainer keeps these clicks for players who use them mid-quest, and the menus are where they learn them.

### Prints lead with the Short Name

- **Departs from:** MESSAGES, every print leads with the Full Name.
- **Instead:** Every line printed to the player's own chat window, and every Example line drawn as one, leads with the Short Name (`PWQL // ...`).
- **Why:** The add-on prints often while questing, and a short lead keeps those lines short.

### Questie installs with the add-on

- **Departs from:** REQUIRED LIBRARIES → .pkgmeta, everything but `package-as` and the externals copied verbatim from Thanks for the Buff.
- **Instead:** The `.pkgmeta` lists Questie, QuestieDB and QuestieTrace as required dependencies, so the CurseForge app installs them alongside the add-on.
- **Why:** The add-on's quest map, chains, tooltips and route read Questie's quest data, and the maintainer wants players to get Questie and its data add-ons with it.
