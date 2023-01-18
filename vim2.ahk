#singleInstance force
#usehook

global Mode:=1
global History:="init"
global Motion:=""
global Count:=""
global Leader:=""
global cReplace:=0
global ModeText:=["Normal","Insert","Motion","Mouse","Command","Replace","View"]

showMode()
setCapsLockState,AlwaysOff
loop 26{
	if(A_index<=10){
		hotkey,% A_index-1,vim
	}
	asciii:=64+A_index
	char:=chr(asciii)
	hotkey,% char,vim
	hotkey,% "+"char,vim
}
hotks:=["$","^","space","esc","enter",".",":","?"]
for index,hotk in hotks
	hotkey,%hotk%,vim

; ==============================================================================
; vimgrep /\v^\a+\(cmd/j %
; ==============================================================================
; TODO
; make a standard way for cmd to wait a key, such as f,t,gu,q
; mouse mode rapid move, one resolution: divide screen to 10x10 square,
; or I can use image edge detection to get all button
; a clipboard manager, because win+v don't word
; detect whether is editting text 
; maybe I should add modifier parameter to normal(key,modifier:="")
; modifier=[ctrl,shift,alt,win]
; ==============================================================================

; special key
capslock::
	Suspend ; state revert
	setCapsLockState,AlwaysOff
	send,{Ctrl down}
	keywait, capslock ; keep down
	send,{Ctrl up}
	Suspend ; restore state by revertting again
	return

	+capslock::
	Suspend ; state revert
	setCapsLockState,AlwaysOff
	send,{Ctrl down}{shift down}
	keywait, capslock ; keep down
	send,{Ctrl up}{shift up}
	Suspend ; restore state by revertting again
	return

	alt::
	suspend
	alt()
	suspend
	return
	alt & left::
	suspend
	send,!{left}
	suspend
	return
	alt & right::
	suspend
	send,!{right}
	suspend
	return
	lctrl::
	Suspend
	Suspend,off
	change_mode(1)
	return
	#t::
	suspend
	run wt.exe
	suspend
return

space & x::
vim("^x")
return
	space & d::
	vim("^d")
	return
	space & u::
	vim("^u")
	return
	space & z::
	vim("^z")
	return
	space & 0::
	vim("^0")
	return
	space & a::
	vim("^a")
	return
; space leader

DEBUG(arg){
	tip_show(arg,10,50,3)
}

command(cmd){
	static Read:=""
	static simplemap:={bb:"{browser_back}",bf:"{browser_forward}",w:"^s"
		,wl:"#{left}",wr:"#{right}"
		,vm:"{vkad}",vu:"{vkaf 2}",vd:"{vkae 2}" }
	DEBUG("")
	if(cmd="enter"){
		; else if Read in vu 
		; { 
			; soundset +5 
		; } 
		if Read in q,qu,qui,quit 
			winclose,A	 
		else if Read in tp 
		{
			stp:=180
			winget,t,transparent,A
			; msgbox,,,% t,1 
			if strlen(t)
				winset,transparent,off,A
			else
				winset,transparent,% stp,A
		} else if Read in debug,deb 
			DEBUG(Count)
		else{
			mapkey:=objrawget(simplemap,Read)
			if(mapkey!=""){
				press(mapkey)
			}
		}
		Read:=""
		back_normal()
	}
	else{
		cmd:=nonprint_conv(cmd)
		Read:=Read . cmd
	}
	tip_show(Read,10,9000,2)
	;msgbox , , , %History%,1
}

; click-as
; fine tone-hjklionm
; wide move-udwb
; scroll-zx

mouse(cmd){
	winGetActiveStats,t,w,h,x,y
	dh:=3
	dw:=4
	gain:=1.6
	if(cmd="a"&&Count<=1){
		click,down
		keywait,a
		click,up
	}else if(cmd="a"&&Count>1){
		click, % Count
		Count:=""
		footer(Count)
	}else if(cmd="+a"){
		click
		change_mode(1)
	}else if(cmd="g"){
		winclose ,A
	}else if(cmd="s"){
		click,right
	}else if(cmd="m"){
		smooth_move_mouse("m",dw*gain,dh*gain)
	}else if(cmd="n"){
		smooth_move_mouse("n",-dw*gain,dh*gain)
	}else if(cmd="o"){
		smooth_move_mouse("o",dw*gain,-dh*gain)
	}else if(cmd="i"){
		smooth_move_mouse("i",-dw*gain,-dh*gain)
	}else if(cmd="j"){
		smooth_move_mouse("j",0,dh*gain)
	}else if(cmd="k"){
		smooth_move_mouse("k",0,-dh*gain)
	}else if(cmd="h"){
		smooth_move_mouse("h",-dh*gain,0)
	}else if(cmd="l"){
		smooth_move_mouse("l",dh*gain,0)
	}else if(cmd="u"){
		mousemove,0,-h/dh,0,R
	}else if(cmd="d"){
		mousemove,0,h/dh,0,R
	}else if(cmd="b"){
		mousemove,-w/dw,0,0,R
	}else if(cmd="w"){
		mousemove,w/dw,0,0,R
	}else if(cmd="x"){
		smooth_scroll("x","down")
	}else if(cmd="space & x"){
		send ^{click wheeldown}
	}else if(cmd="space & z"){
		send ^{click wheelup}
	}else if(cmd="space & 0"){
		send ^0
	}else if(cmd="z"){
		smooth_scroll("z","up")
	}else if(cmd="q"){
		back_normal()
	}
}

motion(cmd){
	if(cmd!=Motion){
		keywait,shift
		send,{shift down}
		normal(cmd)	 
		if(process_name()="WINWORD.EXE"){
			if(cmd="$"){
				send,{left}
			}
		}
		send,{shift up}
	}else{
		whole_line()
	}
	if(Motion="d"){
		send,^x
		back_normal()
	}else if(Motion="y"){
		send,^c
		back_normal()
	}else if(Motion="c"){
		send,^x
		change_mode(2)
		; to insert
	}
}

normal(cmd){
	listlines off
	maptable:={k:"{up}",l:"{right}",h:"{left}",w:"^{right}",b:"^{left}"
		 ,"space & d":"{pgdn}","space & u":"{pgup}",g:"{home}","+g":"{end}"
		 ,p:"^v"
		 ,x:"{bs}","+x":"{del}",u:"^z","+u":"^y"
		 ,esc:"",space:"{space}",enter:"{enter}","$":"{end}","^":"{home}"}

	mapkey:=objrawget(maptable,cmd)
	listlines on
	if(mapkey!=""){
		press(mapkey)
	}else if(cmd="j"){
		if(process_name()="msedge.exe"){
			edge_pdf_focus()
		}
		send,{Down}
	}else if(cmd="i"){
		tooltip
		Mode:=2 
		setnumlockstate, on
		suspend,on
	}else if(cmd="+i"){
		send,{home}
		normal("i")
	}else if(cmd="+a"){
		send,{end}
		normal("i")
	}else if(cmd="nop"){
		return
	}else if(cmd="d"||cmd="c"||cmd="y"){
		to_motion(cmd)
	}else if(cmd="+d"){
		normal("d")
		motion("$")
	}else if(cmd="+c"){
		normal("c")
		motion("$")
	}else if(cmd="+r"){
		cReplace:=1
		Mode:=6
		showMode()
	}else if(cmd="r"){
		Mode:=6
		showMode()
	}else if(cmd="e"){
		send,{right}
		normal("w")
		send,{left}
	}else if(cmd="o"){
		send,{end}{enter}
		normal("i")
	}else if(cmd="+o"){
		send,{home}{enter}{up}
		normal("i")
	}else if(cmd=":"){
		change_mode(5)
	}else if(cmd="s"){
		normal("x")
		normal("i")
	}else if(cmd="+s"){
		normal("+x")
		normal("i")
	}else if(cmd="."){
		normal(History)
	}else if(cmd="?"){
		helpinfo=
		(LTrim 
		 i:to insert mode, lctrl:to normal mode, m:to mouse mode
		 j:up, k:down, h:left, l:right
		 w:next word, b:previous word, e:next end of word
		 d:delete after a move, c:like press d and i 
		 x:delete char before cursor, X:delete char after cursor,s/S:x/X and i
		 o:add new line below and press i, O:add new line obove and press i
		)
		msgbox,0x40040,Help, % helpinfo
	}else if(cmd="f"){
		; normal("yy")
		; wait a target char
		return
	}else if(cmd="m"){
		Mode:=4
		showMode()
	}else if(cmd="v"){
		Mode:=7
		showMode()
	}
	listlines off
	if (cmd!="."&&cmd!=":"){
		History:=cmd
	}
	listlines on
}

; ============================================================
; below code is small functions
; ============================================================
press(arg){
	if arg=""
		return
	send,% arg
}
nonprint_conv(cmd){
	if(cmd="space"){
		cmd:=" "
	}else if(cmd ~= "\+[a-z]"){
		cmd:=substr(cmd,2)
		; stringupper,cmd,cmd
	}
	return cmd
}

vim(cmd:=""){
	listlines off
	cmd:=A_thishotkey
	stringlower,cmd,cmd
	if(cmd>=0&&cmd<=10){
		Count:=Count . cmd
		Count:=Ltrim(Count,"0")
	}
	footer(Count)
	if(cmd="esc"&&Count>=1){
		Count:=""
		footer(Count)
		return 
	}
	; msgbox,,,% cmd,1
	showMode()
	listlines on
	switch Mode{
	case 1:
		normal(cmd)
	case 2:
		normal("i")
	case 3:
		motion(cmd)
	case 4:
		mouse(cmd)
	case 5:
		command(cmd)
	case 6:
		replace(cmd)
	case 7:
		view(cmd)
	}
}

whole_line(){
	send,{home}
	send,{shift down}
	send,{end}
	send,{shift up}
}

view(cmd){
	if(cmd="+g"){
		send,+{end}
	}else{
		send,{shift down}
		normal(cmd)
		send,{shift up}
	}
	if cmd not in j,k,h,l,w,b,e,c,s,g,+g
	{
		; msgbox,,,% cmd, .5
		back_normal()
	}
}

change_mode(new_mode){
	Mode:=new_mode
	showMode()
	if (Mode=2){
		normal("i")
	}else if (Mode=1){
		setnumlockstate, off
		cReplace:=0
	}
}

replace(cmd){
	cmd:=nonprint_conv(cmd)
	send,{del}%cmd% 
	if(cReplace=0){
		back_normal()
	}
}


to_motion(cmd){
	curmode:=Mode
	Motion:=cmd
	if(ModeText[curmode]="View"){
		; no waiting a move
		motion("nop")
	}else{
		change_mode(3)
	}
}

back_normal(){
	change_mode(1)
}
smooth_move_mouse(key,x,y){
	static running:=0
	if running 
		return
	running:=1
	while (getkeystate(key,"P")!=0) {
		mousemove,x,y,0,R
		x*=1.1
		y*=1.1
	}
	running:=0
}
smooth_scroll(key,stat){
	while (getkeystate(key,"P")!=0) {
		send {click wheel%stat%}
		sleep 100
	}
 }
process_name(){
	listlines off
	winget,name,processname,A
	return name
	listlines on
}
alt(){
	winget,name,processname,A
	key:=""
	if (name="msedge.exe" ){
		input,key,l1 t0.3 ,{LALT}
		if(asc(key)=0){
			edge_pdf_focus()
			return
		}
		if(key="`t") {
			key={tab}
		}
		;msgbox,,,% "asc: "asc(key),1
	}
	;msgbox,% name
	send,{alt down}%key%
	keywait, lalt
	send,{alt up}
}
edge_pdf_focus(){
	static current_title:=""
	wingetactivetitle,title ;
	if( current_title!=title && regexmatch(title,".*\.pdf") ){
		send,{F6}+{F6} ; focus on main page
			;msgbox,,,% title,1
	}
	current_title:=title
}
footer(arg){
	tip_show(arg,10,9000,2)
}
tip_show(arg,x:=10,y:=-2000,num:=1){
	tooltip , % arg,x,y,num
}
showMode(){
	tooltip % "Mode="ModeText[Mode],10,-4000
}
::opva::
suspend
send,open vim2.ahk{enter}
suspend
return

::mytele::
suspend
send,15965394977
suspend
return
::myemail::
suspend
send,roseupram@163.com
suspend
return
