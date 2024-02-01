/*
Mouse Scroll v03 
by Mikhail V., 2020 
tested on Windows 10, AHK 1.1.28

Note: this app uses right mouse button to toggle scrolling, 
so the rbutton is blocked to prevent the context menu popup.
(see: rbutton-block.ahk)  
*/

/*
——————————————————————————————————————————————————————————————————————————————————
脚本Meta定义
——————————————————————————————————————————————————————————————————————————————————
*/

#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetStoreCapsLockMode, Off
#InstallMouseHook



/*
——————————————————————————————————————————————————————————————————————————————————
用户配置
——————————————————————————————————————————————————————————————————————————————————
*/
; === User settings ===

; 设置，是否滚动翻转。
; swap := false 
swapY := true 				; swap scroll direction
swapX := false 				; swap scroll direction


ratio := 1
change_调整频率和单次行数 :=  2              ;  增加频率，减少【单次行数】
; 【执行器】的次数
k := 6 * ( ( 1 / 3 ) / ratio / change_调整频率和单次行数 )						; scroll speed coefficient (higher k means higher speed)

; === Internal settings ===
movelimit := 15			; max amount of scroll at once

; 【触发器】的距离
S_y := 20 * ( 1.5 / ratio / change_调整频率和单次行数 * 1 )  						; unit distance (higher S = lower speed)
S_x := 20 * ( 1.5 / ratio / change_调整频率和单次行数 * 1.5 )  						; unit distance (higher S = lower speed)
; 每次检测（之间），进行睡眠的毫秒
T := 20 * ( 1 / ratio )					; scan frequency in MS (


/*
——————————————————————————————————————————————————————————————————————————————————
临时变量。
——————————————————————————————————————————————————————————————————————————————————
*/

; 【yp】是前一次的  鼠标y值
mousegetpos xp , yp									; get mouse Y position
; panp := getkeystate("rbutton", "P")					; save key state / set the key used to scroll
dy := 0
dyTotal := 0
movesTotalY := 0
; TIP 【X】的另一套
dx := 0
dxTotal := 0
movesTotalX := 0



/*
——————————————————————————————————————————————————————————————————————————————————
正式代码。循环
——————————————————————————————————————————————————————————————————————————————————
*/

loop 
{
    ; 进程睡眠 T 毫秒
	sleep %T%

	; 右键，按下的状态。    我猜测，按下是【1】？  松开为【0】？
	pan := getkeystate("rbutton", "P")				; set the key used to scroll
	; pan_on := (pan > panp)							; check if key state is changed

	; 【右键】是否已经松开。    猜测，【按下是1  松开是0】  。
	; 【panp】是前一次的鼠标按下状态。
	pan_off := (pan < panp)							; check if key state is changed 
	panp := pan     ; 更新设置

    /*
        处理，X和Y的差异。
        TODO 将来，感觉这一块，是可以    【直接抽取】  的。
    */

	; y坐标
	mousegetpos x , y							; get current mouse position Y
	; 变化的y坐标
	dy := k * (y - yp)						; relative mouse movement
	dx := k * (x - xp)
	;
	yp := y									; save y position
	xp := x

	; 自从【上一次按下】以来，  y变化的总值
	dyTotal := dyTotal + dy
	dxTotal := dxTotal + dx


    ; 【触发器】触发  次数。
	movesY := dyTotal // S_y           ; 整除
	movesX := dxTotal // S_x

	; 扣减，已被执行的次数  （去除，余数之类） （WARN 不保留余数 ）。
	dyTotal := dyTotal - movesY * S_y					; calculate remainder after division
	dxTotal := dxTotal - movesX * S_x

	; 计算滚动方向
	dy := (movesY >= 0) ^ swapY					; get direction
	dx := (movesX >= 0) ^ swapX

	; 计算，最终滚动的行数
	ny := min(abs(movesY), movelimit)
	nx := min(abs(movesX), movelimit)
	; tooltip,  %moves% -- %dy%


	; TIP 按下时
	if (pan = true ) {
        /*
        ——————————————————————————————————————————————————————————————————————————————————
        原本，是【垂直滚动】
        */
	    ; 向下拖动
		if (dy = 1)
			send, {wheeldown %ny% }
        ; 向上拖动
		if (dy = 0)
			send, {wheelup %ny%}
        ; 总拖动行数
		; movesTotal := movesTotal + moves              ; TIP 原代码，我感觉有Bug。会触发【向上N行、再向下N行  回到远点  仍会触发  右键菜单】    的行为
		movesTotalY := movesTotalY + abs(movesY)           ; TIP 加上绝对值，只要滚动过  就不再可能【为0】  也不再可能【触发  右键菜单】  。


        /*
        ——————————————————————————————————————————————————————————————————————————————————
        加上【水平滚动】：
                if (directionX = 1)
                        send  {wheelleft %nXabs%}
                if (directionX = 0)
                        send  {wheelright %nXabs%}
        */
        if (dx = 1)
            send, {wheelleft %nx% }
        if (dx = 0)
            send, {wheelright %nx%}
        movesTotalX := movesTotalX + abs(movesX)           ; TIP 跟着修复。

	}
	; TIP 松开时
	if (pan_off = true) {
	    ; TIP 此处，也是【&&】表示  短路与；  【||】表示  短路或。
		if ( movesTotalY = 0 && movesTotalX = 0 )
			send {rbutton}
        ; TIP 每松开一次。重置一下。
		movesTotalY := 0
		movesTotalX := 0
	}
}





;————————————————————————————————————————————————————————————————————————
;————————————————————————————————————————————————————————————————————————
;————————————————————————————————————————————————————————————————————————
/*
TIP
    参考资料：
        In AutoHotKey, how do I block LButton from being sent if it's used in the hotkey context but not if it's used elsewhere? - Stack Overflow    https://stackoverflow.com/a/38405557/6264260
    似乎，必须放在【最后面】，才不会【阻塞脚本执行】。
        …………………………
*/


; 默认关闭【右键】的默认行为。  全部改为【手动触发】：    如【send {rbutton}】来触发。
; block the right mouse button
rbutton::
    test_a := 1
return

;————————————————————————————————————————————————————————————————————————
;————————————————————————————————————————————————————————————————————————
;————————————————————————————————————————————————————————————————————————

