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

    def bootstrap(roles=[], script=nil, opts={})
      roles.each do |r|
        ui.info "Bootstrapping role: #{r}"
        run_action(:bootstrap, opts.merge({:role => r, :script => script}))
      end
    end

    def provision(roles=[], opts={})
      roles.each do |r|
        ui.info "Provisioning role: #{r}"
        run_action(:provision, opts.merge({:role => r}))
      end
    end

    def reboot(opts=nil)
      run_action(:reboot, opts)
    end

    def up(roles=[], script=nil, opts={})
      roles.each do |r|
        ui.info "Up'ing role: #{r}"
        run_action(:up, opts.merge({:role => r, :script => script}))
      end
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