module Caterer
  module Config
    module Provisioner
      class ChefSolo
        attr_accessor :run_list, :json, :cookbooks_path, :roles_path, :data_bags_path, :bootstrap_scripts

        def initialize
          @run_list          = []
          @json              = {}
          @cookbooks_path    = ['cookbooks']
          @roles_path        = ['roles']
          @data_bags_path    = ['data_bags']
          @bootstrap_scripts = []
        end
      end
    end
  end
end