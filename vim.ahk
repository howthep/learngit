/*TODO
1. not use in some exe
2. visual mode
*/
motion:="no"
ModeText:=["Normal","Insert"]
mode:=1 
;#Usehook
loop{
	blockinput off
	if(mode=1){
		Tooltip,% Format("keycode:{1:d},mode:{2:s}`n,{3:s},{4:s}",Asc(inchar),ModeText[mode] ,winexe,inchar) , 5,0
		input ,inchar,M I C L1 
		blockinput on
	 }else{
		Tooltip,
		continue
	  }
	Tooltip,% Format("keycode:{1:d},mode:{2:s}`n,{3:s},{4:s}",Asc(inchar),ModeText[mode] ,winexe,inchar) , 5,0
	 winget, winexe, processname, A
 if(inchar and mode=1){
	 if(motion!="no"){
		 keywait, shift
		if (motion=inchar){
		  send,{home}{shift down}{end}
		 }
		else{
			send,{shift down}
			Normal(inchar)
		 }
		send,{shift up}
		switch motion{
			case "d":
				send,{bs}
			case "c":
				send,{bs}
				mode:=2
		 }
		motion:="no"
	 }else{
		Normal(inchar)
	  }
 }
}
Normal(cmd){
	global mode
	global motion
	 switch Asc(cmd){
		 case Asc("d"):
			motion:="d"
		 case Asc("c"):
			motion:="c"
		 case Asc("o"):
			 send,{end}{enter}
			 mode:=2
		 case Asc("O"):
			 send,{up}{end}{enter}
			 mode:=2
		 case Asc("A"):
			 send,{end}
			 mode:=2
		 case Asc("g"):
			 send,{home}
		 case Asc("G"):
			 send,{end}
		 case Asc("k"):
			 send,{up}
		 case Asc("j"):
			 send,{down}
		 case Asc("h"):
			 send,{left}
		 case Asc("l"):
			 send,{right}
		 case Asc("w"):
			 send,^{right}
		 case Asc("b"):
			 send,^{left}
		 case Asc("x"):
			 send,{bs}
		 case Asc("X"):
			 send,{del}
		 case Asc("u"):
			 send,^z{right}{left}
		 case 18:
			 send,^+z
		 case 4:
			 send,{pgdn}
		 case 21:
			 send,{pgup}
		 case Asc("i"):
			 mode:=2
		}	

 }
::opva::open vim.ahk{enter}

^g::
;winget, name, processname, A
msgbox,% Format("keycode:{1:d},mode:{2:s},{3:s},motion:{4:s}",Asc(inchar),ModeText[mode] ,winexe,motion)
return

capslock::
mode=1
return

