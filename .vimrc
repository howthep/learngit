" ~/.vim/ftplugin/typescript.vim
"function! SmartBracket(brc)	{{{
 
function! SmartBracket(brc)	
	let line = getline('.')
	let cursor = col('.')
	let char = nr2char(strgetchar(line,cursor))
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
colorscheme desert
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
""set guifont =Lucida_Sans_Typewriter:h18:cANSI:qDRAFT 
set sessionoptions+=unix,slash
set smartcase
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

nnoremap <F2> oDate: <Esc>:read !date<CR>kJk
nnoremap <F3> "+p
nnoremap <cr> za
nnoremap H ^
nnoremap L $

"autocmd group for different filetype{{{
augroup maingroup
	autocmd!
	autocmd	Filetype markdown setlocal smartindent
	autocmd Filetype markdown onoremap <buffer>il :<c-u>execute "normal! $?^\\s*-\\s?e\r:nohlsearch\rlvg_"<cr>
	""autocmd	Filetype rust se smartindent
	autocmd	Filetype sh  nnoremap <buffer> <F5> :w\|!bash %<cr>
	autocmd	Filetype vim nnoremap <buffer> <F5> :w\|so %<cr>
	autocmd	Filetype vim setlocal foldmethod=marker
	autocmd	Filetype vim iabbrev <buffer> iabf iabbrev <buffer>
	autocmd	Filetype vim iabbrev <buffer> bf <buffer>
	autocmd	Filetype vim iabbrev <buffer> fdmk "{{{<cr><cr>}}}<up><bs>
	autocmd	Filetype vim let b:CMT='"'
	autocmd	Filetype python let b:CMT='#'
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
"}}}"

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

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
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"}}}"

"normal and visual map same key{{{
nnoremap _ :.m.-2<cr>
nnoremap - :.m.+1<cr>
nnoremap + :.t.<cr>
vnoremap - :'<,'>m'>+1<cr>gv
vnoremap _ :'<,'>m'<-2<cr>gv
vnoremap + :'<,'>t'<-1<cr>gv

nnoremap & :&&<CR>
vnoremap & :&&<CR>
"}}}"

"operator map{{{
 
onoremap p i(
onoremap u i{
"curly:c is ban,so i use u,u is also like the shape of {}"
onoremap s i[
onoremap q i"
"quote"
onoremap P a(
onoremap U a{
onoremap S a[
onoremap Q a"
onoremap H ^
onoremap L $
"}}}"

" func!  SmartDelete() "{{{
 
func!  SmartDelete()
	""echom "SmartDelete"
	let line = getline(".")
	let cursor = col(".")-1
	let char= line[cursor]
	let pairs=['(',')','{','}']
	let ind = index(pairs,char)
	if ind>=0
		let end=0
		let start=0
		normal! %
		if ind %2==0
			let start = cursor
			""let end = match(line,pairs[ind+1],cursor)
			let end = col(".")-1
		else
			let end = cursor
			""let start = match(line,pairs[ind-1],0)
			let start =col('.')-1
		endif	
		normal! %
		""echo line[start]
		""echo line[end]
		let head = strcharpart(line,0,start)
		let rest = strcharpart(line,start,strlen(line)-start)
		""echo 'head'.head 
		""echo "rest".rest 
		let sub=strcharpart(line,start,end-start+1)
		""echom sub
		let trimStr = strcharpart(sub,1,strlen(sub)-2)
		""echom "target: "..trimStr

		let res =head..substitute(rest,'\V'.sub,trimStr,"")
		""echom res
		call setline(".",res)

		""call cursor(line('.'),7)
		call cursor(line('.'),cursor-1+(ind+1)%2)
	else
		execute "normal! a\<bs>"
	endif
endf
"}}}"
inoremap <C-H> <ESC>:call SmartDelete()<cr>a

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
		execute "normal! ^".repeat('x',len(b:CMT))
	else
		execute "normal! I".b:CMT
	endif
endf
nnoremap  <leader>c :call Comment()<cr>
vnoremap  <leader>c :call Comment()<cr>
"}}}"
