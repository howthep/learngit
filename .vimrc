" /c/Users/86159/.vim/ftplugin/javascript.vim
" /c/Users/86159/.vim/ftplugin/html.vim
function SmartBracket(brc)	
	let line = getline('.')
	let cursor = col('.')
	let char = nr2char(strgetchar(line,cursor))
	if char ==a:brc
		execute("normal x")
		"execute('print')
	else
		execute("normal a")
	endif
endfunction

function SmartCR()
	let lnum = line('.')
	let line1 = getline(lnum)
	let ind = indent(lnum-1)

	if line1 =~ '^\s*}'
		execute('normal O ')
		" execute("normal O\<Tab>\<BS>")
	" else 
	" 	call setline(lnum,repeat("\<Tab>",ind/&tabstop)..line1)
	endif
endfunction

imap <CR> <CR><Esc>:call SmartCR()<CR>A
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
set smartindent
set enc=utf-8
set mouse=
set is
set guifont =Lucida_Sans_Typewriter:h20:cANSI:qDRAFT 
:set sessionoptions+=unix,slash
set smartcase
:map <F2> oDate: <Esc>:read !date<CR>kJk
:map <F3> "+p

inoremap ( ()<Left>
inoremap ` ``<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
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
