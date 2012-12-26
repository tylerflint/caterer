module Caterer
  module Action
    module Provisioner
      module Validate
        autoload :Bootstrapped, 'caterer/action/provisioner/validate/bootstrapped'
        autoload :Engine,       'caterer/action/provisioner/validate/engine'
      end
    end
  end
end