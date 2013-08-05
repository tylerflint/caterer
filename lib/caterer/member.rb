module Caterer
  class Member

    attr_reader :name
    attr_accessor :host, :port, :user, :password, :key, :images, :data
    
    def initialize(name=nil)
      @name = name
      @data = {}
    end

    def add_image(image)
      @images ||= []
      @images << image
    end

  end
end