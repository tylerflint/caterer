module Caterer
  module Action
    module Config
      module Validate
        autoload :Provisioner,  'caterer/action/config/validate/provisioner'
        autoload :Role,         'caterer/action/config/validate/role'
      end
    end
  end
end