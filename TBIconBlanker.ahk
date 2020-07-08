#NoTrayIcon
#Persistent
#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, Off
SysGet, TBarHeight, 4

Menu, Tray, NoStandard

Gui +LastFound
hWnd := WinExist()

;Hook the shell.
; http://www.autohotkey.com/forum/viewtopic.php?p=123323#123323
DllCall( "RegisterShellHookWindow", UInt, hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str, "SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )

; Create a blank cursor for use instead of a blank icon file.
; http://www.autohotkey.com/forum/viewtopic.php?p=220113#220113
VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
hIcon := DllCall( "CreateCursor", Uint, 0, Int, 0, Int, 0, Int, 32, Int, 32, Uint, &AndMask, Uint, &XorMask )


; ------------------------------------------------------------------------
; Subroutines ------------------------------------------------------------
; ------------------------------------------------------------------------


WatchCursor:
{
    MouseGetPos, , yPos, CurrID,
    If ( yPos >= 0 and yPos < ( TBarHeight + 3 ) )
    {
        SendMessage, 0x80, 0, hIcon, , % "ahk_id " . CurrID ; Blank out titlebar and taskbar icons.
    }
    Else
    {
        SendMessage, 0x80, 0, hIcon, , % "ahk_id " . CurrID ; Blank out titlebar and taskbar icons.
    }
}
Return


; ------------------------------------------------------------------------
; Functions --------------------------------------------------------------
; ------------------------------------------------------------------------

; Shell hook to blank out windows that are subsequently created.
ShellMessage( wParam, lParam )
{
    Global hIcon, MinMaxCloseOption, PrevID
    If wParam in 1,6,32772
    {
        SendMessage, 0x80, 0, hIcon, , % "ahk_id " . lParam ; Blank out titlebar and taskbar icons.
    }
    PrevID := lParam
}
