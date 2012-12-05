module Caterer
  module Command
    class Test < Vli::Command::Base
      
      def execute
        puts "testy testy!"
        0
      end

    end
  end
end