" VimWiki plugin file
" Language:    Wiki
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 19.01.2009 23:43
" Version:     0.5.3

if exists("g:loaded_vimwiki_auto") || &cp
  finish
endif
let g:loaded_vimwiki_auto = 1

let s:wiki_badsymbols = '[<>|?*/\:"]'

"" vimwiki functions {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:msg(message) "{{{
  echohl WarningMsg
  echomsg 'vimwiki: '.a:message
  echohl None
endfunction "}}}

function! s:getFileNameOnly(filename) "{{{
  let word = substitute(a:filename, '\'.g:vimwiki_ext, "", "g")
  let word = substitute(word, '.*[/\\]', "", "g")
  return word
endfunction "}}}

function! s:editfile(command, filename) "{{{
  let fname = escape(a:filename, '% ')
  execute a:command.' '.fname

  " if fname is new
  " if g:vimwiki_addheading!=0 && glob(fname) == ''
  " execute 'normal I! '.s:getfilename(fname)
  " update
  " endif
endfunction "}}}

function! s:SearchWord(wikiRx,cmd) "{{{
  let hl = &hls
  let lasts = @/
  let @/ = a:wikiRx
  set nohls
  try
    :silent exe 'normal ' a:cmd
  catch /Pattern not found/
    call s:msg('WikiWord not found')
  endt
  let @/ = lasts
  let &hls = hl
endfunction "}}}

function! s:WikiGetWordAtCursor(wikiRX) "{{{
  let col = col('.') - 1
  let line = getline('.')
  let ebeg = -1
  let cont = match(line, a:wikiRX, 0)
  while (ebeg >= 0 || (0 <= cont) && (cont <= col))
    let contn = matchend(line, a:wikiRX, cont)
    if (cont <= col) && (col < contn)
      let ebeg = match(line, a:wikiRX, cont)
      let elen = contn - ebeg
      break
    else
      let cont = match(line, a:wikiRX, contn)
    endif
  endwh
  if ebeg >= 0
    return strpart(line, ebeg, elen)
  else
    return ""
  endif
endf "}}}

function! s:WikiStripWord(word, sym) "{{{
  function! s:WikiStripWordHelper(word, sym)
    return substitute(a:word, s:wiki_badsymbols, a:sym, 'g')
  endfunction

  let result = a:word
  if strpart(a:word, 0, 2) == "[["
    let result = s:WikiStripWordHelper(strpart(a:word, 2, strlen(a:word)-4), a:sym)
  endif
  return result
endfunction "}}}

function! s:WikiIsLinkToNonWikiFile(word) "{{{
  " Check if word is link to a non-wiki file.
  " The easiest way is to check if it has extension like .txt or .html
  if a:word =~ '\.\w\{1,4}$'
    return 1
  endif
  return 0
endfunction "}}}

"" WikiWord history helper functions {{{
" history is [['WikiWord.wiki', 11], ['AnotherWikiWord', 3] ... etc]
" where numbers are column positions we should return to when coming back.
function! s:GetHistoryWord(historyItem)
  return get(a:historyItem, 0)
endfunction
function! s:GetHistoryColumn(historyItem)
  return get(a:historyItem, 1)
endfunction
"}}}

function! vimwiki#WikiNextWord() "{{{
  call s:SearchWord(g:vimwiki_rxWikiWord, 'n')
endfunction "}}}

function! vimwiki#WikiPrevWord() "{{{
  call s:SearchWord(g:vimwiki_rxWikiWord, 'N')
endfunction "}}}

function! vimwiki#WikiFollowWord(split) "{{{
  if a:split == "split"
    let cmd = ":split "
  elseif a:split == "vsplit"
    let cmd = ":vsplit "
  else
    let cmd = ":e "
  endif
  let word = s:WikiStripWord(s:WikiGetWordAtCursor(g:vimwiki_rxWikiWord), g:vimwiki_stripsym)
  " insert doesn't work properly inside :if. Check :help :if.
  if word == ""
    execute "normal! \n"
    return
  endif
  if s:WikiIsLinkToNonWikiFile(word)
    call s:editfile(cmd, word)
  else
    call insert(g:vimwiki_history, [expand('%:p'), col('.')])
    call s:editfile(cmd, g:vimwiki_home.word.g:vimwiki_ext)
  endif
endfunction "}}}

function! vimwiki#WikiGoBackWord() "{{{
  if !empty(g:vimwiki_history)
    let word = remove(g:vimwiki_history, 0)
    " go back to saved WikiWord
    execute ":e ".s:GetHistoryWord(word)
    call cursor(line('.'), s:GetHistoryColumn(word))
  endif
endfunction "}}}

function! vimwiki#WikiNewLine(direction) "{{{
  "" direction == checkup - use previous line for checking
  "" direction == checkdown - use next line for checking
  function! s:WikiAutoListItemInsert(listSym, dir)
    let sym = escape(a:listSym, '*')
    if a:dir=='checkup'
      let linenum = line('.')-1
    else
      let linenum = line('.')+1
    end
    let prevline = getline(linenum)
    if prevline =~ '^\s\+'.sym
      let curline = substitute(getline('.'),'^\s\+',"","g")
      if prevline =~ '^\s*'.sym.'\s*$'
        " there should be easier way ...
        execute 'normal kA '."\<ESC>".'"_dF'.a:listSym.'JX'
        return 1
      endif
      let ind = indent(linenum)
      call setline(line('.'), strpart(prevline, 0, ind).a:listSym.' '.curline)
      call cursor(line('.'), ind+3)
      return 1
    endif
    return 0
  endfunction

  if s:WikiAutoListItemInsert('*', a:direction)
    return
  endif

  if s:WikiAutoListItemInsert('#', a:direction)
    return
  endif

  " delete <space>
  if getline('.') =~ '^\s\+$'
    execute 'normal x'
  else
    execute 'normal X'
  endif
endfunction "}}}

function! vimwiki#WikiHighlightWords() "{{{
  let wikies = glob(g:vimwiki_home.'*')
  "" remove .wiki extensions
  let wikies = substitute(wikies, '\'.g:vimwiki_ext, "", "g")
  let g:vimwiki_wikiwords = split(wikies, '\n')
  "" remove paths
  call map(g:vimwiki_wikiwords, 'substitute(v:val, ''.*[/\\]'', "", "g")')
  "" remove backup files (.wiki~)
  call filter(g:vimwiki_wikiwords, 'v:val !~ ''.*\~$''')

  for word in g:vimwiki_wikiwords
    if word =~ g:vimwiki_word1 && !s:WikiIsLinkToNonWikiFile(word)
      execute 'syntax match wikiWord /\<'.word.'\>/'
    else
      execute 'syntax match wikiWord /\[\['.substitute(word,  g:vimwiki_stripsym, s:wiki_badsymbols, "g").'\]\]/'
    endif
  endfor
endfunction "}}}

function! vimwiki#WikiGoHome()"{{{
  try
    execute ':e '.g:vimwiki_home.g:vimwiki_index.g:vimwiki_ext
  catch /E37/ " catch 'No write since last change' error
    " this is really unsecure!!!
    execute ':'.g:vimwiki_gohome.' '.g:vimwiki_home.g:vimwiki_index.g:vimwiki_ext
  endtry
  let g:vimwiki_history = []
endfunction"}}}

function! vimwiki#WikiDeleteWord() "{{{
  "" file system funcs
  "" Delete WikiWord you are in from filesystem
  let val = input('Delete ['.expand('%').'] (y/n)? ', "")
  if val!='y'
    return
  endif
  let fname = expand('%:p')
  " call WikiGoBackWord()
  try
    call delete(fname)
  catch /.*/
    call s:msg('Cannot delete "'.expand('%:r').'"!')
    return
  endtry
  execute "bdelete! ".escape(fname, " ")

  " delete from g:vimwiki_history list
  call filter (g:vimwiki_history, 's:GetHistoryWord(v:val) != fname')
  " as we got back to previous WikiWord - delete it from history - as much
  " as possible
  let hword = ""
  while !empty(g:vimwiki_history) && hword == s:GetHistoryWord(g:vimwiki_history[0])
    let hword = s:GetHistoryWord(remove(g:vimwiki_history, 0))
  endwhile

  " reread buffer => deleted WikiWord should appear as non-existent
  execute "e"
endfunction "}}}

function! vimwiki#WikiRenameWord() "{{{
  "" Rename WikiWord, update all links to renamed WikiWord
  let wwtorename = expand('%:r')
  let isOldWordComplex = 0
  if wwtorename !~ g:vimwiki_word1
    let wwtorename = substitute(wwtorename,  g:vimwiki_stripsym, s:wiki_badsymbols, "g")
    let isOldWordComplex = 1
  endif

  " there is no file (new one maybe)
  " if glob(g:vimwiki_home.expand('%')) == ''
  if glob(expand('%:p')) == ''
    call s:msg('Cannot rename "'.expand('%:p').'". It does not exist! (New file? Save it before renaming.)')
    return
  endif

  let val = input('Rename "'.expand('%:r').'" (y/n)? ', "")
  if val!='y'
    return
  endif
  let newWord = input('Enter new name: ', "")
  " check newWord - it should be 'good', not empty
  if substitute(newWord, '\s', '', 'g') == ''
    call s:msg('Cannot rename to an empty filename!')
    return
  endif
  if s:WikiIsLinkToNonWikiFile(newWord)
    call s:msg('Cannot rename to a filename with extension (ie .txt .html)!')
    return
  endif

  if newWord !~ g:vimwiki_word1
    " if newWord is 'complex wiki word' then add [[]]
    let newWord = '[['.newWord.']]'
  endif
  let newFileName = s:WikiStripWord(newWord, g:vimwiki_stripsym).g:vimwiki_ext

  " do not rename if word with such name exists
  let fname = glob(g:vimwiki_home.newFileName)
  if fname != ''
    call s:msg('Cannot rename to "'.newFileName.'". File with that name exist!')
    return
  endif
  " rename WikiWord file
  try
    echomsg "Renaming ".expand('%')." to ".g:vimwiki_home.newFileName
    let res = rename(expand('%'), g:vimwiki_home.newFileName)
    if res == 0
      bd
    else
      throw "Cannot rename!"
    end
  catch /.*/
    call s:msg('Cannot rename "'.expand('%:r').'" to "'.newFileName.'"')
    return
  endtry

  " save open buffers
  let openbuffers = []
  let bcount = 1
  while bcount<=bufnr("$")
    if bufexists(bcount)
      call add(openbuffers, bufname(bcount))
    endif
    let bcount = bcount + 1
  endwhile

  " update links
  echomsg "Updating links to ".newWord."..."
  execute ':silent args '.escape(g:vimwiki_home, " ").'*'.g:vimwiki_ext
  if isOldWordComplex
    execute ':silent argdo %sm/\[\['.wwtorename.'\]\]/'.newWord.'/geI | update'
  else
    execute ':silent argdo %sm/\<'.wwtorename.'\>/'.newWord.'/geI | update'
  endif
  execute ':silent argd *'.g:vimwiki_ext

  " restore open buffers
  let bcount = 1
  while bcount<=bufnr("$")
    if bufexists(bcount)
      if index(openbuffers, bufname(bcount)) == -1
        execute 'silent bdelete '.escape(bufname(bcount), " ")
      end
    endif
    let bcount = bcount + 1
  endwhile

  call s:editfile('e', g:vimwiki_home.newFileName)

  "" DONE: after renaming GUI caption is a bit corrupted?
  "" FIXED: buffers menu is also not in the "normal" state, howto Refresh menu?
  "" TODO: Localized version of Gvim gives error -- Refresh menu doesn't exist
  execute "silent! emenu Buffers.Refresh\ menu"

  echomsg wwtorename." is renamed to ".newWord
endfunction "}}}

" Functions 2}}}

"" vimwiki html functions {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:WikiCreateDefaultCSS(path) " {{{
  if glob(a:path.'style.css') == ""
    let lines = ['body { margin: 1em 5em 1em 5em; font-size: 120%; line-height: 1.5;}']
    call add(lines, 'p, ul, ol {margin: 0.3em auto;}')
    call add(lines, '.todo {font-weight: bold; text-decoration: underline; color: #FF0000; }')
    call add(lines, '.strike {text-decoration: line-through; }')
    call add(lines, 'h1 {font-size: 2.0em;}')
    call add(lines, 'h2 {font-size: 1.4em;}')
    call add(lines, 'h3 {font-size: 1.0em;}')
    call add(lines, 'h4 {font-size: 0.8em;}')
    call add(lines, 'h5 {font-size: 0.7em;}')
    call add(lines, 'h6 {font-size: 0.6em;}')
    call add(lines, 'h1 { border-bottom: 1px solid #3366cc; text-align: left; padding: 0em 1em 0.3em 0em; }')
    call add(lines, 'h3 { background: #e5ecf9; border-top: 1px solid #3366cc; padding: 0.1em 0.3em 0.1em 0.5em; }')
    call add(lines, 'ul { margin-left: 2em; padding-left: 0.5em; }')
    call add(lines, 'pre { border-left: 0.2em solid #ccc; margin-left: 2em; padding-left: 0.5em; }')
    call add(lines, 'td { border: 1px solid #ccc; padding: 0.3em; }')
    call add(lines, 'hr { border: none; border-top: 1px solid #ccc; }')

    call writefile(lines, a:path.'style.css')
    echomsg "Default style.css is created."
  endif
endfunction "}}}

function! s:syntax_supported()
  return g:vimwiki_syntax == "default"
endfunction

function! vimwiki#WikiAll2HTML(path) "{{{
  if !s:syntax_supported()
    call s:msg('Wiki2Html: Only vimwiki_default syntax supported!!!')
    return
  endif

  if !isdirectory(a:path)
    call s:msg('Please create '.a:path.' directory first!')
    return
  endif

  let setting_more = &more
  setlocal nomore

  let wikifiles = split(glob(g:vimwiki_home.'*'.g:vimwiki_ext), '\n')
  for wikifile in wikifiles
    echomsg 'Processing '.wikifile
    call vimwiki#Wiki2HTML(a:path, wikifile)
  endfor
  call s:WikiCreateDefaultCSS(g:vimwiki_home_html)
  echomsg 'Wikifiles converted.'

  let &more = setting_more
endfunction "}}}

function! vimwiki#Wiki2HTML(path, wikifile) "{{{
  if !s:syntax_supported()
    call s:msg('Wiki2Html: Only vimwiki_default syntax supported!!!')
    return
  endif

  if !isdirectory(a:path)
    call s:msg('Please create '.a:path.' directory first!')
    return
  endif

  "" helper funcs
  function! s:isWebLink(lnk) "{{{
    if a:lnk =~ '^\(http://\|www.\|ftp://\)'
      return 1
    endif
    return 0
  endfunction "}}}
  function! s:isImgLink(lnk) "{{{
    if a:lnk =~ '.\(png\|jpg\|gif\|jpeg\)$'
      return 1
    endif
    return 0
  endfunction "}}}

  function! s:HTMLHeader(title, charset) "{{{
    let lines=[]
    call add(lines, "")
    call add(lines, '<html>')
    call add(lines, '<head>')
    call add(lines, '<link rel="Stylesheet" type="text/css" href="style.css" />')
    call add(lines, '<title>'.a:title.'</title>')
    call add(lines, '<meta http-equiv="Content-Type" content="text/html; charset='.a:charset.'" />')
    call add(lines, '</head>')
    call add(lines, '<body>')
    return lines
  endfunction "}}}

  function! s:HTMLFooter() "{{{
    let lines=[]
    call add(lines, "")
    call add(lines, '</body>')
    call add(lines, '</html>')
    return lines
  endfunction "}}}

  function! s:closeCode(code, ldest) "{{{
    if a:code
      call add(a:ldest, "</pre></code>")
      return 0
    endif
    return a:code
  endfunction "}}}

  function! s:closePre(pre, ldest) "{{{
    if a:pre
      call add(a:ldest, "</pre>")
      return 0
    endif
    return a:pre
  endfunction "}}}

  function! s:closeTable(table, ldest) "{{{
    if a:table
      call add(a:ldest, "</table>")
      return 0
    endif
    return a:table
  endfunction "}}}

  function! s:closeList(lists, ldest) "{{{
    while len(a:lists)
      let item = remove(a:lists, -1)
      call add(a:ldest, item[0])
    endwhile
  endfunction! "}}}

  " TODO: сделать так, чтобы {{{WikiWord}}} нормально отрабатывал
  function! s:processCode(line, code) "{{{
    let lines = []
    let code = a:code
    let processed = 0
    if !code && a:line =~ '^{{{\s*$'
      " if !code && a:line =~ g:vimwiki_rxPreStart
      let code = 1
      call add(lines, "<code><pre>")
      let processed = 1
    elseif code && a:line =~ '^}}}\s*$'
      " elseif code && a:line =~ g:vimwiki_rxPreEnd
      let code = 0
      call add(lines, "</pre></code>")
      let processed = 1
    elseif code
      let processed = 1
      call add(lines, a:line)
    endif
    return [processed, lines, code]
  endfunction "}}}

  function! s:processPre(line, pre) "{{{
    let lines = []
    let pre = a:pre
    let processed = 0
    if a:line =~ '^\s\+[^[:blank:]*#]'
      if !pre
        call add(lines, "<pre>")
        let pre = 1
      endif
      let processed = 1
      call add(lines, a:line)
    elseif pre && a:line =~ '^\s*$'
      let processed = 1
      call add(lines, a:line)
    elseif pre 
      call add(lines, "</pre>")
      let pre = 0
    endif
    return [processed, lines, pre]
  endfunction "}}}

  function! s:processList(line, lists) "{{{
    let lines = []
    let lstSym = ''
    let lstTagOpen = ''
    let lstTagClose = ''
    let lstRegExp = ''
    let processed = 0
    if a:line =~ '^\s\+\*'
      let lstSym = '*'
      let lstTagOpen = '<ul>'
      let lstTagClose = '</ul>'
      let lstRegExp = '^\s\+\*'
      let processed = 1
    elseif a:line =~ '^\s\+#' 
      let lstSym = '#'
      let lstTagOpen = '<ol>'
      let lstTagClose = '</ol>'
      let lstRegExp = '^\s\+#'
      let processed = 1
    endif
    if lstSym != ''
      let indent = stridx(a:line, lstSym)
      let cnt = len(a:lists)
      if !cnt || (cnt && indent > a:lists[-1][1])
        call add(a:lists, [lstTagClose, indent])
        call add(lines, lstTagOpen)
      elseif (cnt && indent < a:lists[-1][1])
        while indent < a:lists[-1][1]
          let item = remove(a:lists, -1)
          call add(lines, item[0])
        endwhile
      endif
      call add(lines, '<li>'.substitute(a:line, lstRegExp, '', '').'</li>')
    else
      while len(a:lists)
        let item = remove(a:lists, -1)
        call add(lines, item[0])
      endwhile
    endif
    return [processed, lines]
  endfunction "}}}

  function! s:processP(line) "{{{
    let lines = []
    if a:line =~ '^\S'
      call add(lines, '<p>'.a:line.'</p>')
      return [1, lines]
    endif
    return [0, lines]
  endfunction "}}}

  function! s:processHeading(line) "{{{
    let line = a:line
    let processed = 0
    if a:line =~ g:vimwiki_rxH6
      let line = '<h6>'.strpart(a:line, 6).'</h6>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH5
      let line = '<h5>'.strpart(a:line, 5).'</h5>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH4
      let line = '<h4>'.strpart(a:line, 4).'</h4>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH3
      let line = '<h3>'.strpart(a:line, 3).'</h3>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH2
      let line = '<h2>'.strpart(a:line, 2).'</h2>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH1
      let line = '<h1>'.strpart(a:line, 1).'</h1>'
      let processed = 1
    endif
    return [processed, line]
  endfunction "}}}

  function! s:processHR(line) "{{{
    let line = a:line
    let processed = 0
    if a:line =~ '^-----*$'
      let line = '<hr />'
      let processed = 1
    endif
    return [processed, line]
  endfunction "}}}

  function! s:processTable(line, table) "{{{
    let table = a:table
    let lines = []
    let processed = 0
    if a:line =~ '^||.\+||.*'
      if !table
        call add(lines, "<table>")
        let table = 1
      endif
      let processed = 1

      call add(lines, "<tr>")
      let pos1 = 0
      let pos2 = 0
      let done = 0
      while !done
        let pos1 = stridx(a:line, '||', pos2)
        let pos2 = stridx(a:line, '||', pos1+2)
        if pos1==-1 || pos2==-1
          let done = 1
          let pos2 = len(a:line)
        endif
        let line = strpart(a:line, pos1+2, pos2-pos1-2)
        if line != ''
          call add(lines, "<td>".line."</td>")
        endif
      endwhile
      call add(lines, "</tr>")

    elseif table
      call add(lines, "</table>")
      let table = 0
    endif
    return [processed, lines, table]
  endfunction "}}}

  "" change dangerous html symbols - < > & (line)
  function! s:safeHTML(line) "{{{
    let line = substitute(a:line, '&', '\&amp;', 'g')
    let line = substitute(line, '<', '\&lt;', 'g')
    let line = substitute(line, '>', '\&gt;', 'g')
    return line
  endfunction "}}}

  "" Substitute text found by regexp_match with tagOpen.regexp_subst.tagClose
  function! s:MakeTagHelper(line, regexp_match, tagOpen, tagClose, cSymRemove, func) " {{{
    let pos = 0
    let lines = split(a:line, a:regexp_match, 1)
    let res_line = ""
    for line in lines
      let res_line = res_line.line
      let matched = matchstr(a:line, a:regexp_match, pos)
      if matched != ""
        let toReplace = strpart(matched, a:cSymRemove, len(matched)-2*a:cSymRemove)
        if a:func!=""
          let toReplace = {a:func}(escape(toReplace, '\&*[]?%'))
        else
          " let toReplace = a:tagOpen.escape(toReplace, '\&*[]?%').a:tagClose
          let toReplace = a:tagOpen.toReplace.a:tagClose
        endif
        let res_line = res_line.toReplace
      endif
      let pos = matchend(a:line, a:regexp_match, pos)
    endfor
    return res_line

  endfunction " }}}

  "" Make tags only if not in ` ... `
  "" ... should be function that process regexp_match deeper.
  function! s:MakeTag(line, regexp_match, tagOpen, tagClose, ...) " {{{
    "check if additional function exists
    let func = ""
    let cSym = 1
    if a:0 == 2
      let cSym = a:1
      let func = a:2
    elseif a:0 == 1
      let cSym = a:1
    endif

    let patt_splitter = g:vimwiki_rxCode
    " let patt_splitter = '\('.g:vimwiki_rxCode.'\)\|\(<a href.\{-}</a>\)\|\(<img src.\{-}/>\)'
    " TODO: make one regexp from g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd
    let patt_splitter = '\('.g:vimwiki_rxCode.'\)\|\('.g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd.'\)\|\(<a href.\{-}</a>\)\|\(<img src.\{-}/>\)'
    if g:vimwiki_rxCode == a:regexp_match || g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd == a:regexp_match
      let res_line = s:MakeTagHelper(a:line, a:regexp_match, a:tagOpen, a:tagClose, cSym, func)
    else
      let pos = 0
      let lines = split(a:line, patt_splitter, 1)
      let res_line = ""
      for line in lines
        let res_line = res_line.s:MakeTagHelper(line, a:regexp_match, a:tagOpen, a:tagClose, cSym, func)
        let res_line = res_line.matchstr(a:line, patt_splitter, pos)
        let pos = matchend(a:line, patt_splitter, pos)
      endfor
    endif
    return res_line
  endfunction " }}}

  "" Make <a href="link">link desc</a>
  "" from [link link desc]
  function! s:MakeExternalLink(entag) "{{{
    let line = ''
    if s:isWebLink(a:entag)
      let lnkElements = split(a:entag)
      let head = lnkElements[0]
      let rest = join(lnkElements[1:])
      if rest==""
        let rest=head
      endif
      if s:isImgLink(rest)
        if rest!=head
          let line = '<a href="'.head.'"><img src="'.rest.'" /></a>'
        else
          let line = '<img src="'.rest.'" />'
        endif
      else
        let line = '<a href="'.head.'">'.rest.'</a>'
      endif
    else
      if s:isImgLink(a:entag)
        let line = '<img src="'.a:entag.'" />'
      else
        let line = '<a href="'.a:entag.'">'.a:entag.'</a>'
      endif
    endif
    return line
  endfunction "}}}

  "" Make <a href="This is a link">This is a link</a>
  "" from [[This is a link]]
  function! s:MakeInternalLink(entag) "{{{
    let line = ''
    if s:isImgLink(a:entag)
      let line = '<img src="'.a:entag.'" />'
    else
      let line = '<a href="'.a:entag.'.html">'.a:entag.'</a>'
    endif
    return line
  endfunction "}}}

  "" Make <a href="WikiWord">WikiWord</a>
  "" from WikiWord
  function! s:MakeWikiWordLink(entag) "{{{
    let line = '<a href="'.a:entag.'.html">'.a:entag.'</a>'
    return line
  endfunction "}}}

  "" Make <a href="http://habamax.ru">http://habamax.ru</a>
  "" from http://habamax.ru
  function! s:MakeBareBoneLink(entag) "{{{
    if s:isImgLink(a:entag)
      let line = '<img src="'.a:entag.'" />'
    else
      let line = '<a href="'.a:entag.'">'.a:entag.'</a>'
    endif
    return line
  endfunction "}}}

  let lsource=readfile(a:wikifile)
  let ldest = s:HTMLHeader(s:getFileNameOnly(a:wikifile), &encoding)

  let pre = 0
  let code = 0
  let table = 0
  let lists = []

  for line in lsource
    let processed = 0
    let lines = []

    let line = s:safeHTML(line)

    "" Code
    if !processed
      let [processed, lines, code] = s:processCode(line, code)
      if processed && len(lists)
        call s:closeList(lists, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      if processed && pre
        let pre = s:closePre(pre, ldest)
      endif
      call extend(ldest, lines)
    endif

    "" Pre
    if !processed
      let [processed, lines, pre] = s:processPre(line, pre)
      if processed && len(lists)
        call s:closeList(lists, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      if processed && code
        let code = s:closeCode(code, ldest)
      endif
      call extend(ldest, lines)
    endif


    "" list
    if !processed
      let [processed, lines] = s:processList(line, lists)
      if processed && pre
        let pre = s:closePre(pre, ldest)
      endif
      if processed && code
        let code = s:closeCode(code, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      call map(lines, 's:MakeTag(v:val, ''\[\[.\{-}\]\]'', '''', '''', 2, ''s:MakeInternalLink'')')
      call map(lines, 's:MakeTag(v:val, ''\[.\{-}\]'', '''', '''', 1, ''s:MakeExternalLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWeblink, '''', '''', 0, ''s:MakeBareBoneLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWikiWord, '''', '''', 0, ''s:MakeWikiWordLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxItalic, ''<em>'', ''</em>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxBold, ''<strong>'', ''</strong>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxTodo, ''<span class="todo">'', ''</span>'', 0)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxDelText, ''<span class="strike">'', ''</span>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSuperScript, ''<sup><small>'', ''</small></sup>'', 1)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSubScript, ''<sub><small>'', ''</small></sub>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxCode, ''<code>'', ''</code>'')')
      " TODO: change MakeTag function: delete cSym parameter -- count of symbols
      " to strip from 2 sides of tag. Add 2 new instead -- OpenWikiTag length
      " and CloseWikiTag length as for preformatted text there could be {{{,}}} and <pre>,</pre>.
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxPreStart.''.\+''.g:vimwiki_rxPreEnd, ''<code>'', ''</code>'', 3)')
      call extend(ldest, lines)
    endif

    "" table
    if !processed
      let [processed, lines, table] = s:processTable(line, table)
      call map(lines, 's:MakeTag(v:val, ''\[\[.\{-}\]\]'', '''', '''', 2, ''s:MakeInternalLink'')')
      call map(lines, 's:MakeTag(v:val, ''\[.\{-}\]'', '''', '''', 1, ''s:MakeExternalLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWeblink, '''', '''', 0, ''s:MakeBareBoneLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWikiWord, '''', '''', 0, ''s:MakeWikiWordLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxItalic, ''<em>'', ''</em>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxBold, ''<strong>'', ''</strong>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxTodo, ''<span class="todo">'', ''</span>'', 0)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxDelText, ''<span class="strike">'', ''</span>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSuperScript, ''<sup><small>'', ''</small></sup>'', 1)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSubScript, ''<sub><small>'', ''</small></sub>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxCode, ''<code>'', ''</code>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxPreStart.''.\+''.g:vimwiki_rxPreEnd, ''<code>'', ''</code>'', 3)')
      call extend(ldest, lines)
    endif

    if !processed
      let [processed, line] = s:processHeading(line)
      if processed
        call s:closeList(lists, ldest)
        let table = s:closeTable(table, ldest)
        let code = s:closeCode(code, ldest)
        call add(ldest, line)
      endif
    endif

    if !processed
      let [processed, line] = s:processHR(line)
      if processed
        call s:closeList(lists, ldest)
        let table = s:closeTable(table, ldest)
        let code = s:closeCode(code, ldest)
        call add(ldest, line)
      endif
    endif

    "" P
    if !processed
      let line = s:MakeTag(line, '\[\[.\{-}\]\]', '', '', 2, 's:MakeInternalLink')
      let line = s:MakeTag(line, '\[.\{-}\]', '', '', 1, 's:MakeExternalLink')
      let line = s:MakeTag(line, g:vimwiki_rxWeblink, '', '', 0, 's:MakeBareBoneLink')
      let line = s:MakeTag(line, g:vimwiki_rxWikiWord, '', '', 0, 's:MakeWikiWordLink')
      let line = s:MakeTag(line, g:vimwiki_rxItalic, '<em>', '</em>')
      let line = s:MakeTag(line, g:vimwiki_rxBold, '<strong>', '</strong>')
      let line = s:MakeTag(line, g:vimwiki_rxTodo, '<span class="todo">', '</span>', 0)
      let line = s:MakeTag(line, g:vimwiki_rxDelText, '<span class="strike">', '</span>', 2)
      let line = s:MakeTag(line, g:vimwiki_rxSuperScript, '<sup><small>', '</small></sup>', 1)
      let line = s:MakeTag(line, g:vimwiki_rxSubScript, '<sub><small>', '</small></sub>', 2)
      let line = s:MakeTag(line, g:vimwiki_rxCode, '<code>', '</code>')
      let line = s:MakeTag(line, g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd, '<code>', '</code>', 3)
      let [processed, lines] = s:processP(line)
      if processed && pre
        let pre = s:closePre(pre, ldest)
      endif
      if processed && code
        let code = s:closeCode(code, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      call extend(ldest, lines)
    endif

    "" add the rest
    if !processed
      call add(ldest, line)
    endif
  endfor

  "" process end of file
  "" close opened tags if any
  call s:closePre(pre, ldest)
  call s:closeCode(code, ldest)
  call s:closeList(lists, ldest)
  call s:closeTable(table, ldest)


  call extend(ldest, s:HTMLFooter())

  "" make html file.
  "" TODO: add html headings, css, etc.
  let wwFileNameOnly = s:getFileNameOnly(a:wikifile)
  call writefile(ldest, a:path.wwFileNameOnly.'.html')
endfunction "}}}

" 2}}}
