module Caterer
  module Command
    class Test < Vli::Command::Base
      
      def execute
        opts = {
          host: '33.33.33.10',
          user: 'ernie',
          pass: 'password'
        }
        server = Server.new(@env, nil, opts)
        channel = server.ssh
        channel.execute("whoami") do |type, data|
          @env.ui.info data
        end
        0
      end

    end
  end
end