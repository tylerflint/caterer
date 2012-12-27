module Caterer
  module Action
    module Provisioner
      class Prepare < Base

        def call(env)
          env[:provisioner].prepare(env[:server])
          @app.call(env)
        end

      end     
    end
  end
end