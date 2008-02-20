if filereadable($VIMRUNTIME . '/vimrc_example.vim')
  source $VIMRUNTIME/vimrc_example.vim
endif

set ambiwidth=double
set autoread
set hidden
set number
set showmatch
set ttymouse=xterm2
set wildmode=longest:list
set nocompatible

nnoremap j gj
nnoremap k gk

"backup
set backup
set backupdir=$HOME/.backup
set wildmode=longest:list

"encoding
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos

"Tab
set expandtab
set smartindent
set ts=2 sw=2 sts=2
set tabstop=2
set shiftwidth=2
set softtabstop=2

"search
set nohlsearch
set ignorecase
set smartcase
set incsearch

" 全角空白と行末の空白の色を変える
highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red

function! HighlightSpace()
  match WideSpace "　"
  match EOLSpace /\s\+$/
endf

call HighlightSpace()
autocmd WinEnter * call HighlightSpace()

"statusline
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
autocmd InsertEnter * highlight StatusLine ctermfg=red guifg=red
autocmd InsertLeave * highlight StatusLine ctermfg=white guifg=white

"minibufexpl
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1

"自動的に QuickFix リストを表示する
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin
