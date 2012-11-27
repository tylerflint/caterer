module Caterer::Config

  class Base
    attr_accessor :roles

    def initialize
      @roles = []  
    end

    def role(name)
      role = Caterer::Config::Role.new(name)
      yield role if block_given?
      @roles << role
    end
  end

end