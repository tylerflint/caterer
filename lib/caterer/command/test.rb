module Caterer
  module Command
    class Test < Vli::Command::Base
      
      def execute
        [:warn, :error, :info, :success].each do |method|
          @env.ui.send(method, method.to_s)
        end
        0
      end

    end
  end
end