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

    def provision(opts=nil)
      run_action(:provision, opts)
    end

    def reboot(opts=nil)
      run_action(:reboot, opts)
    end

    def up(opts=nil)
      run_action(:up, opts)
    end

    def channel
      @channel ||= Communication::SSH.new(self)
    end

    def ssh_opts
      {
        :host => host,
        :port => port,
        :username => username,
        :password => password,
        :max_tries => 10
      }
    end

    def ui
      @ui ||= begin
        ui = @env.ui.dup
        # ui.resource = @name
        ui
      end
    end

    def username
      
    end

    def password
      
    end

    def host
      
    end

    def port
      
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