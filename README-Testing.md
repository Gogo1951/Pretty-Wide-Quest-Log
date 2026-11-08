# Pretty Wide Quest Log // Test Plan

Pretty Wide Quest Log turns the quest log into one wide window, with your quest list beside the quest details and a map of the selected quest, plus a route on the zone map and a Quest Arrow when Questie is on. This time we most want you to try ignoring objectives from the Quest Arrow and the zone map, and the arrow's new look once you reach an objective.

**Play on Classic Era, Season of Discovery, WoW Forever, TBC Anniversary, and MoP Classic.** If something looks wrong, tell us the check number and what you saw on [Discord](https://discord.gg/eh8hKq992Q).

## What's New

1. With Questie on, press `M` and follow the route's markers through your objectives and turn-ins; a dungeon quest's objectives should be one red-ringed marker at the dungeon's entrance.
2. Right-click a marker on the zone map to take it off the route.
3. Turn on **Show Next Objective** from the Quest Arrow's menu and follow the arrow to an objective; once there it should read "Current Objective Area" with a dimmed "Next Objective" line under it.
4. Turn on **Show Upcoming Turn-Ins** from the Quest Arrow's menu; each quest's turn-in should join the route, with Questie's gray question mark, before you finish the quest.
5. Mouse over the Quest Arrow and ignore an objective from its menu; it should stay on the menu's ignore list until you middle-click the arrow.
6. Take a flight path; the Quest Arrow should hide in the air and come back on landing with a route from where you came down.
7. In a party, open the Quest Arrow's menu and turn a member's objectives off and back on; anyone without Questie should show "No Questie".
8. On WoW Forever, share a quest with your party during a fight; it should say it will share once combat ends, and then do it.

## Everything Else

9. Press `L` and change **Zone Order** and **Quest Order** under **Wide Quest Log** in the options; the list should re-sort, and each click should select the quest you clicked.
10. With Questie on, select a quest that has you kill or collect things; the map beside the log should shade each area, and a quest in a chain should list its steps.
11. In a party, walk into a dungeon you have quests for; party chat should list them, and your party should be offered each one you can share.
12. On WoW Forever and MoP Classic, press `L` in and out of combat, and open the quest log from the micro menu; it should be the wide quest log every time.
13. Open the options with `/pwql` and from **Options > AddOns > Pretty Wide Quest Log**, then try `/pwql` in combat; it should refuse with a chat message.
