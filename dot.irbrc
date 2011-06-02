%w[rubygems irb/completion irb/ext/save-history pp wirb hirb hirb-unicode].each do |g|
  begin
    require g
  rescue LoadError
    puts $!
  end
end
Wirb.start
Hirb.enable
IRB.conf[:SAVE_HISTORY] = 100000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE] = :DEFAULT
