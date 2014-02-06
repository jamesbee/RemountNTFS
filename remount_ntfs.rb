#! /usr/bin/env ruby
#  encoding: utf-8

require_relative 'remount_ntfs/my_logger'
require_relative 'remount_ntfs/functional'

module RemountNTFS
    class RemountNTFS

    end
end



if __FILE__ == $0
    paser = OptionParser.new
    p RemountNTFS.ARGS
end
