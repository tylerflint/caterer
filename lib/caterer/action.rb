module Caterer
  module Action
    autoload :Base,         'caterer/action/base'
    autoload :Config,       'caterer/action/config'
    autoload :Runner,       'caterer/action/runner'
    autoload :Provisioner,  'caterer/action/provisioner'
    autoload :Server,       'caterer/action/server'
  end
end