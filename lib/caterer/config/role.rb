require 'active_support/inflector'

module Caterer
  module Config
    class Role
      
      attr_reader :name, :provisioner

      def initialize(name)
        @name = name
      end

      def provision(type)
        @provisioner = "Caterer::Config::Provision::#{type.to_s.classify}".constantize.new
        yield @provisioner if block_given?
      end

    end
  end
end