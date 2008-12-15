#!/usr/bin/ruby
require 'fileutils'

HOME = ENV['HOME']
files = Dir.glob('.*').reject {|f| %w(. .. .svn .git).include?(f) }
FileUtils.rm_rf(files.map {|f| File.join(HOME, f) }, :verbose => true)
FileUtils.symlink(files.map {|f| File.expand_path(f) }, HOME, :verbose => true)
