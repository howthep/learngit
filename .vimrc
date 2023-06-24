"~/.vim/ftplugin/html.vim 
"function! SmartBracket(brc)	{{{
 
function! SmartBracket(brc)	
	let line = getline('.')
	let cursor = col('.')
	"let char = nr2char(strgetchar(line,cursor))
	let char = strcharpart(line,cursor,1)
	let pairs=['"','`',"'"]
	if char ==a:brc
		" there is brc, so just delete it
		execute("normal! x")
	elseif index(pairs,a:brc)>-1
		execute('normal! i'..a:brc)
	endif
	
endfunction

"}}}

syntax on
filetype plugin on
filetype indent on
"set options{{{
 
set conceallevel=0
set noundofile
set nobackup
set number
set ruler
set noswapfile
set showmode
set showcmd

"colorscheme slate
colorscheme odesert
set scrolloff=2
set shiftwidth=4
set tabstop=4
set softtabstop=4
set foldcolumn=2
set foldmethod=indent
set foldlevelstart=0
set foldlevel=1


set fileencodings=utf-8,gbk
set enc=utf-8
set mouse=
set incsearch
set nohlsearch
"set guifont =Lucida_Sans_Typewriter:h18:cANSI:qDRAFT 
set sessionoptions+=unix,slash
set smartcase

set winwidth=80
"}}}

"disable key" "{{{
 
noremap <Up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
" inoremap <c-c> <nop>
inoremap jk <esc>
inoremap <esc> <nop>
"}}}

"normal map{{{
 
nnoremap <F2> oDate: <Esc>:read !date<CR>kJk
nnoremap <F3> "+p
nnoremap H ^
nnoremap L $
nnoremap gu gU
nnoremap gU gu

"}}}

"autocmd group for different filetype{{{
function! MapCR()
	if mapcheck("\<cr>")->len()==0 
		nnoremap <buffer> <cr> za
	endif
endfunction

augroup maingroup
	autocmd!
	autocmd	BufRead * call MapCR()
	" autocmd	Filetype * call MapCR()
	autocmd	Filetype {txt,help} setlocal nowrap
	autocmd	Filetype markdown setlocal smartindent
	autocmd	Filetype sh  nnoremap <buffer> <F5> :w\|!bash %<cr>
	autocmd	Filetype perl  nnoremap <buffer> <F5> :w\|!perl %<cr>
	autocmd	Filetype vim nnoremap <buffer> <F5> :w\|so %<cr>
	autocmd	Filetype python nnoremap <buffer> <F5> :w\|!python3 %<cr>
	autocmd	Filetype autohotkey nnoremap <buffer> <F5> :w\|!powershell.exe start %<cr>
	autocmd	BufRead .vimrc setlocal foldmethod=marker
	autocmd	Filetype vim iabbrev <buffer> iabf iabbrev <buffer>
	autocmd	Filetype vim iabbrev <buffer> bf <buffer>
	autocmd	Filetype vim iabbrev <buffer> fdmk "{{{<cr><cr>}}}<up><bs>
	"for comment flag
	autocmd	Filetype {python,sh,perl} let b:CMT='#'
	autocmd	Filetype {lua} let b:CMT='--'
	autocmd	Filetype {c} let b:CMT='//'
	autocmd	Filetype {css} let b:CMT='/*:*/'
	"
	autocmd	Filetype {qf} unmap <buffer> <cr>
augroup END
"}}}


"insert map{{{
 
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

inoremap } }<Esc>:call SmartBracket('}')<CR>a
inoremap " "<Esc>:call SmartBracket('"')<CR>a
inoremap ' '<Esc>:call SmartBracket("'")<CR>a
inoremap ` `<Esc>:call SmartBracket('`')<CR>a
inoremap ] ]<Esc>:call SmartBracket(']')<CR>a
inoremap ) )<Esc>:call SmartBracket(')')<CR>a

inoremap <C-L> <DEL>
inoremap <c-U> <esc>viwUea
"}}}

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoreabbr h vertical help

" leader map{{{
 
"let mapleader = "\\"
let mapleader="\<space>"
vnoremap <leader>{ c{<C-r>"}<Esc>
vnoremap <leader>} c{<C-r>"}<Esc>
vnoremap <leader>[ c[<C-r>"]<Esc>
vnoremap <leader>] c[<C-r>"]<Esc>
vnoremap <leader>( c(<C-r>")<Esc>
vnoremap <leader>) c(<C-r>")<Esc>
vnoremap <leader>' c'<C-r>"'<Esc>
vnoremap <leader>" c"<C-r>""<Esc>
vnoremap <leader>* c*<C-r>"*<Esc>
vnoremap <leader>_ c_<C-r>"_<Esc>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>bb :buffers <cr>
nnoremap <leader>bn :w\|bn <cr>
nnoremap <leader>bp :w\|bp <cr>
nnoremap <leader>sw *
nnoremap <leader>j <c-d>
nnoremap <leader>k <c-u>
nnoremap <leader><leader> <nop>
"}}}

"normal and visual map same key{{{
nnoremap _ :.move.-2<cr>
nnoremap - :.move.+1<cr>
nnoremap + :.copy.<cr>
vnoremap - :move'>+1<cr>gv
vnoremap _ :move'<-2<cr>gv
vnoremap + :copy'<-1<cr>gv
"vnoremap + :'<,'>t'<-1<cr>gv

nnoremap & :&&<CR>
vnoremap & :&&<CR>
"}}}"

" operator map{{{
onoremap p i(
onoremap u i{
"curly:c is ban,so i use u,u is also like the shape of {}
onoremap s i[
onoremap q i"
"quote
onoremap P a(
onoremap U a{
onoremap S a[
onoremap Q a"
onoremap H ^
onoremap L $
"}}}

" visual map
vnoremap H ^
vnoremap L $


" TODO
" add comment which is at head and end,like html,css
" function Comment {{{
 
function! Comment()
	let acmt=&cms->split("%s")
	if len(getbufvar(bufname(),"CMT"))>0
		let acmt=b:CMT->split(":")
	endif
	let head=acmt[0]
	let tail=acmt->get(1,"")
	
	let line=getline(".")
	let matched=line->matchstr('\V\^\s\*'.head.'\s\*\zs\.\*\ze'.tail.'\$')
	let newline=""

	if len(matched)!=0
		" echo "is comment" 
		let indent=line->matchstr('\v^\zs\s*\ze.*')
		let newline=indent.matched->trim()
	else
		" echo "not is comment" 
		let newline=substitute(line,'\v^(\s*)(.*)','\1'.head.' \2 '.tail,'')
	endif
	call setline(".",newline)
	normal ^
endf 
nnoremap  <leader>c :call Comment()<cr>
vnoremap  <leader>c :call Comment()<cr>
"}}}
