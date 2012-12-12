module Caterer
  module Command
    class Base < Vli::Command::Base
      
      def parse_options(opts=nil, options={}, force_argv=true)
        opts ||= OptionParser.new
        opts.separator ""
        opts.on("-u USER", "--user USER", 'assumes current username') do |u|
          options[:user] = u
        end
        opts.on('-p PASSWORD', '--password PASSWORD', 'assumes key') do |p|
          options[:pass] = p
        end
        opts.on('-P PORT', '--port PORT', 'assumes 22') do |p|
          options[:port] = p
        end
        opts.separator ""

        begin
          argv = super(opts)
          raise if force_argv and (not argv or argv.length == 0)
          argv
        rescue
          safe_puts(opts.help)
          nil
        end
        
      end

      def with_target_servers(argv, options={})
        argv.first.split(",").each do |host|
          yield Server.new(@env, options.merge({:host => host}))
        end
      end

    end
  end
end