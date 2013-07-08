module Caterer
  module Provisioner
    autoload :Base,     'caterer/provisioner/base'
    autoload :ChefSolo, 'caterer/provisioner/chef_solo'
    autoload :Shell,    'caterer/provisioner/shell'
  end
end