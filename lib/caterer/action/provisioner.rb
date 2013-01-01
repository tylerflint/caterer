module Caterer
  module Action
    module Provisioner
      autoload :Bootstrap,  'caterer/action/provisioner/bootstrap'
      autoload :Cleanup,    'caterer/action/provisioner/cleanup'
      autoload :Install,    'caterer/action/provisioner/install'
      autoload :Load,       'caterer/action/provisioner/load'
      autoload :Lock,       'caterer/action/provisioner/lock'
      autoload :Prepare,    'caterer/action/provisioner/prepare'
      autoload :Provision,  'caterer/action/provisioner/provision'
      autoload :Uninstall,  'caterer/action/provisioner/uninstall'
      autoload :Unlock,     'caterer/action/provisioner/unlock'
      autoload :Validate,   'caterer/action/provisioner/validate'
    end
  end
end