require 'vli'
require 'caterer/version'
require 'caterer/logger'

module Caterer
  autoload :Action,         'caterer/action'
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
Caterer.actions.register(:bootstrap) do
  Vli::Action::Builder.new do
    use Caterer::Action::Provisioner::Prepare
    use Caterer::Action::Provisioner::Bootstrap
  end
end