module Caterer
  module Action
    module Server
      class Platform < Base
        
        def call(env)
          platform = env[:server].detect_platform
          @app.call(env) if platform
        end

      end
    end
  end
end