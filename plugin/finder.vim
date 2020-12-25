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
hi finder_match gui=bold guifg=#af4c09 ctermfg=yellow
hi link FinderListMatch finder_match
hi link FinderPromptCommand Normal
hi link FinderPreviewLine Visual

function! s:finder_completion_function(...)
  return join(luaeval('vim.tbl_keys(require("finder"))'), "\n")
endfunction

command! -nargs=+ -complete=custom,s:finder_completion_function Finder lua require'finder.command'.run_command([[<args>]])
