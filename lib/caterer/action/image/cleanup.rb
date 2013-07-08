module Caterer
  module Action
    module Image
      class Cleanup < Base

        def call(env)

          config = env[:config]
          server = env[:server]
          image  = config.images[env[:image]]

          image.cleanup(server) if env[:ghost_mode]

          @app.call(env)
        end
        
      end
    end
  end
end