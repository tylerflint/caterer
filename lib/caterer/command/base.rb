require 'oj'
require 'multi_json'

module Caterer
  module Command
    class Base
      
      include Vli::Util::SafePuts
      
      def initialize(argv, env)
        @argv   = argv
        @env    = env
      end

      def execute; end

      def parse_options(opts=nil, force_argv=false)
        argv = @argv.dup
        opts ||= OptionParser.new

        opts.on_tail("-h", "--help", "Print this help") do
          safe_puts(opts.help)
          return nil
        end

        begin
          opts.parse!(argv)
          raise if force_argv and (not argv or argv.length == 0)
          argv
        rescue
          safe_puts(opts.help)
          nil
        end

      end

    end
  end
end