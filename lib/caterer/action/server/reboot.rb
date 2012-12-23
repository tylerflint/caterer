module Caterer
  module Action
    module Server
      class Reboot < Base
        def call(env)
          env[:server].reboot!
          @app.call(env)
        end
      end
    end
  end
end