module Caterer
  module Config
    module Provisioner
      autoload :Base,     'caterer/config/provisioner/base'
      autoload :ChefSolo, 'caterer/config/provisioner/chef_solo'
    end
  end
end