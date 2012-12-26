module Caterer
  module Config
    class Base

      attr_reader :images, :groups
      attr_accessor :default_provisioner

      def initialize
        @images  = {}
        @groups  = {}
        @default_provisioner = :chef_solo
      end

      def image(name)
        @images[name] ||= Image.new(name)
        yield @images[name] if block_given?
      end

      def group(name)
        @groups[name] ||= Group.new(name)
        yield @groups[name] if block_given?
      end
      
      def member(name, &block)
        group(:default) do |d|
          d.member(name, &block)
        end
      end

    end
  end
end