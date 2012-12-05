require 'vli'
require 'caterer/version'
require 'caterer/logger'

module Caterer
  autoload :Cli,          'caterer/cli'
  autoload :Command,      'caterer/command'
  autoload :Config,       'caterer/config'
  autoload :Environment,  'caterer/environment'
  
  extend self

  def commands
    @commands ||= Vli::Registry.new
  end

  def config
    @config ||= Config::Base.new
  end

  def configure
    yield config if block_given?
  end

end

# commands
Caterer.commands.register(:test)      { Caterer::Command::Test }
Caterer.commands.register(:bootstrap) { Caterer::Command::Bootstrap }
Caterer.commands.register(:provision) { Caterer::Command::Provision }
Caterer.commands.register(:up)        { Caterer::Command::Up }
Caterer.commands.register(:reboot)    { Caterer::Command::Reboot }

# actions
