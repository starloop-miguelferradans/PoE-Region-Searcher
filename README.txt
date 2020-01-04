Path Of Exile's Conqueror Influence Tracker

This is a fork from Fall's Region Search Overlay found here: https://github.com/Fallstreak6/PoE-Region-Searcher
This is a AutoHotKey script to add map tab QoL and save time with atlas progression, and to track influenced
regions automatically, by parsing Path Of Exile's client log.

Preview:

https://i.imgur.com/ujtPY9V.png
https://github.com/starloop-miguelferradans/PoE-Region-Searcher

Automatic Influence Tracking:

Every time you encounter a Conqueror in a map, the script UI will update automatically to reflect the new status.

There are five levels of influence status:

* 0: no influence in this region
* 1: Conqueror encountered once
* 2: Conqueror encountered twice
* 3: Conqueror encountered thrice, and his/her Citadel is opened
* 4: Conqueror was defeated and his/her influence cannot be spawned again in this Sirus spawn cycle

When you defeat every Conqueror, the script UI will reset, ready for the new Sirus spawn cycle

Initial Setup:

The first time you use the script, you will have to modify the Config.ini file, found in the main folder.

Here you will have to update the path to your client log, and the status of your current influenced regions
for each conqueror, follow the explanation from above to set each Conqueror correctly.

After this is done, there is nothing else to do, the script will automatically update the influences when you encounter
the Conquerors in maps.

Features:

* Click to search your map tab by region. Works in any stash tab with a search bar. (Make sure your stash is open when you do this or nothing will happen, it can check if the game is open but not what you are doing ingame)
* Tracks your influenced regions automatically by parsing Path Of Exile's client log
* Automatic always on top while you play.
* Hotkey to show and hide interface. F2 is default.