" ~/.vim/ftplugin/javascript.vim
" ~/.vim/ftplugin/html.vim
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
	let line = getline('.')
	let cursor = col('.')
	let chr = nr2char(strgetchar(line,cursor))
	"chr is char after cursor"
	echo chr
	if chr =='}'
		execute("normal! a\<cr>\<esc>k$")
	endif
endf
func Snippet(abbr,snip)
	let cmd ="inoreabbr <buffer> ".a:abbr ." ".a:snip
	let cmd .='<C-c>?$1<cr>c2w'
	execute(cmd)
endf
augroup jsro
	au!
	autocmd BufWritePre,Bufread * :normal mt=ap`t
augroup END
inoremap <CR> <ESC>:call SmartCR()<cr>a<cr>
syntax on
filetype plugin on
filetype indent on
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
set is

set guifont =Lucida_Sans_Typewriter:h18:cANSI:qDRAFT 
:set sessionoptions+=unix,slash
set smartcase
:map <F2> oDate: <Esc>:read !date<CR>kJk
:map <F3> "+p

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
