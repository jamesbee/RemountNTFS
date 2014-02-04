require 'optparse'
require 'ostruct'

module RemountNTFS
    ARGS = OpenStruct.new
    ARGS.target_partition = ""      # default will be /dev/disk0s*
    ARGS.target_device = ""
    ARGS.target = :BOOTCAMP     # default set to BOOTCAMP
    ARGS.r_only = false         # default set to writable
    ARGS.mount_path = "/Volumes/" # prefix
    ARGS.mount_cmd = "/usr/local/sbin/mount_ntfs"

    class Parser
        def initialize
            opt_parser = OptionParser.new do |opts|
                # The banner and title of the opt help_me
                opts.banner = "Usage: remount_ntfs.rb [options] [TARGET_DISK]"
                opts.separator ""
                opts.separator "Specific options:"

                opts.on("--target TARGET") do |target|
                    ARGS.target = target.to_s
                end

                opts.separator ""
                opts.separator "Common options:"

                opts.on_tail('-h', '--help',
                        'Print this screen.') do
                    puts opts
                end
            end

            opt_parser.parse! ARGV
            ARGS.target = ARGV[0] unless ARGV.empty?
        end

        def options
            ARGS
        end
    end
end
