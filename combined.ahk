#e::                            ;Windows-E (replaces "Open 'My Computer'")
IfWinExist ahk_class Emacs
{
   WinActivate
}
else
{
   Run C:\usr\local\emacs-24.3\bin\runemacs.exe
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
   Run C:\usr\local\emacs-24.3\bin\runemacs.exe
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
