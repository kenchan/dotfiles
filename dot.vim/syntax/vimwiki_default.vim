" Vim syntax file
" Language:    Wiki (vimwiki default)
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 20.01.2009 11:22
" Version:     0.5.3

" text: *strong*
" let g:vimwiki_rxBold = '\*[^*]\+\*'
let g:vimwiki_rxBold = '\(^\|\s\+\|[[:punct:]]\)\zs\*[^*`]\+\*\ze\([[:punct:]]\|\s\+\|$\)'

" text: _emphasis_
" let g:vimwiki_rxItalic = '_[^_]\+_'
let g:vimwiki_rxItalic = '\(^\|\s\+\|[[:punct:]]\)\zs_[^_`]\+_\ze\([[:punct:]]\|\s\+\|$\)'

" text: *_strong italic_* or _*italic strong*_
let g:vimwiki_rxBoldItalic = '\(^\|\s\+\|[[:punct:]]\)\zs\(\*_[^*_`]\+_\*\)\|\(_\*[^*_`]\+\*_\)\ze\([[:punct:]]\|\s\+\|$\)'

" text: `code`
let g:vimwiki_rxCode = '`[^`]\+`'

" text: ~~deleted text~~
let g:vimwiki_rxDelText = '\~\~[^~`]\+\~\~'

" text: ^superscript^
let g:vimwiki_rxSuperScript = '\^[^^`]\+\^'

" text: ,,subscript,,
let g:vimwiki_rxSubScript = ',,[^,`]\+,,'

" Header levels, 1-6
let g:vimwiki_rxH1 = '^!\{1}.*$'
let g:vimwiki_rxH2 = '^!\{2}.*$'
let g:vimwiki_rxH3 = '^!\{3}.*$'
let g:vimwiki_rxH4 = '^!\{4}.*$'
let g:vimwiki_rxH5 = '^!\{5}.*$'
let g:vimwiki_rxH6 = '^!\{6}.*$'

" <hr>, horizontal rule
let g:vimwiki_rxHR = '^----.*$'

" Tables. Each line starts and ends with '||'; each cell is separated by '||'
let g:vimwiki_rxTable = '||'

" Bulleted list items start with whitespace(s), then '*'
" syntax match wikiList           /^\s\+\(\*\|[1-9]\+0*\.\).*$/   contains=@wikiText
" highlight only bullets and digits.
" let g:vimwiki_rxList = '^\s\+\(\*\|#\)'
let g:vimwiki_rxListBullet = '^\s\+\*'
let g:vimwiki_rxListNumber = '^\s\+#'

" Treat all other lines that start with spaces as PRE-formatted text.
let g:vimwiki_rxPre1 = '^\s\+[^[:blank:]*#].*$'

" Preformatted text
" let g:vimwiki_rxPreStart = '^{{{\s*$'
" let g:vimwiki_rxPreEnd = '^}}}\s*$'
let g:vimwiki_rxPreStart = '{{{'
let g:vimwiki_rxPreEnd = '}}}'

" Header's folding
let g:vimwiki_rxFoldHeadingStart = '^!'
let g:vimwiki_rxFoldHeadingEnd = '\n\+\ze!'

" vim:tw=0:
