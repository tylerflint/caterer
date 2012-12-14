module Caterer
  module Action
    module Server
      module Validate
        class SSH < Base
          
          def call(env)
            ready = env[:server].ssh.ready?

            if not ready
              env[:ui].error "unable to ssh into #{env[:server].host}"
              return
            end

            @app.call(env)
          end

        end
      end
    end
  end
end