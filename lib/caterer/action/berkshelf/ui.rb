module Caterer
  module Action
    module Berkshelf
      class UI < Base
        
        def call(env)
          
          ::Berkshelf.ui = begin
            ui = env[:ui].dup
            ui.resource = "Berkshelf"
            ui
          end

          @app.call(env)
        end

      end
    end
  end
end