module Caterer
  module Config
    class Group

      attr_reader    :name
      attr_accessor  :images, :members, :user, :password, :key, :data

      def initialize(name=nil)
        @name    = name
        @images  = []
        @members = {}
      end

      def add_image(image)
        @images << image
      end

      def member(name)
        @members[name] ||= Member.new(name)
        yield @members[name] if block_given?
      end
    end
  end
end