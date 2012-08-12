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

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
