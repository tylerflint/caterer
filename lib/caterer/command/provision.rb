module Caterer
  module Command
    class Provision < Base
      
      def execute
        options = {}
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: cater provision HOST [options]"
        end

        # Parse the options
        argv = parse_options(opts, options, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.provision
        end

        0
      end

    end
  end
end