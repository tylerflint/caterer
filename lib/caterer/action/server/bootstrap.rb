module Caterer
  module Action
    module Server
      class Bootstrap
        
        def initialize(app, env)
          @app = app
          @env = env
        end

        def call(env)
          env[:server].bootstrap!(env[:script])
          @app.call(env)
        end

      end
    end
  end
end