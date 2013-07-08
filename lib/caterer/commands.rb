# commands
Caterer.commands.register(:clean)     { Caterer::Command::Clean }
Caterer.commands.register(:lock)      { Caterer::Command::Lock }
Caterer.commands.register(:provision) { Caterer::Command::Provision }
Caterer.commands.register(:unlock)    { Caterer::Command::Unlock }
