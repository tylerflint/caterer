require 'pathname'
require 'digest'

module Caterer
  class Environment
    
    attr_reader :cwd, :caterfile_name, :ui

    def initialize(opts={})
      opts = {
        :cwd => nil,
        :caterfile_name => nil,
        :ui_class => nil,
        :custom_config => nil
      }.merge(opts)

      opts[:cwd] ||= ENV["CATERER_CWD"] if ENV.has_key?("CATERER_CWD")
      opts[:cwd] ||= Dir.pwd

      opts[:caterfile_name] ||= []
      opts[:caterfile_name] = [opts[:caterfile_name]] if !opts[:caterfile_name].is_a?(Array)
      opts[:caterfile_name] += ["Caterfile"]

      @cwd            = Pathname.new(opts[:cwd])
      @caterfile_name = opts[:caterfile_name]
      @custom_config  = opts[:custom_config]

      ui_class = opts[:ui_class] || Vli::UI::Silent
      @ui      = ui_class.new("cater")

    end

    def action_runner
      @action_runner ||= Vli::Action::Runner.new(action_registry) do
        {
          :action_runner  => action_runner,
          :ui             => @ui,
          :uuid           => uuid
        }
      end
    end

    def uuid
      @uuid ||= ::Digest::MD5.hexdigest(@cwd.to_s)
    end

    def action_registry
      Caterer.actions
    end

    def config
      @config ||= begin
        load_default_config
        load_custom_config
        Caterer.config
      end
    end
    alias :load! :config

    def load_default_config
      require_relative '../../config/default'
    end

    def load_custom_config
      if @custom_config
        # if it's been explicitly defined, load it
        load_config_file @custom_config
      else
        # lets try a few variations
        @caterfile_name.each do |config_file|
          load_config_file "#{@cwd}/#{config_file}"
        end
      end
    end

    def load_config_file(file)
      load file if File.exists? file
    end

    def cli(*args)
      Cli.new(args.flatten, self).execute
    end

  end
end