CtrlP-SmartTabs
===============

Vim CtrlP plugin to switch between opened tabs.

![smarttabs][1]

Synopsis
========
With the vim plugin CtrlP you can easily open a file or a buffer.
This is a ctrlp.vim extension that allow you to switch between different opened tabs.

Prerequisites
=============
In order to use this plugin you need to have [CtrlP](https://github.com/kien/ctrlp.vim) installed.

Installation
============
If you use [Vundle](https://github.com/gmarik/vundle.git) you can install this plugin adding this line:

    Bundle 'DavidEGx/ctrlp-smarttabs'

to your .vimrc file and running the command:

    :BundleInstall

In case you use [pathogen](https://github.com/tpope/vim-pathogen) as a plugin manager you can install it by running:

    $ cd ~/.vim/bundle/
    $ git clone https://github.com/DavidEGx/ctrlp-smarttabs.git

If you don't use any plugin manager I would strongly recommend you to have a look at [Vundle](https://github.com/gmarik/vundle.git) or [pathogen](https://github.com/tpope/vim-pathogen). If for any reason you don't want to use any plugin manager you can simple install this plugin by copying it to your ~/.vim folder:

    $ wget http://www.vim.org/scripts/download_script.php?src_id=21191 -O ctrlp-smarttabs.zip
    $ unzip ctrlp-smarttabs.zip -d ~/.vim
    $ rm ctrlp-smarttabs.zip

Configuration
============
Put this into your vimrc so the SmartTabs search will show up when you open CtrlP:

    let g:ctrlp_extensions = ['smarttabs']

Other options:

    let g:ctrlp_smarttabs_modify_tabline = 0
    " If 1 will highlight the selected file in the tabline.
    " (Default: 1)

    let g:ctrlp_smarttabs_reverse = 0
    " Reverse the order in which files are displayed.
    " (Default: 1)

    let g:ctrlp_smarttabs_exclude_quickfix = 1
    " Exclude quickfix buffers.
    " (Default: 0)

Basic Usage
===========
You can see the list of opened tabs using :CtrlPSmartTabs, there you can select any opened tab and press enter to jump the opened tab.
Alternatively it is possible to open CtrlP by pressing <kbd>ctrl</kbd><kbd>p</kbd> and then reach SmartTabs pressing <kbd>ctrl</kbd><kbd>f</kbd> repeatedly.

To use easily just add some mapping to your .vimrc:

    " Just an example from my .vimrc
    nnoremap <F3> :CtrlPSmartTabs<CR>
    nnoremap <F4> :CtrlP<CR>

    " or
    nnoremap þ :CtrlPSmartTabs<CR> " Altgr+p to open SmartTabs
    " 'þ' is equivalent to AltGr+p in my keyboard so this allow me to have ctrl+p and altgr+p for files a tabs

    " or whatever mapping feels good


License
=======
Copyright (C) 2013-2017 David Escribano Garcia. Distributed under GPLv3 license.

[1]: http://i.imgur.com/E1F1ove.png
