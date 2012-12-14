module Caterer
  module Config
    class Base

      attr_reader :roles, :groups

      def initialize
        @roles  = {}
        @groups = {}
      end

      def role(name)
        role = Role.new(name)
        yield role if block_given?
        @roles[name] = role
      end

      def group(name)
        group = Group.new(name) 
        yield group if block_given?
        @groups[name] = group
      end
      
    end
  end
end