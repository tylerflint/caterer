module Caterer
  module Config
    class Base

      attr_reader :images, :groups
      attr_accessor :default_provisioner

      def initialize
        @images = {}
        @groups = {}
        @keys   = {}
      end

      def image(name)
        @images[name] ||= Image.new(name)
        yield @images[name] if block_given?
        @images[name]
      end

      def group(name)
        @groups[name] ||= Group.new(name)
        yield @groups[name] if block_given?
        @groups[name]
      end
      
      def member(name, &block)
        group(:default) do |d|
          d.member(name, &block)
        end
      end

      # here we allow custom config keys
      def method_missing(method, *args, &block)
        @keys[method] ||= begin
          if klass = Caterer.config_keys.get(method)
            klass.new
          else
            super
          end
        end
        yield @keys[method] if block_given?
        @keys[method]
      end

    end
  end
end

Caterer.config_keys.register(:provisioner) { Caterer::Config::Provisioner::Base }