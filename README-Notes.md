# Pretty Wide Quest Log // Notes

> Where Pretty Wide Quest Log departs from the Gogo1951 add-on Style Guide, kept so no review raises it again.

## Exceptions

### Validate Data checks map art IDs

- **Departs from:** Build Reference → DIAGNOSTIC TOOLS → Validate Data, one kind per ID kind a client API can answer.
- **Instead:** The map reveal tables get a kind of their own, which checks each map art ID against the art the client's own maps are drawn on and flags one no map uses as `NO MAP`; the Data Review prunes a `NO MAP` row only when the client's `UiMapXMapArt` table on wago.tools has no map for that art either.
- **Why:** No client API looks up a map art ID, and a map reports only the art of the character's current phase, so the game alone can't tell a phased zone's other art from art the client lacks.

### Track All buttons use our own strings

- **Departs from:** GAME NAMES, a Blizzard UI label comes from the client.
- **Instead:** The Track All and Untrack All buttons use the add-on's own strings on every client, though WoW Forever has Blizzard labels for them.
- **Why:** The buttons read the same on every client.

### Quest log title leads with Quest Log

- **Departs from:** ADD-ON NAMES, window titles shaped `Full Name // Title`.
- **Instead:** The quest log window's title is the game's own Quest Log label, then the Short Name (`Quest Log // PWQL`).
- **Why:** The window stands in for Blizzard's quest log, so its title leads with the game's own name for it.

### README Showcase has a screenshot per client

- **Departs from:** README rules, the Showcase under the TL;DR showing the add-on in a single item.
- **Instead:** The Showcase holds a screenshot under a heading for each client, Forever and TBC & Era, with the quest map's feature lines above the TBC & Era one.
- **Why:** The two clients' quest logs are different windows that look different, so each gets its own picture, and the maintainer keeps the map's lines beside the one they caption.

### README shows quest chains in a screenshot

- **Departs from:** README rules, the README carrying one image, the Showcase's.
- **Instead:** Tips & Tricks has a Quest Chains section with a screenshot of a quest's chain in the details pane.
- **Why:** A chain's checked-off, highlighted steps are quicker to understand in a picture than in words.

### Classic quest log reshaped in place

- **Departs from:** COMPATIBILITY, never calling `SetUIPanelAttribute` and writing nothing to a Blizzard panel; FILE STRUCTURE, named frames carrying the add-on's prefix.
- **Instead:** On Classic Era and TBC the wide quest log widens Blizzard's own quest log window: it gives the panel manager the window's new size through `SetUIPanelAttribute`, raises `QUESTS_DISPLAYED` and adds list rows named like Blizzard's for a taller window, and docks the map inside it.
- **Why:** Those clients' quest log is Blizzard's unprotected window, which the game and other add-ons keep using, so reshaping it in place reaches nothing protected and keeps them working.
