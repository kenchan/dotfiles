function! s:RunRspec (opts)
  let rails_spec_path_re = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'

  if( expand('%') =~ rails_spec_path_re && filereadable('script/spec') )
    "let command = '!ruby script/spec '
    let spec_command = '!spec '
    if filereadable('tmp/pids/spec_server.pid')
      let spec_command = spec_command . ' --drb '
    endif
  else
    let spec_command = '!spec '
  endif
  exe spec_command . a:opts . ' ' . expand('%:p')
endfunction

function! s:RunCucumber (feature)
  if( filereadable('Rakefile') )
    let command = '!rake features FEATURE='
  elseif( filereadable('script/cucumber') )
    let command = '!script/cucumber --language ja '
  else
    let command = '!cucumber --language ja '
  endif
  exe command . a:feature
endfunction

function! <SID>RunBehavior ()
  call s:RunRspec('--format=n --color')
endfunction

function! <SID>RunExample ()
  call s:RunRspec('--format=n --color --line ' . line('.'))
endfunction

function! <SID>RunScinario ()
  call s:RunCucumber(expand('%:p') . ':' . line('.'))
endfunction

function! <SID>RunFeature ()
  call s:RunCucumber(expand('%:p'))
endfunction

function! s:SetupCucumberVim ()
  command! RunFeature call <SID>RunFeature()
  command! RunScinario call <SID>RunScinario()

  nnoremap -fe :RunFeature<CR>
  nnoremap -sc :RunScinario<CR>
endfunction

function s:SetupRspecVim()
  command! RunExample call <SID>RunExample()
  command! RunBehavior call <SID>RunBehavior()

  nnoremap -ex :RunExample<CR>
  nnoremap -bh :RunBehavior<CR>
endfunction

" TODO script localにする
au BufRead,BufNewFile *_spec.rb call s:SetupRspecVim()
au BufRead,BufNewFile *.feature call s:SetupCucumberVim()
