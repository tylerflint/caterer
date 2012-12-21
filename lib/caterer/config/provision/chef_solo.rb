module Caterer
  module Config
    module Provision

      class ChefSolo
        
        attr_reader :name, :run_list
        attr_accessor :json, :cookbooks_path, :roles_path, :data_bags_path, :bootstrap_scripts

        def initialize(name)
          @name              = name
          @run_list          = []
          @json              = {}
          @cookbooks_path    = ['cookbooks']
          @roles_path        = ['roles']
          @data_bags_path    = ['data_bags']
          @bootstrap_scripts = []
        end

        def add_recipe(recipe)
          @run_list << "recipe[#{recipe}]"
        end

        def add_role(role)
          @run_list << "role[#{role}]"
        end

        def add_image(image)
          image = Caterer.config.images[image]
          raise "Unknown image :#{image}" if not image

          provisioner = image.provisioner
          raise "No provisioner for :#{image}" if not provisioner

          if not provisioner.name == :chef_solo
            raise "Incompatible provisioner. Must be :#{provisioner.name}"
          end

          @run_list += provisioner.run_list
          @bootstrap_scripts += provisioner.bootstrap_scripts
        end

        def add_bootstrap(script)
          @bootstrap_scripts << script
        end

        def errors
          errors = {}

          if not @run_list.length > 0
            errors[:run_list] = "is empty"
          end

          if not @cookbooks_path.is_a? Array
            errors[:cookbooks_path] = "must be an array"
          end

          if not @roles_path.is_a? Array
            errors[:roles_path] = "must be an array"
          end

          if not @data_bags_path.is_a? Array
            errors[:data_bags_path] = "must be an array"
          end

          if errors.length > 0
            errors
          end
        end

      end
    end
  end
end