module Caterer
  module Provisioner
    class Base

      # config dsl
      def errors; end

      # provision dsl
      def bootstrap(server); end
      def bootstrapped?(server); true; end
      def cleanup(server); end
      def install(server); end
      def prepare(server); end
      def provision(server); end
      def uninstall(server); end
        
    end
  end
end