require 'rubygems'
require 'irb/completion'
require 'utility_belt'
require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 100000
IRB.conf[:PROMPT_MODE] = :DEFAULT
IRB.conf[:AUTO_INDENT] = true
