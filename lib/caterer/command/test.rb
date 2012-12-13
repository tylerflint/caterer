module Caterer
  module Command
    class Test < Base
      
      def execute
        options = {}
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: cater test"
        end

        # Parse the options
        argv = parse_options(opts, options, false)
        puts "whatev"
        0
      end

    end
  end
end