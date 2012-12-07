require 'pathname'

module Caterer
  class Environment
    
    attr_reader :cwd, :caterfile_name, :ui

    def initialize(opts={})
      opts = {
        :cwd => nil,
        :caterfile_name => nil,
        :ui_class => nil
      }.merge(opts)

      opts[:cwd] ||= ENV["CATERER_CWD"] if ENV.has_key?("CATERER_CWD")
      opts[:cwd] ||= Dir.pwd
      opts[:cwd]  = Pathname.new(opts[:cwd])

      opts[:caterfile_name] ||= []
      opts[:caterfile_name] = [opts[:caterfile_name]] if !opts[:vagrantfile_name].is_a?(Array)
      opts[:caterfile_name] += ["Caterfile"]

      @cwd            = opts[:cwd]
      @caterfile_name = opts[:caterfile_name]

      ui_class = opts[:ui_class] || Vli::UI::Silent
      @ui      = ui_class.new("cater")

    end

    def action_runner
      @action_runner ||= Vli::Action::Runner.new(action_registry) do
        {
          :action_runner  => action_runner,
          :ui             => @ui
        }
      end
    end

    def action_registry
      Caterer.actions
    end

    def load!
      load_default_config
      load_custom_config
    end

    def load_default_config
      # doesn't work yet
      # require 'config/default'
    end

    def load_custom_config
      @caterfile_name.each do |config_file|
        file = "#{@cwd}/#{config_file}"
        load file if File.exists? file
      end
    end

    def cli(*args)
      Cli.new(args.flatten, self).execute
    end

  end
end