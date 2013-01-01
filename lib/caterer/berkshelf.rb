require 'berkshelf' # this can take a bit of time :(

module Caterer
  module Berkshelf
    
    extend self

    def shelf_for(env)
      return nil if env[:uuid].nil?

      File.join(::Berkshelf.berkshelf_path, "caterer", env[:uuid])
    end

    def install
      Vli::Action::Builder.new do
        use Action::Berkshelf::UI
        use Action::Berkshelf::Install
      end
    end

    def clean
      Vli::Action::Builder.new do
        use Action::Berkshelf::UI
        use Action::Berkshelf::Clean
      end
    end

    def init!
      
      Caterer.config_keys.register(:berkshelf) { Config::Berkshelf }

      [ :provision, :up ].each do |action|
        Caterer.actions[action].insert_after(Caterer::Action::Provisioner::Load, install)
      end

      Caterer.actions[:clean].use clean

    end

  end
end

Caterer::Berkshelf.init!