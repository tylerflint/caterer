module Caterer
  module Action
    module Server
      module Validate
        class Unlocked < Base
          
          def call(env)

            if env[:server].locked?
              env[:ui].error "Server is currently locked, cannot proceed"
              return
            end

            @app.call(env)
          end

        end        
      end
    end
  end
end