module Caterer
  module Action
    module Berkshelf
      autoload :Clean,    'caterer/action/berkshelf/clean'
      autoload :Install,  'caterer/action/berkshelf/install'
      autoload :UI,       'caterer/action/berkshelf/ui'
    end
  end
end