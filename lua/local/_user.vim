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

