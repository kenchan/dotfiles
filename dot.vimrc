if filereadable($VIMRUNTIME . '/vimrc_example.vim')
  source $VIMRUNTIME/vimrc_example.vim
endif

set t_Co=256
colorscheme desert256

set ambiwidth=double
set autoread
set hidden
set number
set showmatch
set ttymouse=xterm2
set wildmode=longest:list
set nocompatible

"backup
set nobackup

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

"statusline
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" keymap
nnoremap j gj
nnoremap k gk

" 全角空白と行末の空白の色を変える
highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red

function! HighlightSpace()
  match WideSpace "　"
  match EOLSpace /\s\+$/
endf

call HighlightSpace()

autocmd WinEnter * call HighlightSpace()

autocmd InsertEnter * highlight StatusLine ctermfg=red guifg=red
autocmd InsertLeave * highlight StatusLine ctermfg=white guifg=white

"自動的に QuickFix リストを表示する
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

"辞書補完設定
autocmd FileType actionscript :set dictionary=~/.vim/dict/actionscript3.dict

" clipboard
set clipboard=unnamed

" vimwiki
let g:vimwiki_home="/home/kenichi/vimwiki/"

" <Leader>
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d(%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M:%S')<CR>

" for neocomplcache
let g:NeoComplCache_EnableAtStartup = 1

" buftabs
let g:buftags_only_basename = 1
set laststatus=2
let g:buftabs_in_statusline = 1
