module Caterer
  module Action
    module Provisioner
      class Base < Action::Base
        
        def provisioner(env)

          if image = env[:image]
            env[:config].images[image].provisioner
          else
            Caterer.provisioners.get(env[:engine] || default_engine).new
          end
        end

        def default_engine
          Caterer.config.default_provisioner
        end

      end
    end
  end
end