module Caterer
  module Action
    module Provisioner
      class Prepare < Base

        def call(env)

          config = env[:config]
          server = env[:server]
          image  = config.images[env[:image]]

          image.provisioners.each do |provisioner|
            %w( install prepare ).each do |action|
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

      end
    end
  end
end