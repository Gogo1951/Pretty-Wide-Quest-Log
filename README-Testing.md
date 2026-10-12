# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window, with quest levels and tags and your whole quest list beside the quest details and a map of the selected quest. This time we most want you to try the new right-click menu on zone names and the quest chain in the quest details.

**Play on Classic Era, WoW Forever, and TBC Anniversary.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. In a party, right-click a zone name in the quest list and click **Share Quests**; your party should get that zone's quests one at a time.
2. Share a quest with a party member who is busy, too far away, or has a full quest log; they should get a whisper naming the quest.
3. Right-click a zone with gray quests and click **Abandon Gray Quests**; the prompt should list each quest before anything is abandoned.
4. With Questie on, select a quest that's part of a chain and check the details show the chain with your step highlighted.
5. With a quest ready to turn in, hover the turn-in line beside the quest count to see each quest's XP and gold.
6. Click the quest ID under a quest's details and copy the Wowhead link it offers.
7. Type `/pwql`, open **Quest Log**, and try **Show Current Zone First**, **Completed Quests First**, **Close When Combat Starts**, **Quest Log Scale** and **Map Scale**.
8. Turn off **Enable Quality of Life** and check quest givers go back to Blizzard's look, then turn it on and try **Show Quest Levels** under **Quality of Life**.
9. Turn off **Enable Quest Log Cleanup**, close the options and accept the reload; `L` should open Blizzard's quest log until you turn it back on.
10. Log in without Questie and check chat warns you, and the map beside the log still shows the zone you're in.

## Everything Else

11. Press `L`, change **Zone Order** and **Quest Order**, then click and Shift + Click quests to check each click lands on the quest you clicked.
12. With Questie on, select a quest and check the map shows only its icons, using the dropdown in the map's top-left corner for quests in more than one zone.
13. Try **Collapse All** and **Track All** above the quest list, then drag the grip in the bottom-right corner to make the log taller.
14. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**; TBC Anniversary is the one that tends to break here.
15. In combat, `/pwql` should refuse to open the options while the quest log still works; on WoW Forever, also click a quest in your tracker mid-fight.
