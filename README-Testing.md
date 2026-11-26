# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window and, with Questie on, draws a route on the zone map with a Quest Arrow to follow. This time we most want you to try timed quests, quest rewards, and how the route plans each area.

**Play on Classic Era, Season of Discovery, WoW Forever, TBC Anniversary, and MoP Classic.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. Turn in a quest with a choice of rewards; the one that sells for the most should already be picked and carry a gold coin (with Pawn, its upgrade is picked instead).
2. With Questie on, take a timed quest such as Need for a Cure; the Quest Arrow should list it under **Timer Active!**, and chat should warn you at 5 minutes and at 1 minute left.
3. With Questie on, pick up an item that runs out, like Rendered Spores; its quest should go first on the route, with the item's time left under the Quest Arrow.
4. With Questie on, take a quest whose item comes from somewhere else, like Need for a Cure or The Demon Seed; the route should send you to get it first.
5. With Questie on, follow the route through a zone; it should pick up every quest for an area before sending you there to work it.
6. With Questie on, walk straight toward an objective the Quest Arrow isn't pointing at for about 10 seconds; the arrow should switch to it.
7. Leave a city with the Quest Arrow pointing at its gate; once through, it should point on into the zone, not back at the gate.

## Everything Else

8. Press **L** and change **Zone Order** and **Quest Order** under **Quest List** in the options; the list should re-sort.
9. With Questie on, select a quest that has you kill or collect things; the map beside the log should shade each area, and a quest in a chain should list its steps.
10. With Questie on, press **M**, then follow the Quest Arrow through a zone's quests, hovering it to skip a waypoint.
11. In a party, click **Share Quests** on a zone in the quest log, then walk into a dungeon you have quests for; your party should be offered each quest they're missing.
12. Talk to a quest giver; quests should show level tags like [40D], with the quest ID under each linking to Wowhead.
13. On WoW Forever and MoP Classic, press **L**, use a Quest Arrow item button, and share a quest, all **in combat**; WoW Forever should share it once combat ends, MoP Classic right away.
14. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**, then try `/pwql` in combat; it should refuse with a chat message.
