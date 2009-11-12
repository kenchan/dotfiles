"=============================================================================
" File: rbpit.vim
" Autor: Koutarou Tanaka <from.kyushu.island@gmail.com>
" OriginalFile: pitconfig.vim
" OriginalAuthor: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: Tue, 26 May 2009
" Version: 0.1
" Usage:
"   :PitReload
"     reload pit config named as g:pitconfig_default
"
"   :PitLoad profile
"     load pit config named as 'profile'
"
"   :PitShow
"     show current pit config named as g:pitconfig_default
"   :PitShow profile
"     show current pit config named as 'profile'
"
"   :PitEdit
"     open pit config file with text editor asigned $EDITOR
"
"   :PitSave
"     save current variables to pit config which named as g:pitconfig_default
"   :PitSave profile
"     save current variables to pit config which named as 'profile'
"
"   :PitAdd varname
"     add variable to current pit config.
"
"   :PitDel varname
"     delete variable from current pit config.
"
" Tips:
"   you can get pit config as Dictionary like following.
"
"     :echo PitGet('vimrc')['my_vim_config']
"     :echo PitGet()['my_vim_config']
"
"   you can set pit config like following.
"
"     :call PitSet({ 'foo': 'bar' })
"     :call PitSet({ 'foo': 'bar' }, 'myprofile')

if &cp || (exists('g:loaded_rbpit') && g:loaded_pitconfig)
  finish
endif
let g:loaded_rbpit = 1

if !exists('g:pitconfig_default')
  let g:pitconfig_default = 'vimrc'
endif
if !exists('g:pitconfig_autoload')
  let g:pitconfig_autoload = 1
endif

if !has('ruby')
  finish
endif

"ruby: require modules {{{
ruby <<__END__
require 'rubygems'
require 'pit'
__END__
"}}}

function! PitGet(...)
  if a:0 == 0
    let l:profname = g:pitconfig_default
  elseif a:0 == 1 && len(a:1)
    let l:profname = a:1
  else
    throw "too many arguments"
  endif
  let l:ret = {}
"ruby: get pit config as JSON string {{{
ruby <<__END__
config = Pit.get(VIM.evaluate('l:profname'))
dictionary = ""
config.each do |key,value|
  if dictionary.empty?
    dictionary += "{'#{key}': \"#{value}\""
  else
    dictionary += ", '#{key}': \"#{value}\""
  end
end
dictionary += "}"
VIM.command("let l:ret = #{dictionary}")
__END__
" }}}
  if !exists('l:ret')
    let ret = {}
  endif
  return l:ret
endfunction

function! PitSet(...)
  if a:0 == 1 && len(a:1)
    let l:data = string(a:1)
    let l:profname = g:pitconfig_default
  elseif a:0 == 2 && len(a:1) && len(a:2)
    let l:data = string(a:1)
    let l:profname = a:2
  else
    throw "too many or few arguments"
  endif
  let l:ret = {}
"ruby: save to pit config {{{
ruby <<__END__
profname = VIM.evaluate('l:profname')
data = VIM.evaluate('l:data')
Pit.set(profname, :data => data)
__END__
"}}}
endfunction

function! s:PitLoad(profname)
"ruby: load pit config to global scope {{{
ruby <<__END__
config = Pit.get(VIM.evaluate("a:profname"))
config.each do |key,value|
  key = "g:#{key}"
  VIM.command("silent! unlet #{key}|let #{key} = '#{value}'")
end
__END__
"}}}
endfunction

function! s:PitAdd(...)
  let l:profname = g:pitconfig_default
"ruby: add variable to pit config {{{
ruby <<__END__
profname = VIM.evaluate('l:profname')
varcount = VIM.evaluate('a:0').to_i
config = Pit.get(profname)
(1..varcount).each do |count|
  varname = VIM.evaluate("a:#{count}")
  name = varname.gsub(/^[gsl]:/,"")
  type = VIM.evaluate("type(#{varname})").to_i
  VIM.evaluate("string(#{varname})") if type == 3 or type == 4
  config[name] = VIM.evaluate(varname)
end
Pit.set(profname, :data => config)
__END__
"}}}
endfunction

function! s:PitDel(...)
  let l:profname = g:pitconfig_default
"ruby: delete variable from pit config {{{
ruby <<__END__
profname = VIM.evaluate('l:profname')
config = Pit.get(profname)
data = {}
varcount = VIM.evaluate('a:0').to_i
varnames = []
(1..varcount).each do |count|
  varname = VIM.evaluate("a:#{count}")
  varname.gsub!(/^[gsl]:/,"")
  varnames.push varname
end
config.each do |key,value|
  unless varnames.include? key
    type = VIM.evaluate("type(g:#{key})")
    if type == '3' or type == '4'
      data[key] = VIM.evaluate("string(g:#{key})")
    else
      data[key] = VIM.evaluate("g:#{key}")
    end
  end
end
Pit.set(profname, :data => data)
__END__
"}}}
endfunction

function! s:PitShow(...)
  let l:profname = g:pitconfig_default
  if a:0 == 1 && len(a:1)
    let l:profname = a:1
  endif
  let l:config = PitGet(l:profname)
  echohl Title | echo l:profname | echohl None
  for l:key in keys(l:config)
    echohl LineNr | echo l:key | echohl None | echon ":"
    echo " " l:config[key]
  endfor
  silent! unlet l:config
endfunction

function! s:PitEdit(...)
  let l:profname = g:pitconfig_default
  if a:0 == 1 && len(a:1)
    let l:profname = a:1
  endif
  if len($EDITOR) == 0
    let $EDITOR = v:progname
  endif
  if executable('pit')
    exec '!pit set ' l:profname
  elseif executable('ppit')
    exec '!ppit set ' l:profname
  endif
endfunction

function! s:PitSave(...)
  let l:profname = g:pitconfig_default
  if a:0 == 1 && len(a:1)
    let l:profname = a:1
  endif
"ruby: save to pit config {{{
ruby <<__END__
profname = VIM.evaluate('l:profname')
config = Pit.get(profname)
data = {}
config.each do |key,value|
  VIM.command("let l:type = type(g:#{key})")
  type = VIM.evaluate('l:type').to_i
  g_key = (type == 3 or type == 4)? "string(g:#{key})":"g:#{key}"
  data[key] = VIM.evaluate(g_key)
end
Pit.set(profname,:data => data)
__END__
"}}}
endfunction

command! PitReload :call s:PitLoad(g:pitconfig_default)
command! -nargs=1 PitLoad :call s:PitLoad(<q-args>)
command! -nargs=* PitSave :call s:PitSave(<q-args>)
command! -nargs=* PitShow :call s:PitShow(<q-args>)
command! -nargs=* PitEdit :call s:PitEdit(<q-args>)
command! -nargs=+ -complete=var PitAdd :call s:PitAdd(<f-args>)
command! -nargs=+ -complete=var PitDel :call s:PitDel(<f-args>)

if g:pitconfig_autoload
  call s:PitLoad(g:pitconfig_default)
endif
" vim:fdm=marker fdl=0 fdc=0 fdo+=jump,search:
" vim:fdt=substitute(getline(v\:foldstart),'\\(.\*\\){\\{3}','\\1',''):
