let b:CMT="<!--:-->"
setlocal nowrap
inoreabbrev <buffer> html <html lang="cn"><cr><head><cr><meta charset="UTF-8"><cr></head><cr><body><cr></body><cr></html><c-c>/body/b-2<cr>o
iabbrev <buffer> link <link rel="stylesheet" type="text/css" href="style.css"/>
inoremap <buffer> > ><c-c>:call TagComplete()<cr>a
function! TagComplete()
	let tags=["p","a","h1","h2","h3","h4","h5","strong","em","ol","ul","li","span","body","head","title","div","script"]
	let old0=@0
	normal! T<vt>y
	let tagname=@0
	if tags->index(tagname)>=0
		execute "normal! f>a</".tagname.">\<c-c>F<i"
	else
		execute "normal! f>"
	endif
	let @0=old0
endfunc
