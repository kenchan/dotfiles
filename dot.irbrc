%w[rubygems irb/completion irb/ext/save-history utility_belt pp wirb].each do |g|
  begin
    require g
  rescue LoadError
  end
end
Wirb.start
IRB.conf[:SAVE_HISTORY] = 100000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE] = :DEFAULT
