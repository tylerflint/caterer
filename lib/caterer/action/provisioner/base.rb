module Caterer
  module Action
    module Provisioner
      class Base < Action::Base
        
        def provisioner
          @env[:server].provisioner
        end

      end
    end
  end
end