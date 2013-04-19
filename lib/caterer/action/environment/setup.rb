module Caterer
  module Action
    module Environment
      class Setup < Base
        
        def call(env)
          @app.call(env)
        end

      end
    end
  end
end