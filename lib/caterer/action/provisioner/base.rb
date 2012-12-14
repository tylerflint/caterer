require 'active_support/inflector'

module Caterer
  module Action
    module Provisioner
      class Base < Action::Base
        
        def provisioner(env)
          config = env[:config].roles[env[:role]].provisioner
          "Caterer::Provisioner::#{config.name.to_s.classify}".constantize.new(env[:server], config)
        end

      end
    end
  end
end