; AutoHotKey script
; Note that backtic (`) is escape character; be sure to escape commas even inside strings!

SetTitleMatchMode, RegEx
SetTitleMatchMode, Fast

; Sleep and reload, because Windows seems to fight with these shortcut keys
; FileAppend, %A_NOW% Script loaded`, sleeping...`n, C:\Log\ahk.log
; MsgBox, "Script loaded, sleeping..."
; Sleep, 60000
; Reload

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

F4::
IfWinExist Tabs Outliner
{
   WinActivate
}
return

