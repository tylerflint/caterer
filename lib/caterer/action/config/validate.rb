module Caterer
  module Action
    module Config
      module Validate
        autoload :Provisioner,  'caterer/action/config/validate/provisioner'
        autoload :Image,        'caterer/action/config/validate/image'
      end
    end
  end
end