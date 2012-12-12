module Caterer
  module Action
    module Provisioner
      class Provision < Base

        def call(env)
          @app.call(env)
        end
        
      end
    end
  end
end