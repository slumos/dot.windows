#InstallKeybdHook
#UseHook

SetCapslockState AlwaysOff
SetKeyDelay 0


*Home::SendInput {LCtrl Down}
*Home Up::SendInput {LCtrl Up}
*End::SendInput {LCtrl Down}
*End Up::SendInput {LCtrl Up}

emacs_like() {
  IfWinActive, ahk_class ConsoleWindowClass
    Return 1
  IfWinActive, ahk_class ConEmu
    Return 1
  IfWinActive, ahk_class Emacs
    Return 1

  Return 0
}

^a::
If emacs_like()
  Send %A_ThisHotKey%
Else
  SendInput {Home}
Return

^e::
If emacs_like()
  Send %A_ThisHotKey%
Else
  SendInput {End}
Return

