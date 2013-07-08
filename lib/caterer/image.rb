require 'tilt'

module Caterer
  class Image
  
    attr_reader :name, :provisioners

    def initialize(name)
      @name         = name
      @provisioners = []
    end

    def provision(type, opts={})
      provisioner_klass = Caterer.provisioners.get(type)
      raise ":#{type} is not a valid provisioner" if not provisioner_klass
      provisioner = provisioner_klass.new(self, opts)
      yield provisioner if block_given?
      @provisioners << provisioner
      provisioner
    end

    # actions

    def prepare(server)
      # create bin dir
      server.ssh.sudo "mkdir -p #{bin_dir}", :stream => true
      server.ssh.sudo "chown -R #{server.username} #{bin_dir}", :stream => true

      # create lib dir
      server.ssh.sudo "mkdir -p #{lib_dir}", :stream => true
      server.ssh.sudo "chown -R #{server.username} #{lib_dir}", :stream => true

      # create var dir
      server.ssh.sudo "mkdir -p #{var_dir}", :stream => true
      server.ssh.sudo "chown -R #{server.username} #{var_dir}", :stream => true

      # create bin wrapper
      server.ui.info "Generating bin wrapper..."
      server.ssh.upload(StringIO.new(bin_wrapper_content), bin_wrapper_path)
      server.ssh.sudo "chmod +x #{bin_wrapper_path}", :stream => true
    end

    def run(server)
      # run
      server.ui.info "Running #{name}..."
      res = server.ssh.sudo bin_wrapper_path, :stream => true
      unless res == 0
        server.ui.error "#{name} failed with exit code: #{res}"
      end
    end

    def cleanup(server)
      server.ui.info "Cleaning #{name}..."
      server.ssh.sudo "rm -rf #{var_dir}"
      server.ssh.sudo "rm -rf #{lib_dir}"
      server.ssh.sudo "rm -f #{bin_wrapper_path}"
    end

    # helpers

    def bin_dir
      "#{config.dest_dir}/bin"
    end

    def lib_dir
      "#{config.dest_dir}/lib/#{name}"
    end

    def var_dir
      "#{config.dest_dir}/var/#{name}"
    end

    def bin_wrapper_path
      "#{bin_dir}/cater-#{name}"
    end

    protected

    def config
      @config ||= Caterer.config
    end

    def bin_wrapper_content
      Tilt.new(File.expand_path('../../templates/image/bin_wrapper.erb', __FILE__)).render(self)
    end

  end
end