call plug#begin()

Plug 'machakann/vim-sandwich'

call plug#end()

set number
set clipboard=unnamedplus
set fileencodings=utf-8,euc-jp

set expandtab
set ts=2 sw=2 sts=2

if executable('zenhan.exe')
	autocmd InsertLeave * :call system('zenhan.exe 0')
  autocmd InsertEnter * :call system('zenhan.exe 1')
endif

nnoremap ; :
nnoremap : ;
nnoremap k gk
nnoremap j gj

if exists('g:vscode')
  nnoremap k :<C-u>call rpcrequest(g:vscode_channel, 'vscode-command', 'cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>
  nnoremap j :<C-u>call rpcrequest(g:vscode_channel, 'vscode-command', 'cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>
endif
