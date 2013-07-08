module Caterer
  module Action
    module Image
      class Run < Base

        def call(env)

          config = env[:config]
          server = env[:server]
          image  = config.images[env[:image]]

          image.run(server) if not env[:dry_run]

          @app.call(env)
        end
        
      end
    end
  end
end