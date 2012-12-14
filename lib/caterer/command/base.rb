module Caterer
  module Command
    class Base < Vli::Command::Base
      
      def parse_options(opts=nil, options={}, force_argv=true)
        opts ||= OptionParser.new
        opts.separator ""
        opts.on("-c CONFIG", 'assumes Caterfile in current directory')
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
        opts.on('-r ROLE', '--role ROLE', 'corresponds to a role in Caterfile') do |r|
          options[:role] = r
        end
        opts.on('-g GROUP', '--group GROUP', 'corresponds to a group in Caterfile') do |g|
          options[:group] = g
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

      def role_list(options={})
        options[:role].split(',').map(&:to_sym)
      end

    end
  end
end