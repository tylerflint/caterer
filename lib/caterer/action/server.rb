module Caterer
  module Action
    module Server
      autoload :Cleanup,  'caterer/action/server/cleanup'
      autoload :Lock,     'caterer/action/server/lock'
      autoload :Platform, 'caterer/action/server/platform'
      autoload :Prepare,  'caterer/action/server/prepare'
      autoload :Validate, 'caterer/action/server/validate'
      autoload :Unlock,   'caterer/action/server/unlock'
    end
  end
end