module Caterer
  module Config
    class Group

      attr_reader    :name
      attr_accessor  :roles, :members, :user, :password

      def initialize(name)
        @name    = name
        @roles   = []
        @members = []
      end

      def add_role(role)
        @roles << role
      end

      def member(name)
        member = Member.new(name)
        yield member if block_given?
        @members << member
      end
    end
  end
end