global Mode=1
global History:=""
global Motion:=""
showMode(mode){
	ModeText:=["Normal","Insert","Motion","Mouse","Command","Replace","View"]
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
+u::
vim("+u")
return
s::
vim("s")
return
+s::
vim("+s")
return

vim(cmd){
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

view(cmd){
send,{shift down}
normal(cmd)
send,{shift up}
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
		send,{del}
	}
	back_normal()
}
whole_line(){
	send,{home}
	send,{shift down}
	send,{end}
	send,{shift up}
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
		gain:=1.8
		if(cmd="a"){
			click,down
				keywait,a
				click,up
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
			; mousemove,0,-dh*gain,0,R
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
			click,wheeldown
		}else if(cmd="z"){
			click,wheelup
		}else if(cmd="q"){
			back_normal()
		}
}

replace(cmd){
	send,{del}%cmd% 
}

normal(cmd){
	showMode(Mode)  
	if(cmd="i"){
		tooltip
		Mode=2 
		suspend,on
	}else if(cmd="m"){
		Mode=4
		showMode(Mode)
	}else if(cmd="v"){
		Mode=7
		showMode(Mode)
	}else if(cmd="d"){
		Mode:=3
		Motion:="d"
		showMode(Mode)
	}else if(cmd="r"){
		Mode:=6
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
	}else if(cmd="o"){
		send,{end}{enter}
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
		Mode=5
		showMode(Mode)
	}else if(cmd="s"){
		normal("x")
		normal("i")
	}else if(cmd="+s"){
		normal("+x")
		normal("i")
	}
}

insert(cmd){
	tooltip
		send,%cmd%
}
back_normal(){
	Mode=1
		showMode(Mode)
}
smooth_move_mouse(key,x,y){
	loop{
		if (getkeystate(key,"P")!=0) {
			mousemove,x,y,0,R
		} 
		else{
			break
		}
	}
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
