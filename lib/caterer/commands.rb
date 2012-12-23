# commands
Caterer.commands.register(:bootstrap) { Caterer::Command::Bootstrap }
Caterer.commands.register(:lock)      { Caterer::Command::Lock }
Caterer.commands.register(:provision) { Caterer::Command::Provision }
Caterer.commands.register(:reboot)    { Caterer::Command::Reboot }
Caterer.commands.register(:unlock)    { Caterer::Command::Unlock }
Caterer.commands.register(:up)        { Caterer::Command::Up }
