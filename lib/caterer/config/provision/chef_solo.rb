module Caterer
  module Config
    module Provision

      class ChefSolo
        
        attr_accessor :recipes, :json, :cookbooks_path, :bootstrap_script

        def initialize
          @recipes        = []
          @json           = {}
          @cookbooks_path = ['cookbooks']
        end

        def add_recipe(recipe)
          @recipes << recipe
        end

      end
    end
  end
end