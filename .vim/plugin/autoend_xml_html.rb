module AutoEnd::Handler
  class Xml
    include AutoEnd::Helper

    def self.filetypes
      %w(xml)
    end

    def initialize
      @regexp = /<([\w:]+)[^\/>]*>\s*$/
    end

    def handle(line = $curbuf.line)
      return unless eol? && @regexp =~ line
      append_line indent + "</#{$1}>"
    end
  end

  class Html < Xml
    def self.filetypes
      %w(html eruby)
    end

    def initialize
      empty_elems = %w(area base basefont br col frame hr img input isindex link meta param).join('|')
      @regexp = /<(?!(?:#{empty_elems})\b)(\w+)[^\/>]*>\s*$/i
    end
  end
end
