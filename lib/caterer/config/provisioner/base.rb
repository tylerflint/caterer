module Caterer
  module Config
    module Provisioner
      class Base
        attr_accessor :default_engine

        def initialize
          @keys = {}
        end

        def chef_solo
          @keys[:chef_solo] ||= Config::Provisioner::ChefSolo.new
          yield @keys[:chef_solo] if block_given?
          @keys[:chef_solo]
        end

      end
    end    
  end
end