" Vim syntax file
" Language:    Wiki
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 20.01.2009 11:22
" Version:     0.5.3

" Quit if syntax file is already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"" use max highlighting - could be quite slow if there are too many wikifiles
if g:vimwiki_maxhi
  " Every WikiWord is nonexistent
  execute 'syntax match wikiNoExistsWord /'.g:vimwiki_word1.'/'
  execute 'syntax match wikiNoExistsWord /'.g:vimwiki_word2.'/'
  " till we find them in g:vimwiki_home
  call vimwiki#WikiHighlightWords()
else
  " A WikiWord (unqualifiedWikiName)
  execute 'syntax match wikiWord /'.g:vimwiki_word1.'/'
  " A [[bracketed wiki word]]
  execute 'syntax match wikiWord /'.g:vimwiki_word2.'/'
endif


" text: "this is a link (optional tooltip)":http://www.microsoft.com
" TODO: check URL syntax against RFC
let g:vimwiki_rxWeblink = '\("[^"(]\+\((\([^)]\+\))\)\?":\)\?\(https\?\|ftp\|gopher\|telnet\|file\|notes\|ms-help\):\(\(\(//\)\|\(\\\\\)\)\+[A-Za-z0-9:#@%/;$~_?+-=.&\-\\\\]*\)'
execute 'syntax match wikiLink `'.g:vimwiki_rxWeblink.'`'

" Emoticons: must come after the Textilisms, as later rules take precedence
" over earlier ones. This match is an approximation for the ~70 distinct
syntax match wikiEmoticons /\((.)\|:[()|$@]\|:-[DOPS()\]|$@]\|;)\|:'(\)/

let g:vimwiki_rxTodo = '\(TODO:\|DONE:\|FIXME:\|FIXED:\)'
execute 'syntax match wikiTodo /'. g:vimwiki_rxTodo .'/'

" Load concrete Wiki syntax
execute 'runtime! syntax/vimwiki_'.g:vimwiki_syntax.'.vim'

execute 'syntax match wikiBold /'.g:vimwiki_rxBold.'/'

execute 'syntax match wikiItalic /'.g:vimwiki_rxItalic.'/'

execute 'syntax match wikiBoldItalic /'.g:vimwiki_rxBoldItalic.'/'

execute 'syntax match wikiDelText /'.g:vimwiki_rxDelText.'/'

execute 'syntax match wikiSuperScript /'.g:vimwiki_rxSuperScript.'/'

execute 'syntax match wikiSubScript /'.g:vimwiki_rxSubScript.'/'

execute 'syntax match wikiCode /'.g:vimwiki_rxCode.'/'

" Aggregate all the regular text highlighting into wikiText
syntax cluster wikiText contains=wikiItalic,wikiBold,wikiCode,wikiDelText,wikiSuperScript,wikiSubScript,wikiWord,wikiEmoticons

" Header levels, 1-6
execute 'syntax match wikiH1 /'.g:vimwiki_rxH1.'/'
execute 'syntax match wikiH2 /'.g:vimwiki_rxH2.'/'
execute 'syntax match wikiH3 /'.g:vimwiki_rxH3.'/'
execute 'syntax match wikiH4 /'.g:vimwiki_rxH4.'/'
execute 'syntax match wikiH5 /'.g:vimwiki_rxH5.'/'
execute 'syntax match wikiH6 /'.g:vimwiki_rxH6.'/'

" <hr>, horizontal rule
execute 'syntax match wikiHR /'.g:vimwiki_rxHR.'/'

" Tables. Each line starts and ends with '||'; each cell is separated by '||'
execute 'syntax match wikiTable /'.g:vimwiki_rxTable.'/'

" Bulleted list items start with whitespace(s), then '*'
" syntax match wikiList           /^\s\+\(\*\|[1-9]\+0*\.\).*$/   contains=@wikiText
" highlight only bullets and digits.
execute 'syntax match wikiList /'.g:vimwiki_rxListBullet.'/'
execute 'syntax match wikiList /'.g:vimwiki_rxListNumber.'/'

" Treat all other lines that start with spaces as PRE-formatted text.
execute 'syntax match wikiPre /'.g:vimwiki_rxPre1.'/'

execute 'syntax region wikiPre start=/'.g:vimwiki_rxPreStart.'/ end=/'.g:vimwiki_rxPreEnd.'/'
" FIXME: this is quite buggy...
" execute 'syntax sync match wikiPreSync grouphere wikiPre /'.g:vimwiki_rxPreStart.'/'


" Folding
execute 'syntax region wikiHeaderFolding start=/'.g:vimwiki_rxFoldHeadingStart.'/ end=/'.g:vimwiki_rxFoldHeadingEnd.'/ transparent fold'

hi def link wikiH1                    Title
hi def link wikiH2                    wikiH1
hi def link wikiH3                    wikiH2
hi def link wikiH4                    wikiH3
hi def link wikiH5                    wikiH4
hi def link wikiH6                    wikiH5
hi def link wikiHR                    wikiH6

hi def wikiBold                       term=bold cterm=bold gui=bold
hi def wikiItalic                     term=italic cterm=italic gui=italic
hi def wikiBoldItalic                 term=bold cterm=bold gui=bold,italic

hi def link wikiCode                  PreProc
hi def link wikiWord                  Underlined
hi def link wikiNoExistsWord          Error

hi def link wikiPre                   PreProc
hi def link wikiLink                  Underlined
hi def link wikiList                  Type
hi def link wikiTable                 PreProc
hi def link wikiEmoticons             Constant
hi def link wikiDelText               Comment
hi def link wikiInsText               Constant
hi def link wikiSuperScript           Constant
hi def link wikiSubScript             Constant
hi def link wikiTodo                  Todo

let b:current_syntax="vimwiki"

