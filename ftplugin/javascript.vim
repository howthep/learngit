se include=^import\s\w+\simport
iabbr cosnt const
iabbr conts const
iabbr <buffer> import import$1 from '$2'<C-c>0/\$<cr>c2w
iabbr <buffer> if if()<Left>
iabbr <buffer> function function (){}<C-c>i<CR>return ;<C-o>O
" inoremap<F5> <Esc>:w <CR>:so %<CR>
" nnoremap<F5> <Esc>:w <CR>:so %<CR>
augroup jsro
	au!
	autocmd BufWritePre,Bufread * :normal mt=ap`t
augroup END

inoremap <buffer> <S-tab> <c-c>/\v\$\w<cr>c2w
