module Caterer
  module Action
    module Provisioner
      class Uninstall < Base

        def call(env)

          config = env[:config]
          server = env[:server]
          image  = config.images[env[:image]]

          image.provisioners.each do |provisioner|
            provisioner.uninstall(server)
          end

          @app.call(env)
        end
        
      end
    end
  end
end