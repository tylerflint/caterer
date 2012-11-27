require 'active_support/inflector'

module Caterer::Config

  class Role
    
    attr_reader   :name

    def initialize(name)
      @name = name
    end

    def provision(type=nil)
      return @provision if not type
      @provision = "Caterer::Config::Provision::#{type.to_s.classify}".constantize.new
      yield @provision if block_given?
    end

  end

end