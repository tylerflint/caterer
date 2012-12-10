module Caterer
  module Communication
    class Rsync
      
      def initialize(server)
        @server     = server
        @logger     = Log4r::Logger.new("caterer::communication::ssh")
      end

      

    end
  end
end