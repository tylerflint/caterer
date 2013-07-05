module Caterer
  module Config
    autoload :Base,         'caterer/config/base'
    autoload :Berkshelf,    'caterer/config/berkshelf'
    autoload :Provisioner,  'caterer/config/provisioner'
  end
end