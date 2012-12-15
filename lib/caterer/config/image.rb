require 'active_support/inflector'

module Caterer
  module Config
    class Image
      
      attr_reader :name, :provisioner

      def initialize(name)
        @name = name
      end

      def provision(type)
        @provisioner = "Caterer::Config::Provision::#{type.to_s.classify}".constantize.new(type)
        yield @provisioner if block_given?
      end

    end
  end
end