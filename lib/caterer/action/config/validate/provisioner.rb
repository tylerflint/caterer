module Caterer
  module Action
    module Config
      module Validate
        class Provisioner < Base
          
          def call(env)

            if env[:image]

              provisioners = env[:config].images[env[:image]].provisioners

              if provisioners.empty?
                env[:ui].error "image ':#{env[:image]}' does not have a provisioner"
                return
              end

              provisioners.each do |provisioner|

                if errors = provisioner.errors
                  errors.each do |key, val|
                    env[:ui].error "image :#{env[:image]} provisioner error -> #{key} #{val}"
                  end
                  return
                end 

              end

            end          

            @app.call(env)
          end

        end
      end
    end
  end
end