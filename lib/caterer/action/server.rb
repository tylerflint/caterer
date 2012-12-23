module Caterer
  module Action
    module Server
      autoload :Lock,     'caterer/action/server/lock'
      autoload :Reboot,   'caterer/action/server/reboot'
      autoload :Validate, 'caterer/action/server/validate'
      autoload :Unlock,   'caterer/action/server/unlock'
    end
  end
end