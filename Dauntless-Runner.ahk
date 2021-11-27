#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SIngleInstance force
DEBUG:=1
if(A_Args[1] == "OnlineUpdated" || DEBUG) {
	Sleep 1000
	EXE_Path := Load("EXE_Path")
	FileDelete, %EXE_Path%
	Sleep 500
	FileCopy,%A_AppData%/Dauntless-QOL-%A_Args[2]%.exe, %EXE_Path%
	Sleep 1000
	Run, %EXE_Path%, NewVersion
	exitapp
}
if(Load("AutoStart"))
	Run, Load("EXE_Path")
exitapp