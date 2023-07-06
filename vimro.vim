nnoremap <F5> :w\|so %<CR>
inoremap <F5> <c-c>:w\|so % <CR>
""
if &ft !="markdown"
	echo "md"
endif
func SmartDelete(offset)
	let cursPos=col('.')
	let line = getline('.')
	let chr = nr2char(strgetchar(line,cursPos+a:offset))
	let pairs = split(&mps,'\v(,|:)')
	echo pairs
	let id =index(pairs,chr) 
	let temp=@"
	if id>=0
		if id%2==1
			execute printf('normal! %%xf%sx',chr)
		else
			execute printf('normal! %%xF%sx',chr)
		endif
	else
		execute "normal ".(a:offset>=0?'l':'')."x"
	endif
	let @"= temp
endf
inoremap <C-h> <c-c>:call SmartDelete(-1)<cr>i
inoremap <C-l> <c-c>:call SmartDelete(0)<cr>i

" multiple conditions"{
"set ignorecase
"if 'bb' ==# 'BB'
"	"case sensitive"
"	echo 'bb != BB'
" elseif 'bb'==?'BB' 
"	"case insensitive"
"	echo 'bb == BB!!!'
"else
"	echo 'none'
"endif

"if '===' =~# '\v^\=+'
"	echo 'equals line'
"endif
"" }

"define function"
func Hello(foo,...)
	"rest arguments"
	echo "hello ".join(a:000,', ').'. '.a:0.' people'
endf
call Hello('ros','pam','seu')

func TextWidthIsTooWide()
	if &l:textwidth> 80
		return 1
	endif
	"default return 0"
endf

if TextWidthIsTooWide()
	echo 'to wide'
endif
"lambda"{
echo map([1,2,3],{index,value->value*value})	
	 " }
"loop"{
" for item in split(@a)
" 	echo item
" endfor
" let [x,temp]=[0,'']
" while x<5
" 	let temp.=x
" 	let x+=1
" endwhile
" echo printf('result: %s',temp)
" " }

" using variations"{
" let @a='big brother is watching you'
" echo @a
" echo 'r u finding "'.@/ .'"'
" echo 'color is '. g:colors_name
" " }

"number"{
"echo 2.3e+2
"echo 1.8e-3
"echo 2*2.0
"echo 3/2
"echo 3/2.0
""}

"string"{
" echo '-1aaA'+'101bbB'
" echo 1.'22jj'
" echo "\\n\n\"\ta"
" echo 'this''s enough'
" echo strlen(@a)
" echo split(@a)
" echo toupper(@a)
" echo join(split('a,v,c,e',','),'_')
"}
"list{
" let arr =[0,1,2,3,4,5]+[0,2,2] 
" echo get(arr,100,'err').index(arr,5).len(arr)
"} 
