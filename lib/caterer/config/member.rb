module Caterer
  module Config
    class Member

      attr_reader :name
      attr_accessor :host, :user, :password
      
      def initialize(name)
        @name = name
      end

    end
  end
end