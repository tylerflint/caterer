module Caterer
  module Command
    class Up < Server
      
      def execute
        options = {}
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: cater provision HOST [options]"
        end

        add_server_opts(parser, options)

        # Parse the options
        argv = parse_options(parser, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.up
        end

        0
      end

    end
  end
end