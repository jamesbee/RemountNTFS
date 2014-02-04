#! /usr/bin/env ruby
#  encoding: utf-8

require 'colored'
require 'logger'
require 'optparse'

class String
    def yellow_and_underline
        self.yellow.underline
    end
    alias :warning :yellow_and_underline
    alias :fatal :red_on_yellow
end

logger = Logger.new(STDOUT)
logger.level = Logger::WARN
logger.datetime_format = "%Y-%m-%d %H:%M:%S"

#src = `mount`
#puts src.scan(/(^.*\d[s]\d{1,2}).*DROP/)[0]

puts 'test'.warning
