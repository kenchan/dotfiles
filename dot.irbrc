%w[rubygems irb/completion irb/ext/save-history pp].each do |g|
  begin
    require g
  rescue LoadError
    puts $!
  end
end
IRB.conf[:SAVE_HISTORY] = 100000
IRB.conf[:PROMPT_MODE] = :DEFAULT
