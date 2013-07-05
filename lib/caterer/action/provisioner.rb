module Caterer
  module Action
    module Provisioner
      autoload :Run,        'caterer/action/provisioner/run'
      autoload :Uninstall,  'caterer/action/provisioner/uninstall'
    end
  end
end