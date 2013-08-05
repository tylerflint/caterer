Caterer.configure do |config|

  config.default_command = 'provision'
  
  config.provisioner.default_engine = :chef_solo

end