require 'tilt'
require 'erubis'
require 'erb'
require 'oj'
require 'multi_json'

module Caterer
  module Provisioner
    class ChefSolo < Base
      
      def bootstrap

        if bootstrap_scripts.length == 0
          server.ui.warn "No bootstrap scripts to execute"
        end

        # validate
        with_bootstrap_scripts do |script, count|

          if not File.exists? script
            server.ui.error "#{script} does not exist!"
            return
          end

        end

        # upload
        with_bootstrap_scripts do |script, count|

          server.ui.info "Uploading #{script}..."
          server.ssh.upload script, "#{bootstrap_path}-#{count}"

          server.ssh.sudo "chown #{server.username} #{bootstrap_path}-#{count}", :stream => true
          server.ssh.sudo "chmod +x #{bootstrap_path}-#{count}", :stream => true

        end

        # run
        with_bootstrap_scripts do |script, count|

          server.ui.info "Running #{script}..."
          server.ssh.sudo "#{bootstrap_path}-#{count}", :stream => true

        end

      end

      def prepare
        # create base dir
        server.ssh.sudo "mkdir -p #{base_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{base_path}", :stream => true
      end

      def install
        server.ui.info "Preparing installation..."

        # upload
        server.ssh.upload install_script, "#{install_path}"

        # set permissions
        server.ssh.sudo "chown #{server.username} #{install_path}", :stream => true
        server.ssh.sudo "chmod +x #{install_path}", :stream => true

        # run
        server.ui.info "Installing chef-solo..."
        server.ssh.sudo "#{install_path}", :stream => true
      end

      def provision

        # create cookbooks directory
        server.ssh.sudo "mkdir -p #{cookbooks_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{cookbooks_path}", :stream => true

        # sync cookbooks
        server.ui.info "Syncing cookbooks..."
        config.cookbooks_path.each do |path|
          upload_directory path, "#{cookbooks_path}/#{Digest::MD5.hexdigest(path)}"
        end

        # create roles directory
        server.ssh.sudo "mkdir -p #{roles_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{roles_path}", :stream => true

        # sync roles
        server.ui.info "Syncing roles..."
        config.roles_path.each do |path|
          upload_directory path, roles_path
        end

        # create data_bags directory
        server.ssh.sudo "mkdir -p #{data_bags_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{data_bags_path}", :stream => true

        # sync databags
        server.ui.info "Syncing data bags..."
        config.data_bags_path.each do |path|
          upload_directory path, data_bags_path
        end

        # create solo.rb
        server.ui.info "Generating solo.rb..."
        server.ssh.upload(StringIO.new(solo_content), solo_path)

        # create json
        server.ui.info "Generating json config..."
        server.ssh.upload(StringIO.new(json_config), json_config_path)

        # set permissions on everything
        server.ssh.sudo "chown -R #{server.username} #{base_path}", :stream => true

        # run
        server.ui.info "Running chef-solo..."
        server.ssh.sudo command_string, :stream => true
      end

      def cleanup
        # installer
        server.ssh.sudo "rm -f #{install_path}", :stream => true

        # bootstrap scripts
        server.ssh.sudo "rm -f #{bootstrap_path}*", :stream => true

        # solo.rb
        server.ssh.sudo "rm -f #{solo_path}", :stream => true

        # json
        server.ssh.sudo "rm -f #{json_config_path}", :stream => true

        # for now, leave cookbooks, roles, and data bags for faster provisioning
      end

      protected

      def upload_directory(from, to)
        if File.exists? from
          if @server.can_rsync?
            from += "/" if not from.match /\/$/
            @server.rsync.sync(from, to)        
          else
            unique = Digest::MD5.hexdigest(from)
            server.ssh.upload from, "#{to}/#{unique}"
            server.ssh.sudo "mv #{to}/#{unique}/* #{to}/", :stream => true
            server.ssh.sudo "rm -rf #{to}/#{unique}", :stream => true
          end
        end
      end

      def with_bootstrap_scripts
        config.bootstrap_scripts.each_with_index do |script, index|
          yield script, index if block_given?
        end
      end

      def bootstrap_scripts
        config.bootstrap_scripts
      end

      def base_path
        "/tmp/cater-chef-solo"
      end

      def install_path
        "#{base_path}/install"
      end

      def bootstrap_path
        "#{base_path}/bootstrap"
      end

      def cookbooks_path
        "#{base_path}/cookbooks"
      end

      def roles_path
        "#{base_path}/roles"
      end

      def data_bags_path
        "#{base_path}/data_bags"
      end

      def config_bootstrap
        config.bootstrap_script
      end

      def install_script
        File.expand_path("../../../templates/provisioner/chef_solo/bootstrap.sh", __FILE__)
      end

      def solo_path
        "#{base_path}/solo.rb"
      end

      def solo_content
        Tilt.new(File.expand_path('../../../templates/provisioner/chef_solo/solo.erb', __FILE__)).render(self)
      end

      def json_config
        MultiJson.dump(config_data)
      end

      def config_data
        {:run_list => config.run_list}.merge(config.json).merge(server.data)
      end

      def json_config_path
        "#{base_path}/config.json"
      end

      def command_string
        "chef-solo -c #{solo_path} -j #{json_config_path}"
      end

    end
  end
end