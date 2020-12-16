if exists('g:loaded_finder') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_finder = 1

hi link FinderPromptBorder Normal
hi link FinderPreviewBorder Normal
hi link FinderListBorder Normal
hi link FinderPromptHighlight Normal
hi link FinderPreviewHighlight Normal
hi link FinderListHighlight Normal
hi link FinderListSelection Visual
hi FinderListMatch gui=bold guifg=#af4c09 ctermfg=yellow
hi link FinderPromptCommand Normal
