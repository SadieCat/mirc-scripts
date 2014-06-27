;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Name: mIRC Loaded Script Viewer v2.0            ;
; Author: TheGeekLord <petpow@thegeeklord.net>    ;
; License: GNU General Public License v3.0        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias scripts {
  if ($dialog(loaded_scripts)) dialog -x loaded_scripts
  dialog -m loaded_scripts loaded_scripts
}
dialog -l loaded_scripts {
  title "mIRC :: Loaded Script Viewer"
  size -1 -1 180 130
  option dbu
  text "To begin select a script from the list box below:", 1, 5 5 115 8
  list 2, 5 15 60 110, sort size vsbar
  text "Name: <unknown>", 3, 70 15 100 8
  text "File size: <unknown>", 4, 70 25 100 8
  text "Creation date: <unknown>", 5, 70 35 100 8
  text "Modification date: <unknown>", 6, 70 45 100 8
  text "Lines: <unknown>", 7, 70 55 100 8
  text "On events: <unknown>", 8, 70 65 100 8
  text "Raw events: <unknown>", 9, 70 75 100 8
  text "Aliases: <unknown>", 10, 70 85 100 8
  text "CTCPs: <unknown>", 11, 70 95 100 8
  text "Menus: <unknown>", 12, 70 105 100 8
  text Total number of loaded scripts: $script(0), 13, 70 115 100 8
}
on *:dialog:loaded_scripts:init:*: {
  var %s 1
  while (%s <= $script(0)) {
    did -a loaded_scripts 2 $nopath($script(%s))
    inc %s
  }
}
on *:dialog:loaded_scripts:sclick:2: {
  did -o loaded_scripts 3 1 Name: $did(loaded_scripts,2).seltext
  did -o loaded_scripts 4 1 File size: $+($left($calc($file($script($did(loaded_scripts,2).seltext)).size / 1024),5),KB)
  did -o loaded_scripts 5 1 Creation date: $asctime($file($script($did(loaded_scripts,2).seltext)).ctime,dd/mm/yy hh:nn TT)
  did -o loaded_scripts 6 1 Modification date: $asctime($file($script($did(loaded_scripts,2).seltext)).mtime,dd/mm/yy hh:nn TT)
  did -o loaded_scripts 7 1 Lines: $lines($script($did(loaded_scripts,2).seltext))
  did -o loaded_scripts 8 1 On events: $itemcount($script($did(loaded_scripts,2).seltext),2,on)
  did -o loaded_scripts 9 1 Raw events: $itemcount($script($did(loaded_scripts,2).seltext),3,raw)
  did -o loaded_scripts 10 1 Aliases: $itemcount($script($did(loaded_scripts,2).seltext),5,alias)
  did -o loaded_scripts 11 1 CTCPs: $itemcount($script($did(loaded_scripts,2).seltext),4,ctcp)
  did -o loaded_scripts 12 1 Menus: $itemcount($script($did(loaded_scripts,2).seltext),4,menu)
}
on *:dialog:loaded_scripts:dclick:2: {
  run notepad $script($did(loaded_scripts,2).seltext)
}
alias itemcount {
  var %l 1
  var %i 0
  while (%l <= $lines($1)) {
    if ($left($read($1,n,%l),$2) == $3) inc %i
    inc %l
  }
  return %i
}
