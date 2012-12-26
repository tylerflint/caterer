module Caterer
  module Config
    class Image
      
      attr_reader :name, :provisioner

      def initialize(name)
        @name = name
      end

      def provision(type)
        provisioner_klass = Caterer.provisioners.get(type)
        raise ":#{type} is not a valida provisioner" if not provisioner_klass
        @provisioner = provisioner_klass.new
        yield @provisioner if block_given?
      end

    end
  end
end