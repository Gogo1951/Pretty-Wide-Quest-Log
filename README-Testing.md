# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window and, with Questie on, draws a route on the zone map with a Quest Arrow to follow. This time we most want you to try the new Quest Tooltips on mobs, items and Questie's map icons.

**Play on Classic Era, Season of Discovery, WoW Forever, TBC Anniversary, and MoP Classic.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. With Questie on, hover a mob, object or item one of your quests needs; its tooltip should list the quest and each objective with its count, the way the Quest Arrow does.
2. In a party with Questie, hover a mob you all need; each objective should list everyone's progress under it, you first.
3. Hover a Questie quest giver icon on the mini-map or zone map; it should name the giver, with one **Pick up** or **Turn in** line per quest.
4. Turn off **Enable Quest Tooltips** under **Features** in the options and hover the same mob; Questie's own tooltip lines should be back, no reload needed.
5. With Questie on, work an area while a quest shows under **While You're Here**; the Quest Arrow's **Next Objective** should be the waypoint after it, not that same quest.
6. With Questie on, take a quest to kill a named creature that drops the start of another quest; the route should send you to that creature only once.

## Everything Else

7. Press **L** and change **Zone Order** and **Quest Order** under **Quest List** in the options; the list should re-sort.
8. With Questie on, select a quest that has you kill or collect things; the map beside the log should shade each area, and a quest in a chain should list its steps.
9. With Questie on, press **M**; each objective should be one marker, joined by the route nearest first, turn-ins included.
10. With Questie on, follow the Quest Arrow through a zone's quests, and hover it to skip a waypoint.
11. In a party, click **Share Quests** on a zone in the quest log, then walk into a dungeon you have quests for; your party should be offered each quest they're missing.
12. Talk to a quest giver; quests should show level tags like [40D], with the quest ID under each linking to Wowhead.
13. On WoW Forever and MoP Classic, press **L**, use a Quest Arrow item button, and share a quest, all **in combat**; WoW Forever should share it once combat ends, MoP Classic right away.
14. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**, then try `/pwql` in combat; it should refuse with a chat message.
