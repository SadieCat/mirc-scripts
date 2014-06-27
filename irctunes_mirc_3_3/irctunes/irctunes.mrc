;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; iRCTunes for mIRC v3.3                           ;
; Author: TheGeekLord <petpow@thegeeklord.net>     ;
; License: GNU General Public License v3.0         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:start: {
  if ($ini($itconfig, script) == 0) {
    writeini -n $itconfig script n0 on *:START: $chr(123)
    writeini -n $itconfig script n1 .unload -rs $!shortfn($script)
    writeini -n $itconfig script n2 $chr(125)
  }
  if ($ini($itconfig, settings, theme) != 1) itsettings theme [DESCRIBE] is listening to <BOLD>'^NAME^'</BOLD> by <BOLD>^ARTIST^</BOLD> [^LENGTH^/^SIZE^/^BITRATE^kbps]
  if ($ini($itconfig, settings, achkupdate) != 1) itsettings achkupdate true
  if ($ini($itconfig, settings, autoconn) != 1) itsettings autoconn true
  if ($readini($itconfig, settings, support) != false) itsettings support false
  if ($itsettings(autoconn) == true) {
    .comopen irctunes iTunes.Application
    if (!$com(irctunes)) echo -a $itcolor(ERROR,iRCTunes was unable to open the COM connection to iTunes)
  }
  if ($itsettings(achkupdate) == true) { 
    .timer 1 10 itunes checkupdate
  }
  if (!$exists($+($itdirectory,itplugins\))) {
    mkdir $+($itdirectory,itplugins\)
  }
  if ($findfile($+($itdirectory,itplugins\),it_*.itp,0) > 0) {
    var %it.plugid 1
    while (%it.plugid <= $findfile($+($itdirectory,itplugins\),it_*.itp,0)) {
      if (!$script($findfile($+($itdirectory,itplugins\),it_*.itp,%it.plugid).shortfn)) {
        .load -rs $+(",$findfile($+($itdirectory,itplugins\),it_*.itp,%it.plugid),")
      }
      inc %it.plugid
    }
  }
  echo -a $itcolor(INFORMATION,iRCTunes $itversion for mIRC has been loaded - to view a list of commands type /itunes help)
}
on *:unload: {
  if ($com(irctunes)) {
    .comclose irctunes
  }
  if ($exists($itconfig)) {
    remini $itconfig temp 
    .rename $itconfig $+($itdirectory,irctunes-old-,$ctime,.ini)
  }
  var %it.pluguid 1
  while (%it.pluguid <= $script(0)) { 
    if ($right($script(%it.pluguid),4) == .itp) {
      .timer -m 1 %it.pluguid .unload -rs $+(",$script(%it.pluguid),")
    } 
    inc %it.pluguid 
  } 
  echo -a $itcolor(INFORMATION,iRCTunes $itversion for mIRC has been unloaded)
}
on *:exit: {
  remini $itconfig temp
}
on *:join:#thegeeklord: {
  if ($network == freenode) && ($itsettings(support) == true) { 
    describe $chan requires help with iRCTunes for mIRC $itversion running on Windows $os with mIRC $version
    itsettings support false 
  }
}
alias itunes {
  if (!$1) { 
    echo -a $itcolor(ERROR,You must enter a command - for a list of commands type "/itunes help")
  }
  elseif ($1 == help) {
    echo -a  === iRCTunes $itversion for mIRC Help ===
    echo -a  /itunes about           -  Displays an information dialog showing information about iRCTunes
    echo -a  /itunes autoupdatecheck -  Toggles checking for iRCTunes updates when mIRC starts on and off
    echo -a  /itunes advertise       -  Messages information about your iRCTunes versions to the active channel
    echo -a  /itunes autobroadcast   -  Toggles automatically broadcasting the current tracks information on and off
    echo -a  /itunes autoconn        -  Toggles automatically connecting to iTunes when mIRC starts on and off
    echo -a  /itunes autoshowto      -  Toggles automatically sending your current tracks info to a target on and off
    echo -a  /itunes broadcast       -  Messages your current track's information to all channels on all networks
    echo -a  /itunes checkupdate     -  Connects to the iRCTunes update server and checks if a newer version exists
    echo -a  /itunes clipboard       -  Sends information about your current playing track to the windows clipboard
    echo -a  /itunes comstatus       -  Shows status information about iRCTunes' com connection to iTunes
    echo -a  /itunes disconnect      -  Closes the COM connection which iRCTunes uses to communicate with iTunes
    echo -a  /itunes exit            -  Sends a request to iTunes to disconnect the connection and close down
    echo -a  /itunes forward         -  Sends a request to iTunes to fast forward the currently playing track until resumed
    echo -a  /itunes help            -  Displays a list of commands which can be used with iRCTunes and it's plugins
    echo -a  /itunes info            -  Displays a dialog containing various information about the current playing track
    echo -a  /itunes mute            -  Sends a request to iTunes to mute the volume of the currently playing track
    echo -a  /itunes next            -  Sends a request to iTunes to change the playing track to the next in the playlist
    echo -a  /itunes pause           -  Sends a request to iTunes to temporarily pause the playing of the current track
    echo -a  /itunes play            -  Sends a request to iTunes to start play or continue the currently selected track
    echo -a  /itunes prev            -  Sends a request to iTunes to change the playing track to the previous in the playlist
    echo -a  /itunes plugins         -  Displays a list of plugins which exist in the plugins directory and their status
    echo -a  /itunes reconnect       -  Closes iRCTunes' connection to iTunes (if it exists) and reconnects after a delay
    echo -a  /itunes replay          -  Sends a request to iTunes to restart the current track from the beginning
    echo -a  /itunes resume          -  Sends a request to iTunes to resume playing after rewinding or fast forwarding
    echo -a  /itunes rewind          -  Sends a request to iTunes to rewind the currently playing track until resumed
    echo -a  /itunes sendtrack       -  Sends the currently playing track to a specified user over IRC using DCC send
    echo -a  /itunes show            -  Sends information about your current playing track to the active channel/pmsg window
    echo -a  /itunes showto          -  Sends information about your current playing track to a specified irc target
    echo -a  /itunes stop            -  Sends a request to iTunes to stop the playing of the current track permanently
    echo -a  /itunes support         -  Connects you automatically to the iRCTunes support channel on the freenode network
    echo -a  /itunes theme           -  Shows a human readable version of the iRCTunes theme in the active window
    echo -a  /itunes themes          -  Displays the iRCTunes theme editor for changing your iRCTunes now playing theme
    echo -a  /itunes unmute          -  Sends a request to iTunes to unmute the volume of the currently playing track
    echo -a  /itunes volume          -  Sends a request to iTunes to set the volume of your currently playing track
    echo -a  /itunes website         -  Displays the iRCTunes for mIRC website in your windows default browser
    echo -a  iRCTunes copyright $chr(169) $asctime(yyyy) TheGeekLord (www.irctunes.net)
  }
  elseif ($1 == about) {
    if ($dialog(it_about)) {
      dialog -x it_about
    }
    else {
      dialog -m it_about it_about
    }
  }
  elseif ($1 == autoupdatecheck) {
    if ($itsettings(achkupdate) == true) {
      itsettings achkupdate false 
      echo -a $itcolor(INFORMATION,iRCTunes will no longer automatically check for updates when mIRC starts (not recommended))
    }
    else {
      itsettings achkupdate true 
      echo -a $itcolor(INFORMATION,iRCTunes will now automatically check for updates when mIRC starts (recommended))
    }
  }
  elseif ($1 == advertise) { 
    .scid -t1 $activecid describe $active uses iRCTunes $itversion for mIRC by TheGeekLord (www.irctunes.net)
  }
  elseif ($1 == autobroadcast) {
    if ($timer(ast)) { 
      .timerast off 
      echo -a $itcolor(INFORMATION,iRCTunes detected that autoshowto [/itunes autoshowto] was enabled and has disabled it to prevent conflicts)
    }
    if ($timer(abc)) {
      .timerabc off
      echo -a $itcolor(INFORMATION,iRCTunes will now no longer send your now playing information to all channels when your track changes)
      .scid -at1 ame now has disabled iRCTunes Automatic Track Information Broadcasting
    }
    else {
      .ittemp lastbroadcastlocation $itinfo(shortlocation)
      .timerabc 0 10 itautobroadcastcheck
      echo -a $itcolor(INFORMATION,iRCTunes will now send your now playing information to all channels when your track changes)
      .scid -at1 ame now has enabled iRCTunes Automatic Track Information Broadcasting
    }
  }
  elseif ($1 == autoconn) { 
    if ($itsettings(autoconn) == true) {
      itsettings autoconn false
      echo -a $itcolor(INFORMATION,iRCTunes will now no longer connect to iTunes when mIRC starts (recommended for older, slower machines)) 
    }
    elseif ($itsettings(autoconn) == false) { 
      itsettings autoconn true
      echo -a $itcolor(INFORMATION,iRCTunes will now connect to iTunes when mIRC starts (recommended for newer, faster machines))
    }
  }
  elseif ($1 == autoshowto) {
    if ($timer(abc)) {
      .timerabc off
      echo -a $itcolor(INFORMATION,iRCTunes detected that autobroadcast [/itunes autobroadcast] was enabled and has disabled it to prevent conflicts)
    }
    if ($timer(ast)) {
      .timerast off
      echo -a $itcolor(INFORMATION,iRCTunes will now no longer send your now playing information to your named channels when your track changes)
      tokenize 44 $ittemp(showtochannels)
      var %i 1
      while (%i <= $0) {
        .scid -t1 $scid($activecid) describe $eval($+($chr(36),%i),2) now has disabled iRCTunes Automatic Track Information Broadcasting
        inc %i
      }
    }
    else { 
      if ($2) {
        ittemp lastshowtolocation $itinfo(shortlocation)
        ittemp showtochannels $2
        .timerast 0 10 .scid $scid($activecid) itautoshowtocheck
        echo -a $itcolor(INFORMATION,iRCTunes will now send an automatic np message to $+(",$2,") every time your track changes)
        tokenize 44 $2
        var %i 1
        while (%i <= $0) {
          .scid -t1 $scid($activecid) describe $eval($+($chr(36),%i),2) now has enabled iRCTunes Automatic Track Information Broadcasting
          inc %i
        }
      }
      else {
        echo -a $itcolor(SYNTAX,/itunes autoshowto <target>)
      }
    }
  }
  elseif ($1 == broadcast) { 
    if ($itinfo(shortlocation) == COM Error) {
      echo -a $itcolor(INFORMATION,iRCTunes encountered an error while broadcasting your track information - please type /itunes reconnect)
    }
    else {
      tokenize 32 $itsettings(theme)
      if ($1 == [DESCRIBE]) { .scid -at1 ame $itparsetheme($2-) }
      else { .scid -at1 amsg $itparsetheme($itsettings(theme)) }
    }
  }
  elseif ($1 == checkupdate) {
    if ($sock(it_chkupdate)) sockclose it_chkupdate
    if ($ini($itconfig, script) != 0) remini $itconfig updatecheck
    .sockopen it_chkupdate www.irctunes.net 80
    echo -a $itcolor(INFORMATION,Checking for a newer version of iRCTunes [Current Version: $+($itversion,]))
  }
  elseif ($1 == clipboard) {
    clipboard [iRCTunes] Track: $+($itinfo(name),$chr(44)) Artist: $+($itinfo(artist),$chr(44)) Album: $itinfo(album)
    echo -a $itcolor(INFORMATION,Information about your currently playing track has been sent to the clipboard)
  }
  elseif ($1 == comstatus) {
    if ($com(irctunes)) && ($itinfo(shortlocation) != COM Error) {
      echo -a $itcolor(INFORMATION,The COM connection to iTunes is connected and working properly)
    }
    elseif ($com(irctunes)) && ($itinfo(shortlocation) == COM Error) {
      echo -a $itcolor(INFORMATION,The COM connection to iTunes is connected but returning an error)
      echo -a $itcolor(INFORMATION,To attempt to fix this type /itunes reconnect)
    }
    else {
      echo -a $itcolor(INFORMATION,The COM connection to iTunes is not connected)
      echo -a $itcolor(INFORMATION,To connect to iTunes type /itunes reconnect)
    }
  }
  elseif ($1 == disconnect) {
    if ($com(irctunes)) {
      .comclose irctunes
      echo -a $itcolor(INFORMATION,The COM connection between iRCTunes and iTunes has been disconnected)
    }
    else {
      echo -a $itcolor(ERROR,The COM connection between iRCTunes and iTunes was not connected so it can not be disconnected)
    }
  }
  elseif ($1 == exit) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Quit,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while quitting iTunes)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == forward) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,FastForward,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while asking iTunes to fast forward)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == info) { 
    if ($dialog(it_trackinfo)) {
      remini $itconfig ittemp lastinfolocation
      dialog -x it_trackinfo
    }
    else {
      ittemp lastinfolocation $itinfo(shortlocation)
      if ($timer(iti)) .timeriti off
      dialog -m it_trackinfo it_trackinfo
    }
  }
  elseif ($1 == next) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,NextTrack,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while moving iTunes to the next track)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == mute) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Mute,4,bstr,true)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while muting iTunes)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == pause) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Pause,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while pausing iTunes)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == play) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Play,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while asking iTunes to begin playing)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == prev) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,PreviousTrack,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while asking iTunes play the previous track)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == plugins) {
    if ($exists($+($itdirectory,itplugins\)) != $true) mkdir $+($itdirectory,itplugins\)
    if ($findfile($+($itdirectory,itplugins\),it_*.itp,0) > 0) {
      if ($dialog(it_plugins)) {
        dialog -x it_plugins
      }
      else {
        dialog -m it_plugins it_plugins
      }
    }
    else {
      echo $itcolor(ERROR,iRCTunes can not find any plugins matching the name it_*.itp in the plugins directory)
    }
  }
  elseif ($1 == reconnect) { 
    echo -a $itcolor(INFORMATION,iRCTunes is now reconnecting to iTunes)
    if ($com(irctunes)) {
      .comclose irctunes
      .comopen irctunes iTunes.Application
    }
    else { 
      .comopen irctunes iTunes.Application
    }
    echo -a $itcolor(INFORMATION,iRCTunes has now reconnected to iTunes)
  }
  elseif ($1 == replay) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,BackTrack,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while asking iTunes to replay)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == resume) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Resume,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while asking iTunes to resume playing)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == rewind) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Rewind,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while asking iTunes to rewind)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == sendtrack) { 
    if ($2) {
      dcc send $2 $itinfo(shortlocation)
      echo $itcolor(INFORMATION,Offerering $+(",$nopath($itinfo(location)),") to $+(",$2,"))
    }
    else {
      var %it.sndto $?="Enter the nickname of the person you would like to send your current track to"
      if (%it.sndto) {
        dcc send %it.sndto $itinfo(shortlocation)
        echo $itcolor(INFORMATION,Offerering $+(",$nopath($itinfo(location)),") to $+(",%it.sndto,"))
      }
    }
  }
  elseif ($1 == show) {
    if ($itinfo(shortlocation) == COM Error) {
      echo -a $itcolor(INFORMATION,iRCTunes encountered an error while broadcasting your track information - please type /itunes reconnect)
    }
    elseif ($active == Status Window) {
      echo -a $itcolor(INFORMATION,You may not send now playing information to the status window)
    }
    else {
      tokenize 32 $itsettings(theme)
      if ($1 == [DESCRIBE]) { .scid $scid($activecid) describe $active $itparsetheme($2-) }
      else { .scid $scid($activecid) msg $active $itparsetheme($1-) }
    }
  }
  elseif ($1 == showto) {
    if ($2) {
      if ($itinfo(shortlocation) == COM Error) {
        echo -a $itcolor(INFORMATION,iRCTunes encountered an error while broadcasting your track information - please type /itunes reconnect)
      }
      else {
        var %i 1
        tokenize 44 $2
        var %i 1
        while (%i <= $0) {
          if ($gettok($itsettings(theme),1,32) == [DESCRIBE]) { .scid $scid($activecid) describe $eval($+($chr(36),%i),2) $itparsetheme($gettok($itsettings(theme),2-,32)) }
          else { .scid $scid($activecid) msg $eval($+($chr(36),%i),2) $itparsetheme($itsettings(theme)) }
          inc %i
        }
      }
    }
    else {
      echo -a $itcolor(SYNTAX,/itunes showto <target>)
    }
  }
  elseif ($1 == stop) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Stop,3)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while asking iTunes to stop)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == support) {
    var %it.checksure $?!="Are you sure you want to get support over irc? $crlf $+ Please state your problem clearly and be patient"
    if (%it.checksure == $true) {
      itsettings support true
      if ($status == disconnected) server chat.freenode.net -j #thegeeklord
      else server -m chat.freenode.net -j #thegeeklord
      echo -a $itcolor(INFORMATION,Now connecting you to the iRCTunes support channel for live support)
      echo -a $itcolor(INFORMATION,An automatic message will be sent to the help channel on connection)
    }
  }
  elseif ($1 == theme) {
    echo -a $itcolor(INFORMATION,Your iRCTunes theme is: $itsettings(theme))
  }
  elseif ($1 == themes) {
    if ($dialog(it_theming)) {
      dialog -x it_theming
    }
    else {
      dialog -m it_theming it_theming
    }
  }
  elseif ($1 == unmute) {
    if (!$com(irctunes)) goto nexterr
    var %it.comresult $com(irctunes,Mute,4,bstr,false)
    if ($comerr) || (%it.comresult == 0) {
      :nexterr
      echo -a $itcolor(ERROR,iRCTunes encountered an error while unmuting iTunes)
      echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
    }
  }
  elseif ($1 == volume) {
    if ($2 isnum 0-100) {
      if (!$com(irctunes)) goto nexterr
      var %it.comresult $com(irctunes,SoundVolume,4,int,$2)
      if ($comerr) || (%it.comresult == 0) {
        :nexterr
        echo -a $itcolor(ERROR,iRCTunes encountered an error while setting iTunes' volume)
        echo -a $itcolor(ERROR,Please ensure that iTunes is open and connected (/itunes comstatus))
      }
    }
    else {
      echo -a $itcolor(SYNTAX,/itunes volume <N> (where <N> is a number between 0 and 100))
    }
  }
  elseif ($1 == website) { 
    run http://www.irctunes.net/mirc/ 
  }

  ; A little easter egg for v3.3 only ;D
  elseif ($1 == moo) {
    ; $+($chr(3),07) on 9
    echo -a 09,09#####################
    echo -a 09,09#########07,09(__)09,09########
    echo -a 09,09#########07,09(oo)09,09########
    echo -a 09,09##########07,09\/09,09#########
    echo -a 07,09Have you mooed today?
    echo -a 09,09#####################
  }
  ; End easter egg ;D

  else {
    echo $itcolor(ERROR,The iRCTunes command $+(",$1,") does not exist)
  }
}
on *:sockopen:it_chkupdate: {
  if ($sockerr) { 
    echo -a $itcolor(ERROR,iRCTunes encountered a problem while sending a request for the update information)
    halt 
  }
  sockwrite -n $sockname GET /mirc/updater.php?version=3 HTTP/1.1
  sockwrite -n $sockname Host: www.irctunes.net
  sockwrite -n $sockname User-Agent: iRCTunes Update Checker $+($chr(40),iRCTunes $itnumversion,$chr(44),$chr(32),mIRC $version,$chr(44),$chr(32),Windows $os,$chr(41)) $+ $crlf $+ $crlf
}
on *:sockread:it_chkupdate:{
  if ($sockerr) { 
    echo -a $itcolor(ERROR,iRCTunes encountered a problem while reading the update information)
    halt 
  }
  var %itmp
  sockread %itmp
  tokenize 32 %itmp
  if ($1 = VERSION) {
    writeini -n $itconfig updatecheck version $2- 
  }
  elseif ($1 == NUMVERSION) {
    writeini -n $itconfig updatecheck numversion $2-
  }
  elseif ($1 == INFORMATION) { 
    writeini -n $itconfig updatecheck information $2- 
  }
  elseif ($1 == RELTIME) { 
    writeini -n $itconfig updatecheck reltime $2- 
  } 
  elseif ($1 == LINK) {
    writeini -n $itconfig updatecheck link $2- 
  }
  elseif ($1 == EOF) {
    .sockclose $sockname
    if ($readini($itconfig, updatecheck, numversion) == $itnumversion) {
      echo -a $itcolor(INFORMATION,No iRCTunes updates are currently available for download)
      remini $itconfig updatecheck
    }
    elseif ($readini($itconfig, updatecheck, numversion) < $itnumversion) {
      echo -a $itcolor(INFORMATION,The version of iRCTunes you are using is newer than the latest release)
      remini $itconfig updatecheck
    }
    elseif ($readini($itconfig, updatecheck, numversion) > $itnumversion) {
      echo -a $itcolor(WARNING,A new version of iRCTunes is available - $readini($itconfig, updatecheck, version) [Released $+($readini($itconfig, updatecheck, reltime),]))
      dialog -mdrieo it_newver it_newver  
    }
    else {
      echo -a $itcolor(ERROR,An error occured while processing the iRCTunes update information - to find out the latest version visit http://irctunes.sf.net/mirc/download.php
      remini $itconfig updatecheck
    }
  }
}
menu nicklist {
  iRCTunes $itversion
  .CTCP iTunes:ctcp $$1 itunes
  .CTCP iRCTunes:ctcp $$1 irctunes
  .CTCP GetSong:ctcp $$1 getsong
}
menu channel,query {
  iRCTunes $itversion
  .Announce Track :itunes show
  .Advertise iRCTunes:itunes advertise
  .Restart iRCTunes:itunes reconnect
  .-
  .iRCTunes !commands
  ..!itunes:msg $active !itunes
  ..!getsong:msg $active !getsong
}
menu menubar {
  iRCTunes $itversion
  .iTunes Controls
  ..Next track:itunes next
  ..Pause track:itunes pause
  ..Play track:itunes play
  ..Previous track:itunes prev
  ..Rewind track:itunes rewind
  ..Stop track:itunes stop
  ..Replay track:itunes replay
  ..Resume playing:itunes resume
  ..Fast Forward track:itunes forward
  ..Set iTunes volume:itunes volume $?="What volume would you like to set iTunes to (enter a number betwen 0 and 100)"
  ..Mute iTunes:itunes mute
  ..Unmute iTunes:itunes unmute
  ..Quit iTunes:$iif($?!="Are you sure you want to close iTunes?" == $true,itunes exit)
  .iRCTunes Controls
  ..About iRCTunes:itunes about
  ..Advertise iRCTunes:itunes advertise
  ..Toggle automatic update checking:itunes autoupdatecheck
  ..Toggle automatic np broadcasting:itunes autobroadcast
  ..Toggle automatic connecting to iTunes:itunes autoconn
  ..Broadcast np information:itunes broadcast
  ..Check for updates:itunes checkupdate
  ..Send info to clipboard:itunes clipboard
  ..Check iTunes connection status:itunes comstatus
  ..View track information:itunes info
  ..(Re)connect to iTunes:itunes reconnect
  ..Share current track via DCC:itunes sendtrack
  ..Show np information on IRC:itunes show
  ..View current iRCTunes np theme:itunes theme
  ..Change current iRCTunes np theme:itunes themes
  .Plugin Controls
  ..List Plugins:itunes plugins
  ..-
  .Help and Support
  ..Main Help:itunes help
  ..IRC Support:itunes support
  ..-
  ..iRCTunes Website:itunes website
  ..iRCTunes Bug Tracker:run http://code.google.com/p/irctunes/issues/list

}
ctcp *:irctunes: { 
  .notice $nick $itcolor(REMOTE,I use iRCTunes $itversion for mIRC by TheGeekLord (www.irctunes.net))
  .echo -a $itcolor(INFORMATION,$+($iif($network,$network,$server),->,$nick) requested your iRCTunes version via CTCP)
  halt
}
alias -l itupdateinfo {
  if ($ittemp(lastinfolocation) != $itinfo(shortlocation)) { 
    if ($dialog(it_trackinfo)) did -o it_trackinfo 1 1 Listing information for $nopath($itinfo(location))
    if ($dialog(it_trackinfo)) did -o it_trackinfo 2 1 Name: $itinfo(name)
    if ($dialog(it_trackinfo)) did -o it_trackinfo 3 1 Artist: $itinfo(artist)
    if ($dialog(it_trackinfo)) did -o it_trackinfo 4 1 Album: $itinfo(album)
    if ($dialog(it_trackinfo)) did -o it_trackinfo 5 1 Rating: $+($itinfo(rating),/100)
    ittemp lastinfolocation $itinfo(shortlocation)
  }
}
alias -l itautoshowtocheck {
  if ($ittemp(lastshowtolocation) != $itinfo(shortlocation)) { 
    tokenize 44 $ittemp(showtochannels)
    var %i 1
    while (%i <= $0) {
      itunes showto $eval($+($chr(36),%i),2)
      inc %i
    }
    ittemp lastshowtolocation $itinfo(shortlocation)
  }
}
alias -l itautobroadcastcheck {
  if ($ittemp(lastbroadcastlocation) != $itinfo(shortlocation)) { 
    itunes broadcast
    ittemp lastbroadcastlocation $itinfo(shortlocation)
  }
}
alias itversion { 
  return v3.3
}
alias itnumversion { 
  return 3.3.0
}
alias itconfig { 
  return $+($itdirectory,irctunes.ini) 
}
alias itdirectory { 
  return $shortfn($scriptdir)
}
alias itsettings {
  if ($isid == $true) return $readini($itconfig, settings, $1)
  else writeini $itconfig settings $$1 $$2-
}
alias ittemp {
  if ($isid == $true) return $readini($itconfig, temp, $$1)
  else writeini $itconfig temp $$1 $$2 $3-
}
alias itcolor {
  if ($1 == ERROR) { return $+(04,Error:,$chr(32),$2-) } 
  elseif ($1 == WARNING) { return $+(07,Warning:,$chr(32),$2-) }
  elseif ($1 == INFORMATION) { return $+(03,Info:,$chr(32),$2-) }
  elseif ($1 == REMOTE) { return $+(,03,[iRCTunes],,$chr(32),$2-) }
  elseif ($1 == SYNTAX) { return $+(12,Syntax:,$chr(32),$2-) }
}
alias itsilentcomfix {
  if ($com(irctunes)) {
    .comclose irctunes
    .comopen irctunes iTunes.Application 
  }
  else {
    .comopen irctunes iTunes.Application 
  }
}
alias itparsetheme {
  var %ipt $replace($1,^ALBUM^,$itinfo(album),^ARTIST^,$itinfo(artist),^BITRATE^,$itinfo(bitrate))
  var %ipt $replace(%ipt,^BPM^,$itinfo(bpm),^GENRE^,$itinfo(genre),^LENGTH^,$itinfo(length))
  var %ipt $replace(%ipt,^SECLENGTH^,$itinfo(seclength),^LOCATION^,$itinfo(location))
  var %ipt $replace(%ipt,^SHORTLOCATION^,$itinfo(shortlocation),^PLAYCOUNT^,$itinfo(playcount))
  var %ipt $replace(%ipt,^RATING^,$itinfo(rating),^GRAPHRATING^,$itinfo(graphrating))
  var %ipt $replace(%ipt,^NAME^,$itinfo(name),^YEAR^,$itinfo(year),^COMPOSER^,$itinfo(composer))
  var %ipt $replace(%ipt,^COMMENTS^,$itinfo(comments),^MEDIATYPE^,$itinfo(mediatype))
  var %ipt $replace(%ipt,^TRACKCOUNT^,$itinfo(trackcount),^TRACKNUMBER^,$itinfo(tracknumber))
  var %ipt $replace(%ipt,^COMPILATION^,$itinfo(compilation),^SIZE^,$itinfo(size))
  var %ipt $replace(%ipt,^FILETYPE^,$itinfo(filetype),^ALBUMARTIST^,$itinfo(albumartist))

  var %ipt $replace(%ipt,^PLISTNAME^,$itplinfo(name),^PLISTLENGTH^,$itplinfo(length))
  var %ipt $replace(%ipt,^PLISTSECLENGTH^,$itplinfo(seclength))

  var %ipt $replace(%ipt,^STRNAME^,$itstrinfo(title),^STRURL^,$itstrinfo(url))

  var %ipt $replace(%ipt,<BOLD>,$chr(2),</BOLD>,$chr(15),<UNDERLINE>,$chr(31),</UNDERLINE>,$chr(15))
  var %ipt $replace(%ipt,<WHITE>,$+($chr(3),00),<BLACK>,$+($chr(3),01),<BLUE>,$+($chr(3),02))
  var %ipt $replace(%ipt,<DARKGREEN>,$+($chr(3),03),<RED>,$+($chr(3),04),<BROWN>,$+($chr(3),05))
  var %ipt $replace(%ipt,<PURPLE>,$+($chr(3),06),<ORANGE>,$+($chr(3),07),<YELLOW>,$+($chr(3),08))
  var %ipt $replace(%ipt,<GREEN>,$+($chr(3),09),<CYAN>,$+($chr(3),10),<AQUA>,$+($chr(3),11))
  var %ipt $replace(%ipt,<BLUE>,$+($chr(3),12),<PINK>,$+($chr(3),13),<DARKGREY>,$+($chr(3),14))
  var %ipt $replace(%ipt,<DARKGRAY>,$+($chr(3),14),<GREY>,$+($chr(3),15),<GRAY>,$+($chr(3),15))
  var %ipt $replace(%ipt,</COLOR>,$chr(15))

  var %ipt $replace(%ipt,<ENDSPECIAL>,$chr(15),^TRACK^,$itinfo(name))
  return %ipt
}
alias itplinfo {
  if (!$com(irctunes)) return COM Error
  if ($com(CurrentPlaylist)) .comclose CurrentPlaylist
  noop $com(irctunes,CurrentPlayList,3,dispatch* CurrentPlaylist) 
  if ($comerr) || (!$com(CurrentPlaylist)) return COM Error
  if ($1 == name) { 
    noop $com(CurrentPlaylist,Name,3)
    return $iif($com(CurrentPlaylist).result == $null,Unknown Playlist Name,$com(CurrentPlaylist).result)
  }
  elseif ($1 == seclength) { 
    noop $com(CurrentPlaylist,Duration,3)
    return $iif($com(CurrentPlaylist).result == $null,Unknown Playlist Length,$com(CurrentPlaylist).result)
  }
  elseif ($1 == length) { 
    noop $com(CurrentPlaylist,Duration,3)
    if ($com(CurrentPlaylist).result == $null) return Unknown Playlist Length
    elseif ($com(CurrentPlaylist).result > 3600) return $asctime($com(CurrentPlaylist).result,HH:nn:ss)
    else return $asctime($com(CurrentTrack).result,nn:ss)
    return $iif($com(CurrentPlaylist).result == $null,Unknown Playlist Length,$com(CurrentPlaylist).result)
  } 
}
alias itstrinfo {
  if (!$com(irctunes)) return COM Error
  if ($1 == title) {
    noop $com(irctunes,CurrentStreamTitle,3)
    return $iif($com(irctunes).result == $null,Unknown Stream Title,$com(irctunes).result)
  }
  elseif ($1 == url) {
    noop $com(irctunes,CurrentStreamURL,3)
    return $iif($com(irctunes).result == $null,Unknown Stream URL,$com(irctunes).result)
  }
}
alias itinfo {
  if (!$com(irctunes)) return COM Error
  if ($com(CurrentTrack)) .comclose CurrentTrack
  noop $com(irctunes,CurrentTrack,3,dispatch* CurrentTrack) 
  if ($comerr) || (!$com(CurrentTrack)) return COM Error
  if ($1 == name) { 
    noop $com(CurrentTrack,Name,3)
    return $iif(!$com(CurrentTrack).result,Unknown Track Name,$com(CurrentTrack).result)
  }
  elseif ($1 == artist) {
    noop $com(CurrentTrack,Artist,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Artist,$com(CurrentTrack).result)
  }
  elseif ($1 == album) {
    noop $com(CurrentTrack,Album,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Album,$com(CurrentTrack).result)
  }
  elseif ($1 == albumartist) {
    noop $com(CurrentTrack,AlbumArtist,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Album Artist,$com(CurrentTrack).result)
  }
  elseif ($1 == bitrate) {
    noop  $com(CurrentTrack,BitRate,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Bitrate,$com(CurrentTrack).result)
  }
  elseif ($1 == playcount) {
    noop $com(CurrentTrack,PlayedCount,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Playcount,$com(CurrentTrack).result)
  }
  elseif ($1 == rating) {
    noop $com(CurrentTrack,Rating,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Rating,$com(CurrentTrack).result)
  }
  elseif ($1 == genre) {
    noop $com(CurrentTrack,Genre,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Genre,$com(CurrentTrack).result)
  }
  elseif ($1 == bpm) {
    noop $com(CurrentTrack,BPM,3) 
    return $iif(!$com(CurrentTrack).result,Unknown BPM,$com(CurrentTrack).result)
  }
  elseif ($1 == location) {
    noop $com(CurrentTrack,Location,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Location,$com(CurrentTrack).result)
  }
  elseif ($1 == year) {
    noop $com(CurrentTrack,Year,3) 
    return $iif($com(CurrentTrack).result <= 0,Unknown Year,$com(CurrentTrack).result)
  }
  elseif ($1 == composer) {
    noop $com(CurrentTrack,Composer,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Composer,$com(CurrentTrack).result)
  }
  elseif ($1 == mediatype) {
    noop $com(CurrentTrack,KindAsString,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Media Type,$com(CurrentTrack).result)
  }
  elseif ($1 == comments) {
    noop $com(CurrentTrack,Comment,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Comments,$com(CurrentTrack).result)
  }
  elseif ($1 == trackcount) {
    noop $com(CurrentTrack,TrackCount,3) 
    return $iif($com(CurrentTrack).result <= 0,Unknown Track Count,$com(CurrentTrack).result)
  }
  elseif ($1 == tracknumber) {
    noop $com(CurrentTrack,TrackNumber,3) 
    return $iif($com(CurrentTrack).result <= 0,Unknown Track Number,$com(CurrentTrack).result)
  }
  elseif ($1 == seclength) {
    noop $com(CurrentTrack,Duration,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Length, $com(CurrentTrack).result)
  }
  elseif ($1 == shortlocation) {
    noop $com(CurrentTrack,Location,3) 
    return $iif(!$com(CurrentTrack).result,Unknown Location, $shortfn($com(CurrentTrack).result))
  }
  elseif ($1 == compilation) {
    noop $com(CurrentTrack,Compilation,3)
    if ($com(CurrentTrack).result == $true) return yes
    elseif ($com(CurrentTrack).result == $false) return no
    else return Unknown Compilation
  }
  elseif ($1 == filetype) {
    noop $com(CurrentTrack,Location,3)
    if (!$com(CurrentTrack).result) return Unknown File Type
    elseif (!$gettok($com(CurrentTrack).result,2,46)) return Unknown File Type
    else {
      tokenize 46 $com(CurrentTrack).result
      return $upper($eval($+($chr(36),$0),2))
    }
  }
  elseif ($1 == size) {
    noop $com(CurrentTrack,Size,3)
    if (!$com(CurrentTrack).result) {
      return Unknown Size
    }
    elseif ($com(CurrentTrack).result < 1024) {
      var %it.result $com(CurrentTrack).result
      var %it.result $round(%it.result, 2)
      return $+(%it.result,B)
    }
    elseif ($com(CurrentTrack).result < 1048576) {
      var %it.result $calc($com(CurrentTrack).result / 1024)
      var %it.result $round(%it.result, 2)
      return $+(%it.result,KiB)
    }
    elseif ($com(CurrentTrack).result < 1073741824) {
      var %it.result $calc($com(CurrentTrack).result / 1048576)
      var %it.result $round(%it.result, 2)
      return $+(%it.result,MiB)
    }
    else {
      var %it.result $calc($com(CurrentTrack).result / 1073741824)
      var %it.result $round(%it.result, 2)
      return $+(%it.result,GiB)
    }
  }
  elseif ($1 == length) {
    noop $com(CurrentTrack,Duration,3)
    if (!$com(CurrentTrack).result) return Unknown Length
    elseif ($com(CurrentTrack).result > 3600) return $asctime($com(CurrentTrack).result,HH:nn:ss)
    else return $asctime($com(CurrentTrack).result,nn:ss)
  }
  elseif ($1 == graphrating) {
    noop $com(CurrentTrack,Rating,3) 
    if ($com(CurrentTrack).result isnum 0-10) return [.....]
    elseif ($com(CurrentTrack).result isnum 10-29) return [*....]
    elseif ($com(CurrentTrack).result isnum 30-49) return [**...]
    elseif ($com(CurrentTrack).result isnum 50-69) return [***..]
    elseif ($com(CurrentTrack).result isnum 70-89) return [****.]
    elseif ($com(CurrentTrack).result isnum 90-100) return [*****]
    else return Unknown Rating
  }
}
dialog -l it_newver {
  title "iRCTunes :: Update Notifier"
  size -1 -1 180 78
  option dbu
  text "The iRCTunes updater found the following update available for download:", 1, 1 1 178 8
  text "Current iRCTunes version:", 2, 2 10 65 8
  text "Latest iRCTunes version:", 3, 2 19 65 8
  text "Latest version information:", 4, 2 28 65 8
  text $itversion, 5, 69 10 110 8
  text "Loading...", 6, 69 19 110 8
  text "Loading...", 7, 69 28 110 40
  button "Download Update", 8, 1 37 66 10
  button "Remind me later (in 2hrs)", 9, 1 47 66 10
  button "Disable checker and close", 10, 1 57 66 10, ok cancel
  text "iRCTunes :: www.irctunes.net", 11, 1 69 178 8, disable center
}
on *:dialog:it_newver:sclick:8: { 
  run $readini($itconfig, updatecheck, link)
  dialog -x it_newver 
}
on *:dialog:it_newver:sclick:9: { 
  dialog -x it_newver
  .timer 1 7200 itunes checkupdate
}
on *:dialog:it_newver:sclick:10: {
  dialog -x it_newver 
  itsettings checkupdate false
  echo -a iRCTunes has disabled automatic update checking
}
on *:dialog:it_newver:init:*: {
  did -a it_newver 6 $readini($itconfig, updatecheck, version) 
  did -a it_newver 7 $readini($itconfig, updatecheck, information)
}
on *:dialog:it_newver:close:*: { 
  remini $itconfig updatecheck
}
dialog it_about {
  title "iRCTunes :: About"
  size -1 -1 140 100
  option dbu
  tab "Author Credits", 1, 1 0 138 99
  text Author:, 2, 6 18 20 8, tab 1
  text "TheGeekLord  <petpow@thegeeklord.net>", 3, 27 18 110 8, tab 1
  text "TheGeekLord  @ chat.freenode.net", 4, 27 27 110 8, tab 1
  text "About:", 5, 6 36 20 8, tab 1
  text "iRCTunes is an extension for the mIRC Internet Relay Chat (IRC) client. It allows you to command iTunes via simple but effective controls. iRCTunes also allows you to share your music and now playing data over IRC. In addition to this, iRCTunes also has a powerful plugin interface which allows users to create addons which enhances their iRCTunes experience.", 6, 27 36 110 60, tab 1
  tab "Misc Credits", 7
  text TheGeekLord would like to thank:, 8, 8 20 80 8, tab 7
  text "McoreD (beta testing, suggesting new features)", 9, 12 36 120 8, tab 7
  text "iMac600 (creator of iRCTunes for XChat Aqua)", 10, 12 47 120 8, tab 7
  text "Freenode IRC Network (hosting support channel)", 11, 12 58 120 8, tab 7
  text "Google Code (hosting iRCTunes project page)", 12, 12 69 120 8, tab 7
  text "Apple (for creating the iTunes media player)", 13, 12 80 120 8, tab 7
}

dialog -l it_trackinfo {
  title "iRCTunes :: Track Information"
  size -1 -1 160 81
  option dbu
  box Listing information for $nopath($itinfo(location)), 1, 1 1 158 79
  text Name: $itinfo(name), 2, 5 10 150 8
  text Artist: $itinfo(artist), 3, 5 19 150 8
  text Album: $itinfo(album), 4, 5 28 150 8
  text Rating: $itinfo(rating) $+ /100, 5, 5 37 150 8
  button "Play", 6, 5 46 37 10
  button "Pause", 7, 42 46 37 10
  button "Previous", 8, 5 66 37 10
  button "Next", 9, 42 66 37 10
  button "Rewind", 10, 117 46 38 10
  button "Stop", 11, 79 46 38 10
  button "Mute", 12, 5 56 37 10
  button "Unmute", 13, 42 56 37 10
  button "Volume", 14, 79 56 38 10
  button "Resume", 15, 117 56 38 10
  button "Replay", 16, 79 66 38 10
  button "Fast Fwd", 17, 117 66 38 10
}
on *:dialog:it_trackinfo:init:*: .timeriti 0 3 itupdateinfo
on *:dialog:it_trackinfo:close:*: .timeriti off
on *:dialog:it_trackinfo:sclick:6: itunes play
on *:dialog:it_trackinfo:sclick:7: itunes pause
on *:dialog:it_trackinfo:sclick:8: itunes prev
on *:dialog:it_trackinfo:sclick:9: itunes next
on *:dialog:it_trackinfo:sclick:10: itunes rewind
on *:dialog:it_trackinfo:sclick:11: itunes stop
on *:dialog:it_trackinfo:sclick:12: itunes mute
on *:dialog:it_trackinfo:sclick:13: itunes unmute
on *:dialog:it_trackinfo:sclick:14: itunes volume $?="What volume would you like to set iTunes to (enter a number betwen 0 and 100)"
on *:dialog:it_trackinfo:sclick:15: itunes resume
on *:dialog:it_trackinfo:sclick:16: itunes replay
on *:dialog:it_trackinfo:sclick:17: itunes forward
dialog -l it_theming {
  title "iRCTunes Theme Editor"
  size -1 -1 200 166
  option dbu
  tab "Show/Broadcast", 1, 2 0 195 157
  text "Action (/me) Themes", 2, 8 17 55 8, tab 1
  button "• iDemo is listening to 'TRACK' by ARTIST [LENGTH/SIZE/BITRATE]", 3, 20 25 170 15, tab 1 default
  button "• iDemo iTunes: [TRACK|ARTIST|ALBUM]", 4, 20 40 170 15, tab 1
  button "• iDemo iTunes: TRACK - ARTIST", 5, 20 55 170 15, tab 1
  text "Message (/msg) Themes", 6, 7 72 60 8, tab 1
  button "I am listening to TRACK by ARTIST from ALBUM [iRCTunes]", 7, 20 80 170 15, tab 1
  button "iRCTunes :: TRACK - ARTIST - ALBUM", 8, 20 110 170 15, tab 1
  button "Now Playing: TRACK by ARTIST from ALBUM", 9, 20 95 170 15, tab 1
  button "Save", 10, 4 145 95 10, tab 1
  button "Reset", 11, 100 145 95 10, tab 1
  edit "<theme goes here>", 12, 20 134 170 10, tab 1 autohs
  text "Manual Theme Editor", 13, 7 126 55 8, tab 1
  tab Theme Help, 14
  text "iRCTunes Theming Variables", 15, 6 15 185 8, tab 14 center
  edit "", 16, 6 23 185 130, tab 14 read multi autohs autovs vsbar
  text "iRCTunes :: www.irctunes.net", 17, 1 158 198 8, disable center
}
on *:dialog:it_theming:init:*: {
  did -o it_theming 12 1 $itsettings(theme) 

  did -a it_theming 16 == Track Variables ==
  did -a it_theming 16 $crlf $+ ^ALBUM^          :: The album the track belongs to
  did -a it_theming 16 $crlf $+ ^ALBUMARTIST^    :: The album artist who created the track
  did -a it_theming 16 $crlf $+ ^ARTIST^         :: The artist who created the track
  did -a it_theming 16 $crlf $+ ^BITRATE^        :: The bitrate of the track
  did -a it_theming 16 $crlf $+ ^BPM^            :: The beats per minute of the track
  did -a it_theming 16 $crlf $+ ^COMMENTS^       :: Any comments associated with this track
  did -a it_theming 16 $crlf $+ ^COMPILATION^    :: Whether this track part of a compilation
  did -a it_theming 16 $crlf $+ ^COMPOSER^       :: The composer of the track
  did -a it_theming 16 $crlf $+ ^FILETYPE^       :: The file type of the track
  did -a it_theming 16 $crlf $+ ^GENRE^          :: The genre of the track
  did -a it_theming 16 $crlf $+ ^GRAPHRATING^    :: The rating of the track in star form
  did -a it_theming 16 $crlf $+ ^LENGTH^         :: The formatted length of the track
  did -a it_theming 16 $crlf $+ ^LOCATION^       :: The location of the track on your pc
  did -a it_theming 16 $crlf $+ ^MEDIATYPE^      :: The type of file the track is
  did -a it_theming 16 $crlf $+ ^NAME^           :: The name of the track
  did -a it_theming 16 $crlf $+ ^PLAYCOUNT^      :: The number of times this track has been played
  did -a it_theming 16 $crlf $+ ^RATING^         :: The users rating of the track (0 to 100)
  did -a it_theming 16 $crlf $+ ^SECLENGTH^      :: The length of this track in seconds
  did -a it_theming 16 $crlf $+ ^SHORTLOCATION^  :: The short location of the track
  did -a it_theming 16 $crlf $+ ^SIZE^           :: The size of the track in B/KiB/MiB/GiB
  did -a it_theming 16 $crlf $+ ^TRACKCOUNT^     :: The total number of tracks on the album
  did -a it_theming 16 $crlf $+ ^TRACKNUMBER^    :: The ID of this track on the album
  did -a it_theming 16 $crlf $+ ^YEAR^           :: The year the track was recorded/released

  did -a it_theming 16 $crlf $+ == Playlist Variables ==
  did -a it_theming 16 $crlf $+ ^PLISTLENGTH^     :: The formatted length of the track
  did -a it_theming 16 $crlf $+ ^PLISTNAME^       :: The name of the track
  did -a it_theming 16 $crlf $+ ^PLISTSECLENGTH^  :: The length in secs of the playlist


  did -a it_theming 16 $crlf $+ == Stream Variables ==
  did -a it_theming 16 $crlf $+ ^STRNAME^  :: The name of your audio stream
  did -a it_theming 16 $crlf $+ ^STRURL^   :: The url of your audio stream

  did -a it_theming 16 $crlf $+ == Misc Variables ==
  did -a it_theming 16 $crlf $+ <AQUA>        :: Changes the color of the text to aqua
  did -a it_theming 16 $crlf $+ <BLACK>       :: Changes the color of the text to black
  did -a it_theming 16 $crlf $+ <BLUE>        :: Changes the color of the text to blue
  did -a it_theming 16 $crlf $+ <BROWN>       :: Changes the color of the text to brown
  did -a it_theming 16 $crlf $+ <CYAN>        :: Changes the color of the text to cyan
  did -a it_theming 16 $crlf $+ <DARKGREEN>   :: Changes the color of the text to dark green
  did -a it_theming 16 $crlf $+ <DARKGREY>    :: Changes the color of the text to dark grey
  did -a it_theming 16 $crlf $+ <GREEN>       :: Changes the color of the text to green
  did -a it_theming 16 $crlf $+ <GREY>        :: Changes the color of the text to grey
  did -a it_theming 16 $crlf $+ <ORANGE>      :: Changes the color of the text to orange
  did -a it_theming 16 $crlf $+ <PINK>        :: Changes the color of the text to pink
  did -a it_theming 16 $crlf $+ <PURPLE>      :: Changes the color of the text to purple
  did -a it_theming 16 $crlf $+ <RED>         :: Changes the color of the text to red
  did -a it_theming 16 $crlf $+ <WHITE>       :: Changes the color of the text to white
  did -a it_theming 16 $crlf $+ <YELLOW>      :: Changes the color of the text to yellow
  did -a it_theming 16 $crlf $+ </COLOR>      :: Returns all text to normal formatting
  did -a it_theming 16 $crlf $+ <BOLD>        :: Changes the formatting of the text to bold
  did -a it_theming 16 $crlf $+ </BOLD>       :: Returns all text to normal formatting
  did -a it_theming 16 $crlf $+ <UNDERLINE>   :: Changes thte formatting of the text to underline
  did -a it_theming 16 $crlf $+ </UNDERLINE>  :: Returns all text to normal formatting
}
on *:dialog:it_theming:sclick:3: did -o it_theming 12 1 [DESCRIBE] is listening to <BOLD>'^NAME^'</BOLD> by <BOLD>^ARTIST^</BOLD> [^LENGTH^/^SIZE^/^BITRATE^kbps]
on *:dialog:it_theming:sclick:4: did -o it_theming 12 1 [DESCRIBE] iTunes: [^NAME^|^ARTIST^|^ALBUM^]
on *:dialog:it_theming:sclick:5: did -o it_theming 12 1 [DESCRIBE] iTunes: ^NAME^ - ^ARTIST^
on *:dialog:it_theming:sclick:7: did -o it_theming 12 1 I am listening to ^NAME^ by ^ARTIST^ from ^ALBUM^ [iRCTunes]
on *:dialog:it_theming:sclick:8: did -o it_theming 12 1 iRCTunes :: ^NAME^ - ^ARTIST^ - ^ALBUM^
on *:dialog:it_theming:sclick:9: did -o it_theming 12 1 Now Playing: ^NAME^ by ^ARTIST^ from ^ALBUM^
on *:dialog:it_theming:sclick:10: itsettings theme $did(it_theming, 12).text
on *:dialog:it_theming:sclick:11: did -o it_theming 12 1 $itsettings(theme)
dialog -l it_plugins {
  title "iRCTunes :: Plugin Control"
  size -1 -1 139 85
  option dbu
  text "To show information about a script click on its name:", 1, 5 5 130 8
  list 2, 5 15 60 65, sort size vsbar
  text "Status: no plugin selected", 3, 70 15 65 8
  button "Reload", 4, 70 25 65 12, disabled
  button "Unload", 5, 70 39 65 12, disabled
  button "Delete", 6, 70 53 65 12, disabled
  button "View Source", 7, 70 67 65 12, disabled
}
on *:dialog:it_plugins:init:*: {
  var %it.plugin 1
  while (%it.plugin <= $findfile($+($itdirectory,itplugins\),it_*.itp,0)) {
    did -a it_plugins 2 $replace($nopath($findfile($+($itdirectory,itplugins\),it_*.itp,%it.plugin)),.itp,$null)
    inc %it.plugin
  }
}
on *:dialog:it_plugins:sclick:2: {
  did -e it_plugins 4
  did -e it_plugins 6
  did -e it_plugins 7
  if ($script($+($did(it_plugins,2).seltext,.itp))) {
    did -o it_plugins 3 1 Status: Loaded
    did -o it_plugins 4 1 Reload
    did -e it_plugins 5
  }
  else {
    did -o it_plugins 3 1 Status: Not Loaded
    did -o it_plugins 4 1 Load
    did -b it_plugins 5
  }
}
on *:dialog:it_plugins:sclick:4: {
  .reload -rs $+(",$findfile($+($itdirectory,itplugins\),$+($did(it_plugins,2).seltext,.itp),1),")
  dialog -x it_plugins
  dialog -m it_plugins it_plugins
}
on *:dialog:it_plugins:sclick:5: {
  .unload -rs $+(",$findfile($+($itdirectory,itplugins\),$+($did(it_plugins,2).seltext,.itp),1),")
  dialog -x it_plugins
  dialog -m it_plugins it_plugins
}
on *:dialog:it_plugins:sclick:6: {
  if ($script($+($did(it_plugins,2).seltext,.itp))) {
    .unload -rs $script($+($did(it_plugins,2).seltext,.itp))
  }
  .remove -b $+(",$findfile($+($itdirectory,itplugins\),$+($did(it_plugins,2).seltext,.itp),1),")
  dialog -x it_plugins
  dialog -m it_plugins it_plugins
}
on *:dialog:it_plugins:sclick:7: {
  run notepad $+(",$findfile($+($itdirectory,itplugins\),$+($did(it_plugins,2).seltext,.itp),1),")
}
