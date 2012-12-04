require 'caterer/version'
require 'caterer/logger'

module Caterer
  autoload :Cli,          'caterer/cli'
  autoload :Command,      'caterer/command'
  autoload :Config,       'caterer/config'
  autoload :Environment,  'caterer/environment'
  autoload :Registry,     'caterer/registry'
  
  extend self

  def commands
    @commands ||= Registry.new
  end

  def config
    @config ||= Config::Base.new
  end

  def configure
    yield config if block_given?
  end

end

require 'caterer/commands'