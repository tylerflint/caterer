module Caterer
  module Action
    module Provisioner
      class Provision < Base

        def call(env)
          env[:provisioner].provision(env[:server])
          @app.call(env)
        end
        
      end
    end
  end
end