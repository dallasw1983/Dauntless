; Author: RitZ
; Purpose: This script contains different utilities for QOL improvements
; Usage: Script works in Fullscreen or Borderless Window mode with 1080p resolution (I use 1920x1080) and Default keybinds. 
; Some snippets with clicks might not fully work with other resolutions. 
; If anyone made their own coordinates for 1440p or other resolutions do share with me so I can create a separate version. You need to use Window Spy (right click AHK in taskbar) and take "client" coordinates.
; To change in-game keybinds to something else, see Defaults section below.

; Defaults
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SIngleInstance Force
#InstallKeybdHook
#InstallMouseHook
CoordMode, Mouse, Client

tmp:=Load("Version")
Menu, Tray, NoDefault
Menu, Tray, NoStandard
Menu, Tray, Add, Check for update Ver%tmp%, UpdateCheckMenu
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add,Reload,ReloadApp
Menu, Tray, Add,Exit,QuitApp

GroupAdd, DauntlessRelated, Shortcuts and their uses 
GroupAdd, DauntlessRelated, Cell Recycle
GroupAdd, DauntlessRelated, RitZ's quick escalation reload script
GroupAdd, DauntlessRelated, RitZ's quick hunting ground reload script

Save("EXE_Path", A_ScriptFullPath)

SetTimer,UpdateCheck, 3600000
GoSub, UpdateCheck


if(!Load("FirstRun")) {
	if(!FileExist(A_AppData . "\DauntlessQOL"))
		FileCreateDir, %A_AppData%\DauntlessQOL
	Loop, Files, %A_AppData%\DauntlessQOL
	{
	if(A_LoopFileExt != "ini")
		FileDelete, A_LoopFileFullPath
	}
	FileDelete, %A_Startup%\Dauntless-Runner.exe
	
	FileInstall, images\Dauntless-Chat.png, %A_AppData%\DauntlessQOL\Dauntless-Chat.png
	FileInstall, images\Dauntless-Emoji.png, %A_AppData%\DauntlessQOL\Dauntless-Emoji.png
	FileInstall, images\Dauntless-Emote.png, %A_AppData%\DauntlessQOL\Dauntless-Emote.png
	FileInstall, images\Dauntless-CellBurn.png, %A_AppData%\DauntlessQOL\Dauntless-CellBurn.png
	
	FileInstall, Dauntless-Runner.exe, %A_Startup%\Dauntless-Runner.exe
	
	FileGetSize, file_size , %A_AppData%\DauntlessQOL\Dauntless-Chat.png, K
	if(file_size == 0)
		reload
}

if(!Load("FirstRun") || A_Args[1] == "NewVersion") {
	GoSub, HelpScreen
	Save("FirstRun",1)
}
;FileDelete, %A_AppData%\Dauntless-QOL-Settings.ini

Dauntless_Time_Move := 10000
Dauntless_Time_Idle := 0
QS_7 := [967,174,1254,284,1384,568,1204,807,715,808,601,547,715,270]
QS_6 := [710,122,471,347,481,773,729,899,1490,781,1592,223]

SetTimer,IdleCheck,5000
DefaultEmoteKeybind := True
global EmoteKeybind := DefaultEmoteKeybind ? "c" : "v"
; To change this keybind replace y with unused key desired (apart from special keys like Shift, Control, Alt). Remember to bind the same key in-game to Sprint
global SprintKeybind := "y"
global HuntKeybind := "h"
global InteractKeybind := "e"
global HuntingGroundChosen := ""
global HuntingGroundNames := ["Emberthorn Cove         (1 - 2)","Boreal Outpost          (1 - 3)","Revelation Rock         (2 - 4)","Restless Sands          (3 - 5)","Iron Falls              (4 - 6)","Sunderstone             (5 - 8)","Aulric's Peak           (6 - 9)","Frostmarch              (7 - 10)","Thunderwatch            (8 - 11)","Fortune's Folly         (9 - 12)","Brightwood              (10 - 13)","Conundrum Rocks         (10 - 13)","Coldrunner Key          (11 - 14)","The Snowblind Waste     (12 - 15)","Undervald Defile        (13 - 16)","Cape Fury               (14 - 17)","Hades Reach             (15 - 18)","Razorcliff Isle         (16 - 19)","The Paradox Breaks      (16 - 19)","Twilight Sanctuary      (17 - 20)","The Blazeworks          (20 - 24)"]
global HuntingGroundTotal := NumGet(&HuntingGroundNames + 4*A_PtrSize)
global HuntingGroundPrivateHunt := False
global EscalationChosen := ""
global EscalationLevelChosen := ""
global EscalationNames := ["Shock","Blaze","Umbral","Terra","Frost","Patrol","Heroic"]
global EscalationTotal := NumGet(&EscalationNames + 4*A_PtrSize)
global EscalationPrivateHunt := False

