require_relative 'options_parser'
require_relative 'my_logger'
require_relative 'commons'

module RemountNTFS
    class Functional
        class << self
            def remount
                # show tips and banner
                banner = "RemountNTFS.RB v0.1 [Guid mode]\n".bold +
                    "Hi ".bold + RemountNTFS.whoami.green +
                    ", #{RemountNTFS.greeting_time}".bold

                tips = "\n\nWhich target you want to remount?\n".bold +
                    RemountNTFS.mounted_devices.join(", ").green + "\n" +
                    "[".bold + "BOOTCAMP".underline + " by default]:".bold
                print banner, tips

                # get the target
                get_target

                # start procedure
                puts "#{ARGS.target_partition} on #{ARGS.target} will be remount.".bold
                puts $user.green + ", you can ignore the upcoming 'eject fail' message."

                eject_target

                # final step
                puts "Remounting #{ARGS.target}...".bold
                
                remount_target
            end

            private

            # get target from console
            def get_target
                target = gets.chomp || "BOOTCAMP"
                is_ntfs? target

                unless target.empty?
                    reg_match target
                else
                    target = "BOOTCAMP"
                    reg_match target
                end

                # start procedure
                ARGS.target = target
            end

            # first check the target should be ntfs
            def is_ntfs? target
                $mounted = `mount`
                if /^.*#{target}.*ntfs.*$/i =~ $mounted
                    return true
                else
                    $logger.fatal "#{$user}, you gonna be kidding.".fatal
                    $logger.fatal "Target #{target} is not a NTFS partition!".fatal
                    exit 1
                end
            end

            # then eject target
            def eject_target
                puts ''
                system("diskutil eject #{ARGS.target}")
                sleep 3
            end

            # remount target
            def remount_target
                path = ARGS.mount_path+ARGS.target
                unless system("mkdir #{path}")
                    $logger.fatal "Cannot create directory #{path}, check your setting".fatal
                    exit
                end

                system("sudo -k #{ARGS.mount_cmd} #{ARGS.target_partition} #{path}")
                system("diskutil mountDisk #{ARGS.target_device}")
            end
            
            # find target device by gaven target
            def reg_match target
                begin
                ARGS.target_partition = $mounted.scan(/(^.*\d[s]\d{1,2}).*#{target}/)[0][0]
                ARGS.target_device = $mounted.scan(/(^.*\d)[s]\d{1,2}.*#{target}/)[0][0]
                rescue NoMethodError
                    $logger.fatal "some how, #{target} is no longger mounted on system.".fatal
                    exit 1
                end
            end

        end
    end
end

 RemountNTFS::Functional.remount
