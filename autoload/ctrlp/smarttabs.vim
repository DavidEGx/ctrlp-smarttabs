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
let g:loaded_ctrlp_smarttabs  = 1
let s:ctrlp_smarttabs_tabline = ""
if !exists('g:ctrlp_smarttabs_modify_tabline') | let g:ctrlp_smarttabs_modify_tabline = 1 | en
if !exists('g:ctrlp_smarttabs_reverse') | let g:ctrlp_smarttabs_reverse = 1 | en

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
 \ 'init': 'ctrlp#smarttabs#init()',
 \ 'accept': 'ctrlp#smarttabs#accept',
 \ 'lname': 'Smart Tabs',
 \ 'sname': 'Tabs',
 \ 'type': 'line',
 \ 'enter': 'ctrlp#smarttabs#enter()',
 \ 'exit': 'ctrlp#smarttabs#exit()',
 \ 'opts': 'ctrlp#smarttabs#opts()',
 \ 'sort': 0,
 \ 'specinput': 0,
 \ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#smarttabs#init()
  let l:tablist    = []
  if g:ctrlp_smarttabs_reverse
    let l:tabnumbers = reverse(range(1,tabpagenr("$")))
  else
    let l:tabnumbers = range(1,tabpagenr("$"))
  endif

  " Add all tabs
  for tabnumber in l:tabnumbers
    let l:buflist = tabpagebuflist(tabnumber)
    for bufid in l:buflist
      let l:bufname = bufname(bufid)
      if (bufloaded(bufid) == 1 && buflisted(bufid) > 0)
        if (strlen(l:bufname) > 0)
          call add(l:tablist, tabnumber . ": " . l:bufname)
        else
          call add(l:tablist, tabnumber . ": [No Name]")
        endif
      endif
    endfor
  endfor

  if g:ctrlp_smarttabs_modify_tabline
    let s:ctrlp_smarttabs_tabline = &tabline
    augroup ctrlpsmarttabscursor
      autocmd!
      autocmd CursorMoved * call ctrlp#smarttabs#setTabLine()
    augroup END
  endif

  return l:tablist
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#smarttabs#accept(mode, str)
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
function! ctrlp#smarttabs#enter()
endfunction


" (optional) Do something after exiting ctrlp
function! ctrlp#smarttabs#exit()
  execute "set tabline=" . s:ctrlp_smarttabs_tabline
  augroup ctrlpsmarttabscursor
    autocmd!
  augroup END
endfunction


" (optional) Set or check for user options specific to this extension
function! ctrlp#smarttabs#opts()
endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#smarttabs#id()
  return s:id
endfunction

function! ctrlp#smarttabs#setTabLine()
  let l:line_parts = split(getline("."), ":")
  if (len(l:line_parts) > 0)
    let l:tabnumber = strpart(line_parts[0], 2)
    if (l:tabnumber > 0)
      execute "set tabline=%!ctrlp#smarttabs#tabLine(" . l:tabnumber . ")"
      return
    endif
  endif
  execute "set tabline=%!ctrlp#smarttabs#tabLine(0)"
endfunction

function! ctrlp#smarttabs#tabLine(tabnumber)
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == a:tabnumber
      let s .= '%#IncSearch#'
    elseif i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by ctrlpsmarttabs#tabLabel()
    let s .= ' %{ctrlp#smarttabs#tabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif

  return s
endfunction

function! ctrlp#smarttabs#tabLabel(tab)
  let l:buflist = tabpagebuflist(a:tab)
  let l:winnr   = tabpagewinnr(a:tab)
  let l:name    = bufname(l:buflist[l:winnr - 1])
  if (l:name ==# "ControlP")
    let l:name = bufname(l:buflist[l:winnr - 2])
  endif
  if (l:name ==# "")
    let l:name = "[No Name]"
  endif

  return tabpagewinnr(a:tab, '$') . " " . pathshorten(l:name)
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
