; AutoHotKey script
; Note that backtic (`) is escape character; be sure to escape commas even inside strings!

SetTitleMatchMode, RegEx
SetTitleMatchMode, Fast

; Sleep and reload, because Windows seems to fight with these shortcut keys
; FileAppend, %A_NOW% Script loaded`, sleeping...`n, C:\Log\ahk.log
; MsgBox, "Script loaded, sleeping..."
; Sleep, 60000
; Reload

tzoffset()
{
    ;Returns ISO-8601 time zone offset from UTC in form "{+|-}HH:MM".
    ;Completely insane snippet from https://www.autohotkey.com/boards/viewtopic.php?t=65544#time_zone_dst
    ;
    VarSetCapacity(TIME_ZONE_INFORMATION, 172, 0)
    vRet := DllCall("kernel32\GetTimeZoneInformation", "Ptr",&TIME_ZONE_INFORMATION, "UInt")
    oArray := ["unknown", "no", "yes"]
    vIsDST := oArray[vRet+1]
    vBias := NumGet(&TIME_ZONE_INFORMATION, 0, "Int")
    vStdOffset := vBias + NumGet(&TIME_ZONE_INFORMATION, 84, "Int")
    vDltOffset := vBias + NumGet(&TIME_ZONE_INFORMATION, 168, "Int")
    if (vRet = 1) ;TIME_ZONE_ID_STANDARD := 1
    vOffset := vStdOffset
    else if (vRet = 2) ;TIME_ZONE_ID_DAYLIGHT := 2
    vOffset := vDltOffset
    else ;TIME_ZONE_ID_UNKNOWN := 0
    vOffset := ""
    vOffsetH := Floor( Abs( vOffset)/60)                  ; Hours
    vOffsetM := Abs( vOffset) - 60 * vOffsetH             ; Minutes
    ; Format tzoffset for use in timestamps
    vOffsetHHMM := (vOffset>0?"-":"+") Format( "{1:02d}:{2:02d}", vOffsetH, vOffsetM)
    ; vOutput := "is DST: " vIsDST "`r`n`r`n"
    ; vOutput .= "current offset: " vOffset "`r`n"
    ; vOutput .= "non-DST offset: " vStdOffset "`r`n"
    ; vOutput .= "DST offset: " vDltOffset "`r`n`r`n"
    ; vOutput .= "UTC to local: " (vOffset>0?"-":"+") Abs(vDltOffset) "`r`n" ;note: invert the sign
    ; vOutput .= "local to UTC: " (vOffset<0?"-":"+") Abs(vDltOffset) "`r`n"
    ; vOutput .= "TZOffset: '" vOffsetHHMM "'"
    ; MsgBox, % vOutput
    return vOffsetHHMM
}

; Atom: C:\Users\j6l\AppData\Local\atom\update.exe --processStart atom.exe
#a::
IfWinExist \bAtom$
{
   WinActivate
}
else
{
   Run C:\Users\j6l\AppData\Local\atom\update.exe --processStart atom.exe
   WinWait \bAtom$
   WinActivate
}
return

#e::                            ;Windows-E (replaces "Open 'My Computer'")
IfWinExist ahk_class Emacs
{
   WinActivate
}
else
{
   Run C:\usr\local\emacs\26.1\bin\runemacs.exe, C:\Users\j6l ; 2nd param is working dir
   WinWait ahk_class Emacs
   WinActivate
}
return

#j::                            ;Windows-J key
IfWinExist ahk_class Emacs
{
   WinActivate
   Send {F8}                    ;Function key stroke (journal entry, in my case)
}
else
{
   Run C:\usr\local\emacs\26.1\bin\runemacs.exe, C:\Users\j6l
   WinWait ahk_class Emacs
   WinActivate
   Send {F8}
}
return

; Visual Studio Code
#v::
IfWinExist Visual.Studio.Code
{
   WinActivate
}
else
{
   Run C:\Users\j6l\AppData\Local\Programs\Microsoft VS Code\Code.exe
   WinWait Visual.Studio.Code
   WinActivate
}
return

F4::
IfWinExist Tabs Outliner
{
   WinActivate
}
return

; Jam a "from" line in whatever (in my case, an issue-tracking/workflow system that doesn't actually this in a useful manner).
; "From <name> <date>:"
#f::
FormatTime, dt,, d-MMM-yyyy (ddd) h:mm tt
tzo := tzoffset()
SendInput ---- %dt% %tzo% -- John Lusk -- ` 
return

