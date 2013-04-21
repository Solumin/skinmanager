## DEPRECATED
---

VALVe is releasing a thing called [SteamPipe](https://support.steampowered.com/kb_article.php?ref=7388-QPFN-2491), which will completely reorganize TF2.
If you want to install a custom skin or anything, you just need to drop the archive into your tf/custom folder.

The upshot of this: The skinmanager is not needed. This is pretty disappointing, since I just started working on it a couple days ago.

The current state of the repository can be considered version 1.0 of the Skin Manager. If it becomes apparent that something like this will still be useful, I'll probably continue development. I think it's an interesting project.

---


The test/skins folders has 3 skins in it:
- Eternal Youth Maiden
	Author: Cbast
	Link: http://tf2.gamebanana.com/skins/107868
- Ambassador-style Dead Ringer
	Author: Nahka
	Link: http://tf2.gamebanana.com/skins/108312
- Golden Revolver
	Author: CC_ArK
	Link: http://tf2.gamebanana.com/skins/35909

These three skins were chosen because of their file structure.
The Eternal Youth Maiden has a "tf/" folder, the Ambi DR uses "models" and "materials",
and the Golden Revolver has no file structure at all.
These are the three general cases for skins that we need to test against.
