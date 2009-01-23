" Vim syntax file
" Language:    Wiki (MediaWiki)
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 20.01.2009 11:22
" Version:     0.5.3

" text: '''strong'''
let g:vimwiki_rxBold = "'''[^']\\+'''"

" text: ''emphasis''
let g:vimwiki_rxItalic = "''[^']\\+''"

" text: '''''strong italic'''''
let g:vimwiki_rxBoldItalic = "'''''[^']\\+'''''"

" text: `code`
let g:vimwiki_rxCode = '`[^`]\+`'

" text: ~~deleted text~~
let g:vimwiki_rxDelText = '\~\~[^~]\+\~\~'

" text: ^superscript^
let g:vimwiki_rxSuperScript = '\^[^^]\+\^'

" text: ,,subscript,,
let g:vimwiki_rxSubScript = ',,[^,]\+,,'

" Header levels, 1-6
let g:vimwiki_rxH1 = '^\s*=\{1}.\+=\{1}\s*$'
let g:vimwiki_rxH2 = '^\s*=\{2}.\+=\{2}\s*$'
let g:vimwiki_rxH3 = '^\s*=\{3}.\+=\{3}\s*$'
let g:vimwiki_rxH4 = '^\s*=\{4}.\+=\{4}\s*$'
let g:vimwiki_rxH5 = '^\s*=\{5}.\+=\{5}\s*$'
let g:vimwiki_rxH6 = '^\s*=\{6}.\+=\{6}\s*$'

" <hr>, horizontal rule
let g:vimwiki_rxHR = '^----.*$'

" Tables. Each line starts and ends with '||'; each cell is separated by '||'
let g:vimwiki_rxTable = '||'

" Bulleted list items start with whitespace(s), then '*'
" highlight only bullets and digits.
let g:vimwiki_rxListBullet = '^\s*\*\+\([^*]*$\)\@='
let g:vimwiki_rxListNumber = '^\s*#\+'

" Treat all other lines that start with spaces as PRE-formatted text.
let g:vimwiki_rxPre1 = '^\s\+[^[:blank:]*#].*$'

" Preformatted text
let g:vimwiki_rxPreStart = '<pre>'
let g:vimwiki_rxPreEnd = '<\/pre>'

" Header's folding
let g:vimwiki_rxFoldHeadingStart = '^=\+[^=]\+='
let g:vimwiki_rxFoldHeadingEnd = '\n\ze=\+[^=]\+='

" vim:tw=0:
