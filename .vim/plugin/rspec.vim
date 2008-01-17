function! Rspec ()
  let rails_spec_pat = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'

  let opts = '--format=s --color '

  if( expand('%') =~ rails_spec_pat && filereadable('script/spec') )
    let command = '!ruby script/spec '
    if filereadable('tmp/spec_server.pid')
      let opts = opts . ' --drb'
    endif
  else
    let command = '!spec '
  endif

  if 1
    let opts = opts . ' --line '.line('.')
  endif
  exe command . opts . ' ' . expand('%:p')

endfunction

au BufRead,BufNewFile *_spec.rb :command! Rspec :call Rspec()
