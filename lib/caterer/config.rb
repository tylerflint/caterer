module Caterer
  module Config
    autoload :Base,       'caterer/config/base'
    autoload :Cluster,    'caterer/config/cluster'
    autoload :Group,      'caterer/config/group'
    autoload :Member,     'caterer/config/member'
    autoload :Node,       'caterer/config/node'
    autoload :Role,       'caterer/config/role'
    autoload :Provision,  'caterer/config/provision'
  end
end