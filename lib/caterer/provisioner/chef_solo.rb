require 'tilt'
require 'erubis'
require 'erb'
require 'oj'
require 'multi_json'

module Caterer
  module Provisioner
    class ChefSolo < Base
      
      attr_reader :run_list
      attr_accessor :json, :cookbooks_path, :roles_path
      attr_accessor :data_bags_path, :bootstrap_scripts

      def initialize
        @run_list          = []
        @json              = {}
        @cookbooks_path    = ['cookbooks']
        @roles_path        = ['roles']
        @data_bags_path    = ['data_bags']
        @bootstrap_scripts = []
      end

      # config DSL

      def add_recipe(recipe)
        @run_list << "recipe[#{recipe}]"
      end

      def add_role(role)
        @run_list << "role[#{role}]"
      end

      # I don't like this at all, but it seems to make the best Caterfile workflow
      def add_image(image)
        image = Caterer.config.images[image]
        raise "Unknown image :#{image}" if not image

        provisioner = image.provisioner
        raise "No provisioner for :#{image}" if not provisioner

        if not provisioner.class == self.class
          raise "add_image incompatibility: #{provisioner.class} != #{self.class}"
        end

        @run_list += provisioner.run_list
        @bootstrap_scripts += provisioner.bootstrap_scripts
      end

      def add_bootstrap(script)
        @bootstrap_scripts << script
      end

      def errors
        errors = {}

        if not @run_list.length > 0
          errors[:run_list] = "is empty"
        end

        if not @cookbooks_path.is_a? Array
          errors[:cookbooks_path] = "must be an array"
        end

        if not @roles_path.is_a? Array
          errors[:roles_path] = "must be an array"
        end

        if not @data_bags_path.is_a? Array
          errors[:data_bags_path] = "must be an array"
        end

        if errors.length > 0
          errors
        end
      end

      # provision engine

      def bootstrap(server)

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
          server.ssh.upload script, "#{target_bootstrap_path}-#{count}"

          server.ssh.sudo "chown #{server.username} #{target_bootstrap_path}-#{count}", :stream => true
          server.ssh.sudo "chmod +x #{target_bootstrap_path}-#{count}", :stream => true

        end

        # run
        with_bootstrap_scripts do |script, count|

          server.ui.info "Running #{script}..."
          server.ssh.sudo "#{target_bootstrap_path}-#{count}", :stream => true

        end

      end

      def bootstrapped?(server)
        res = server.ssh.sudo "command -v chef-solo &>/dev/null"
        res == 0 ? true : false
      end

      def prepare(server)
        # create base dir
        server.ssh.sudo "mkdir -p #{target_base_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{target_base_path}", :stream => true
      end

      def install(server)
        server.ui.info "Preparing installation..."

        # upload
        server.ssh.upload install_script, "#{target_install_path}"

        # set permissions
        server.ssh.sudo "chown #{server.username} #{target_install_path}", :stream => true
        server.ssh.sudo "chmod +x #{target_install_path}", :stream => true

        # run
        server.ui.info "Installing chef-solo..."
        server.ssh.sudo "#{target_install_path}", :stream => true
      end

      def provision(server)

        # create cookbooks directory
        server.ssh.sudo "mkdir -p #{target_cookbooks_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{target_cookbooks_path}", :stream => true

        # sync cookbooks
        server.ui.info "Syncing cookbooks..."
        cookbooks_path.each do |path|
          server.upload_directory path, "#{target_cookbooks_path}/#{Digest::MD5.hexdigest(path)}"
        end

        # create roles directory
        server.ssh.sudo "mkdir -p #{target_roles_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{target_roles_path}", :stream => true

        # sync roles
        server.ui.info "Syncing roles..."
        roles_path.each do |path|
          server.upload_directory path, target_roles_path
        end

        # create data_bags directory
        server.ssh.sudo "mkdir -p #{target_data_bags_path}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{target_data_bags_path}", :stream => true

        # sync databags
        server.ui.info "Syncing data bags..."
        data_bags_path.each do |path|
          server.upload_directory path, target_data_bags_path
        end

        # create solo.rb
        server.ui.info "Generating solo.rb..."
        server.ssh.upload(StringIO.new(solo_content(server)), target_solo_path)

        # create json
        server.ui.info "Generating json config..."
        server.ssh.upload(StringIO.new(json_config(config_data.merge(server.data))), target_json_config_path)

        # set permissions on everything
        server.ssh.sudo "chown -R #{server.username} #{target_base_path}", :stream => true

        # run
        server.ui.info "Running chef-solo..."
        server.ssh.sudo command_string, :stream => true
      end

      def cleanup(server)
        server.ui.info "Cleaning up..."

        # installer
        server.ssh.sudo "rm -f #{target_install_path}", :stream => true

        # bootstrap scripts
        server.ssh.sudo "rm -f #{target_bootstrap_path}*", :stream => true

        # solo.rb
        server.ssh.sudo "rm -f #{target_solo_path}", :stream => true

        # json
        server.ssh.sudo "rm -f #{target_json_config_path}", :stream => true

        # for now, leave cookbooks, roles, and data bags for faster provisioning
      end

      def uninstall(server)
        server.ui.info "Uninstalling..."

        server.ssh.sudo "rm -rf #{target_base_path}", :stream => true
      end

      protected

      def with_bootstrap_scripts
        bootstrap_scripts.each_with_index do |script, index|
          yield script, index if block_given?
        end
      end

      def target_base_path
        "/tmp/cater-chef-solo"
      end

      def target_install_path
        "#{target_base_path}/install"
      end

      def target_bootstrap_path
        "#{target_base_path}/bootstrap"
      end

      def target_cookbooks_path
        "#{target_base_path}/cookbooks"
      end

      def target_roles_path
        "#{target_base_path}/roles"
      end

      def target_data_bags_path
        "#{target_base_path}/data_bags"
      end

      def target_solo_path
        "#{target_base_path}/solo.rb"
      end

      def target_json_config_path
        "#{target_base_path}/config.json"
      end

      def install_script
        File.expand_path("../../../templates/provisioner/chef_solo/bootstrap.sh", __FILE__)
      end

      def solo_content(server)
        Tilt.new(File.expand_path('../../../templates/provisioner/chef_solo/solo.erb', __FILE__)).render(self, {:server => server})
      end

      def json_config(data)
        MultiJson.dump(data)
      end

      def config_data
        {:run_list => run_list}.merge(json)
      end

      def final_cookbook_paths
        cookbooks_path.inject([]) do |res, path|
          # make sure they actually contain recipes, otherwise chef-solo will freak
          if Dir.entries(path).length > 2
            res << "#{target_cookbooks_path}/#{Digest::MD5.hexdigest(path)}"
          end
          res
        end
      end

      def command_string
        "chef-solo -c #{target_solo_path} -j #{target_json_config_path}"
      end

    end
  end
end