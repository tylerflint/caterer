module Caterer
  module Provisioner
    class Base

      attr_reader :server, :config

      def initialize(server, config=nil)
        @server = server
        @config = config
      end

      def bootstrap(script=nil);  end
      def prepare;    end
      def install;    end
      def provision;  end
      def cleanup;    end

    end
  end
end