function SmartTag()
	let currentLine = getline('.')
	" s/\v\<(\w+)\>/\0<\/\1>
	let change = substitute(currentLine,'\v\<(\w+)\>','\0  <\/\1>','')
	call setline('.',change)
	call cursor('.',col('.')+1)
endfunction
inoremap > ><Esc>:call SmartTag()<CR>a
" inoremap<F5> <Esc>:w <CR>:so %<CR>
" nnoremap<F5> <Esc>:w <CR>:so %<CR>
set mps+=<:> 
