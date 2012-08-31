require 'rubygems'
require 'bundler'
#require 'pathname'
#require 'logger'
#require 'fileutils'

require 'bundler/setup'
require 'coffee-script'

SRCS = %w(
kb.coffee
models/board.coffee
models/ticket.coffee
collections/ticketlist.coffee
raphael/board.coffee
raphael/ticket.coffee
views/ticket_view.coffee
views/board_view.coffee
)

namespace :js do
  desc "compile coffee-scripts"
  task :compile do
    js = open "#{File.dirname(__FILE__)}/js/kb.js", 'w+'
    SRCS.each do |cfile|
      puts "Compiling #{cfile}"
      js.puts CoffeeScript.compile File.read File.join(File.dirname(__FILE__),"src",cfile)
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
