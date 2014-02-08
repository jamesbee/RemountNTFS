require_relative 'options_parser'
require_relative 'my_logger'
require_relative 'commons'

$user = `echo $USER`.chomp
$mounted = `mount`

module RemountNTFS
    class Functional
        class << self
            # Run as guid mode, first print banner, than read a target from input,
            # then remount target.
            def engage_interact_remount
                print_banner

                # get the target
                get_target

                engage_remount_procedure
            end


            # @param [Symbol] target
            def remount_target(target)
                get_target target

                engage_remount_procedure
            end

            def reverse(target=:BOOTCAMP)
                is_ntfs? target

                reg_match target

                eject_target

                system("diskutil mountDisk #{ARGS.target_device}")
            end


            def greeting
                puts "hello user!".bold.red.underline
            end

            private

            # A helper method, read a target and remount it.
            def engage_remount_procedure
                # start procedure
                puts "#{ARGS.target_partition} on #{ARGS.target} will be remount.".bold

                eject_target

                # final step
                puts "Remounting #{ARGS.target}...".bold

                mount_target
            end

            def print_banner
                # show tips and banner
                banner = "RemountNTFS.RB v0.1 [Guid mode]\n".bold +
                    "Hi ".bold + RemountNTFS.whoami.green +
                    ", #{RemountNTFS.greeting_time}".bold

                tips = "\n\nWhich target you want to remount?\n".bold +
                    RemountNTFS.mounted_devices.join(", ").green + "\n" +
                    "[".bold + "BOOTCAMP".underline + " by default]:".bold
                print banner, tips
            end

            # get target from console
            def get_target(_target=:gets)
                _target = gets.chomp if _target==:gets

                _target = :BOOTCAMP if _target.empty?

                is_ntfs? _target

                reg_match _target

                # start procedure
                ARGS.target = _target
            end

            # first check the target should be ntfs
            def is_ntfs?(target=:BOOTCAMP)
                $mounted = `mount`
                unless /^.*#{target}.*ntfs.*$/i =~ $mounted or /^.*#{target}.*osxfusefs.*$/i =~ $mounted
                    $logger.fatal "#{$user}, you gonna be kidding.".fatal
                    $logger.fatal "Target #{target} is not a NTFS partition!".fatal
                    exit 1
                end
            end

            # then eject target
            def eject_target
                puts $user.green + ", you can ignore the upcoming 'eject fail' message."
                puts ''
                system("diskutil eject #{ARGS.target}")
                sleep 3
            end

            # remount target
            def mount_target
                path = ARGS.mount_path.to_s + ARGS.target.to_s
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
                if ARGS.target_partition.empty? or ARGS.target_partition.empty?
                    $logger.fatal "Cannot find any partition match given target #{target}".fatal
                    exit 2
                end
                rescue NoMethodError
                    $logger.fatal "some how, #{target} is no longger mounted on system.".fatal
                    exit 1
                end
            end

        end
    end
end
