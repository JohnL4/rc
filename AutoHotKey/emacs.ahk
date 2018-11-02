#e::                            ;Windows-E (replaces "Open 'My Computer'")
IfWinExist ahk_class Emacs
{
   WinActivate
}
else
{
   Run C:\usr\local\emacs\emacs-23.2\bin\runemacs.exe
   WinWait ahk_class Emacs
   WinActivate
}
