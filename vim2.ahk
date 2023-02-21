; When you get stucked, maybe you use = to assign, instead of := 
; Array start by index 1 not 0 
#include %A_scriptDir%/lib.ahk
#singleInstance force
#usehook

global Mode:=1
global leaders:=[]
global ModeText:=["Normal","Insert","Motion","Mouse","Command","Replace","View"]
global ModeNum:=[]
init()

; ==============================================================================
; vimgrep /\v^\a+\(cmd/j %
; ==============================================================================
; TODO
; Each func return a string containing action, and use press() or call func to execute
; or I can first construct string, at the end of func calling press()
; Why? because modifier can be changed by other func, for example, I press down shift 
; in motion(), when execute(), some func may make shift up, so the motion() fails
; 
; count support
; q[a-zA-Z] support
; mouse mode rapid move, one resolution: divide screen to 10x10 square,
; a clipboard manager, because win+v don't work
; detect whether is editting text 
; ==============================================================================

; global key
*capslock::
	Suspend ; state revert
	send,{Ctrl down}
	keywait, capslock ; keep down
	send,{Ctrl up}
	Suspend ; restore state by revertting again
	return
	alt::
	suspend
	alt()
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

; ^ ctrl ! alt + shift # win 

DEBUG(arg){
	tip_show(arg,10,50,3)
}

rlcmd(cmd){
	static Read:=""
	if(cmd="enter"){
		command(Read)
		; print(Read,1) 
		Read:=""
		tip_show("",10,9000,2)
		return 
	}else if(cmd="clear" || cmd="space & u"){
		Read:=""
	}else if(cmd="bs"|| cmd="space & h"){
		Read:=substr(Read,1,strlen(Read)-1)
	}else{
		cmd:=hk2str(cmd)
		Read:=Read . cmd
	}
	tip_show(strlen(Read)?Read:" ",10,9000,2)
	return "rl"
}
command(cmd){
	static simplemap:={bb:"{browser_back}",bf:"{browser_forward}",w:"^s"
		,vda:"^#d",vdn:"^#{right}",vdp:"^#{left}",vdc:"^#{f4}"
		,wl:"#{left}",wr:"#{right}",wls:"^!{tab}"
		,q:"!{f4}",wq:"^s!{f4}"
		,vm:"{vkad}",vu:"{vkaf 2}",vd:"{vkae 2}" }
	static fnmap:={}
	DEBUG("")
		; else if Read in vu 
		; { 
			; soundset +5 
		; } 
	if(regexmatch(cmd,"^tp\s*")){
		tpcmd(cmd)
	}else if(regexmatch(cmd,"^top\s*")){
		arr=split(cmd," ")
		topcmd(arr[2])
	}else if cmd in debug,deb 
	{
		a:="Mode"
		DEBUG(%a%)
	}
	else if(cmd="kill"){
		winkill,A
	}else{
		press(simplemap[cmd])
	}
}
topcmd(num){
	winset,Alwaysontop,%num%,A
}


mcmd(cmd){
	if(cmd="q"){
		return
		}
	; click-as
	; fine tone-hjklionm
	; wide move-udwb
	; scroll-zx
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
		return
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
	}else if(cmd="z"){
		smooth_scroll("z","up")
	}else if(cmd="enter"){
		send,{enter}
	}else if(cmd~="space & [a-z0-9]"){
		k:=substr(cmd,strlen(cmd))
		; print(k) 
		press("^" k)
	}
	return "m"
}
dcmd(cmd){
	static ld:=""
	if (cmd="d"){
		if(process_name() ~= "godot"){
			press("^x")
		} else{
		press("{home}" select("{end}") "^x")
		}
		return
	}
	fn:="normal"
	if(ld){
		fn:=ld "cmd"
		ld:=""
	}
	res:=%fn%(cmd,true)
	; print(res[1],1) 
	if(res[1]="move"){
		press(select(res[2]) "^x")
	}else if(res[1]="leader"){
		ld:=res[2]
		return "d"
	}
}
ccmd(cmd){
	res:=dcmd(cmd)
	if(res){
		return res
	}
	normal("i")
}
rcmd(cmd){
	if(cmd!="esc"){
		press("{ins}" cmd "{ins}")
		return "r"
	}
}
gcmd(cmd,only_text:=false){
	static map:={g:"{home}"}
	if(only_text){
		return ["move",map[cmd]]
	}
	move(map[cmd])
}
vcmd(cmd){
	static map:={x:"^x",y:"^c"}
	k:=map[cmd]
	if(k){
		press(k)
		return
	}
	res:=normal(cmd,true)
	type:=res[1]
	if(res[1]="move"){
		move(select(res[2]))
		return "v"
	}else if(type="edit" ||type="eval"){
		%type%(res[2])
	}
}
select(cmd){
	return "{shift down}" cmd "{shift up}"
}

