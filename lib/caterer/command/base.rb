require 'oj'
require 'multi_json'

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
        opts.on('-k KEY', '--key KEY', 'path to private key') do |k|
          options[:key] = k
        end
        opts.on('-P PORT', '--port PORT', 'assumes 22') do |p|
          options[:port] = p
        end
        opts.on('-e ENGINE', '--engine ENGINE', 'provision engine' ) do |e|
          options[:engine] = e
        end
        opts.on('-d JSON', '--data JSON', 'json data that the provisioner may use' ) do |d|
          options[:data] = d
        end
        opts.on('-i IMAGE', '--image IMAGE', 'corresponds to a image in Caterfile') do |i|
          options[:image] = i
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
        target_servers(argv, options).each do |server|
          yield server if block_given?
        end
      end

      def target_servers(argv, options={})
        @servers ||= begin
          servers = []

          argv.first.split(",").each do |host|
            
            if group = @env.config.groups[host.to_sym]
              group.members.each do |key, member|
                servers << init_server(group, member, options)
              end
            else

              if not host.match /::/
                host = "default::#{host}"
              end

              g, m   = host.split "::"
              group  = nil
              member = nil

              if group = @env.config.groups[g.to_sym]
                member = group.members[m.to_sym]
              end

              servers << init_server(group, member, options.merge(:host => m))
            end
          end    

          servers
        end
      end

      def init_server(group=nil, member=nil, options={})

        group ||= Config::Group.new
        member ||= Config::Member.new

        opts = {}
        opts[:alias]  = member.name
        opts[:user]   = options[:user] || member.user || group.user
        opts[:pass]   = options[:pass] || member.password || group.password
        opts[:host]   = member.host || options[:host]
        opts[:port]   = options[:port] || member.port
        opts[:images] = image_list(options) || member.images || group.images
        opts[:key]    = options[:key] || member.key || group.key

        if engine = options[:engine]
          opts[:engine] = engine.to_sym
        end

        opts[:data] = begin

          data = group.data.merge(member.data)

          if json = options[:data]
            data = data.merge(MultiJson.load(json, :symbolize_keys => true) rescue {})
          end

          data
        end

        Server.new(@env, opts)
      end

      def image_list(options={})
        if images = options[:image]
          images.split(',').map(&:to_sym)
        end
      end

    end
  end
end