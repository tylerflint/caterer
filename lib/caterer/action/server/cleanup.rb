module Caterer
  module Action
    module Server
      class Cleanup < Base
        
        def call(env)
          env[:server].cleanup if env[:ghost_mode]
          @app.call(env)
        end

      end
    end
  end
end