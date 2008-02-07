if !has('ruby')
  finish
endif

ruby << RUBY
require 'singleton'

class AutoEnd
  include Singleton

  def initialize
    @handlers = {}

    AutoEnd::Handler.constants.map {|const|
      AutoEnd::Handler.const_get(const)
    }.each do |klass|
      handler = klass.new

      klass.filetypes.each do |type|
        @handlers[type] = handler
      end
    end
  end

  def exec
    handler = @handlers[VIM.evaluate('&filetype')] and handler.handle
  end

  module Handler; end

  module Helper
    def append_line(str, row = $curbuf.line_number)
      return if str.nil? || str.empty?
      $curbuf.append(row, str)
    end

    def indent(line = $curbuf.line)
      /^\s*/.match(line).to_a.first
    end

    def eol?
      $curwin.cursor.last.succ == $curbuf.line.size
    end

    HERE = File.join(VIM.evaluate('&runtimepath').split(',', 2).first, 'plugin')
  end
end

Dir.glob(File.join(AutoEnd::Helper::HERE, 'autoend_*.rb')) do |f|
  require f
end
RUBY

inoremap <silent> <CR> <ESC>:ruby AutoEnd.instance.exec<CR>a<CR>
