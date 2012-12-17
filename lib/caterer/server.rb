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
      @images = opts[:images] || []
    end

    def bootstrap(opts={})
      @images.each do |i|
        ui.info "*** Bootstrapping image: #{i} ***"
        run_action(:bootstrap, opts.merge({:image => i}))
      end
    end

    def provision(opts={})
      @images.each do |i|
        ui.info "*** Provisioning image: #{i} ***"
        run_action(:provision, opts.merge({:image => i}))
      end
    end

    def reboot(opts={})
      run_action(:reboot, opts)
    end

    def up(opts={})
      @images.each do |i|
        ui.info "*** Up'ing image: #{i} ***"
        run_action(:up, opts.merge({:image => i}))
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