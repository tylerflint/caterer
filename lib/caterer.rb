require 'vli'
require 'caterer/version'
require 'caterer/logger'

module Caterer
  autoload :Action,         'caterer/action'
  autoload :Berkshelf,      'caterer/berkshelf'
  autoload :Cli,            'caterer/cli'
  autoload :Command,        'caterer/command'
  autoload :Communication,  'caterer/communication'
  autoload :Config,         'caterer/config'
  autoload :Environment,    'caterer/environment'
  autoload :Provisioner,    'caterer/provisioner'
  autoload :Server,         'caterer/server'
  autoload :Util,           'caterer/util'
  
  extend self

  def actions
    @actions ||= Vli::Registry.new
  end

  def commands
    @commands ||= Vli::Registry.new
  end

  def provisioners
    @provisioners ||= Vli::Registry.new
  end

  def config_keys
    @config_keys  ||= Vli::Registry.new
  end

  def config
    @config ||= Config::Base.new
  end

  def configure
    yield config if block_given?
  end

end

require 'caterer/commands'
require 'caterer/actions'
require 'caterer/provisioners'