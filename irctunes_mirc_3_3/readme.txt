################################################################################
########################### iRCTunes for mIRC Readme ###########################
############################### v3.3, 13/11/2008 ###############################
################################################################################

iRCTunes is a plugin for mIRC that allows you to completely control iTunes.     
Using a series of /itunes commands, you can quickly and easily export the now   
playing metadata to IRC. Also by using commands such as Play, Pause and Rewind 
you can control the activity of iTunes without leaving mIRC.

################################################################################
############### 1. TABLE OF CONTENTS ###########################################
################################################################################

1) Table of Contents
2) Licenses
3) Installation
4) Changes
5) Plugins
6) Feedback
7) Thanks

################################################################################
############### 2. LICENSE #####################################################
################################################################################

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.

In addition to the above terms we request that if you fork iRCTunes you use a
different name to prevent confusion between versions. For more information email
petpow@thegeeklord.net

################################################################################
############### 3. INSTALLATION ################################################
################################################################################

1. Unzip iRCTunes using your favourite archive program (I recommend WinRAR).
2. Copy the "irctunes" directory (the one which contains irctunes.mrc) to the 
   directory you installed mIRC into (type "//run $mircdir" for mIRC to open
   this directory for you).
3. If you do not already have mIRC open then run mIRC
4. Type "/load -rs irctunes/irctunes.mrc" and press enter to load iRCTunes
5. Restart mIRC by typing "/exit -nr"

iRCTunes should now be loaded as a remote into your mIRC. Type /itunes help to
check this. If you have any problems then email petpow@thegeeklord.net

Note: if you are upgrading from an older version of iRCTunes you must first open
mirc and type  /unload -rs irctunes.mrc. Configuration files will be backed up
as irctunes-old-XXXXXXXXXX.ini (where XXXXXXXXXX means the posix time for when
you unloaded iRCTunes).

################################################################################
############### 4. CHANGES #####################################################
################################################################################

[ADDED] Added ^FILETYPE^ for finding the filetype of your current song
[ADDED] Added ^ALBUMARTIST^ for finding the album artist of your current song
[MODIFIED] Reordered items in theming help to be in alphabetical order
[MODIFIED] Improved formatting of ^SIZE^ to use B, KiB and GiB as well as MiB
[MODIFIED] Changed timer to update info dialog more often (/itunes info)
[MODIFIED] Tweaked code for all theming vars to be more efficient
[MODIFIED] Fixed a few bugs where iRCTunes was referring to its directory wrong
[MODIFIED] ^COMPILATION^ now returns yes/no instead of $true/$false (requested)
[MODIFIED] Fixed a bug in sendtrack getting confused if user cancels

################################################################################
############### 5. PLUGINS #####################################################
################################################################################

iRCTunes allows users to extend iRCTunes via its plugin interface. Plugins can
be used enhance a users experience in any way they wish.

To load a plugin move it into the "itplugins" folder which can be found in the
same place as irctunes.mrc (if you have iRCTunes loaded into mIRC you can type
"//run $itdirectory" to open this). Once you have moved it into this directory
open mirc and type "/itunes plugins". Click on the name of your new plugin and
click the "Load" button. Now you can close the plugin interface and enjoy your
new plugin.

To unload a plugin type "/itunes plugins" and click on the name of the plugin
you wish to unload. If you wish to delete the plugin you can click on the
"Delete" button. However, if you just want to unload the plugin for your current
session you can click on the "Unload" button.

################################################################################
############### 6. FEEDBACK ####################################################
################################################################################

If you have any feedback to make, bugs to report or suggestions to make about
iRCTunes please send me an email to petpow@thegeeklord.net with the topic of
"Regarding iRCTunes VERSION" (replace VERSION with the version of iRCTunes
you are using). If reporting a bug please include your mIRC version, names of 
other loaded scripts, operating system, iTunes version and anything else you 
think is necessary in the email.

################################################################################
############### 7. THANKS ######################################################
################################################################################

I would like to thank the freenode IRC Network (irc.freenode.net) for hosting
the iRCTunes support channel. McoreD (itsfv.sourceforge.net) for bug testing and
suggesting new features. Google Code (code.google.com) for hosting the iRCTunes
project page (irctunes.googlecode.com) and finally Apple (www.apple.com) for
creating iTunes - a REAL media player ;D.

################################################################################
################################################################################