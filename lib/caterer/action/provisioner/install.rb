module Caterer
  module Action
    module Provisioner
      class Install < Base

        def call(env)
          provisioner(env).install
          @app.call(env)
        end
        
      end
    end
  end
end