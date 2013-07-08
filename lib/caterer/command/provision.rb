module Caterer
  module Command
    class Provision < Server
      
      def execute
        options = {}
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: cater provision HOST [options]"
        end

        add_server_opts(parser, options)

        # add provision specific options
        parser.on('--ghost', 'provision in ghost-mode (leave no trace)') do
          options[:ghost] = true
        end
        parser.on('--dry', "sync provision configuration, but don't run the provisioner") do
          options[:dry] = true
        end

        parser.separator ""

        # Parse the options
        argv = parse_options(parser, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.provision(dry_run: options[:dry], ghost_mode: options[:ghost])
        end

        0
      end

    end
  end
end