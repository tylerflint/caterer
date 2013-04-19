module Caterer
  module Command
    class Berks < Vli::Command::Base
      
      def execute
        options = {}
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: cater berks install|update|clean"
        end

        # Parse the options
        argv = parse_options(opts)
        if not argv.any?
          safe_puts(opts.help)
          return
        end

        case argv.first
        when 'install'
          run_action :berks_install
        when 'update'
          run_action :berks_install, {force_berks_install: true}
        when 'clean'
          run_action :berks_clean, {force_berks_clean: true}
        else
          safe_puts(opts.help)
        end

        0
      end

      def run_action(name, options=nil)
        options = {
          :ui => @env.ui,
          :config => @env.config
        }.merge(options || {})

        @env.action_runner.run(name, options)
      end

    end
  end
end