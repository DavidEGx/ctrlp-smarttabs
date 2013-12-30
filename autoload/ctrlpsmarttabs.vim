" =============================================================================
" File:          autoload/ctrlp-smarttabs/ctrlpsmarttabs.vim
" Description:   ctrlp extension to switch between opened tabs
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['smarttabs']
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'smarttabs',
"         \ 'another_extension',
"         \ 'another_extension',
"         \ ]

" Load guard
if ( exists('g:loaded_ctrlp_smarttabs') && g:loaded_ctrlp_smarttabs )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_smarttabs = 1


" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlpsmarttabs#init()',
	\ 'accept': 'ctrlpsmarttabs#accept',
	\ 'lname': 'Smart Tabs',
	\ 'sname': 'Tabs',
	\ 'type': 'line',
	\ 'enter': 'ctrlpsmarttabs#enter()',
	\ 'exit': 'ctrlpsmarttabs#exit()',
	\ 'opts': 'ctrlpsmarttabs#opts()',
	\ 'sort': 0,
	\ 'specinput': 0,
	\ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlpsmarttabs#init()
  let l:tablist    = []
  let l:tabnumbers = reverse(range(1,tabpagenr("$")))

  for tabnumber in l:tabnumbers
    let l:buflist = tabpagebuflist(tabnumber)
    for bufid in l:buflist
      let l:bufname = bufname(bufid)
      if (strlen(l:bufname) > 0 && bufloaded(bufid) == 1 && buflisted(bufid) > 0)
        call add(l:tablist, tabnumber . ": " . l:bufname)
      endif
    endfor
  endfor

  return l:tablist
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlpsmarttabs#accept(mode, str)
  let l:tabnumber = split(a:str, ":")[0]
  let l:bufname   = strpart(split(a:str, ":")[1], 1)
  let l:bufname   = fnamemodify(l:bufname, ":p")

  " Move to the appropriate tab
  execute "normal! " . l:tabnumber . "gt"

  " Move to the appropriate window
  let l:window_number = bufwinnr(bufnr(l:bufname))
  execute l:window_number . "wincmd w"

	call ctrlp#exit()
endfunction


" (optional) Do something before enterting ctrlp
function! ctrlpsmarttabs#enter()
endfunction


" (optional) Do something after exiting ctrlp
function! ctrlpsmarttabs#exit()
endfunction


" (optional) Set or check for user options specific to this extension
function! ctrlpsmarttabs#opts()
endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlpsmarttabs#id()
	return s:id
endfunction




" vim:nofen:fdl=0:ts=2:sw=2:sts=2
