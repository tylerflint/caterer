module Caterer
  module Command
    class Reboot < Base
      
      def execute
        options = {}
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: cater reboot HOST [options]"
        end

        # Parse the options
        argv = parse_options(opts, options, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.reboot
        end

        0
      end

    end
  end
end