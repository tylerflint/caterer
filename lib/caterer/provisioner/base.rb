module Caterer
  module Provisioner
    class Base

      attr_reader :server, :config

      def initialize(server, image, config=nil)
        @server = server
        @image  = image
        @config = config
      end

      def bootstrap;  end
      def cleanup;    end
      def install;    end
      def prepare;    end
      def provision;  end

    end
  end
end