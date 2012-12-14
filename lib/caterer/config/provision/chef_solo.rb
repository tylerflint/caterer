module Caterer
  module Config
    module Provision

      class ChefSolo
        
        attr_reader :name
        attr_accessor :recipes, :json, :cookbooks_path, :bootstrap_script

        def initialize(name)
          @name           = name
          @recipes        = []
          @json           = {}
          @cookbooks_path = ['cookbooks']
        end

        def add_recipe(recipe)
          @recipes << recipe
        end

        def errors
          errors = {}

          if not @recipes.length > 0
            errors[:recipes] = "list is empty"
          end

          if errors.length > 0
            errors
          end
        end

      end
    end
  end
end