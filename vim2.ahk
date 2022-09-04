global Mode=1
showMode(mode){
	ModeText:=["Normal","Insert","Motion","Mouse","Command"]
	tooltip % "Mode="ModeText[Mode]
 }
showMode(Mode)
#usehook

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
z::
vim("z")
return
t::
vim("t")
return
r::
vim("r")
return
e::
vim("e")
return
a::
vim("a")
return
m::
vim("m")
return

; finished
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
	}
}
mouse(cmd){
}
normal(cmd){
	showMode(Mode)
	if(cmd="i"){
		tooltip
		Mode=2 ;
		suspend,on
	}else if(cmd="v"){
		;
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
	}else if(cmd="x"){
			send,{bs} 
	}else if(cmd="+x"){
			send,{del} 
	}else if(cmd="u"){
			send,^{z} 
	}else if(cmd="s"){
			normal("x")
			normal("i")
	}
}
insert(cmd){
	tooltip
	send,%cmd%
}
::opva::
suspend
send,open vim2.ahk{enter}
return

