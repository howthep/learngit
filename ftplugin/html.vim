if &ft==#'html'
setlocal nowrap
iabbrev <buffer> p <p></p><esc>F<i
iabbrev <buffer> div <div></div><esc>F<i
iabbrev <buffer> script <script src=""></script><esc>F=la
iabbrev <buffer> html <html lang="cn"><cr><head><cr></head><cr><body><cr></body><cr></html><esc>/head/b-2<cr>o
iabbrev <buffer> title <title></title><esc>F<i
iabbrev <buffer> link <link rel="stylesheet" type="text/css" href="style.css"/><esc>Fsa
endif
