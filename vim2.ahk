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
alt::
	suspend
	alt()
	suspend
	return
	capslock::
	Suspend
	Suspend,off
	change_mode(1)
	return
	#t::
	suspend
	run wt.exe
	sleep 300
	winactivate, ahk_exe WindowsTerminal.exe
	; winactivate 
	suspend
return

; ^ ctrl ! alt + shift # win 


rlcmd(cmd){
	static Read:=""
	if(cmd="enter"){
		command(Read)
		; print(Read,1) 
		Read:=""
		footer("")
		return 
	}else if(cmd="clear" || cmd="space & u"){
		Read:=""
	}else if(cmd="bs"|| cmd="space & h"){
		Read:=substr(Read,1,strlen(Read)-1)
	}else{
		cmd:=hk2str(cmd)
		Read:=Read . cmd
	}
	footer(strlen(Read)?Read:" ")
	return "rl"
}
command(cmd){
	static simplemap:={bb:"{browser_back}",bf:"{browser_forward}",w:"^s" ,vda:"^#d",vdn:"^#{right}",vdp:"^#{left}",vdc:"^#{f4}"
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


mcmd(cmd){
	if(cmd="q"){
		return
	}
	winGetActiveStats,t,w,h,x,y
	dh:=3
	dw:=4
	gain:=2
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
	}else if(cmd~="^[jkhlionm]$"){
		vecs:={j:[0,1],k:[0,-1],h:[-1,0],l:[1,0],m:[1,1],n:[-1,1],i:[-1,-1],o:[1,-1]}
		v:=vecs[cmd]
		x:=v[1]*dh*gain
		y:=v[2]*dh*gain
		smooth_move_mouse(cmd,x,y)
	}else if(cmd~="[udwb]$"){
		vecs:={d:[0,1],u:[0,-1],b:[-1,0],w:[1,0]}
		k:=substr(cmd,strlen(cmd))
		if(substr(cmd,1,1)="+"){
			w:=A_screenwidth
			h:=A_screenheight
		}
		v:=vecs[k]
		x:=v[1]*w/dw
		y:=v[2]*h/dh
		mousemove,x,y,0,R
	}else if(cmd~="^[zx]$"){
		tmap:={x:"down",z:"up"}
		smooth_scroll(cmd,tmap[cmd])
	}else if(cmd="space & x"){
		send ^{click wheeldown}
	}else if(cmd="space & z"){
		send ^{click wheelup}
	}else if(cmd="enter"){
		send,{enter}
	}else if(cmd~="space & [a-z0-9]"){
		k:=substr(cmd,strlen(cmd))
		press("^" k)
	}
	return "m"
}
dcmd(cmd){
	static ld:=""
	if (cmd="d"){
		whole_line()
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
	res:=dcmd(cmd="c"?"d":cmd)
	if(res){
		return res
	}
	normal("i")
}
rcmd(cmd){
	if(cmd!="esc"){
		press("{del}" cmd )
		; press("{ins}" cmd "{ins}") 
		return "r"
	}
}
gcmd(cmd,only_text:=false){
	static map:={g:"^{home}",t:"^{tab}","+t":"^+{tab}"}
	if(only_text){
		return ["move",map[cmd]]
	}
	move(map[cmd])
}
vcmd(cmd){
	static map:={x:"^x",d:"^x",y:"^c"}
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
	keywait,shift
	return "{shift down}" cmd "{shift up}"
}

normal(cmd,only_text:=false){
	static maps:=[{name:"move"
		,j:"{down}",k:"{up}",h:"{left}",l:"{right}","+g":"^{end}"
		,"space & d":"{pgdn}","space & u":"{pgup}"
		,"$":"{end}","^":"{home}",w:"^{right}",b:"^{left}"}
	,{name:"edit"
	,p:"^v",tab:"{tab}"
	,"-":"!{down}","_":"!{up}","+":"^d",bs:"{bs}"
	,x:"+{left}^x","+x":"+{right}^x",u:"^z","+u":"^y",enter:"{enter}"}
	,{name:"eval"
	,"+d":"d,$","+a":"$,i","+i":"^,i","+c":"c,$"
	,"o":"$,enter,i" ,"+o":"^,enter,k,i"
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
				mode_show("")
			}else{
				mode_show((leaders.length()<=0?"Normal":"Leader:" leaders[leaders.length()]))
			}
		}
		else{
			mode_show("Normal")
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

whole_line(delete_line:=true){
	keywait,shift
	exename:=process_name()
	line:=""
	op:=(delete_line?"^x":"")
	if(exename ~= "godot"){
		line:=""
	}else if(exename ~= "WINWORD"){
		line:="{home}" select("{end}")
	} else{
		line:="{home}" select("{end}{right}") 
	}
	press(line op)
}


change_mode(new_mode){
	old_mode:=Mode
	Mode:=new_mode
	; showMode() 
	if(old_mode=5){
		rlcmd("clear")
		footer("")
	}
	if (Mode=2){
		tooltip
		Mode:=2 
		; setnumlockstate, on 
		suspend,on
	}else if (Mode=1){
		; setnumlockstate, off  
		mode_show("Normal")
		leaders:=[]
	}else if(Mode=5){
		footer(" ")
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
	mode_show("Leader:" leaders[leaders.length()])
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
DEBUG(arg){
	tip_show(arg,10,50,3)
}
mode_show(arg){
	off:=-9999
	tip_show(arg,off,off)
}
footer(arg){
	tip_show(arg,-9990,9000,2)
}
tip_show(arg,x:=10,y:=-2000,num:=1){
	tooltip , % arg,x,y,num
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
topcmd(num){
	winset,Alwaysontop,%num%,A
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
