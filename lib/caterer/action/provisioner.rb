module Caterer
  module Action
    module Provisioner
      autoload :Cleanup,    'caterer/action/provisioner/cleanup'
      autoload :Prepare,    'caterer/action/provisioner/prepare'
      autoload :Uninstall,  'caterer/action/provisioner/uninstall'
    end
  end
end