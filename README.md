# Pretty Wide Quest Log (PWQL)

Wide quest log with a quest route and quest arrow. You pick the quests, we help with a clean route to get them done fast. Quest levels, tags, rewards, quest chains, a quest map, and party quest sharing. Works with Questie, Spoken, VoiceOver, and ElvUI.

**TL;DR:** Quest with confidence and speed. A clean route through every quest you picked, an arrow to follow, the quest log Blizzard should have shipped, and your whole group on the same quests without typing a word.

## Turns Icon Soup into an Actionable Route

<img width="800" src="https://github.com/user-attachments/assets/b7daa43e-194b-4508-94e5-ae38ca5b6090" />

## With an Easy-to-Follow Guide Arrow

<img width="800" src="https://github.com/user-attachments/assets/a5d6bc3a-6f05-468e-aed7-6dc9af7387c5" />

### Quest Route

<img width="800" alt="README-Infographic-Routes-on-Zone-Map" src="https://github.com/user-attachments/assets/67e326f3-5914-4dde-8843-d3ed55af852a" />

* **Every Quest, One Route** // Pick your quests and the zone map lays them out as one route, nearest first, turn-ins included.
* **Predictive Quest Routes** // The route plans the quests you'll pick up next and the ones that follow, so you clear each part of the zone in one trip. That's 18-38% less running than a plain route, which already beats questing by hand.
* **Your Party's Quests Too** // Quests your friends carry join your route when they run Questie too, and you stick around to help them finish before everyone turns in.
* **Group Up** // When someone in your zone drifts off your mini-map, the Quest Arrow leads you all to a meeting spot so you can quest together.
* **Your Route, Your Rules** // Ignore any objective and the route plans around it, or switch off the parts you don't need.

Simulated runs through every quest in a zone, on foot, against the plain nearest-first route the add-on started with:

| Zone | Quests | Less Running | Time Saved |
|---|---|---|---|
| Darkshore | 57 | 38% | 47 min |
| Redridge Mountains | 31 | 37% | 15 min |
| Elwynn Forest | 61 | 29% | 20 min |
| Durotar | 41 | 26% | 17 min |
| Westfall | 27 | 22% | 10 min |
| Loch Modan | 33 | 18% | 9 min |

<img width="800" alt="Pasted 2026-11-12 at 1 11 10 AM" src="https://github.com/user-attachments/assets/fe0201b0-d666-4b08-887a-04999a445db0" />

### Quest Arrow

<img width="400" src="https://github.com/user-attachments/assets/345a94f6-3897-4820-8cd3-8415e1cc7d27" />

* **Always Know Where to Go** // An arrow on screen points to the next waypoint, with the distance in yards.
* **What to Do When You Get There** // The quests and objectives at that waypoint are listed right under it.
* **Quest Items One Click Away** // A quest with an item to use gets a button beside it, or set one key for Use Quest Item.
* **Pick Up Flight Paths on the Way** // Flight masters you haven't met yet join the route, so you never miss a flight path.
* **Out of the Way When It Should Be** // It hides in raids and instances, and you choose what it shows, how big it is, and where it sits.

### Wide Quest Log

<img width="800" alt="README-Infographic-Wide-Quest-Log" src="https://github.com/user-attachments/assets/02b81053-ffec-4fbf-834b-fb7e855a51a6" />

* **Everything at a Glance** // Your quests by zone, the selected quest's details, and its map, side by side.
* **Spot the Tough Ones** // Level and type tags like [40D] flag dungeon, raid, elite, group, and PvP quests before you read a word.
* **A Map Without the Icon Soup** // The map shows only the selected quest, with one shaded area and one icon per objective.
* **Quest Givers Match** // Quest giver windows get the same clean layout, level tags, and a quest ID that links to Wowhead.
* **Read It Your Way** // Pick the font, size, outline, and shadow for the quest log and NPC dialogue, SharedMedia fonts included, and sort zones and quests how you like.

### Quest Sharing

<img width="800" alt="README-Infographic-Quest-Sharing" src="https://github.com/user-attachments/assets/93f4dbe3-5672-4f37-b3a4-795e62b64d2a" />

* **Dungeon Quests, Sorted** // Walk into a dungeon and your party hears which of your quests are inside, then gets every one they're missing.
* **A Whole Zone in One Click** // Share all of a zone's quests from the quest log, skipping any your whole party already has.
* **Welcome to the Party** // Join a group, or have someone join yours, and party members in your zone are offered your quests they don't have yet.
* **Nobody Gets Left Behind** // Anyone a share misses gets a friendly whisper so they can ask again.
* **Your Call** // Each helper has its own switch, and you set the pace between shares.

> Sample Messages

> **Enter a Dungeon, Party:** I have 2 quests to do here: [The Defias Brotherhood], [Red Silk Bandanas] // PWQL

