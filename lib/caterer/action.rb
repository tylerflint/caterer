module Caterer
  module Action
    autoload :Base,         'caterer/action/base'
    autoload :Berkshelf,    'caterer/action/berkshelf'
    autoload :Config,       'caterer/action/config'
    autoload :Environment,  'caterer/action/environment'
    autoload :Image,        'caterer/action/image'
    autoload :Runner,       'caterer/action/runner'
    autoload :Provisioner,  'caterer/action/provisioner'
    autoload :Server,       'caterer/action/server'
  end
end