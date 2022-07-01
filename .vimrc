" /c/Users/86159/.vim/ftplugin/javascript.vim
" ~/.vim/ftplugin/rust.vim
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

func SmartDelete()
	echo 111
endf

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


set fileencodings=utf-8,gbk
set enc=utf-8
set mouse=
set incsearch
""set guifont =Lucida_Sans_Typewriter:h18:cANSI:qDRAFT 
:set sessionoptions+=unix,slash
set smartcase
:map <F2> oDate: <Esc>:read !date<CR>kJk
:map <F3> "+p

autocmd	Filetype markdown se nocindent
autocmd	Filetype rust se smartindent
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
			normal %
		if ind %2==0
			let start = cursor
			""let end = match(line,pairs[ind+1],cursor)
			let end = col(".")-1
		else
			let end = cursor
			""let start = match(line,pairs[ind-1],0)
			let start =col('.')-1
		endif	
			normal %
		""echo line[start]
		""echo line[end]
		let head = strcharpart(line,0,start)
		let rest = strcharpart(line,start,strlen(line)-start)
		""echo 'head'.head 
		""echo "rest".rest 
		let sub=strcharpart(line,start,end-start+1)
		""echo sub
		let trimStr = strcharpart(sub,1,strlen(sub)-2)
		""echo "target: "..trimStr

		let res =head..substitute(rest,sub,trimStr,"")
		""echo res
		call setline(".",res)
		if ind%2==0
			normal hh
		endif
	else
		normal x
	endif
endf


inoremap <C-H> <ESC>:call SmartDelete()<cr>a
"aa"
