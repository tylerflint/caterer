module Caterer
  module Action
    module Provisioner
      class Prepare < Base

        def call(env)
          provisioner(env).prepare
          @app.call(env)
        end

      end     
    end
  end
end