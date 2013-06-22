module Caterer
  module Command
    class Clean < Server
      
      def execute
        options = {}
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: cater clean HOST [options]"
        end

        add_server_opts(parser, options)

        # Parse the options
        argv = parse_options(parser, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.clean
        end

        0
      end

    end
  end
end