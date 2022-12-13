#singleInstance force
global Mode:=1
global History:=""
global Motion:=""
global current_title:=""
showMode(){
	ModeText:=["Normal","Insert","Motion","Mouse","Command","Replace","View"]
	tooltip % "Mode="ModeText[Mode],10,-4000
 }
showMode()
setCapsLockState,AlwaysOff
#usehook

; ==============================================================================
; TODO
; nothing
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
	lalt::
	suspend
	alt()
	suspend
	return
	lalt & left::
	suspend
	send,!{left}
	suspend
	return
	lalt & right::
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


i::
vim("i")
return
	?::
	vim("?")
	return
	f::
	vim("f")
	return
	p::
	vim("p")
	return
	+g::
	vim("+g")
	return
	g::
	vim("g")
	return
	c::
	vim("c")
	return
	t::
	vim("t")
	return
	r::
	vim("r")
	return
	:::
	vim(":")
	return
	o::
	vim("o")
	return
	+o::
	vim("+o")
	return
	a::
	vim("a")
	return
	+a::
	vim("+a")
	return
	m::
	vim("m")
	return
	n::
	vim("n")
	return
	d::
	vim("d")
	return
	e::
	vim("e")
	return
	z::
	vim("z")
	return
	v::
	vim("v")
	return
	q::
	vim("q")
	return
	j::
	vim("j")
	return
	k::
	vim("k")
	return
	h::
	vim("h")
	return
	l::
	vim("l")
	return
	w::
	vim("w")
	return
	b::
	vim("b")
	return
	x::
	vim("x")
	return
	+x::
	vim("+x")
	return
	u::
	vim("u")
	return
	+u::
	vim("+u")
	return
	s::
	vim("s")
	return
	0::
	vim("0")
	return
	+s::
	vim("+s")
	return
; all key to vim

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


command(cmd){
	;History:=History . cmd
	if(cmd="q"){
		winclose,A	 
	}
	back_normal()
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
	if(cmd="a"){
		click,down
		keywait,a
		click,up
	}else if(cmd="+a"){
		click
		change_mode(1)
	}else if(cmd="0"){
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
	}else if(cmd="^x"){
		send ^{click wheeldown}
	}else if(cmd="^z"){
		send ^{click wheelup}
	}else if(cmd="^0"){
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
		send,{shift up}
	}else{
		whole_line()
	}
	if(Motion="d"){
		send,^x
		back_normal()
	}else if(Motion="c"){
		send,{del}
		change_mode(2)
		; to insert
	}
}

normal(cmd){
	if(cmd="i"){
		tooltip
		Mode:=2 
		suspend,on
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
		msgbox,to char
	}else if(cmd="m"){
		Mode:=4
		showMode()
	}else if(cmd="v"){
		Mode:=7
		showMode()
	}else if(cmd="p"){
		send,^v
	}else if(cmd="d"||cmd="c"){
		to_motion(cmd)
	}else if(cmd="r"){
		Mode:=6
		showMode()
	}else if(cmd="^d"){
		send,{pgdn}
	}else if(cmd="^u"){
		send,{pgup}
	}else if(cmd="j"){
		if(process_name()="msedge.exe"){
			wingetactivetitle,title ;
			if( current_title!=title && regexmatch(title,".*\.pdf") ){
				send,{F6 3} ; focus on main page
				;msgbox,,,% title,1
			}
			current_title:=title
		}
		send,{Down}
	}else if(cmd="k"){
		send,{up} 
	}else if(cmd="l"){
		send,{right} 
	}else if(cmd="h"){
		send,{left} 
	}else if(cmd="g"){
		send,{home} 
	}else if(cmd="+g"){
		send,{end} 
	}else if(cmd="b"){
		send,^{left} 
	}else if(cmd="w"){
		send,^{right} 
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
	}else if(cmd="x"){
		send,{bs} 
	}else if(cmd="+x"){
		send,{del} 
	}else if(cmd="u"){
		send,^{z} 
	}else if(cmd="+u"){
		send,^{y} 
	}else if(cmd=":"){
		change_mode(5)
	}else if(cmd="s"){
		normal("x")
		normal("i")
	}else if(cmd="+s"){
		normal("+x")
		normal("i")
	}
}

; ============================================================
; below code is small functions
; ============================================================

vim(cmd){
	showMode()
	switch Mode{
	case 1:
		normal(cmd)
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
	send,{shift down}
	normal(cmd)
	send,{shift up}
 }

change_mode(new_mode){
	Mode:=new_mode
	showMode()
	if (Mode=2){
		normal("i")
	}
}

replace(cmd){
	send,{del}%cmd% 
}

to_motion(cmd){
	change_mode(3)
	Motion:=cmd
}

back_normal(){
	change_mode(1)
}
smooth_move_mouse(key,x,y){
	while (getkeystate(key,"P")!=0) {
		mousemove,x,y,0,R
		x*=1.1
		y*=1.1
	}
}
smooth_scroll(key,stat){
	while (getkeystate(key,"P")!=0) {
		send {click wheel%stat%}
		sleep 100
	}
 }
process_name(){
	winget,name,processname,A
	return name
}
alt(){
	winget,name,processname,A
	key:=""
	if (name="msedge.exe" ){
		input,key,l1 t0.4 ,{LALT}
		if(asc(key)=0){
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
::opva::
suspend
send,open vim2.ahk{enter}
suspend
return

:*:jable::
suspend
send,novnovnov
suspend
return
