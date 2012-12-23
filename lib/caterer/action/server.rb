module Caterer
  module Action
    module Server
      autoload :Lock,     'caterer/action/server/lock'
      autoload :Validate, 'caterer/action/server/validate'
      autoload :Unlock,   'caterer/action/server/unlock'
    end
  end
end