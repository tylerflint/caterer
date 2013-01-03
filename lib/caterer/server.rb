require 'etc'

module Caterer
  class Server
    
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
      @data   = opts[:data] || {}
      @engine = opts[:engine]

      @logger = Log4r::Logger.new("caterer::server")

      @logger.info("Server: #{opts.inspect}")
    end

    def bootstrap(opts={})
      if @images.length > 0
        @images.each do |i|
          ui.info "*** Bootstrapping image: #{i} ***"
          run_action(:bootstrap, opts.merge({:image => i}))
        end        
      else
        ui.info "*** Bootstrapping ***"
        run_action(:bootstrap, opts.merge({:engine => @engine}))
      end
    end

    def provision(opts={})
      if @images.length > 0
        @images.each do |i|
          ui.info "*** Provisioning image: #{i} ***"
          run_action(:provision, opts.merge({:image => i}))
        end
      else
        ui.info "*** Provisioning ***"
        run_action(:provision, opts.merge({:engine => @engine}))
      end
    end

    def up(opts={})
      if @images.length > 0
        @images.each do |i|
          ui.info "*** Up'ing image: #{i} ***"
          run_action(:up, opts.merge({:image => i}))
        end        
      else
        ui.info "*** Up'ing ***"
        run_action(:up, opts.merge({:engine => @engine}))
      end
    end

    def reboot(opts={})
      run_action(:reboot, opts)
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

    def reboot!
      ui.info "Rebooting..."
      ssh.sudo "shutdown -r now", :stream => true
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
        opts[:paranoid] = false
        opts[:port]     = port
        opts[:password] = password if password
        opts[:keys]     = [].tap {|keys| keys << key if key }
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

    def data
      @data_hash ||= begin
        (@data.is_a? Hash) ? @data : {}
      end
    end

    def run_action(name, options=nil)
      options = {
        :server => self,
        :ui => ui,
        :config => env.config
      }.merge(options || {})

      env.action_runner.run(name, options)
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
          unique = Digest::MD5.hexdigest(from)
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