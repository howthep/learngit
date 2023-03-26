let b:CMT='"'
if (v:version >= 900 && getline(1) == "vim9script")
	let b:CMT = "#"
	" setlocal foldmethod=indent 
endif
