module Caterer
  module Action
    module Image
      autoload :Cleanup,  'caterer/action/image/cleanup'
      autoload :Prepare,  'caterer/action/image/prepare'
      autoload :Run,      'caterer/action/image/run'
    end
  end
end