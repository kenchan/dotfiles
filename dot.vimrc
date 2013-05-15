set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" colorschema
Bundle 'xoria256.vim'
Bundle 'pyte'
Bundle 'Solarized'
Bundle 'aereal/vim-magica-colors'
Bundle 'jpo/vim-railscasts-theme'
Bundle '29decibel/codeschool-vim-theme'

Bundle 'vimwiki'
Bundle 'Rename'
Bundle 'taglist.vim'
Bundle 'repeat.vim'
Bundle 'matchit.zip'
Bundle 'SuperTab'

Bundle 'scrooloose/syntastic'

Bundle 'vim-ruby/vim-ruby'
Bundle 'ecomba/vim-ruby-refactoring'
Bundle 'nelstrom/vim-textobj-rubyblock'

Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-fold'
Bundle 'kana/vim-textobj-indent'
Bundle 'kana/vim-textobj-lastpat'

Bundle 'Shougo/vimfiler'

Bundle 'h1mesuke/vim-alignta'

Bundle 'Shougo/unite.vim'
Bundle 'tsukkee/unite-help'
Bundle 'h1mesuke/unite-outline'
Bundle 'basyura/unite-rails'
Bundle 'tsukkee/unite-tag'

Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'

Bundle 'csexton/trailertrash.vim'

Bundle 'kchmck/vim-coffee-script'

Bundle 'mattn/gist-vim'
Bundle 'mattn/webapi-vim'

Bundle 'hail2u/vim-css3-syntax'

Bundle 'maxbrunsfeld/vim-yankstack'

Bundle 'slim-template/vim-slim'

filetype plugin indent on
syntax enable

set term=screen-256color
set t_Co=256
set background=light
let g:solarized_termtrans=1
colorscheme solarized
hi Pmenu ctermbg=4

set ambiwidth=double
set autoread
set hidden
set number
set showmatch
set ttymouse=xterm2
set wildmode=list:longest,list:full

set directory-=.

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

"search
set nohlsearch
set ignorecase
set smartcase
set incsearch

"statusline
set laststatus=2

set clipboard=unnamedplus

" keymap
nnoremap j gj
nnoremap k gk

nnoremap wh <C-w>h
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wl <C-w>l

nnoremap Y y$

nnoremap ; :
nnoremap : ;

nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>s. :<C-u>source $MYVIMRC<CR>

cnoremap <C-a> <Home>
cnoremap <C-x> <C-r>=expand('%:p:h')<CR>/
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" <Leader>
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d(%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M:%S')<CR>

" unite.vim
nnoremap <silent> ,uf :<C-u>Unite file<CR>
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> ,uo :<C-u>Unite outline<CR>
nnoremap <silent> ,ua :<C-u>Unite alignta<CR>
nnoremap <silent> ,uh :<C-u>Unite help<CR>

" unite-alignta
let g:unite_source_alignta_preset_arguments = [
  \ ["Align at ':'", '<<0 \ /1 :'],
  \]

" vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0

" show invisibles
nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬

" yankstack
nmap <C-p> <Plug>yankstack_substitute_older_paste

" syntastic
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 3

augroup MyAutoCmd
  autocmd!

  "自動的に QuickFix リストを表示する
  autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin

  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC | if has('gui_running') | source $MYGVIMRC
  autocmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC

  autocmd BufWritePre * :Trim
augroup END
