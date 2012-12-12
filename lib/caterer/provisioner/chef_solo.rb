module Caterer
  module Provisioner
    class ChefSolo < Base
      
      def bootstrap(script=nil)
        if script
          if File.exists? script
            # upload
            server.ui.info "uploading bootstrap"
            server.ssh.upload script, "/tmp"
            # set permissions
            server.ui.info "applying permissions"
            server.ssh.sudo "chown root:root /tmp/bootstrap.sh"
            server.ssh.sudo "chmod 777 /tmp/bootstrap.sh"
            # run
            server.ui.info "running bootstrap"
            server.ssh.sudo "/tmp/bootstrap.sh" do |type, data|
              if type == :stderr
                server.ui.error data.chomp
              else
                server.ui.success data.chomp
              end
            end
          else
            server.ui.error "script does not exist!"
          end
        end
      end

      def prepare
        
      end

      def provision
        
      end

      def cleanup
        
      end

    end
  end
end