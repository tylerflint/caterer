# commands
Caterer.commands.register(:test)      { Caterer::Command::Test }
Caterer.commands.register(:bootstrap) { Caterer::Command::Bootstrap }
Caterer.commands.register(:provision) { Caterer::Command::Provision }
Caterer.commands.register(:up)        { Caterer::Command::Up }
Caterer.commands.register(:reboot)    { Caterer::Command::Reboot }