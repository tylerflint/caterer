module Caterer
  module Communication
    autoload :Rsync,  'caterer/communication/rsync'
    autoload :SSH,    'caterer/communication/ssh'
  end
end