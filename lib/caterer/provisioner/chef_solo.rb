require 'tilt'

module Caterer
  module Provisioner
    class ChefSolo < Base
      
      def bootstrap(script=nil)

        script ||= config_bootstrap || default_bootstrap

        if not File.exists? script
          server.ui.error "script does not exist!"
          return
        end

        # upload
        server.ui.info "uploading bootstrap script"
        server.ssh.upload script, "#{base_path}/bootstrap"

        # set permissions
        server.ui.info "applying permissions"
        server.ssh.sudo "chown #{server.username} #{base_path}/bootstrap"
        server.ssh.sudo "chmod 777 #{base_path}/bootstrap"

        # run
        server.ui.info "running bootstrap script"
        server.ssh.sudo "#{base_path}/bootstrap", :stream => true
      end

      def prepare
        server.ssh.sudo "mkdir -p #{base_path}"
        server.ssh.sudo "chown #{server.username} #{base_path}"
      end

      def provision
        
      end

      def cleanup
        server.ssh.sudo "rm -rf #{base_path}"
      end

      protected

      def base_path
        "/tmp/cater-chef-solo"
      end

      def cookbooks_path
        ""
      end

      def config_bootstrap
        @config.bootstrap_script
      end

      def default_bootstrap
        "lib/templates/provisioner/chef_solo/bootstrap.sh"
      end

    end
  end
end