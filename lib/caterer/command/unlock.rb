module Caterer
  module Command
    class Unlock < Base
      
      def execute
        options = {}
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: cater unlock HOST [options]"
        end

        # Parse the options
        argv = parse_options(opts, options, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.unlock
        end

        0
      end

    end
  end
end