~F6::suspend
!R::Reload

IdleCheck:
	if(A_TimeIdle > Dauntless_Time_Move && WinExist("Dauntless ahk_class UnrealWindow")) {
		if(A_TimeIdle - Dauntless_Time_Idle > Dauntless_Time_Move) {
			WinActivate, Dauntless
			Send {w down}
			sleep 350
			Send {w up}
			sleep 350
			Send {s down}
			sleep 350
			Send {s up}
			Dauntless_Time_Idle := A_TimeIdle
		}
	}
Return
GUIPoints:
Gui,Main:Font,bold cBlack s10
Gui,Main:add,text,y+15,%a%
Gui,Main:Font,bold cRed s10
Gui,Main:add,text,x+5,%b%
Gui,Main:font,
Gui,Main:font,s10
Gui,Main:add,text,y+1 xm,%c%
return

QuickSetAction:
Gui,Main:submit,nohide
Save("QuickSetValue",QuickSetValue)
if(QuickSetValue==1)
GuiControl,,EmotePicture, %A_AppData%\Dauntless-Emote.png
if(QuickSetValue==2)
GuiControl,,EmotePicture, %A_AppData%\Dauntless-Chat.png
if(QuickSetValue==3)
GuiControl,,EmotePicture, %A_AppData%\Dauntless-Emoji.png
return

GUITabYMargin:
Gui,Main:add,text,ym xm,
return
HelpScreen:
QuickSetValue := Load("QuickSetValue")
if(!QuickSetValue)
	QuickSetValue = 1
if(QuickSetValue == 1)
	pic_path=%A_AppData%\Dauntless-Emote.png
if(QuickSetValue == 2)
	pic_path=%A_AppData%\Dauntless-Chat.png
if(QuickSetValue == 3)
	pic_path=%A_AppData%\Dauntless-Emoji.png
Gui,Main:new
Gui,Main: Add, Tab3, gQuickSetAction, Hunting|Ramsgate|Quick Wheel|Misc

Gui,Main:Tab,1
Gui,Main: Margin, 20
GoSub, GUITabYMargin

a = Board Air Ship - 
b = Alt + C
c = Accept hunt and enter airship.
GoSub, GUIPoints

Gui,Main:Font,bold cGreen s12
Gui,Main:add,text,,Hunting

a = (Re)Load Hunt - 
b = Alt + D
c = Quickly reload hunting ground chosen from the list. `nOnce chosen, the choice is remembered until SCRIPT RELOAD.
GoSub, GUIPoints

a = (Re)Load Hunt Private - 
b = Alt + Shift + D
c = Same as above, but for PRIVATE.
GoSub, GUIPoints

Gui,Main:Font,bold cGreen s12
Gui,Main:add,text,,Escalation

a = (Re)Load Escalation - 
b = Alt + E
c = Quickly reload Escalation chosen from the list. `nOnce chosen, the choice is remembered until SCRIPT RELOAD.
GoSub, GUIPoints

a = (Re)Load Escalation Private - 
b = Alt + Shift + E
c = Same as above, but for PRIVATE.
GoSub, GUIPoints

a = Finish Escalation - 
b = Alt + F
c = End Escalation without looking at details.
GoSub, GUIPoints

Gui,Main:Font,bold cGreen s12
Gui,Main:add,text,,MISC

a = RELOAD SCRIPT - 
b = Alt + R
c = Reloads the script to clear remembered choices
GoSub, GUIPoints

