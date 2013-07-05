module Caterer
  module Command
    autoload :Base,       'caterer/command/base'
    autoload :Clean,      'caterer/command/clean'
    autoload :Berks,      'caterer/command/berks'
    autoload :Lock,       'caterer/command/lock'
    autoload :Provision,  'caterer/command/provision'
    autoload :Reboot,     'caterer/command/reboot'
    autoload :Server,     'caterer/command/server'
    autoload :Test,       'caterer/command/test'
    autoload :Unlock,     'caterer/command/unlock'
  end
end