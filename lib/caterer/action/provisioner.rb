module Caterer
  module Action
    module Provisioner
      autoload :Base,       'caterer/action/provisioner/base'
      autoload :Bootstrap,  'caterer/action/provisioner/bootstrap'
      autoload :Cleanup,    'caterer/action/provisioner/cleanup'
      autoload :Prepare,    'caterer/action/provisioner/prepare'
      autoload :Provision,  'caterer/action/provisioner/provision'
    end
  end
end