Gui,Main:Tab,2
GoSub, GUITabYMargin

a = Craft Iterms - 
b = Alt + L
c = Craft X amount of items
GoSub, GUIPoints

a = Open Cores - 
b = Alt + P
c = Choosing open by 10 and amount 2 will open 20 cores.
GoSub, GUIPoints

a = Buy Ozz Things - 
b = Alt + Shift + [1 to 3]
c = How many times to buy first to third item at Ozz event shop `n(Note: If there's nothing at that position it will buy the bottommost item.)
GoSub, GUIPoints

a = Pick Up Items - 
b = Alt + Q
c = Repeatedly E (to collect about 50 gifts)
GoSub, GUIPoints


a = Burn Cells - 
b = Alt + M
c = Repeatedly burn cells at MiddleMan
GoSub, GUIPoints

Gui,Main:Tab,3
GoSub, GUITabYMargin

a = Action -
b = Alt + [1-7]
c = Do a quick action. Choose the quick action from the list.
GoSub, GUIPoints
	
Gui,Main:Add,DropDownList, x256 y30 vQuickSetValue Choose%QuickSetValue% AltSubmit gQuickSetAction, Emote||Chat|Emoji
Gui,Main: Add, Picture, vEmotePicture w430 xm y+25 h-1, % pic_path

Gui,Main:Tab,4
GoSub, GUITabYMargin

a=Pause
b=F5
c=to suspend the script
GoSub, GUIPoints

a=Reload
b=Alt + R 
c=Reload the script
GoSub, GUIPoints

a=Help Screen
b=Alt + ?
c=bring up this help screen
GoSub, GUIPoints

a=Toggle Sprint
b=Shift
c=once to toggle auto-sprint - `nPre-requisite: Add Y as Sprint keybind in-game
GoSub, GUIPoints

a=Help I'm Stucke
b=Alt + H
c=to do Help am stuck
GoSub, GUIPoints

a=Quit this helper
b=Alt + Shift + Q
c=To Quit this helper script
GoSub, GUIPoints

AutoStartChoice := Load("AutoStart")
Gui,Add,Checkbox,vAutoStartChoice Checked%AutoStartChoice% gAutoStartChoice,Auto Start on CPU bootup?

; Gui,Main:Tab,4

Gui,Main:+AlwaysOnTop +Resize -MaximizeBox -MinimizeBox +LastFound
Gui,Main:show, h515 w485,Shortcuts and their uses
return

; Restrict all snippets below this line to only trigger if Dauntless window is active. Comment with ; to test outside Dauntless
#IfWinActive, ahk_group DauntlessRelated
!/::
	if(!WinExist(Shortcuts and their uses)) {
		GoSub, HelpScreen
	} else {
		WinActivate, Shortcuts and their uses
	}
	
return
!+Q:
ExitApp

!m::
s =
(
Enter qty to burn.`nHold Escape or Space to stop.`nThis will start at the bottom of the screen.
)
Gui,Main:New
Gui,Main:add,text,, % s
GUi,Main:add,edit,vCellRecycleCount,
Gui,Main:add,button,Default gCellRecycleSubmit, Submit
Gui,Main:add,Picture, w500 h-1, %A_AppData%\Dauntless-CellBurn.png
Gui,Main: +AlwaysOnTop -MaximizeBox -MinimizeBox +LastFound
Gui,Main:show, x85 y196, Cell Recycle
return

CellRecycleSubmit:
Gui,Main:Submit
BlockInput, On
BlockInput, MouseMove 
WinActivate, Dauntless
MouseMove, 1009,701
loop, % CellRecycleCount
{
	Send, {LButton down}
	Sleep 760
	Send, {LButton up}
	Sleep 260
	if(GetKeyState("Space", "P") == 1 || GetKeyState("Escape", "P") == 1)
		break
}
BlockInput, Off
BlockInput, MouseMoveOff
Return

; To close an opened window with Esc key
MainGuiEscape:
    Gui,Main: Cancel
	WinActivate, Dauntless
    Return
	
