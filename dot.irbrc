require 'rubygems'
require 'irb/completion'
require 'utility_belt'
require 'irb/ext/save-history'
require 'pp'

UtilityBelt.equip(:all, :except => ["clipboard", "pastie", "google"])

IRB.conf[:SAVE_HISTORY] = 100000
IRB.conf[:PROMPT_MODE] = :DEFAULT
IRB.conf[:AUTO_INDENT] = true
