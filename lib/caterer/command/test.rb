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
        ssh = server.ssh
        # channel.execute("whoami") do |type, data|
        #   @env.ui.info data
        # end
        ssh.upload("#{Dir.pwd}/cookbooks", '/tmp')
        # @env.ui.info Dir.pwd
        0
      end

    end
  end
end