module Caterer
  module Config
    module Provision

      class ChefSolo
        
        attr_reader :name, :run_list
        attr_accessor :json, :cookbooks_path, :roles_path, :data_bags_path, :bootstrap_script

        def initialize(name)
          @name           = name
          @run_list       = []
          @json           = {}
          @cookbooks_path = ['cookbooks']
          @roles_path     = ['roles']
          @data_bags_path = ['data_bags']
        end

        def add_recipe(recipe)
          @run_list << "recipe[#{recipe}]"
        end

        def add_role(role)
          @run_list << "role[#{role}]"
        end

        def errors
          errors = {}

          if not @run_list.length > 0
            errors[:run_list] = "is empty"
          end

          if errors.length > 0
            errors
          end
        end

      end
    end
  end
end