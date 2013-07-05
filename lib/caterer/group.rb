module Caterer
  class Group

    attr_reader    :name
    attr_accessor  :images, :members, :user, :password, :key, :data

    def initialize(name=nil)
      @name    = name
      @images  = []
      @members = {}
      @data    = {}
    end

    def add_image(image)
      @images << image
    end

    def member(name)
      @members[name] ||= Member.new(name)
      yield @members[name] if block_given?
      @members[name]
    end
  end
end