GuiEscape:
    Gui,Main: Cancel
	WinActivate, Dauntless
    Return

; Press Shift once to toggle auto-sprint - Pre-requisite: Replace Shift with Y as Sprint keybind in-game
Shift::
    pressed := !pressed
    If pressed
    {
        SendInput {%SprintKeybind% down}
    }
    Else
    {
        SendInput {%SprintKeybind% up}
    }
    Return

; Press Alt + C to accept hunt and enter airship
!C::
    Send %HuntKeybind%
    Sleep, 100
    Click 416, 938
    Return
    
; Press Alt + F to accept end of hunt and exit without looking at details of hunt
!F::
    Loop, 4
    {
        Click 1808, 1013
        Sleep, 100
    }
    Return

; Press Alt + D to reload hunting ground chosen in the list. Once chosen, the choice is remembered until you close or reload the script. To reload the script do Alt + R.
!D::
    ReloadHuntingGround()
    Return

; Press Alt + Shift + D to reload private hunting ground chosen in the list. Once chosen, the choice is remembered until you close or reload the script. To reload the script do Alt + R.
!+D::
    ReloadHuntingGround(True)
    Return
    
; Press Alt + Shift + 1 to enter how many times to buy first item at Ozz event shop
!+1::
    BuyEventItemAtPos(1)
    Return

; Press Alt + Shift + 2 to enter how many times to buy second item at Ozz event shop
!+2::
    BuyEventItemAtPos(2)
    Return

