module Caterer
  module Action
    module Provisioner
      class Bootstrap < Base
        
        def call(env)
          env[:provisioner].bootstrap(env[:server])
          @app.call(env)
        end

      end
    end
  end
end