module Caterer::Config::Provision

  class ChefSolo
    
    attr_accessor :recipes, :json

    def initialize
      @recipes = []
      @json = {}
    end

    def add_recipe(recipe)
      @recipes << recipe
    end

  end

end