module Caterer
  module Provisioner
    class Base

      attr_reader :server

      def initialize(server)
        @server = server
      end

      def bootstrap(script=nil);  end
      def prepare;    end
      def provision;  end
      def cleanup;    end

    end
  end
end