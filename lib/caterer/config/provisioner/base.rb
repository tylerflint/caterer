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
        end

      end
    end    
  end
end