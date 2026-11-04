# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window, with your whole quest list beside the quest details and a map of the selected quest. This time we most want you to try entering dungeons with a party, since the announcement and quest sharing there now wait for everyone.

**Play on Classic Era, Season of Discovery, WoW Forever, TBC Anniversary, and Mists of Pandaria Classic.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. In a party, enter a dungeon you have quests for while someone is still outside; the announcement and shares should wait until they're in range (at most a minute), except on WoW Forever, where they go out right away.
2. After that, leave the dungeon and come back, then `/reload` inside it; nothing should be announced or shared again.
3. Invite someone new while you're inside the dungeon; only they should be offered your dungeon quests.
4. Enter a dungeon in a raid group; nothing should be announced or shared.

## Everything Else

5. Press `L`, change **Zone Order** and **Quest Order** under **Quest Log**, then click and Shift-Click quests to check each click lands on the quest you clicked.
6. Look over the quest list; dungeon, raid, elite and PvP quests should show their letter after the level, as in [40D].
7. With Questie on, select a quest that has you kill or collect things; the map should shade each area with one icon in it, and a quest in a chain should list its steps.
8. On WoW Forever and Mists of Pandaria Classic, press `L` in and out of combat, and out of combat click the quest log button on the micro menu and a quest in the objective tracker; each should open the wide quest log.
9. In a party, right-click a zone name in the quest list and click **Share 3 Quests** (or however many it offers); anyone too far away should get a whisper naming the quest.
10. Click a quest's ID in the quest details to get its Wowhead link.
11. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**.
12. In combat, `/pwql` should refuse to open the options with a chat message, while the quest log still opens and scrolls.
