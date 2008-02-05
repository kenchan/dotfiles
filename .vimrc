set number
set hlsearch
set backup
set backupdir=$HOME/.backup

"-----------------------------------------------------------------------
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos

"--- Tab ---
"set expandtab
set smartindent
set ts=2 sw=2

"-----------------------------------------------------------------------
set nohlsearch
set incsearch

"------------------------------------------------------------------------
au FileType ruby  :set nowrap tabstop=2 tw=0 sw=2 expandtab
au FileType eruby :set nowrap tabstop=2 tw=0 sw=2 noexpandtab

"------------------------------------------------------------------------
" rails
au BufNewFile,BufRead app/*/*.rhtml	set ft=mason fenc=utf-8
au BufNewFile,BufRead app/**/*.rb	set ft=ruby  fenc=utf-8

" -- vim-ruby -- 
set nocompatible
syntax on
filetype on
filetype indent on
filetype plugin on
imap <C-space> <C-x><C-o><C-p>

set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"--- minibufexpl ---
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1
