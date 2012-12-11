module Caterer
  module Action
    module Server
      class Install
        
        def initialize(app, env)
          @app = app
          @env = env
        end

        def call(env)
          # env[:ui].info "hello from install"
          @app.call(env)
        end

      end
    end
  end
end