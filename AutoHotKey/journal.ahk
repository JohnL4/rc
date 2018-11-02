#j::                            ;Windows-J key
IfWinExist ahk_class Emacs
{
   WinActivate
   Send {F8}                    ;Function key stroke (journal entry, in my case)
}
else
{
   Run C:\usr\local\emacs\emacs-23.2\bin\runemacs.exe
   WinWait ahk_class Emacs
   WinActivate
   Send {F8}
}
