module RemountNTFS

    class RemountNTFS
        class <<RemountNTFS


            def greeting_time
                t = Time.new
                hour = t.hour
                case hour
                    when 1..3
                        return "sweet night"
                    when 20..24
                        return "sweet night"
                    when 4..9
                        return "good morning"
                    when 10..12
                        return "good noon"
                    when 13..18
                        return "good afternoon"
                    else
                        return "good early night"
                end
            end

            def whoami
                $user
            end

            def mounted_devices
                devices = []
                $mounted.scan(/Volumes\/(.*)\s\(ntfs/).map.with_index do |e, i|
                    devices[i] = e[0]
                end
            end
        end
    end
end