; Press Alt + Shift + 3 to enter how many times to buy third item at Ozz event shop (Note: If there's nothing at that position it will buy the bottommost item.)
!+3::
    BuyEventItemAtPos(3)
    Return

; Press Alt + N to do Frostfall Gift curiosity and collect them - Pre-requisite: Set Frostfall Gift in bottom right slot
!N::
    ConfigureCuriosityEmote("Frostfall Gift curiosity", "Please enter the amount of times to repeat bottom right curiosity slot:", 1074, 710, 1244, 840, 1074, 710, 1244, 840)
    Return

; Press Alt + B to do Frostfall Cauldron curiosity and collect them - Pre-requisite: Set Frostfall Cauldron in bottom left slot
!B::
    ConfigureCuriosityEmote("Frostfall Cauldron curiosity", "Please enter the amount of times to repeat bottom left curiosity slot:", 1074, 710, 1244, 840, 790, 694, 456, 988)
    Return

; Press Alt + Shift + N to drop Frostfall Gift curiosity 10 at a time and collect about 50, then repeat for the remainder of the total given - Pre-requisite: Set Frostfall Gift in bottom right slot
!+N::
    ConfigureCuriosityEmote("Frostfall Gift curiosity (Gift Party mode)", "Please enter how many to give in total for bottom right curiosity slot (enter multiple of 10):", 1074, 710, 1244, 840, 1074, 710, 1244, 840, True)
    Return

; Press Alt + Shift + B to drop Frostfall Cauldron curiosity 10 at a time and collect about 50, then repeat for the remainder of the total given - Pre-requisite: Set Frostfall Cauldron in bottom left slot
!+B::
    ConfigureCuriosityEmote("Frostfall Cauldron curiosity (Gift Party mode)", "Please enter how many to give in total for bottom left curiosity slot (enter multiple of 10):", 1074, 710, 1244, 840, 790, 694, 456, 988, True)
    Return

; Press Alt + Q to Repeatedly press E (to collect about 50 gifts)
!Q::
    CollectMultipleTimes()
    Return

!1::
if(!QuickSetValue)
	QuickSetValue := Load("QuickSetValue")
if(QuickSetValue == 1)
	DoQuickEmote(QS_6[1],QS_6[2])
if(QuickSetValue == 2)
	DoQuickChat(QS_7[1],QS_7[2])
if(QuickSetValue == 3)
	DoQuickEmoji(QS_7[1],QS_7[2])
return
!2::
if(!QuickSetValue)
	QuickSetValue := Load("QuickSetValue")
if(QuickSetValue == 1)
	DoQuickEmote(QS_6[3],QS_6[4])
if(QuickSetValue == 2)
	DoQuickChat(QS_7[3],QS_7[4])
if(QuickSetValue == 3)
	DoQuickEmoji(QS_7[3],QS_7[4])
return
!3::
if(!QuickSetValue)
	QuickSetValue := Load("QuickSetValue")
if(QuickSetValue == 1)
	DoQuickEmote(QS_6[5],QS_6[6])
if(QuickSetValue == 2)
	DoQuickChat(QS_7[5],QS_7[6])
if(QuickSetValue == 3)
	DoQuickEmoji(QS_7[5],QS_7[6])
return
!4::
if(!QuickSetValue)
	QuickSetValue := Load("QuickSetValue")
if(QuickSetValue == 1)
	DoQuickEmote(QS_6[7],QS_6[8])
if(QuickSetValue == 2)
	DoQuickChat(QS_7[7],QS_7[8])
if(QuickSetValue == 3)
	DoQuickEmoji(QS_7[7],QS_7[8])
return
!5::
if(!QuickSetValue)
	QuickSetValue := Load("QuickSetValue")
if(QuickSetValue == 1)
	DoQuickEmote(QS_6[9],QS_6[10])
if(QuickSetValue == 2)
	DoQuickChat(QS_7[9],QS_7[10])
if(QuickSetValue == 3)
	DoQuickEmoji(QS_7[9],QS_7[10])
return
!6::
if(!QuickSetValue)
	QuickSetValue := Load("QuickSetValue")
if(QuickSetValue == 1)
	DoQuickEmote(QS_6[11],QS_6[12])
if(QuickSetValue == 2)
	DoQuickChat(QS_7[11],QS_7[12])
if(QuickSetValue == 3)
	DoQuickEmoji(QS_7[11],QS_7[12])
return
!7::
if(!QuickSetValue)
	QuickSetValue := Load("QuickSetValue")
if(QuickSetValue == 1)
	Return
if(QuickSetValue == 2)
	DoQuickChat(QS_7[13],QS_7[14])
if(QuickSetValue == 3)
	DoQuickEmoji(QS_7[13],QS_7[14])
return

; Press Alt + P to open X amount of cores at Core breaker
!P::
    SetTimer, ChangeButtonNames, 50
    Gui +LastFound +OwnDialogs +AlwaysOnTop
    MsgBox, 35, RitZ's Core opening script, Please choose by how much to open the selected cores:
    WinShow, Dauntless
    WinActivate, Dauntless
    Key := "Enter"
    IfMsgBox, Yes
        Key := "Enter"
    Else IfMsgBox, No
        Key := "X"
    Else
        Return

    iterations := ConfigureInputBox("Core opening", "Please enter the amount of times to open selected cores:")
    Loop, %iterations%
    {
		BlockInput, On
        Send {%Key%}
        Sleep, 4300
        Send {Esc}
        Send {Esc}
        Sleep, 100
		BlockInput, Off
    }

    ChangeButtonNames: 
    IfWinNotExist, RitZ's Core opening script
        Return  ; Keep waiting
    SetTimer, ChangeButtonNames, Off
    WinActivate
    ControlSetText, Button1, &1
    ControlSetText, Button2, &10
    Return

; Press Alt + L to craft X amount of items
!L::
    SetTimer, ChangeButtonNamesCrafting, 50
    Gui +LastFound +OwnDialogs +AlwaysOnTop
    MsgBox, 35, RitZ's Crafting script, Please choose by how much to craft the selected item:
    WinShow, Dauntless
    WinActivate, Dauntless
    Key := "R"
    ; Craft by 1
    IfMsgBox, Yes
        Key := "E"
    ; Craft by 10
    Else IfMsgBox, No
        Key := "R"
    Else
        Return

    iterations := ConfigureInputBox("Crafting", "Please enter the amount of times to craft selected item:")
    Loop, %iterations%
    {
		BlockInput, On
        Send {%Key% down}
        ; Craft by 10 need more delay
        Sleep, %Key% == "E" ? 1500 : 2000
        Send {%Key% up}
		BlockInput, Off
    }

    ChangeButtonNamesCrafting:
    IfWinNotExist, RitZ's Crafting script
        Return  ; Keep waiting
    SetTimer, ChangeButtonNamesCrafting, Off
    WinActivate
    ControlSetText, Button1, &1
    ControlSetText, Button2, &10
    Return

; Press Alt + H to do Help am stuck
!H::
	
	BlockInput, On
    Send {Esc}
    Sleep, 50
    Loop, 15
    {
        Send {Down}
    }
    Send {Up}
    Send {Space}
    Sleep, 50
    Send {Space}
	BlockInput, Off
    Return

; Press Alt + E to reload Escalation chosen in the list. Once chosen, the choice is remembered until you close or reload the script. To reload the script do Alt + R.
!E::
    ReloadEscalation()
    Return

; Press Alt + Shift + E to reload private Escalation chosen in the list. Once chosen, the choice is remembered until you close or reload the script. To reload the script do Alt + R.
!+E::
    ReloadEscalation(True)
    Return 
;Subs

UpdateCheckMenu:
tmp := 1
GoSub, UpdateCheck
return

ReloadApp:
Reload

QuitApp:
ExitApp


UpdateCheck:
{
if(!A_Args[1] == "NewVersion") {
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://raw.githubusercontent.com/dallasw1983/Dauntless/main/version", true)
	whr.Send()
	whr.WaitForResponse()
	OnlineVersion := SubStr(whr.ResponseText, 1, 3)

	if(OnlineVersion > Load("Version")) {
		s:="New version: " . OnlineVersion . ",Get er done?"
		MsgBox, 4, Update, %s%, 30
			ifmsgbox Yes 
			{
				UrlDownloadToFile, https://github.com/dallasw1983/Dauntless/raw/main/Dauntless-QOL.exe, %A_AppData%/Dauntless-QOL-%OnlineVersion%.exe
				if(!FileExist(%A_Startup% . "\Dauntless-Runner.exe")) {
					FileInstall, Dauntless-Runner.exe, %A_Startup%\Dauntless-Runner.exe	
				}
				Run, %A_Startup%\Dauntless-Runner.exe OnlineUpdated
				exitapp
			}
		}
	}
if(tmp) {
	Msgbox,0,Update Checked, No New updates
	tmp=
}
return
}

AutoStartChoice:
gui,submit,nohide
Save("AutoStart",AutoStartChoice)
return

;Functions


DoQuickEmote(endCoorX, endCoorY)
{
	If(!DQC_Enable) {
	KeyWait, Alt, U
	KeyWait, Shift, U	
	DQC_Enable:=1
	BlockInput, On
	BlockInput, MouseMove
    Send {%EmoteKeybind% down}
	sleep 35
	MouseMove, 649,540
	Sleep 25
	MouseMove,%endCoorX%, %endCoorY%
	Sleep 25
	MouseClick,L,%endCoorX%, %endCoorY%
	Sleep 25
    Send {%EmoteKeybind% up}
	BlockInput, Off
	BlockInput, MouseMoveOff
	DQC_Enable:=0
	}
}
DoQuickChat(endCoorX, endCoorY)
{
	If(!DQC_Enable) {
	KeyWait, Alt, U
	KeyWait, Shift, U	
	DQC_Enable:=1
	BlockInput, On
	BlockInput, MouseMove
    Send {%EmoteKeybind% down}
	sleep 35
	MouseMove, 1073,540
	Sleep 25
	MouseClick,L,1073,540
	Sleep 50
	MouseMove,%endCoorX%, %endCoorY%
	Sleep 25
	MouseClick,L,%endCoorX%, %endCoorY%
	Sleep 55
    Send {%EmoteKeybind% up}
	BlockInput, Off
	BlockInput, MouseMoveOff
	DQC_Enable:=0
	}
}

DoQuickEmoji(endCoorX, endCoorY)
{
	If(!DQE_Enable) {
	KeyWait, Alt, U
	KeyWait, Shift, U	
	DQC_Enable:=1
	BlockInput, On
	BlockInput, MouseMove
    Send {%EmoteKeybind% down}
	sleep 35
	MouseMove, 662,528
	Sleep 25
	MouseClick,L,662,528
	Sleep 50
	MouseMove,%endCoorX%, %endCoorY%
	Sleep 25
	MouseClick,L,%endCoorX%, %endCoorY%
	Sleep 55
    Send {%EmoteKeybind% up}
	BlockInput, Off
	BlockInput, MouseMoveOff
	DQE_Enable:=0
	}
}

CollectMultipleTimes()
{
    iterations := 150
    Loop, %iterations%
    {
        Interact()
    }
}

DoCuriosityEmote(startCoorX1, startCoorY1, endCoorX1, endCoorY1, startCoorX2, startCoorY2, endCoorX2, endCoorY2)
{
	
	BlockInput, On
	BlockInput, MouseMove
    Send {%EmoteKeybind% down}
    MouseClickDrag, L, startCoorX1, startCoorY1, endCoorX1, endCoorY1
    MouseClickDrag, L, startCoorX2, startCoorY2, endCoorX2, endCoorY2
    Send {%EmoteKeybind% up}
	BlockInput, Off
	BlockInput, MouseMoveOff
    Sleep, 2000
}

Interact()
{
	BlockInput, On
    Send %InteractKeybind%
	BlockInput, Off
    Sleep, 100
}

ConfigureInputBox(scriptType, scriptDesc)
{
    Gui +LastFound +OwnDialogs +AlwaysOnTop
    InputBox, userInput, RitZ's %scriptType% script, %scriptDesc%
    WinShow, Dauntless
    WinActivate, Dauntless
    Return userInput
}

ConfigureCuriosityEmote(scriptType, scriptDesc, startCoorX1, startCoorX2, endCoorX1, endCoorX2, startCoorY1, startCoorY2, endCoorY1, endCoorY2, giftParty := False)
{
    iterations := ConfigureInputBox(scriptType, scriptDesc)
    if (!giftParty) 
    {
        Loop, %iterations%
        {
            DoCuriosityEmote(startCoorX1, startCoorX2, endCoorX1, endCoorX2, startCoorY1, startCoorY2, endCoorY1, endCoorY2)
        }
        Sleep, 300
        iterations := (iterations*3)
        Loop, %iterations%
        {
            Interact()
        }
        Return
    }
    
    iterations := iterations//10
    Loop, %iterations%
    {
        Loop, 10
        {
            DoCuriosityEmote(startCoorX1, startCoorX2, endCoorX1, endCoorX2, startCoorY1, startCoorY2, endCoorY1, endCoorY2)
        }
        CollectMultipleTimes()
    }
}

BuyEventItemAtPos(position)
{
    quantity := ConfigureInputBox("Ozz event item auto purchase", "Please enter how many times to purchase the item in position " . position . " from the top:")
    Loop, %quantity%
    {
        ; Reset position
        Loop, 4
        {
			BlockInput, On
            Send {Up}
			BlockInput, Off
        }
        iterations := position - 1
        Loop, %iterations%
        {
			BlockInput, On
            Send {Down}
			BlockInput, Off
            Sleep, 50
        }
		BlockInput, On
        Send X
		BlockInput, Off
        Sleep, 200
		BlockInput, On
        Send {Enter}
		BlockInput, Off
        Sleep, 4000
    }
}

ReloadHuntingGround(privateHunt := False)
{
    ; If private use 2nd coordinate (after the "?") otherwise use 1st one
    xCoordinate := !privateHunt ? 954 : 1566
    yCoordinate := !privateHunt ? 876 : 1019

    ; If no hunting ground choice was saved, create list of choices
    If (!HuntingGroundChosen)
    {
        GetReloadHuntingGroundGUI()
        HuntingGroundPrivateHunt := privateHunt
        Return

        OnSubmitHuntingGround:
        CommonSubmitGUIOptions()
        ; Call this function again
        ReloadHuntingGround(HuntingGroundPrivateHunt)
        Return
    }

    ; Navigate to chosen hunting ground
	BlockInput, On
    Send %HuntKeybind%
    Sleep, 150
    Send {Space}
    Sleep, 150
    Loop, %HuntingGroundTotal%
    {
        Send {Up}
        Sleep, 25
    }
    iterations := HuntingGroundChosen - 1
    Loop, %iterations%
    {
        Send {Down}
        Sleep, 25
    }
    Sleep, 160
	BlockInput, MouseMove
    Loop, 2
    {
		MouseMove,  %xCoordinate%, %yCoordinate%
        Click, %xCoordinate%, %yCoordinate%
        Sleep, 25
    }
	BlockInput, MouseMoveOff
    ContinueWithLowWpn(privateHunt)
    Send {Esc}
	BlockInput, Off
    Return
}

ReloadEscalation(privateHunt := False)
{
    ; If private use 2nd coordinate (after the "?") otherwise use 1st one
    xCoordinate := !privateHunt ? 954 : 1566
    yCoordinate := !privateHunt ? 876 : 1019

    ; If no escalation choice was saved, create list of choices
    If (!EscalationChosen)
    {
        GetReloadEscalationGUI()
        EscalationPrivateHunt := privateHunt
        Return

        OnSubmitEscalation:
        CommonSubmitGUIOptions()
        ; Call this function again
        ReloadEscalation(EscalationPrivateHunt)
        Return
    }

    ; Navigate to chosen escalation
	BlockInput, On
    Send %HuntKeybind%
    Sleep, 150
    Send {Down}
    Send {Space}
    Sleep, 150
    iterations := EscalationChosen - 1
    Loop, %iterations%
    {
        Send {Down}
        Sleep, 25
    }
    Send {Space}
    Sleep, 150
    iterations := EscalationLevelChosen - 1
    Loop, %iterations%
    {
        Send {Down}
        Sleep, 25
    }
    Sleep, 120
	BlockInput, MouseMove
	MouseMove, %xCoordinate%, %yCoordinate%
    Click, %xCoordinate%, %yCoordinate%
	BlockInput, MouseMoveOff
    ContinueWithLowWpn(privateHunt)
	Sleep, 25
    Send {Esc}
	BlockInput, Off
    Return
}

ArrayToConfigString(Array)
{
    Str := ""
    For Index, Value In Array
       Str .= Value . "|"
    Str .= "|"
    Return Str
}

CommonReloadGUIOptions()
{
    Gui,Main: Destroy
    Gui +AlwaysOnTop
    Gui,Main: -MinimizeBox -MaximizeBox
}

CommonSubmitGUIOptions()
{
    Gui,Main: Submit
    WinShow, Dauntless
    WinActivate, Dauntless
}

GetReloadHuntingGroundGUI()
{
    CommonReloadGUIOptions()
    Gui,Main: Add, Text,, Select the hunting ground to quick reload and press the Submit button
    huntingGroundsStr := ArrayToConfigString(HuntingGroundNames)
    Gui,Main: Font, s10, Consolas
    Gui,Main: Add, ListBox, w300 r%HuntingGroundTotal% vHuntingGroundChosen AltSubmit, %huntingGroundsStr%
    Gui,Main: Add, Button, Default gOnSubmitHuntingGround, Submit
	Gui,Main: +AlwaysOnTop
    Gui,Main: Show, AutoSize Center, RitZ's quick hunting ground reload script
}

GetReloadEscalationGUI()
{
    CommonReloadGUIOptions()
    Gui,Main: Add, Text,, Select the escalation and level to quick reload and press the Submit button
    escalationsStr := ArrayToConfigString(EscalationNames)
    Gui,Main: Font, s10, Consolas
    Gui,Main: Add, ListBox, w300 r%EscalationTotal% vEscalationChosen AltSubmit, %escalationsStr%
    Gui,Main: Add, Radio, AltSubmit vEscalationLevelChosen, 1 - 13
    Gui,Main: Add, Radio, AltSubmit x+20 Checked, 10 - 50
    Gui,Main: Add, Button, Default gOnSubmitEscalation xs, Submit
	Gui,Main: +AlwaysOnTop
    Gui,Main: Show, AutoSize Center, RitZ's quick escalation reload script
}

ContinueWithLowWpn(privateHunt)
{
    If (privateHunt)
    {
        Sleep, 100
        Click, 842, 698
    }
}