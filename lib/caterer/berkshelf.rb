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
      
      Caterer.commands.register(:berks) { Caterer::Command::Berks }

      Caterer.config_keys.register(:berkshelf) { Config::Berkshelf }

      Caterer.actions[:provision].insert(Caterer::Action::Server::Lock, install)

      Caterer.actions[:clean].use clean

      Caterer.actions.register(:berks_install) do
        install
      end

      Caterer.actions.register(:berks_clean) do
        clean
      end

    end

  end
end

Caterer::Berkshelf.init!