normal(cmd,only_text:=false){
	static maps:=[{name:"move"
		,j:"{down}",k:"{up}",h:"{left}",l:"{right}","+g":"{end}"
		,"$":"{end}","^":"{home}",w:"^{right}",b:"^{left}"}
	,{name:"edit"
	,p:"^v",tab:"{tab}"
	,"-":"!{down}","_":"!{up}","+":"^d"
	,x:"+{left}^x","+x":"+{right}^x",u:"^z","+u":"^y",enter:"{enter}"}
	,{name:"eval"
	,"+d":"d,$","+a":"$,i","+i":"^,i","+c":"c,$"
	,"o":"$,enter,i"
	,s:"x,i","+s":"+x,i"}
	,{name:"leader"
	,d:"d",c:"c",r:"r",g:"g",m:"m",v:"v",":":"rl"}
	,{name:"change_mode",i:2}] 
	for i,map in maps {
		op:=map[cmd]
		if(op){
			fn:=map.name
			if(only_text){
				res:=[fn,op]
				return res
			}
			%fn%(op)
		}
	}
}
eval(cmd){
	for i,scmd in split(cmd,","){
		if(leaders.length()>0){
			last:=leaders[leaders.length()]
			wait:=%last%cmd(scmd)
			; print(wait "," last) 
			if(wait!=last){
				leaders.pop()
			}
			if(mode=2){
				tip_show("")
			}else{
				tip_show((leaders.length()<=0?"Normal":"Leader:" leaders[leaders.length()]))
			}
		}
		else{
			tip_show("Normal")
			normal(scmd)
		}
	}
}

vim(cmd:=""){
	cmd:=(cmd=""?A_thishotkey:cmd)
	stringlower,cmd,cmd
	eval(cmd)
}

; ============================================================
; below code is small functions
; ============================================================
hk2str(cmd){
	stringlower,cmd,cmd
	if(cmd ~= "^\+[a-z]$"){
		cmd:=substr(cmd,2)
		stringupper,cmd,cmd
	}else if (cmd="space"){
		cmd:=" "
	}
	return cmd
}

whole_line(){
	exename:=process_name()
	keywait,shift
	if (exename ~="godot"){
		send,{up}{end}{right}
	}else{
		send,{home}
		}
	send,{shift down}
	send,{end}
	if (exename ~="godot"){
		send,{right}
	}
	send,{shift up}
}

view(cmd){
	keywait,shift
	if(cmd="+gxxx"){
		send,+{end}
	}else{
		send,{shift down}
		normal(cmd)
		send,{shift up}
	}
	if(Mode=2){
		return
	}
	if cmd not in j,k,h,l,w,b,e,c,s,g,+g
	{
		; msgbox,,,% cmd, .5
		back_normal()
	}
}

change_mode(new_mode){
	old_mode:=Mode
	Mode:=new_mode
	; showMode() 
	if(old_mode=5){
		rlcmd("clear")
		tip_show("",10,9000,2)
	}
	if (Mode=2){
		tooltip
		Mode:=2 
		; setnumlockstate, on 
		suspend,on
	}else if (Mode=1){
		; setnumlockstate, off  
		tip_show("Normal")
		Leader:=""
	}else if(Mode=5){
		tip_show(" ",10,9000,2)
	}
}

execute(str){
	stack("in")
	Leader:=""
	Mode:=1
	arr:=split(str,",")
	for i,value in arr
	{
		vim(value)
	}
	stack("out")
	; print("out  mode: " Mode) 
	; press somekey, execute as normal mode 
}


leader(cmd){
	i:=leaders.Push(cmd)
	tip_show("Leader:" leaders[leaders.length()])
	if(cmd="rl"){
		rlcmd("")
	}
}
move(cmd){
	press(cmd)
}
edit(cmd){
	press(cmd)
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
	static running:=0
	if running 
		return
	running:=1
	while (getkeystate(key,"P")!=0) {
		send {click wheel%stat%}
		sleep 100
	}
	running:=0
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
			key:="{tab}"
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
tpcmd(readin){
	arr:=split(readin," ")
	if (arr.length()>1){
		stp:=arr[2]
		if (stp>=95){
			stp:="off"
		}
	}else{
		winget,t,transparent,A
		stp:=(strlen(t)>0?"off":80)
	}
	if(stp!="off")
		stp:=stp/100*255
	winset,transparent,% stp,A
}
stack(op){
	static global_var:=["Mode","Leader","Count"]
	static stk:=[]
	; in
	if(op="in"){
		arr:=[]
		for index,gv in global_var
		{
			arr.push(%gv%)
		}
		stk.push(arr)
	} else if (op="out"){
		arr:=stk.pop()
		for index,gv in global_var
		{
			%gv%:=arr[index]
		}
	}
	; print(op join(stk,",")) 
	return
}
init(){
	listlines off
	change_mode(1)
	setCapsLockState,AlwaysOff
	loop 26{
		asciii:=64+A_index
		char:=chr(asciii)
		hotkey,% char,vim
		hotkey,% "+"char,vim
		hotkey,% "space & "char,vim
		if(A_index<=ModeText.length())
		{
			ModeNum[ModeText[A_index]]:=A_index
		}
	}
	loop 32{
		asci:=A_index+asc("!")-1
		char:=chr(asci)
		hotkey,% char,vim
		hotkey,% "space & "char,vim
	}
	loop 35{
		asci:=A_index+asc("[")-1
		char:=chr(asci)
		hotkey,% char,vim
		hotkey,% "space & "char,vim
	}
	hotks:=["~","space","del","tab","esc","bs","enter"]
	for index,hotk in hotks
	{
		hotkey,%hotk%,vim
	}
	normal("i")
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
