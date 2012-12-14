module Caterer
  module Action
    module Config
      module Validate
        class Role < Base

          def call(env)
            # check to ensure the role exists
            role = env[:config].roles[env[:role]]

            if not role
              env[:ui].error "role ':#{env[:role]}' is not defined"
              return
            end

            @app.call(env)
          end

        end
      end
    end
  end
end