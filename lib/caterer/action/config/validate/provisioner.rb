module Caterer
  module Action
    module Config
      module Validate
        class Provisioner < Base
          
          def call(env)

            if env[:image]
              provisioner = env[:config].images[env[:image]].provisioner

              if not provisioner
                env[:ui].error "provisioner for image ':#{env[:image]}' is not defined"
                return
              end
              
              if errors = provisioner.errors
                errors.each do |key, val|
                  env[:ui].error "image :#{env[:image]} provisioner error -> #{key} #{val}"
                end
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