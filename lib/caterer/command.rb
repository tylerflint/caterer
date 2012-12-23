module Caterer
  module Command
    autoload :Base,       'caterer/command/base'
    autoload :Bootstrap,  'caterer/command/bootstrap'
    autoload :Lock,       'caterer/command/lock'
    autoload :Provision,  'caterer/command/provision'
    autoload :Reboot,     'caterer/command/reboot'
    autoload :Test,       'caterer/command/test'
    autoload :Unlock,     'caterer/command/unlock'
    autoload :Up,         'caterer/command/up'
  end
end