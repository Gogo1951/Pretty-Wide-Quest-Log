# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window, with your whole quest list beside the quest details and a map of the selected quest. This time we most want you to try Questie's icons on that map, and on WoW Forever, the map showing only the quest you picked.

**Play on Classic Era, Season of Discovery, WoW Forever, and TBC Anniversary.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. With Questie on, click through a few quests; the map's icons should stay one steady size, close to Blizzard's own quest markers, even after you change Questie's **Global Scale**.
2. On WoW Forever with Questie off, click through a few quests; the map should show only the selected quest's area and marker, plus a marker for where to head when it sends you to another zone.
3. With Questie on, select a quest that's part of a chain; the chain should show with your step highlighted, and with ElvUI on, in the same colors as the Description above it.

## Everything Else

4. Type `/pwql`, change **Zone Order** and **Quest Order** under **Quest Log**, then press `L` and click and Shift + Click quests to check each click lands on the quest you clicked.
5. Try **Collapse All** and **Track All** above the quest list, then drag the grip in the bottom-right corner to make the log taller.
6. With Questie on, select a quest that has you kill or collect things; the map should shade each area with one icon in it, and hovering that icon lists what's found there.
7. With Questie on, select a quest that spans more than one zone and switch zones with the dropdown in the map's top-left corner.
8. Select a quest in a zone you've never been to and check the map shows the whole zone, not bare parchment, with Leatrix Maps turned off too.
9. On WoW Forever, press `L` in and out of combat, and out of combat click the quest log button on the micro menu; each should open the wide quest log, never the world map.
10. In a party, walk into a dungeon you have a few quests for; your party should see which ones you still need, once, and be offered each one you can share.
11. In a party, right-click a zone name in the quest list and click **Share 3 Quests** (or however many it offers); anyone too far away should get a whisper naming the quest.
12. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**; TBC Anniversary is the one that tends to break here.
13. In combat, `/pwql` should refuse to open the options with a chat message, while the quest log still opens and scrolls.
