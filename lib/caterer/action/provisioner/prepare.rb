module Caterer
  module Action
    module Provisioner
      class Prepare < Base

        def call(env)
          env[:ui].info "prepare!"
          @app.call(env)
        end

      end     
    end
  end
end