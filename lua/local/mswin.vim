" Set options and add mapping such that Vim behaves a lot like MS-Windows
"
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last Change:	2024 Mar 13
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>

" Bail out if this isn't wanted.
if exists("g:skip_loading_mswin") && g:skip_loading_mswin
  finish
endif

" set the 'cpoptions' to its Vim default
if 1	" only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
set selection=exclusive
set selectmode=mouse,key
set mousemodel=popup
set keymodel=startsel,stopsel

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
vnoremap <BS> d

" the better solution would be to use has("clipboard_working"),
" but that may not be available yet while starting up, so let's just check if
" clipboard support has been compiled in and assume it will be working :/
if has("clipboard")
    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x

    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " CTRL-V and SHIFT-Insert are Paste
    map <C-V>		"+gP
    map <S-Insert>		"+gP

    cmap <C-V>		<C-R>+
    cmap <S-Insert>		<C-R>+
endif

" restore 'cpoptions'
set cpo&
if 1
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endif
