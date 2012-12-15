module Caterer
  module Action
    module Config
      module Validate
        class Image < Base

          def call(env)
            # check to ensure the image exists
            image = env[:config].images[env[:image]]

            if not image
              env[:ui].error "image ':#{env[:image]}' is not defined"
              return
            end

            @app.call(env)
          end

        end
      end
    end
  end
end