module Caterer
  module Action
    module Provisioner
      class Cleanup < Base

        def call(env)
          provisioner.cleanup
          @app.call(env)
        end
        
      end
    end
  end
end