module Caterer
  module Provisioner
    class Base

      attr_reader :server

      def initialize(server, config=nil)
        @server = server
        @config = config
      end

      def bootstrap(script=nil);  end
      def prepare;    end
      def provision;  end
      def cleanup;    end

    end
  end
end