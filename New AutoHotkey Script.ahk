#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SIngleInstance force
#InstallKeybdHook
#InstallMouseHook
CoordMode, Mouse, Client

run, %A_AppData%\DauntlessQOL\
exitapp
return

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from menu %A_ThisMenu%.
return
msgbox
return

FileGetSize, OutputVar , %A_ApPData%\Dauntless-Chat.png, K
msgbox,% OutputVar
return


MButton::
MouseGetPos, x, y
str.= x . "," . y . ","
clipboard:= str
return
