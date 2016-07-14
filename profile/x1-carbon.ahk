SendMode Input
SetCapslockState AlwaysOff
#NoEnv
#SingleInstance Force

#Include <dual>
dual := new Dual

*Home::
*Home UP::dual.combine("LCtrl", A_ThisHotkey)

*End::
*End Up::dual.combine("LCtrl", A_ThisHotkey)

