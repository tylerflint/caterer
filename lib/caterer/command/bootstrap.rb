module Caterer
  module Command
    class Bootstrap < Base
      
      def execute
        options = {}
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: cater bootstrap HOST [options]"
          opts.separator ""
          opts.on("-s SCRIPT", "--script SCRIPT", 'optional bootstrap script') do |s|
            options[:script] = s
          end
        end

        # Parse the options
        argv = parse_options(opts, options, true)
        return if not argv

        with_target_servers(argv, options) do |server|
          server.bootstrap({:script => options[:script]})
        end

        0
      end

    end
  end
end