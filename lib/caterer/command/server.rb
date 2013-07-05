module Caterer
  module Command
    class Server < Base
      
      def add_server_opts(parser, options)
        parser.separator ""
        parser.on("-c CONFIG", 'assumes Caterfile in current directory')
        parser.separator ""
        parser.on("-u USER", "--user USER", 'assumes current username') do |u|
          options[:user] = u
        end
        parser.on('-p PASSWORD', '--password PASSWORD', 'assumes key') do |p|
          options[:pass] = p
        end
        parser.on('-k KEY', '--key KEY', 'path to private key') do |k|
          options[:key] = k
        end
        parser.on('-P PORT', '--port PORT', 'assumes 22') do |p|
          options[:port] = p
        end
        parser.on('-i IMAGE', '--image IMAGE', 'corresponds to a image in Caterfile') do |i|
          options[:image] = i
        end
        parser.on('-g GROUP', '--group GROUP', 'corresponds to a group in Caterfile') do |g|
          options[:group] = g
        end
        parser.separator ""
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

        group   ||= Config::Group.new
        member  ||= Config::Member.new

        opts = {}
        opts[:alias]  = member.name
        opts[:user]   = options[:user] || member.user || group.user
        opts[:pass]   = options[:pass] || member.password || group.password
        opts[:host]   = member.host || options[:host]
        opts[:port]   = options[:port] || member.port
        opts[:images] = image_list(options) || member.images || group.images
        opts[:key]    = options[:key] || member.key || group.key

        # todo: move this in to the provisioner controller
        opts[:data] = begin

          data = group.data.merge(member.data)

          if options[:data]
            # todo: rather than puking if the json is valid, this should create a pretty language
            json = MultiJson.load options[:data], :symbolize_keys => true
            data = data.merge(json) if json and json.is_a? Hash
          end

          data
        end

        Caterer::Server.new(@env, opts)
      end

      def image_list(options={})
        if images = options[:image]
          images.split(',').map(&:to_sym)
        end
      end

    end
  end
end