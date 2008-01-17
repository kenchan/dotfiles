require 'rubygems'
require 'irb/completion'
require 'what_methods'
require 'wirble'

Wirble.init
Wirble.colorize

IRB.conf.update(
  :SAVE_HISTORY => 100,
  :PROMPT_MODE => :SIMPLE
)
