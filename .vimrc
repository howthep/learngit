" /c/Users/86159/.vim/ftplugin/javascript.vim
" /c/Users/86159/.vim/ftplugin/html.vim
function SmartBracket(brc)	
	let line = getline('.')
	let cursor = col('.')
	let char = nr2char(strgetchar(line,cursor))
	let pairs=['"','`',"'"]
	if char ==a:brc
		" there is brc, so just delete it
		execute("normal x")
	elseif index(pairs,a:brc)>-1
		execute('normal! i'..a:brc)
	endif
endfunction

function SmartCR()
	let lnum = line('.')
	let line1 = getline(lnum)
	let ind = indent(lnum-1)

	if line1 =~ '^\s*}'
		execute('normal O ')
		" else 
		" 	call setline(lnum,repeat("\<Tab>",ind/&tabstop)..line1)
	endif
endfunction

inoremap <CR> <CR> <Esc>:call SmartCR()<CR>s
syntax on
filetype plugin on
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
set foldlevel=1

set cindent

set fileencodings=utf-8,gbk
set enc=utf-8
set mouse=
set incsearch
set guifont =Lucida_Sans_Typewriter:h18:cANSI:qDRAFT 
:set sessionoptions+=unix,slash
set smartcase
:map <F2> oDate: <Esc>:read !date<CR>kJk
:map <F3> "+p

autocmd	Filetype markdown se nocindent
autocmd	Filetype sh  nnorem <F5> :w\|!bash %<cr>
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
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
vnoremap \[ c[<C-r>"]<Esc>
vnoremap \] c[<C-r>"]<Esc>
vnoremap \( c(<C-r>")<Esc>
vnoremap \) c(<C-r>")<Esc>
vnoremap \' c'<C-r>"'<Esc>
nnoremap & :&&<CR>
vnoremap & :&&<CR>
