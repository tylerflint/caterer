module Caterer
  module Action
    module Server
      module Validate
        autoload :SSH,      'caterer/action/server/validate/ssh'
        autoload :Unlocked, 'caterer/action/server/validate/Unlocked'
      end
    end
  end
end