require 'etc'

module Caterer
  class Server
    
    attr_reader :env

    def initialize(env, opts=nil)
      @env    = env || Environment.new
      @user   = opts[:user]
      @pass   = opts[:pass]
      @host   = opts[:host]
      @port   = opts[:port]
    end

    def bootstrap(roles=[], script=nil)
      roles.each do |r|
        ui.info "bootstrapping role: #{r}"
        run_action(:bootstrap, {:role => r, :script => script})
      end
    end

    def provision(roles=[], opts=nil)
      run_action(:provision, opts)
    end

    def reboot(opts=nil)
      run_action(:reboot, opts)
    end

    def up(roles=[], opts=nil)
      run_action(:up, opts)
    end

    def ssh
      @ssh ||= Communication::SSH.new(self)
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
        :ui => ui,
        :config => env.config
      }.merge(options || {})

      env.action_runner.run(name, options)
    end

  end
end