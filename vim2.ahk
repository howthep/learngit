; When you get stucked, maybe you use = to assign, instead of := 
; Array start by index 1 not 0 
#include %A_scriptDir%/lib.ahk
#singleInstance force
#usehook
listlines off

global Mode:=1
global Motion:=""
global Count:=""
global Leader:=""
global cReplace:=0
global ModeText:=["Normal","Insert","Motion","Mouse","Command","Replace","View"]
global ModeNum:=[]

change_mode(1)
setCapsLockState,AlwaysOff
loop 26{
	if(A_index<=10){
		hotkey,% A_index-1,vim
		hotkey,% "space & " (A_index-1),vim
	}
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
hotks:=["$","^","space","tab","+","_","-","@","esc","bs","enter",";",".",":","?"]
for index,hotk in hotks
{
	hotkey,%hotk%,vim
}

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

readline(cmd){
	static Read:=""
	if(cmd="enter"){
		command(Read)
		; print(Read,1) 
		Read:=""
		back_normal()
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


mouse(cmd){
	; click-as
	; fine tone-hjklionm
	; wide move-udwb
	; scroll-zx
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
	}else if(cmd="z"){
		smooth_scroll("z","up")
	}else if(cmd="enter"){
		send,{enter}
	}else if(cmd="q"){
		back_normal()
	}else if(cmd~="space & [a-z0-9]"){
		k:=substr(cmd,strlen(cmd))
		; print(k) 
		press("^" k)
	}
}

motion(cmd){
	static map:={d:"^x",y:"^c",c:"^x"}
	static temp:=""
	if(cmd!=Motion){
		keywait,shift
		send,{shift down}
		if(cmd="f"){
			cmd.=",c"
		}
		execute(cmd)	 
		exename:=process_name()
		if(exename="WINWORD.EXE"){
			if(cmd="$"){
				send,{left}
			}
		}
		send,{shift up}
	}else{
		whole_line()
	}
	if (map[Motion]){
		press(map[Motion])
	}else if Motion in u,+u
	{
		save:=clipboard
		clipboard:=""
		press("^c")
		clipwait
		copied:=clipboard
		if(Motion="u"){
		stringupper,copied,copied
		}else {
		stringlower,copied,copied
		}
		clipboard:=copied
		press("^v")
		sleep,2
		clipboard:=save
	}
	if(Motion="c"){
		change_mode(2) ; to insert
	}
	else{
		back_normal()
	}
}

normal(cmd){
	static maptable:={k:"{up}",l:"{right}",h:"{left}",w:"^{right}",b:"^{left}"
		 ,"space & d":"{pgdn}","space & u":"{pgup}","+g":"{end}"
		 ,tab:"{tab}"
		 ,p:"^v",copy:"^c",cut:"^x"
		 ,x:"{bs}","+x":"{del}",u:"^z","+u":"^y"
		 ,esc:"",space:"{space}",enter:"{enter}","$":"{end}","^":"{home}"}
	static normap:={s:"x,i","+s":"+x,i"
		,e:"l,w,h"
		,"+i":"^,i","+a":"$,i","a":"l,i",o:"$,enter,i","+o":"k,$,enter,i"}
	static lastcmd:="init"
	mapkey:=objrawget(maptable,cmd)
	norkey:=objrawget(normap,cmd)
	if(process_name() ~= "godot" ){
		godotmap:={"+":"^d","-":"!{down}","_":"!{up}"}
		if(mapkey=""){
			mapkey:=godotmap[cmd]
		}
		}
	if(mapkey!=""){
		press(mapkey)
	}else if(norkey!=""){
		arr:=split(norkey,",")
		for i,value in arr 
		{
			normal(value)
		}
	}else if(cmd = "j"){
		if(process_name()="msedge.exe"){
			edge_pdf_focus()
		}
		send,{Down}
	}else if(cmd="i"){
		change_mode(2)
	}else if(cmd="nop"){
		return
	}else if cmd in d,c,y
	{
		to_motion(cmd)
	}else if(cmd ~= "^\+(d|c|y)$"){
		execute(substr(cmd,2) ",$")
	}else if(cmd="+r"){
		cReplace:=1
		normal("r")
	}else if(cmd=";"){
		fcmd()
	}else if(cmd="r"){
		change_mode(6)
	}else if(cmd=":"){
		change_mode(5)
	}else if(cmd="."){
		normal(lastcmd)
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
	}else if cmd in f,g
	{
		Leader:=cmd
		return
	}else if(cmd="m"){
		change_mode(ModeNum["Mouse"])
	}else if(cmd="v"){
		change_mode(ModeNum["View"])
	}
	if !(cmd ~= "^(\.|:|enter)$"){
		lastcmd:=cmd
	}
}

; ============================================================
; below code is small functions
; ============================================================
hk2str(cmd){
	if(cmd="space"){
		cmd:=" "
	}else if(cmd="esc"){
		cmd:=""
	}else if(cmd ~= "^\+[a-z]$"){
		cmd:=substr(cmd,2)
		stringupper,cmd,cmd
	}
	return cmd
}
fcmd(cmd:=""){
	static last:=""
	cmd:=(cmd=""?last:cmd)
	last:=cmd
	setkeydelay,1
	c:=clipboard
	normal("+y")
	times:=Instr(clipboard,cmd,true)
	send,{left}{right %times%}
	setkeydelay,10
	clipboard:=c
	; clipboard:="heko" 
}
gcmd(cmd:=""){
	static keymap:={g:"{home}",d:"#d"}
	mapkey:=objrawget(keymap,cmd)
	if(mapkey){
		press(mapkey)
	}else if(cmd="u" ||cmd="+u"){
		to_motion(cmd)
	}
	; clipboard:="heko" 
}

vim(cmd:=""){
	listlines off
	showMode()
	cmd:=(cmd=""?A_thishotkey:cmd)
	stringlower,cmd,cmd
	if(cmd ~= "^[0-9]$"&&Mode!=5){
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
	if(Leader!=""){
		Leader:=%Leader%cmd(cmd)
		return
	}
	m:=ModeText[Mode]
	stringlower,m,m
	if(m="command"){
		m:="readline"
	}
	%m%(cmd)
	return
}

whole_line(){
	exename:=process_name()
	keywait,shift
	send,{up}{end}{right}
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
	showMode()
	if(old_mode=5){
		readline("clear")
		tip_show("",10,9000,2)
	}
	if (Mode=2){
		tooltip
		Mode:=2 
		; setnumlockstate, on 
		suspend,on
	}else if (Mode=1){
		; setnumlockstate, off  
		cReplace:=0
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

replace(cmd){
	cmd:=hk2str(cmd)
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
