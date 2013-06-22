module Caterer
  module Command
    class Bootstrap < Server
      
      def execute
        options = {}
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: cater bootstrap HOST [options]"
        end

        add_server_opts(parser, options)

        argv = parse_options(parser, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.bootstrap
        end

        0
      end

    end
  end
end