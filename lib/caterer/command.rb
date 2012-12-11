module Caterer
  module Command
    autoload :Base,       'caterer/command/base'
    autoload :Bootstrap,  'caterer/command/bootstrap'
    autoload :Provision,  'caterer/command/provision'
    autoload :Reboot,     'caterer/command/reboot'
    autoload :Test,       'caterer/command/test'
    autoload :Up,         'caterer/command/up'
  end
end