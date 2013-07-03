module Caterer
  module Action
    module Provisioner
      class Cleanup < Base

        def call(env)
          env[:provisioner].uninstall(env[:server]) if env[:ghost_mode]
          @app.call(env)
        end
        
      end
    end
  end
end