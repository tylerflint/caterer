module Caterer
  module Action
    module Provisioner
      class Cleanup < Base

        def call(env)
          provisioner(env).cleanup
          @app.call(env)
        end
        
      end
    end
  end
end