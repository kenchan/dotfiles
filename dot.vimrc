set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'cucumber.zip'
Bundle 'endwise.vim'
Bundle 'haml.zip'
Bundle 'git-commit'
Bundle 'rails.vim'
Bundle 'surround.vim'
Bundle 'YankRing.vim'
Bundle 'newspaper.vim'
Bundle 'xoria256.vim'
Bundle 'git://github.com/vim-ruby/vim-ruby.git'
Bundle 'git://github.com/motemen/git-vim.git'
Bundle 'git://github.com/Shougo/unite.vim.git'
Bundle 'git://github.com/Shougo/neocomplcache.git'
Bundle 'git://github.com/h1mesuke/vim-alignta.git'

filetype off
filetype indent on
syntax enable

set t_Co=256
colorscheme xoria256
hi Pmenu ctermbg=4

set ambiwidth=double
set autoread
set hidden
set number
set showmatch
set ttymouse=xterm2
set wildmode=longest:list
set nocompatible

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
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%=%l,%c%v%8p

" keymap
nnoremap j gj
nnoremap k gk

nnoremap wh <C-w>h
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wl <C-w>l

nnoremap Y y$

" 全角空白と行末の空白の色を変える
highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red

function! s:HighlightSpaces()
  match WideSpace /　/
  match EOLSpace /\s\+$/
endf

call s:HighlightSpaces()

autocmd WinEnter * call s:HighlightSpaces()

autocmd InsertEnter * highlight StatusLine ctermfg=red guifg=red
autocmd InsertLeave * highlight StatusLine ctermfg=white guifg=white

"自動的に QuickFix リストを表示する
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

" clipboard
set clipboard+=unnamed

" <Leader>
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d(%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M:%S')<CR>

" spe-cuke
function! s:SetupSpeCuke()
  command! RunTestFile exe '!sc ' . expand('%:p')
  command! RunTestCase exe '!sc --line ' . line('.') . ' ' . expand('%:p')

  nnoremap -tf :RunTestFile<CR>
  nnoremap -tc :RunTestCase<CR>
endfunction

au BufRead,BufNewFile *_spec.rb,*.feature call s:SetupSpeCuke()

" git-commit.vim
let git_diff_spawn_mode = 1

" git-vim
let g:git_command_edit = 'rightbelow vnew'

" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3

" unite.vim
nnoremap <silent> ,uf :<C-u>Unite file<CR>
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
