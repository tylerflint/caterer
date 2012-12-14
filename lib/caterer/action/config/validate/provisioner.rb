module Caterer
  module Action
    module Config
      module Validate
        class Provisioner < Base
          
          def call(env)
            provisioner = env[:config].roles[env[:role]].provisioner

            if not provisioner
              env[:ui].error "provisioner for role ':#{env[:role]}' is not defined"
              return
            end
            
            if errors = provisioner.errors
              errors.each do |key, val|
                env[:ui].error "role :#{env[:role]} provisioner error -> #{key} #{val}"
              end
              return
            end

            @app.call(env)
          end

        end
      end
    end
  end
end