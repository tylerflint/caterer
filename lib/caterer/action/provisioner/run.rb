module Caterer
  module Action
    module Provisioner
      class Run < Base

        def call(env)

          config = env[:config]
          server = env[:server]
          image  = config.images[env[:image]]

          image.provisioners.each do |provisioner|

            %w(install prepare run cleanup uninstall).each do |action|
              send action.to_sym, server, provisioner
            end
          end

          @app.call(env)
        end
        
        def install(server, provisioner)
          provisioner.install server if not provisioner.installed? server
        end

        def prepare(server, provisioner)
          provisioner.prepare server
        end

        def run(server, provisioner)
          provisioner.provision(server) if not @env[:dry_run]
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