module Caterer
  module Action
    module Provisioner
      class Uninstall < Base

        def call(env)
          env[:provisioner].uninstall(env[:server])
          @app.call(env)
        end
        
      end
    end
  end
end