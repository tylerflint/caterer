module Caterer
  module Action
    module Server
      class Prepare < Base
        
        def call(env)
          env[:server].prepare
          @app.call(env)
        end

      end
    end
  end
end