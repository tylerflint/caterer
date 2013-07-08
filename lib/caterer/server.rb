require 'etc'
require 'digest'

module Caterer
  class Server

    include Util::Shell
    
    attr_reader :env

    def initialize(env, opts=nil)
      @env    = env || Environment.new
      @alias  = opts[:alias]
      @user   = opts[:user]
      @pass   = opts[:pass]
      @host   = opts[:host]
      @port   = opts[:port]
      @key    = opts[:key]
      @images = opts[:images] || []

      @logger = Log4r::Logger.new("caterer::server")

      @logger.info("Server: #{opts.inspect}")
    end

    def provision(opts={})
      if @images.length > 0
        @images.each do |i|
          ui.info "*** Provisioning image: #{i} ***"
          run_action(:provision, opts.merge({:image => i}))
        end
      else
        ui.error "*** No image to provision ***"
      end
    end

    def lock(opts={})
      ui.info "*** Locking ***"
      run_action(:lock, opts)
    end

    def unlock(opts={})
      ui.info "*** Unlocking ***"
      run_action(:unlock, opts)
    end

    def clean(opts={})
      ui.info "*** Cleaning ***"
      run_action(:clean, opts)
    end

    def lock!
      ui.info "Locking..."
      ssh.sudo "touch #{lock_path}"
    end

    def unlock!
      ui.info "Unlocking..."
      ssh.sudo "rm -f #{lock_path}"
    end

    def locked?
      res = ssh.sudo "[ -f #{lock_path} ]"
      res == 0 ? true : false
    end

    def prepare!
      ui.info "Preparing server..."
      ssh.sudo "mkdir -p #{config.dest_dir}", :stream => true
      ssh.sudo "mkdir -p #{config.dest_dir}/lib", :stream => true
      ssh.sudo "mkdir -p #{config.dest_dir}/bin", :stream => true
      ssh.sudo "chown -R #{username} #{config.dest_dir}", :stream => true
    end

    def cleanup!
      ui.info "Cleaning up server..."
      ssh.sudo "rm -rf #{config.dest_dir}"
    end

    def config
      @config ||= Caterer.config
    end

    def ssh
      @ssh ||= Communication::SSH.new(self)
    end

    def rsync
      @rsync ||= Communication::Rsync.new(self)
    end

    def can_rsync?
      !Vli::Util::Platform.windows? and Communication::Rsync.available?
    end

    def ssh_opts
      {}.tap do |opts|
        opts[:paranoid]      = false
        opts[:port]          = port
        opts[:password]      = password if password
        opts[:keys]          = keys if keys.length > 0
        opts[:forward_agent] = true
      end
    end

    def ui
      @ui ||= begin
        ui = @env.ui.dup
        ui.resource = name
        ui
      end
    end

    def name
      @alias || host
    end

    def username
      @user || Etc.getlogin
    end

    def password
      @pass
    end

    def host
      @host
    end

    def port
      @port || 22
    end

    def key
      @key
    end

    def keys
      @keys ||= [].tap {|keys| keys << key if key }
    end

    def run_action(name, options=nil)
      options = {
        :server => self,
        :ui => ui,
        :config => env.config
      }.merge(options || {})

      env.action_runner.run(name, options)
    end

    def detect_platform
      @platform ||= begin
        ui.info "Detecting platform..."
        out = ""
        res = ssh.sudo bash(File.read(platform_script)) do |_stream, data|
          out += data
        end
        if res == 0
          out.strip # success
        else
          ui.error "Unknown platform"
          false
        end
      end
    end
    alias :platform :detect_platform

    def platform_script
      File.expand_path("../../templates/server/platform.sh", __FILE__)
    end

    def upload_directory(from, to)
      if File.exists? from
        if can_rsync?
          from += "/" if not from.match /\/$/
          res = rsync.sync(from, to)
          ui.error "rsync was unsuccessful" if res != 0
        else
          # yuck. Heaven help the poor soul who hath not rsync...
          ui.warn "Rsync unavailable, falling back to scp (slower)..."
          unique = ::Digest::MD5.hexdigest(from)
          ssh.sudo "rm -rf #{to}/*", :stream => true
          ssh.sudo "mkdir -p #{to}/#{unique}", :stream => true
          ssh.sudo "chown -R #{username} #{to}/#{unique}", :stream => true
          ssh.upload from, "#{to}/#{unique}"
          ssh.sudo "mv #{to}/#{unique}/**/* #{to}/", :stream => true
          ssh.sudo "rm -rf #{to}/#{unique}", :stream => true
        end
      end
    end

    protected

    def lock_path
      "/tmp/cater.lock"
    end

  end
end