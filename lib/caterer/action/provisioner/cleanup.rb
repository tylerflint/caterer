module Caterer
  module Action
    module Provisioner
      class Cleanup < Base

        def call(env)

          config = env[:config]
          server = env[:server]
          image  = config.images[env[:image]]

          if image
            image.provisioners.each do |provisioner|
              %w( cleanup uninstall ).each do |action|
                send action.to_sym, server, provisioner
              end
            end
          end

          @app.call(env)
        end
        
        def cleanup(server, provisioner)
          provisioner.cleanup(server)
        end

        def uninstall(server, provisioner)
          provisioner.uninstall(server) if @env[:ghost_mode]
        end

      end
    end
  end
end