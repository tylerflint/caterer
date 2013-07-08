require 'tilt'
require 'erubis'
require 'erb'
require 'oj'
require 'multi_json'

module Caterer
  module Provisioner
    class ChefSolo < Base
      
      include Util::Shell

      attr_reader   :run_list
      attr_accessor :json, :cookbooks_path, :roles_path
      attr_accessor :data_bags_path

      def initialize(image, opts={})
        @image          = image
        @run_list       = provisioner_config.run_list.dup
        @json           = provisioner_config.json.dup
        @cookbooks_path = provisioner_config.cookbooks_path.dup
        @roles_path     = provisioner_config.roles_path.dup
        @data_bags_path = provisioner_config.data_bags_path.dup
      end

      # config DSL

      def add_recipe(recipe)
        @run_list << "recipe[#{recipe}]"
      end

      def add_role(role)
        @run_list << "role[#{role}]"
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

      def install(server)
        server.ui.info "Preparing installation..."

        installer = install_script(server.platform)

        if not File.exists? installer
          server.ui.error "#{server.platform} doesn't have an install script"
          return
        end

        res = server.ssh.sudo bash(File.read(installer)), :stream => true

        # somewhere mark (on the server) that we installed chef-solo for later uninstall

        unless res == 0
          server.ui.error "install failed with exit code: #{res}"
        end
      end

      def installed?(server)
        res = server.ssh.sudo "command -v chef-solo &>/dev/null"
        res == 0 ? true : false
      end

      def prepare(server)
        # create lib dir
        server.ssh.sudo "mkdir -p #{dest_lib_dir}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{dest_lib_dir}", :stream => true

        # create var dir
        server.ssh.sudo "mkdir -p #{dest_var_dir}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{dest_var_dir}", :stream => true

        # create cache dir
        server.ssh.sudo "mkdir -p #{dest_cache_dir}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{dest_cache_dir}", :stream => true

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
        server.ssh.sudo "chown -R #{server.username} #{dest_lib_dir}", :stream => true
        server.ssh.sudo "chown -R #{server.username} #{dest_var_dir}", :stream => true

      end

      def provision_cmd
        "chef-solo -c #{target_solo_path} -j #{target_json_config_path}"
      end

      def uninstall(server)
        server.ui.info "Uninstalling..."

        # figure out how to uninstall chef_solo IF we installed it
      end

      protected

      def config
        @config ||= Caterer.config
      end

      def provisioner_config
        @provisioner_config ||= config.provisioner.chef_solo
      end

      def dest_lib_dir
        "#{image.lib_dir}/chef-solo"
      end

      def dest_var_dir
        "#{image.var_dir}/chef-solo"
      end

      def dest_cache_dir
        "#{dest_var_dir}/cache"
      end

      def target_install_path
        "#{dest_lib_dir}/install"
      end

      def target_bootstrap_path
        "#{dest_lib_dir}/bootstrap"
      end

      def target_cookbooks_path
        "#{dest_lib_dir}/cookbooks"
      end

      def target_roles_path
        "#{dest_lib_dir}/roles"
      end

      def target_data_bags_path
        "#{dest_lib_dir}/data_bags"
      end

      def target_solo_path
        "#{dest_lib_dir}/solo.rb"
      end

      def target_json_config_path
        "#{dest_lib_dir}/config.json"
      end

      def install_script(platform)
        File.expand_path("../../../templates/provisioner/chef_solo/install/#{platform}.sh", __FILE__)
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
          if File.exists?(path) and Dir.entries(path).length > 2
            res << "#{target_cookbooks_path}/#{Digest::MD5.hexdigest(path)}"
          end
          res
        end
      end

    end
  end
end