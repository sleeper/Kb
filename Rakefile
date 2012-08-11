require 'rubygems'
require 'bundler'
#require 'pathname'
#require 'logger'
#require 'fileutils'

require 'bundler/setup'
require 'coffee-script'

namespace :js do
  desc "compile coffee-scripts"
  task :compile do
    js = open "#{File.dirname(__FILE__)}/js/kb.js", 'w+'
    Dir["#{File.dirname(__FILE__)}/src/**/*"].each do |cf|
      if /\.coffee$/ =~ cf
        puts "Compiling #{cf}"
        js.puts CoffeeScript.compile File.read cf
      end
    end
  end
end
