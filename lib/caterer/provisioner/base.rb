module Caterer
  module Provisioner
    class Base

      attr_reader :server, :config

      def initialize(server, config=nil)
        @server = server
        @config = config
      end

      def bootstrap; end
      def bootstrapped?; true; end
      def cleanup; end
      def install; end
      def prepare; end
      def provision; end

    end
  end
end