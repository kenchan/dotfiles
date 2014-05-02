set nocompatible
filetype off

set rtp+=$GOROOT/misc/vim
exe "set rtp+=" . globpath($GOPATH, "src/github.com/golang/lint/misc/vim")

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle'

" colorschema
Plugin '29decibel/codeschool-vim-theme'
Plugin 'Lucius'
Plugin 'Solarized'
Plugin 'aereal/vim-magica-colors'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'mayansmoke'
Plugin 'pyte'
Plugin 'xoria256.vim'

Plugin 'Blackrush/vim-gocode'
Plugin 'Rename'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimfiler'
Plugin 'SuperTab'
Plugin 'basyura/unite-rails'
Plugin 'csexton/trailertrash.vim'
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'h1mesuke/unite-outline'
Plugin 'h1mesuke/vim-alignta'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'itchyny/lightline.vim'
Plugin 'kana/vim-smartinput'
Plugin 'kana/vim-textobj-fold'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-lastpat'
Plugin 'kana/vim-textobj-user'
Plugin 'kchmck/vim-coffee-script'
Plugin 'kien/ctrlp.vim'
Plugin 'matchit.zip'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'repeat.vim'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/syntastic'
Plugin 'slim-template/vim-slim'
Plugin 'taglist.vim'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tsukkee/unite-help'
Plugin 'tsukkee/unite-tag'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vimwiki'

call vundle#end()

filetype plugin indent on
syntax enable

set term=screen-256color
set t_Co=256
set background=light
let g:solarized_termtrans=1
colorscheme lucius
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
