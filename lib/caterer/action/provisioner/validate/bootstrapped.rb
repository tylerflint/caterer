module Caterer
  module Action
    module Provisioner
      module Validate
        class Bootstrapped < Base

          def call(env)

            if not env[:provisioner].bootstrapped?(env[:server])
              env[:ui].error "Server not bootstrapped, cannot continue"
              return
            end

            @app.call(env)

          end
          
        end
      end
    end
  end
end