> **Someone Joins Your Party, Message To Katz:** I have 4 quests in Westfall that you don't have. Would you like me to try to share them? // PWQL

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/pretty-wide-quest-log) or [Wago](https://addons.wago.io/addons/pretty-wide-quest-log).
2. Type `/pwql` to open the Options Interface.
3. With Questie on, open your zone map (M) to see your route, then follow the Quest Arrow.
4. Press your quest log key (L), or click the quest log button on the micro menu.
5. Drag the grip in the bottom-right corner to make the window as tall as you like.
6. _"Your quest log's sorted. Now go find Mankrik's wife."_

## Tips & Tricks

### Routes & the Quest Arrow

🧠 Routes and the Quest Arrow need Questie.

* While the route is on your zone map, the add-on keeps the game's Mini World Map setting off, so the map opens full size with room for the route. Turn off Open the Zone Map Full Size in the Options Interface to keep yours small.
* Waypoint markers can show on the mini-map too. They start off, since Questie's mini-map icons already show where things spawn and drop.

Fun fact: Questie once planned a Routes feature for TBC Classic, but it never made it out of development. Much of this add-on's user experience grew out of Aero's and my work on that project.

<img width="800" alt="Questie Routes" src="https://github.com/user-attachments/assets/1453ba73-15ec-4aaa-b546-a351246cc8d0" />

### Quest Chains

Never lose your place in a long chain again. With Questie installed, the selected quest's details list every step of its chain, checking off the ones you've turned in and highlighting the one you're on. Hover any step for Questie's tooltip on it.

<img width="800" src="https://github.com/user-attachments/assets/6cf6eebe-5eaf-4b0e-98d3-b9811741f6ed" />

### The Quest Log on Each Client

Spoken and VoiceOver keep their play buttons on your quest list, so the narration doesn't skip a beat.

**Forever**

<img width="800" src="https://github.com/user-attachments/assets/2fc1879e-a781-4310-b90b-dbbae9391b64" />

**TBC & Era**

<img width="800" src="https://github.com/user-attachments/assets/052eb021-d91b-45b3-849d-5202897f6baa" />

## Testing & Localization Status

🔴 World of Warcraft // 12.1.0

🟢 Mists of Pandaria Classic // 5.5.4

🟢 Burning Crusade Anniversary // 2.5.6

🟢 World of Warcraft: Forever // 1.60.1

🟢 World of Warcraft: Season of Discovery // 1.15.9

🟢 World of Warcraft: Classic // 1.15.9

**Available Locales** // enUS, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW

## Appreciation & History

🚀 **This add-on stands on the shoulders of those that came before.**

* Iriel and Kudane's [DoubleWide](https://www.wowinterface.com/downloads/info6887-DoubleWide.html)
* Smariot's [QuestHelper](https://www.wowinterface.com/downloads/info9896-QuestHelper.html)
* bloodline\_'s [Wide Quest Log](https://www.wowinterface.com/downloads/info25249-WideQuestLog.html)
* bloodline\_'s [Wide Quest Log Levels](https://www.wowinterface.com/downloads/info25272-WideQuestLogLevels.html)
* CloneVince's [Wide Quest Log](https://www.curseforge.com/wow/addons/widequestlog)
* CloneVince's [Wide Quest Log Levels](https://www.curseforge.com/wow/addons/widequestloglevels)
* austenlo\_ol's [Wide Quest Log IDs](https://www.curseforge.com/wow/addons/widequestlogids)
* StormtrooperTK421's [Wide Quest Log Plus](https://www.curseforge.com/wow/addons/wide-quest-log-plus)

## Get Involved

❤️ **You can help make this better!** Feedback, code contributions, testing, and localization assistance are always appreciated. If you'd like to get involved, please reach out.

* [GitHub](https://github.com/Gogo1951/Pretty-Wide-Quest-Log)
* [Discord](https://discord.gg/eh8hKq992Q)

## Related Add-ons

### 🟢 Pairs With

* TheCrux\_BB's [Questie](https://www.curseforge.com/wow/addons/questie)
* RestedXP's [RestedXP Guide](https://www.curseforge.com/wow/addons/restedxp-guide)
* rustykey's [Spoken](https://www.curseforge.com/wow/addons/spoken)
* jnwhiteh's [TomTom](https://www.curseforge.com/wow/addons/tomtom)
* MrThinger's [VoiceOver (Classic)](https://www.curseforge.com/wow/addons/voiceover)

### 🔴 Alternatives

* Kerzo's [Kerzo Classic Quest Log](https://www.curseforge.com/wow/addons/kerzo-classic-quest-log)
* JugoBetrugoTV's [Quest Master - Forever](https://www.curseforge.com/wow/addons/quest-master)
* DonCoohd's [Questdon: Quest & Dungeon Helper](https://www.curseforge.com/wow/addons/questdon)
* guardycmw's [Questie Automatic Arrow](https://www.curseforge.com/wow/addons/questie-automatic-arrow)
* bitekenny's [StBu MasterQuestLog | The Burning Crusade](https://www.curseforge.com/wow/addons/stbu-masterquestlog)
