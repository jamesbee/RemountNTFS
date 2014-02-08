require 'optparse'
require 'ostruct'
require 'colored'


module RemountNTFS
    ARGS = OpenStruct.new
    ARGS.untouched = true
    ARGS.target_partition = ""      # default will be /dev/disk0s*
    ARGS.target_device = ""
    ARGS.target = :BOOTCAMP     # default set to BOOTCAMP
    ARGS.r_only = false         # default set to writable
    ARGS.guid_mode = false
    ARGS.reverse_mode = false
    ARGS.mount_path = "/Volumes/" # prefix
    ARGS.mount_cmd = "/usr/local/sbin/mount_ntfs"

    class Parser
        def initialize
            opt_parser = OptionParser.new do |opts|
                # The banner and title of the opt help_me
                opts.banner= "RemountNTFS, little util writen by James Become."

                opts.separator ""
                opts.separator "Usage: remount_ntfs.rb [options] [TARGET_DISK]".bold
                opts.separator "Usage: remoutn_ntfs.rb [-g|--guid]".bold
                opts.separator "Usage: remoutn_ntfs.rb [-r|--reverse]".bold
                opts.separator ""
                opts.separator "Specific options:"

                opts.on("-g","--guid",
                        "Start interact guid mode.".bold) do |g|
                    ARGS.guid_mode = true
                end

                opts.on("-r", "--reverse [TARGET]",
                        "Remount partition (BOOTCAMP default) back to system default.".bold) do |target|
                    ARGS.reverse_mode = true
                    if target.nil?
                        ARGS.target = :BOOTCAMP
                    else
                        ARGS.target = target
                    end
                    ARGS.untouched = false
                end

                opts.on("--target TARGET",
                        "If target is specificated this way, it might be rewrote.".bold) do |target|
                    ARGS.target = target.to_s
                    ARGS.untouched = false
                end

                opts.separator ""
                opts.separator "Common options:".bold

                opts.on_tail('-h', '--help',
                        'Print this screen.'.bold) do
                    puts opts
                end
            end

            opt_parser.parse! ARGV
            ARGS.target = ARGV[0] unless ARGV.empty?
            ARGS.guid_mode = true if ARGS.untouched
        end

        def options
            ARGS
        end
    end
end
