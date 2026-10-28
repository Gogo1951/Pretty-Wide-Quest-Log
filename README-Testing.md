# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window, with your whole quest list beside the quest details and a map of the selected quest. This time we most want you to try it on Mists of Pandaria Classic, and the new look of Quest Chain.

**Play on Classic Era, Season of Discovery, WoW Forever, TBC Anniversary, and Mists of Pandaria Classic.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. On Mists of Pandaria Classic, press `L`, click the quest log button on the micro menu, and click a quest in the objective tracker; each should open the wide quest log at that quest.
2. On Mists of Pandaria Classic, drag the grip in the bottom-right corner, then click **Hide Map**; the quest giver's portrait should stay under the map, then move beside the window.
3. With Questie on, select a quest that's part of a chain; the heading should read like **Quest Chain (3 of 5)**, with each step's level in its quest log color and finished steps faded.
4. Turn off Questie's map icons in Questie's options, then select a quest; the map beside the quest log should still show its icons.
5. On WoW Forever, right-click a quest and click **Share Quest** while a party member is too far away; they should get a whisper naming that quest.

## Everything Else

6. Type `/pwql`, change **Zone Order** and **Quest Order** under **Quest Log**, then press `L` and click and Shift + Click quests to check each click lands on the quest you clicked.
7. With Questie on, select a quest that has you kill or collect things; the map should shade each area with one icon in it, and hovering that icon lists what's found there.
8. On WoW Forever, press `L` in and out of combat, and out of combat click the quest log button on the micro menu; each should open the wide quest log, never the world map.
9. In a party, walk into a dungeon you have a few quests for; your party should see which ones you still need, once, and be offered each one you can share.
10. In a party, right-click a zone name in the quest list and click **Share 3 Quests** (or however many it offers); anyone too far away should get a whisper naming the quest.
11. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**; TBC Anniversary is the one that tends to break here.
12. In combat, `/pwql` should refuse to open the options with a chat message, while the quest log still opens and scrolls.
