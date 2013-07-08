module Caterer
  module Provisioner
    class Base

      attr_reader :image

      # config dsl
      def errors; end

      # provision dsl
      def cleanup(server); end
      def install(server); end
      def installed?(server); true; end
      def prepare(server); end
      def uninstall(server); end
      def provision_cmd; end
        
    end
  end
end