##           Author: Skizo
##
##      Modified by: Shaun Voysey
##
##            Title: MoneyDisplay
##
##            Notes: MoneyDisplay - Small movable window displaying current Player Money.
##
##         Version : 9.0.0
##
##     OptionalDeps: None
##
##     Dependencies: None
##
## Original Version: 1.8 by Sphinx

NOTE BY THE AUTHOR

I started this project when I realized that Money Display (http://ui.worldofwar.net/ui.php?id=218) by Sphinx was no longer in development.
Since then I've added functionality such as lock/unlock and the cashflow mode, and I'm still looking forward new functions to add.

If you have any suggestion feel free to contact me.


NOTE BY THE Modifier

I had fixed this addon for Cataclysm and now for Mists of Pandaria. Other than a few coding tweaks to streamline the code, there will be NO further Development by me for this mod.

I love this little addon and hated to see it die off completely.


FILES IN ZIP

MoneyDisplay.xml
MoneyDisplay.lua
MoneyDisplay.toc
readme.txt


INSTALLATION

If you had the previous version, please remove the MoneyDisplay folder first.

Place the "MoneyDisplay" folder here:
    (World of Warcraft folder) --> Interface --> AddOns


MOD DESCRIPTION

Display's a new panel showing Gold, Silver and Copper with appropriate icons defaulting to top-middle of screen.  This updates automatically as you gain or lose money.  The panel can be relocated to any point on the screen by clicking and dragging (click near upper border).  It can now also be locked to allow no further dragging.

The CashFlow amount can be seen by using the scroll wheel on the frame.  Down to view Cashflow, up to revert to actual amount.
The Cashflow can be reset by clicking the middle mouse button.  These can only be achieved by having Cashflow turned on.


HOW TO USE

Use of /money command.

/money                -    Shows all commands
/money show           -    Shows the mod
/money hide           -    Hides the mod
/money reset          -    Reset to default
/money lock           -    Locks the mod
/money unlock         -    Unlocks the mod
/money cashflow [off] -    Enables/Resets/Disables cashflow mode
/money hideborder     -    Hides window border
/money showborder     -    Shows window border
/money alpha 0-255    -    Set the background transparency (0 = transparent, 255 = solid)


REVISIONS

   v9.0
   -- A toc update + some formatting issues.

   v8.0
   -- A toc update.

   v7.3
   -- A toc update.

   v6.2.1
   -- Corrected an issue with reset and storing  the player cashflow information.

   v6.2
   -- A toc update.

   v6.1
   -- A toc update.

   v5.4
   -- A toc update.

   v5.3
   -- A toc update.

   v5.2
   -- A toc update.

   v5.0
   -- A toc update for the Expansion.
   --
   -- Tweaked the logic a little to streamline the code.
   -- Call ResetVariables from SetVariables.  (removed nine lines of duplicated code.  :/
   --
   -- Off now means OFF for Cashflow. So to turn on you must use '/money cashflow'. So now
   -- the mouse scroll will only work when Cashflow is turned on.
   --
   -- Removed the arg1 variable transfer to OnLoad().  Not needed.
   --

   v4.0.1
   -- Blasted Functions and their arguments.  Some have changed.
   --
   -- Removed the argument carryover from MD_OnUpdate().  As the Argument is not used,  no point in transfering it.
   -- Changed the arg1 to delta in the MD_MouseWheel() function, due to the <OnMouseWheel> pulling in 'self' and 'delta'.

   v4.0
   -- Fixed for Cataclysm
   --
   -- Transfer self and Event to the required Functions.
   --
   -- Changed some this's to the Frame name.
   --
   -- <OnMouseUp> and <OnMouseDown> to use button instead of arg1 in the XML.
   -- fixed the <OnMouseDown> Middle Button to reset, only if Cashflow is on.
   --
   -- Now using PLAYER_LOGIN instead of VARIABLES_LOADED.

   v2.2
   -- Created a Lite version containing code to display only
   -- Fixed bug with cashflow not workin over multiple characters
   -- Added coloration to red when cashflow shows a loss
   -- Fixed wrong positions of addon with new characters
   -- Added MiddleMouse controls for CashFlow mode

   v2.1
   -- Fixed bug with /money doing nothing
   -- Added lock/unlock functionality
   -- Added cashflow functionality
   -- Fixed proper help color

   v2.0
   -- Fixed code to work properly with wow patch 20108


TROUBLESHOOTING

If the mod fails to load the most likely problem is a patch revision on the World of Warcraft client PC.  This number needs to be correct in the MoneyDisplay.toc.  Open MoneyDisplay.toc and change to the current version.

Very little needs to be done to this addon, so a toc update will usually fix loading issues during patch updates.  Unless, of course, Blizz change some of the little functions.


FUTURE DEVELOPMENT

None at the Moment.
