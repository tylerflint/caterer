module Caterer
  module Action
    module Provisioner
      class Cleanup < Base

        def call(env)
          @app.call(env)
        end
        
      end
    end
  end
end