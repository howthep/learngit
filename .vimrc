" ~/.vim/ftplugin/typescript.vim
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

function! SmartCR()
	let lnum = line('.')
	let line1 = getline(lnum)
	let ind = indent(lnum-1)

	if line1 =~ '^\s*}'
		execute('normal! O ')
		" else 
		" 	call setline(lnum,repeat("\<Tab>",ind/&tabstop)..line1)
	endif
endfunction
"}}}"

inoremap <CR> <CR> <Esc>:call SmartCR()<CR>s

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
"}}}"

"disable key" "{{{
 
noremap <Up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <c-c> <nop>
inoremap jk <esc>
inoremap <esc> <nop>
"}}}"

"normal map{{{
 
nnoremap <F2> oDate: <Esc>:read !date<CR>kJk
nnoremap <F3> "+p
nnoremap  <cr> za
nnoremap H ^
nnoremap L $
nnoremap gu gU
nnoremap gU gu

"}}}

"autocmd group for different filetype{{{
augroup maingroup
	autocmd!
	"autocmd	Filetype {qf} nnoremap <leader>c :.cc<cr>
	autocmd	Filetype {txt,help} setlocal nowrap
	autocmd	Filetype markdown setlocal smartindent
	autocmd Filetype markdown onoremap <buffer>il :<c-u>execute "normal! $?^\\s*-\\s?e\r:nohlsearch\rlvg_"<cr>
	autocmd	Filetype sh  nnoremap <buffer> <F5> :w\|!bash %<cr>
	autocmd	Filetype vim nnoremap <buffer> <F5> :w\|so %<cr>
	autocmd	Filetype python nnoremap <buffer> <F5> :w\|!python3 %<cr>
	"autocmd	Filetype lua nnoremap <buffer> <F5> :w\|luafile %<cr>
	autocmd	Filetype vim setlocal foldmethod=marker
	autocmd	Filetype vim iabbrev <buffer> iabf iabbrev <buffer>
	autocmd	Filetype vim iabbrev <buffer> bf <buffer>
	autocmd	Filetype vim iabbrev <buffer> fdmk "{{{<cr><cr>}}}<up><bs>
	"for comment flag"
	autocmd	Filetype vim let b:CMT='"'
	autocmd	Filetype {python,sh} let b:CMT='#'
	autocmd	Filetype {lua} let b:CMT='--'
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
inoremap <c-D> <esc>^Da
inoremap <c-U> <esc>viwUea
"}}}

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoreabbr h vertical help

" leader map{{{
 
""let mapleader = "\\"
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
nnoremap <leader>j <c-d>
nnoremap <leader>k <c-u>
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

"operator map{{{
 

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
"}}}"

"visual map
vnoremap H ^
vnoremap L $



"TODO
"add comment which is at head and end,like html
"Comment {{{
 
function! Comment()
	if len(b:CMT)==0
		echo "you need let b:CMT is you comment"
		return
	endif
	let line=getline(".")
	if line=~#'\V\^\s\*'..b:CMT
		execute "normal! zn^".repeat('x',len(b:CMT." "))."zN"
	else
		execute "normal! I".b:CMT."\<Space>"
	endif
endf
nnoremap  <leader>c :call Comment()<cr>
vnoremap  <leader>c :call Comment()<cr>
"}}}"
