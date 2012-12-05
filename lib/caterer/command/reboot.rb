module Caterer
  module Command
    class Reboot < Vli::Command::Base
      
      def execute
        options = {}
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: cater reboot HOST [options]"
          opts.separator ""
          opts.on("-a USER", "--as USER", 'assumes current username') do |a|
            options[:user] = a
          end
          opts.on('-x PASSWORD', '--password PASSWORD', 'assumes key') do |p|
            options[:password] = p
          end
          opts.on('-p PORT', '--port PORT', 'assumes 22') do |p|
            options[:port] = p
          end
          opts.separator ""
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        @env.ui.info options
        0
      end

    end
  end
end