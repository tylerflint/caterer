require 'etc'

module Caterer
  class Server
    
    attr_reader :env
    attr_reader :config

    def initialize(env, config, opts=nil)
      @env    = env
      @config = config
      @user   = opts[:user]
      @pass   = opts[:pass]
      @host   = opts[:host]
      @port   = opts[:port]
    end

    def bootstrap(opts=nil)
      run_action(:bootstrap, opts)
    end

    def bootstrap!(script=nil)
      if script
        if File.exists? script
          # upload
          ui.info "uploading bootstrap"
          ssh.upload script, "/tmp"
          # set permissions
          ui.info "applying permissions"
          ssh.sudo "chown root:root /tmp/bootstrap.sh"
          ssh.sudo "chmod 777 /tmp/bootstrap.sh"
          # run
          ui.info "running bootstrap"
          ssh.sudo "/tmp/bootstrap.sh" do |type, data|
            if type == :stderr
              ui.error data.chomp
            else
              ui.success data.chomp
            end
          end
        else
          ui.error "script does not exist!"
        end
      end
    end

    def provision(opts=nil)
      run_action(:provision, opts)
    end

    def reboot(opts=nil)
      run_action(:reboot, opts)
    end

    def up(opts=nil)
      run_action(:up, opts)
    end

    def ssh
      @ssh ||= Communication::SSH.new(self)
    end

    def rsync
      @rsync ||= Communication::Rsync.new(self)
    end

    def ssh_opts
      {
        :port => port,
        :password => password
      }
    end

    def ui
      @ui ||= begin
        ui = @env.ui.dup
        ui.resource = host
        ui
      end
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

    def run_action(name, options=nil)
      options = {
        :server => self,
        :ui => ui
      }.merge(options || {})

      env.action_runner.run(name, options)
    end

  end
end