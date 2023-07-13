#singleinstance force
split(str,delm:=" "){
	arr:=[]
	loop,parse,str,%delm%
	{
		if strlen(A_loopfield)
			arr.push(A_loopfield)
	}
	return arr
}
join(arr,delm){
	str:=""
	for i,v in arr
	{
		if (i<arr.length())
			str:=str . v . delm
		else
			str:=str . v 
	}
	return str
}

test(){
	abc:="tp 100"
	arr:=split(abc,"1")
	print("$" . join(arr,"-") . "^",1)
}
	; test() 

print(arg,time:=""){
	msgbox,,,% arg,% time
}
process_name(){
	winget,name,processname,A
	return name
}
press(arg){
	if arg=""
		return
	send,% arg
}
