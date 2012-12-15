require 'tilt'
require 'oj'
require 'multi_json'

module Caterer
  module Provisioner
    class ChefSolo < Base
      
      def bootstrap(script=nil)

        script ||= config_bootstrap || default_bootstrap

        if not File.exists? script
          server.ui.error "Script does not exist!"
          return
        end

        # upload
        server.ui.info "Uploading bootstrap script..."
        server.ssh.upload script, "#{bootstrap_path}"

        # set permissions
        server.ui.info "Applying permissions..."
        server.ssh.sudo "chown #{server.username} #{bootstrap_path}"
        server.ssh.sudo "chmod 777 #{bootstrap_path}"

        # run
        server.ui.info "Running bootstrap script..."
        server.ssh.sudo "#{bootstrap_path}", :stream => true
      end

      def prepare
        server.ssh.sudo "mkdir -p #{base_path}"
        server.ssh.sudo "chown #{server.username} #{base_path}"
      end

      def provision

        # create cookbooks directory
        server.ssh.sudo "mkdir -p #{cookbooks_path}"
        server.ssh.sudo "chown -R #{server.username} #{cookbooks_path}"

        # sync cookbooks
        server.ui.info "Syncing cookbooks..."
        @config.cookbooks_path.each do |path|
          upload_directory path, cookbooks_path
        end

        # create roles directory
        server.ssh.sudo "mkdir -p #{roles_path}"
        server.ssh.sudo "chown -R #{server.username} #{roles_path}"

        # sync roles
        server.ui.info "Syncing roles..."
        @config.roles_path.each do |path|
          upload_directory path, roles_path
        end

        # create data_bags directory
        server.ssh.sudo "mkdir -p #{data_bags_path}"
        server.ssh.sudo "chown -R #{server.username} #{data_bags_path}"

        # sync databags
        server.ui.info "Syncing data bags..."
        @config.data_bags_path.each do |path|
          upload_directory path, data_bags_path
        end

        # create solo.rb
        server.ui.info "Generating solo.rb..."
        server.ssh.upload(StringIO.new(solo_content), solo_path)

        # create json
        server.ui.info "Generating json config..."
        server.ssh.upload(StringIO.new(json_config), json_config_path)

        # set permissions on everything
        server.ssh.sudo "chown -R #{server.username} #{base_path}"

        # run
        server.ui.info "Running chef-solo..."
        server.ssh.sudo command_string, :stream => true
      end

      def cleanup
        server.ssh.sudo "rm -rf #{base_path}"
      end

      protected

      def upload_directory(from, to)
        if File.exists? from
          unique = Digest::MD5.hexdigest(from)
          server.ssh.upload from, "#{to}/#{unique}"
          server.ssh.sudo "mv #{to}/#{unique}/* #{to}/"
          server.ssh.sudo "rm -rf #{to}/#{unique}"
        end
      end

      def base_path
        "/tmp/cater-chef-solo"
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
        @config.bootstrap_script
      end

      def default_bootstrap
        "lib/templates/provisioner/chef_solo/bootstrap.sh"
      end

      def solo_path
        "#{base_path}/solo.rb"
      end

      def solo_content
        Tilt.new('lib/templates/provisioner/chef_solo/solo.erb').render(self)
      end

      def json_config
        MultiJson.dump(@config.json.merge({:run_list => @config.run_list}))
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