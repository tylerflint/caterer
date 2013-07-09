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

          config = env[:config]
          image  = config.images[env[:image]]

          if image
            image.provisioners.each do |provisioner|
              if provisioner.is_a? Caterer::Provisioner::ChefSolo or env[:force_berks_clean]
                ::Berkshelf.formatter.msg "cleaning Caterer's shelf"
                FileUtils.remove_dir(shelf, fore: true)
              end
            end
          end

          @app.call(env)
        end

      end
    end
  end
end