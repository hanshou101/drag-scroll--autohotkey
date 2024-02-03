
#SingleInstance force

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn All, StdOut  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
sleep_ms := 500

loop
{
	sleep %sleep_ms%
	Send {F12}
    sleep %sleep_ms%
	Send {F11}
    sleep %sleep_ms%
	Send {F10}
    sleep %sleep_ms%
	Send {F9}
}
*/


/*

参考资料：
        AutoHotkey，怎么在一个脚本中编辑多个循环_百度知道    http://zhidao.baidu.com/question/1452557465691371980/answer/2945014413

#Persistent
SetTimer, send_a, 20
SetTimer, send_s, 50
SetTimer, send_f, 600
SetTimer, send_d, 1900
return

send_a:
    Send, A
return

send_s:
    Send, S
return

send_f:
    Send, F
return

send_d:
    Send, D
return

*/

#Persistent

is_open := 0

; Ctrl + Alt + Z
; 【*号】  即使按下了其它的键，也仍然会触发。
*^!F12::
    ; MsgBox %is_open%
    if (is_open == 1){
        is_open := 0
        close_timer()
/*
之前，这里的If-Else  犯了一个很蠢的问题；    还好  GPT4  检查出来了。
*/
    } else if (is_open == 0){
        is_open := 1
        open_timer()
    }
    ; MsgBox %is_open%
    TrayTip "TitleA", "Flag:  %is_open%  "
return

/*


*/

open_timer(){
    SetTimer, sebd_RB, 8000
    /*


    */
    SetTimer, send_F8, 567
    SetTimer, send_F9, 456
    SetTimer, send_F10, 345
    SetTimer, send_F11, 234
    SetTimer, send_F12, 123
}

close_timer(){
    SetTimer, sebd_RB, Off
    SetTimer, send_F9, Off
    SetTimer, send_F10, Off
    SetTimer, send_F11, Off
    SetTimer, send_F12, Off
}

/*


*/

sebd_RB:
    ;    Send {rbutton down}
    Send {lbutton down}     ; 好像左键，不会打断平A
    sleep 300
    ;    Send {rbutton up}
    Send {lbutton up}
return

send_F8:
    Send {F8}
return

send_F9:
    Send {F9}
return


send_F10:
    Send {F10}
return


send_F11:
    Send {F11}
return


send_F12:
    Send {F12}
return
