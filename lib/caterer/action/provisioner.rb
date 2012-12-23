module Caterer
  module Action
    module Provisioner
      autoload :Base,       'caterer/action/provisioner/base'
      autoload :Bootstrap,  'caterer/action/provisioner/bootstrap'
      autoload :Cleanup,    'caterer/action/provisioner/cleanup'
      autoload :Install,    'caterer/action/provisioner/install'
      autoload :Lock,       'caterer/action/provisioner/lock'
      autoload :Prepare,    'caterer/action/provisioner/prepare'
      autoload :Provision,  'caterer/action/provisioner/provision'
      autoload :Unlock,     'caterer/action/provisioner/unlock'
    end
  end
end