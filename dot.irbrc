%w[rubygems irb/completion irb/ext/save-history utility_belt pp].each do |g|
  begin
    require g
  rescue LoadError
  end
end
IRB.conf[:SAVE_HISTORY] = 100000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE] = :DEFAULT
