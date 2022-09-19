global Mode=1
global History:=""
showMode(mode){
	ModeText:=["Normal","Insert","Motion","Mouse","Command"]
	tooltip % "Mode="ModeText[Mode],10,-4000
 }
showMode(Mode)
#usehook

#t::
suspend
run wt.exe
suspend
return

i::
vim("i")
return

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


lctrl::
Suspend
Mode=1
Suspend,off
showMode(Mode)
return

; placehold
f::
vim("f")
return
t::
vim("t")
return
r::
vim("r")
return

; finished
:::
vim(":")
return
o::
vim("o")
return
a::
vim("a")
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
s::
vim("s")
return

vim(cmd){
	switch Mode{
		case 1:
			normal(cmd)
		case 2:
			insert(cmd)
		case 4:
			mouse(cmd)
		case 5:
			command(cmd)
	}
}

command(cmd){
	History:=History . cmd
	msgbox , , , %History%,1
 }

; click-as
; fine tone-hjklionm
; wide move-udwb
; scroll-zx
mouse(cmd){
	winGetActiveStats,t,w,h,x,y
	dh:=5
	dw:=dh*w/h
	gain:=2
	if(cmd="a"){
		click,down
		keywait,a
		click,up
	}else if(cmd="s"){
		click,right
	}else if(cmd="m"){
		mousemove,dw*gain,dh*gain,0,R
	}else if(cmd="n"){
		mousemove,-dw*gain,dh*gain,0,R
	}else if(cmd="o"){
		mousemove,dw*gain,-dh*gain,0,R
	}else if(cmd="i"){
		mousemove,-dw*gain,-dh*gain,0,R
	}else if(cmd="j"){
		mousemove,0,dh*gain,0,R
	}else if(cmd="k"){
		mousemove,0,-dh*gain,0,R
	}else if(cmd="h"){
		mousemove,-dw*gain,0,0,R
	}else if(cmd="l"){
		mousemove,dw*gain,0,0,R
	}else if(cmd="u"){
		mousemove,0,-h/dh,0,R
	}else if(cmd="d"){
		mousemove,0,h/dh,0,R
	}else if(cmd="b"){
		mousemove,-w/dw,0,0,R
	}else if(cmd="w"){
		mousemove,w/dw,0,0,R
	}else if(cmd="z"){
		click,wheeldown
	}else if(cmd="x"){
		click,wheelup
	}else if(cmd="q"){
		Back()
	}
}


normal(cmd){
	showMode(Mode)
	if(cmd="i"){
		tooltip
		Mode=2 ;
		suspend,on
	}else if(cmd="m"){
		Mode=4
		showMode(Mode)
	}else if(cmd="j"){
		send,{Down}
	}else if(cmd="k"){
		send,{up} 
	}else if(cmd="l"){
		send,{right} 
	}else if(cmd="h"){
		send,{left} 
	}else if(cmd="b"){
		send,^{left} 
	}else if(cmd="w"){
		send,^{right} 
	}else if(cmd="e"){
		send,{right}
		normal("w")
		send,{left}
	}else if(cmd="x"){
		send,{bs} 
	}else if(cmd="+x"){
		send,{del} 
	}else if(cmd="u"){
		send,^{z} 
	}else if(cmd=":"){
		Mode=5
		showMode(Mode)
	}else if(cmd="s"){
		normal("x")
		normal("i")
	}
}

insert(cmd){
	tooltip
	send,%cmd%
}
Back(){
	Mode=1
	showMode(Mode)
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
