# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window and, with Questie on, draws a route on the zone map with a Quest Arrow to follow. This time we most want you to try the shorter route on the zone map, looking at other zones from the quest log, and the quest log on WoW Forever and MoP Classic.

**Play on Classic Era, Season of Discovery, WoW Forever, TBC Anniversary, and MoP Classic.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. With Questie on, press **M** in a zone with lots of quests; the route should end at a **…** marker that shows the rest of it while you hover, and all of it once you click.
2. Under **Maps & Objectives > Zone Map** in the options, set **Waypoints Shown** to **Next 5**, then to **Whole Route**.
3. Turn on **Predictive Questing Routes** under **Planning** on the **Quest Route** options panel, then off and on again from the Quest Arrow's menu; a heads-up popup should show each time.
4. When the Quest Arrow says **Talk to … to Fly to …**, hover it and click that flight under **Ignore**; the route should walk you there instead.
5. With Questie on, press **L** and pick another zone in the zone menu under the map; **Things to Bring** should name that zone, and hovering a quest giver on the map should list their quests.
6. On WoW Forever, share a quest with a party member who is too far away; they should get a whisper from you.
7. On WoW Forever and MoP Classic, click a flight point or dungeon entrance on the map beside the quest log, then get into a fight; no error should pop up.
8. On WoW Forever and MoP Classic, move the quest log, then drag its bottom-right grip to make it taller; its title bar should stay where you put it.
9. Ride into a zone you haven't explored with the quest log open; the map beside it should show the whole zone.
10. With ElvUI on Classic Era or TBC Anniversary, the quest log's text should use ElvUI's font, with a small gap between the map and **Zone Info** under it.

## Everything Else

11. Press **L** and change **Zone Order** and **Quest Order** under **Quest List** in the options; the list should re-sort.
12. With Questie on, select a quest that has you kill or collect things; the map beside the log should shade each area, and a quest in a chain should list its steps.
13. With Questie on, follow the Quest Arrow through a zone's quests, turn-ins included.
14. On WoW Forever and MoP Classic, press **L**, use a Quest Arrow item button, and share a quest, all **in combat**; WoW Forever should share it once combat ends, MoP Classic right away.
15. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**, then try `/pwql` in combat; it should refuse with a chat message.
