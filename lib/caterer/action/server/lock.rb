module Caterer
  module Action
    module Server
      class Lock < Base
        
        def call(env)
          env[:server].lock!
          @app.call(env)
        end

      end
    end
  end
end