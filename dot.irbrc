require 'rubygems'
require 'irb/completion'
require 'utility_belt'
require 'irb/ext/save-history'
require 'pp'

IRB.conf[:SAVE_HISTORY] = 100000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE] = :DEFAULT
