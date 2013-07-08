module Caterer
  module Action
    module Image
      class Prepare < Base

        def call(env)

          config = env[:config]
          server = env[:server]
          image  = config.images[env[:image]]

          image.prepare(server)

          @app.call(env)
        end
        
      end
    end
  end
end