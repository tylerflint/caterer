module Caterer
  module Action
    module Berkshelf
      class Install < Base
        
        attr_reader :shelf
        attr_reader :berksfile

        def initialize(app, env)
          super

          @shelf     = Caterer::Berkshelf.shelf_for(env)
          @berksfile = ::Berkshelf::Berksfile.from_file(env[:config].berkshelf.berksfile_path)
        end


        def call(env)

          if env[:provisioner].is_a? Caterer::Provisioner::ChefSolo
            configure_cookbooks_path(env[:provisioner])
            if needs_update?(env)
              ::Berkshelf.formatter.msg "installing cookbooks..."
              install(env)
            else
              ::Berkshelf.formatter.msg "shelf up-to-date..."
            end
          end

          @app.call(env)
        end

        protected

        def needs_update?(env)
          true
        end

        def install(env)
          berksfile.install({path: shelf}.merge(env[:config].berkshelf.to_hash).symbolize_keys!)
        end

        def configure_cookbooks_path(provisioner)

          # if for some reason the cookbooks path is a string, convert it into an array
          if not provisioner.cookbooks_path.is_a? Array
            provisioner.cookbooks_path = Array(provisioner.cookbooks_path)
          end

          provisioner.cookbooks_path.unshift(shelf)
        end

      end
    end
  end
end