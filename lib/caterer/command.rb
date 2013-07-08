module Caterer
  module Command
    autoload :Base,       'caterer/command/base'
    autoload :Clean,      'caterer/command/clean'
    autoload :Berks,      'caterer/command/berks'
    autoload :Lock,       'caterer/command/lock'
    autoload :Provision,  'caterer/command/provision'
    autoload :Server,     'caterer/command/server'
    autoload :Unlock,     'caterer/command/unlock'
  end
end