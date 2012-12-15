module Caterer
  module Config
    class Base

      attr_reader :images, :groups

      def initialize
        @images  = {}
        @groups = {}
      end

      def image(name)
        image = Image.new(name)
        yield image if block_given?
        @images[name] = image
      end

      def group(name)
        group = Group.new(name) 
        yield group if block_given?
        @groups[name] = group
      end
      
    end
  end
end