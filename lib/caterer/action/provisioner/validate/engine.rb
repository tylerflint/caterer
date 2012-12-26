module Caterer
  module Action
    module Provisioner
      module Validate
        class Engine < Base

          def call(env)

            if env[:engine]
              if not Caterer.provisioners.get(env[:engine])
                env[:ui].error "Unsupported provision engine #{env[:engine]}"
                return
              end
            end

            @app.call(env)

          end
        end

      end
    end
  end
end