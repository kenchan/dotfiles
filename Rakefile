require 'fileutils'
include FileUtils::Verbose

HOME = ENV['HOME']

task :default => %w(remove_dots create_symlink)

task :remove_dots do
  Dir.glob('dot.*') do |src|
    rm_rf File.expand_path(src.sub(/^dot\./, '.'), HOME)
  end
end

task :remove_symlink do
  rm_r Dir.glob(File.expand_path('.*', HOME)).select {|path|
    File.symlink?(path) && File.dirname(File.readlink(path)) == Dir.pwd
  }
end

task :create_symlink do
  Dir.glob('dot.*') do |src|
    dest = File.expand_path(src.sub(/^dot\./, '.'), HOME)
    ln_s File.expand_path(src), dest, :force => true
  end
end
