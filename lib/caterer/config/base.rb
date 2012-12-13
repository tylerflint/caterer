module Caterer
  module Config
    class Base

      attr_reader :roles, :groups

      def initialize
        @roles  = []
        @groups = []
      end

      def role(name)
        role = Role.new(name)
        yield role if block_given?
        @roles << role
      end

      def group(name)
        group = Group.new(name) 
        yield group if block_given?
        @groups << group
      end
      
    end
  end
end