module Caterer
  module Config
    autoload :Base,         'caterer/config/base'
    autoload :Berkshelf,    'caterer/config/berkshelf'
    autoload :Cluster,      'caterer/config/cluster'
    autoload :Group,        'caterer/config/group'
    autoload :Member,       'caterer/config/member'
    autoload :Node,         'caterer/config/node'
    autoload :Image,        'caterer/config/image'
    autoload :Provisioner,  'caterer/config/provisioner'
  end
end