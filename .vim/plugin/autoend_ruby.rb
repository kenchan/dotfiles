class AutoEnd::Handler::Ruby
  include AutoEnd::Helper

  def self.filetypes
    %w(ruby)
  end

  def initialize
    @exps = [
      /^\s*#/,
      /^(=begin)\b/,
      /^\s*(class|module|def)\b(?!.*;)/,
      /([(\[]|\bbegin)\s*$/,
      /(\bdo|\{)(?:\s*\|.*\|)?\s*$/,
      /<<-?["'`]?(\w+)["'`]?/
    ]

    @assoc = Hash.new {|h, k| k }.merge(
      'class'  => 'end',
      'module' => 'end',
      'def'    => 'end',
      'begin'  => 'end',
      'do'     => 'end',
      '('      => ')',
      '{'      => '}',
      '['      => ']',
      '=begin' => '=end'
    )
  end

  def handle(line = $curbuf.line)
    return unless eol? && @exps.find {|e| e =~ line }
    append_line(indent + @assoc[$1]) if $1
  end
end
