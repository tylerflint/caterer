require 'tilt'

module Caterer
  module Provisioner
    class ChefSolo < Base
      
      def bootstrap(script=nil)
        return unless script

        if not File.exists? script
          server.ui.error "script does not exist!"
          return
        end

        # upload
        server.ui.info "uploading bootstrap"
        server.ssh.upload script, "/tmp"

        # set permissions
        server.ui.info "applying permissions"
        server.ssh.sudo "chown root:root /tmp/bootstrap.sh"
        server.ssh.sudo "chmod 777 /tmp/bootstrap.sh"

        # run
        server.ui.info "running bootstrap"
        server.ssh.sudo "/tmp/bootstrap.sh", :stream => true
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