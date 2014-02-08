#! /usr/bin/env ruby
#  encoding: utf-8

require_relative 'remount_ntfs/my_logger'
require_relative 'remount_ntfs/functional'

module RemountNTFS
    class RemountNTFS
        def initialize
        end

        # Remount BOOTCAMP default
        def remount_default
            Functional.remount_target :BOOTCAMP
        end

        def remount(target)
            Functional.remount_target target
        end

        def remount_guid_mode
            Functional.engage_interact_remount
        end

        def reverse_mode(target)
            Functional.reverse target
        end
    end
end



if __FILE__ == $0
    paser = RemountNTFS::Parser.new
    args = RemountNTFS::ARGS

    remounter = RemountNTFS::RemountNTFS.new

    if args.reverse_mode
        remounter.reverse_mode args.target
    elsif args.guid_mode
        remounter.remount_guid_mode
    elsif not args.target.empty?
        remounter.remount args.target
    else
        remounter.remount_default
    end
end
