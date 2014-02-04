require 'colored'
require 'logger'

class String
    # use normal bold as information
    alias :info :bold

    # use yellow underlined as warning
    def yellow_and_underline
        self.yellow.underline
    end
    alias :warning :yellow_and_underline

    # use red on yellow as fatal error
    alias :fatal :red_on_yellow
end

$logger = Logger.new(STDOUT)
$logger.level = Logger::WARN
$logger.datetime_format = "%Y%m%d %H:%M:%S"


module RemountNTFS

end
