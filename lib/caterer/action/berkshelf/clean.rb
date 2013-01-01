module Caterer
  module Action
    module Berkshelf
      class Clean < Base
        
        attr_reader :shelf

        def initialize(app, env)
          super
          @shelf = Caterer::Berkshelf.shelf_for(env)
        end

        def call(env)

          if env[:provisioner].is_a? Caterer::Provisioner::ChefSolo
            ::Berkshelf.formatter.msg "cleaning Caterer's shelf"
            FileUtils.remove_dir(shelf, fore: true)
          end

          @app.call(env)
        end

      end
    end
  end
end