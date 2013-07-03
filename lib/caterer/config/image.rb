module Caterer
  module Config
    class Image
      
      attr_reader :name, :provisioner

      def initialize(name)
        @name = name
      end

      def provision(type)
        provisioner_klass = Caterer.provisioners.get(type)
        raise ":#{type} is not a valid provisioner" if not provisioner_klass
        @provisioner = provisioner_klass.new(name)
        yield @provisioner if block_given?
        @provisioner
      end

    end
  end
end