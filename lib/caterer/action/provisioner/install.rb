module Caterer
  module Action
    module Provisioner
      class Install < Base

        def call(env)
          env[:provisioner].install(env[:server]) if not env[:provisioner].installed?(env[:server])
          @app.call(env)
        end
        
      end
    end
  end
end