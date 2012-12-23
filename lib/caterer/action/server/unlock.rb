module Caterer
  module Action
    module Server
      class Unlock < Base
        
        def call(env)
          env[:server].unlock!
          @app.call(env)
        end

      end
    end
  end
end