module Caterer
  module Config
    class Member

      attr_reader :name
      attr_accessor :host, :port, :user, :password, :key, :images, :data
      
      def initialize(name=nil)
        @name = name
      end

    end
  end
end