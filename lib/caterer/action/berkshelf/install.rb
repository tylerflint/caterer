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
            install(env)
          end

          @app.call(env)
        end

        protected

        def install(env)
          ::Berkshelf.formatter.msg "installing cookbooks..."
          opts = {
            path: shelf
          }.merge(env[:config].berkshelf.to_hash).symbolize_keys!
          berksfile.install(opts)
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