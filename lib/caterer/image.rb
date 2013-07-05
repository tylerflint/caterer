module Caterer
  class Image
  
    attr_reader :name, :provisioners

    def initialize(name)
      @name         = name
      @provisioners = []
    end

    def provision(type)
      provisioner_klass = Caterer.provisioners.get(type)
      raise ":#{type} is not a valid provisioner" if not provisioner_klass
      provisioner = provisioner_klass.new(name)
      yield provisioner if block_given?
      @provisioners << provisioner
      provisioner
    end
    
  end
end