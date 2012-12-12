module Caterer
  module Action
    module Provisioner
      class Bootstrap < Base
        
        def call(env)
          provisioner.bootstrap(env[:script])
          @app.call(env)
        end

      end
    end
  end
end