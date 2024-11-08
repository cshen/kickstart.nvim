" CS: 17-Oct-2024 15:19
"
" to have Vim jump to the last position when reopening a file
" restore cursor position
augroup restore_pos | au!
    au BufWinEnter *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe 'normal! g`"zz'
                \ | endif
augroup end

" vim autocomplete menu, arrow selection. Invert left/right - up/down functions
set wildcharm=<C-Z>
let edit_re = 'e\%[dit] '
cnoremap <expr> <up> getcmdline() =~# edit_re && wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> getcmdline() =~# edit_re && wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> getcmdline() =~# edit_re && wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> getcmdline() =~# edit_re && wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

set timeoutlen=1000 ttimeoutlen=0

" Configed in keymap.lua already. CS: 13-Oct-2024 11:46
" :nmap <c-s> :w<CR>
" :imap <c-s> <Esc>:w<CR>

command! Wq wq
command! W  w
command! Q  q
command! FF Neotree float
" Open a terminal by splitting the windows.
command! Term :bot sp | term


" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

au BufWritePost * lua require('lint').try_lint()

"-----------------------------------------------------------------------
" make Terminal default mode insert
let g:previous_window = -1
function SmartInsert()
  if &buftype == 'terminal'
    if g:previous_window != winnr()
      startinsert
    endif
    let g:previous_window = winnr()
  else
    let g:previous_window = -1
  endif
endfunction
au BufEnter * call SmartInsert()

"-----------------------------------------------------------------------
" Switch on search pattern highlighting.
set         hlsearch
colorscheme evening

" The following two lines do not work for neovim-indent. Need to figure out, CS: [13-Oct-2024 17:43]
hi IblIndent guifg=drakgreen guibg=bg cterm=NONE
hi IblScope guifg=drakgreen guibg=bg cterm=NONE

hi VertSplit guibg=bg guifg=darkgreen cterm=NONE

hi lCursor      guibg=yellow  guifg=NONE
hi CursorLine   cterm=NONE  ctermbg=NONE      guibg=grey15
hi ColorColumn  ctermbg=0   guibg=grey15

hi NonText  guifg=lightblue      guibg=grey15
hi Constant gui=NONE           guibg=black   guifg=gray80
hi Special  gui=NONE             guibg=grey5
hi Comment  gui=NONE           guifg=grey65  guibg=gray15

hi MatchParen gui=bold,italic   guifg=white

hi SpellBad   guisp=yellow gui=bold,undercurl guifg=white guibg=red
hi SpellCap   guisp=white  gui=undercurl guifg=NONE guibg=NONE
hi SpellRare  guisp=blue   gui=undercurl guifg=NONE guibg=NONE
hi SpellLocal guisp=orange gui=undercurl guifg=NONE guibg=NONE

hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=gray45  guibg=gray10
"-----------------------------------------------------------------------
:set modifiable
:set ff=unix

" Transparent editing of age encrypted files. CS: 23 Oct 2024 17:34
augroup encrypted
au!
" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre      *.age set viminfo=
" We don't want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre      *.age set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre      *.age set bin
autocmd BufReadPre,FileReadPre      *.age let ch_save = &ch|set ch=2
autocmd BufReadPre,FileReadPre      *.age let shsave=&sh
autocmd BufReadPre,FileReadPre      *.age let &sh='bash'
autocmd BufReadPre,FileReadPre      *.age let ch_save = &ch|set ch=2

"
" autocmd BufReadPost,FileReadPost    *.age '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
" CS:  8 Nov 2024 14:00 YOU NEED TO CHANGE TO YOUR OWN AGE PRIVATE KEY HERE
"
autocmd BufReadPost,FileReadPost    *.age '[,']! age -d -i ~/.config/age/cs.priv.key 2> /dev/null

autocmd BufReadPost,FileReadPost    *.age let &sh=shsave
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost    *.age set nobin
autocmd BufReadPost,FileReadPost    *.age let &ch = ch_save|unlet ch_save

autocmd BufReadPost,FileReadPost    *.age execute ":doautocmd BufReadPost " . expand("%:r")
" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre    *.age set bin
autocmd BufWritePre,FileWritePre    *.age let shsave=&sh
autocmd BufWritePre,FileWritePre    *.age let &sh='bash'

" autocmd BufWritePre,FileWritePre    *.age '[,']!gpg --encrypt --default-recipient-self 2>/dev/null
" CS:  8 Nov 2024 14:01 CHANGE TO YOUR OWN AGE PUB KEY
autocmd BufWritePre,FileWritePre    *.age '[,']!age -r $(head -1 ~/.config/age/cs.pub.key) 2>/dev/null

autocmd BufWritePre,FileWritePre    *.age let &sh=shsave
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost  *.age silent u
autocmd BufWritePost,FileWritePost  *.age set nobin
augroup END



