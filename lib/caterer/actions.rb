# actions
Caterer.actions.register(:validate) do
  Vli::Action::Builder.new do
    use Caterer::Action::Config::Validate::Image
    use Caterer::Action::Config::Validate::Provisioner
    use Caterer::Action::Provisioner::Validate::Engine
    use Caterer::Action::Server::Validate::SSH
    use Caterer::Action::Server::Validate::Unlocked
  end
end

Caterer.actions.register(:lock) do
  Vli::Action::Builder.new do
    use Caterer::Action::Config::Validate::Image
    use Caterer::Action::Config::Validate::Provisioner
    use Caterer::Action::Server::Validate::SSH
    use Caterer::Action::Server::Lock
  end
end

Caterer.actions.register(:unlock) do
  Vli::Action::Builder.new do
    use Caterer::Action::Config::Validate::Image
    use Caterer::Action::Config::Validate::Provisioner
    use Caterer::Action::Server::Validate::SSH
    use Caterer::Action::Server::Unlock
  end
end

Caterer.actions.register(:bootstrap) do
  Vli::Action::Builder.new do
    use Caterer.actions.get(:validate)
    use Caterer::Action::Provisioner::Prepare
    use Caterer::Action::Server::Lock
    use Caterer::Action::Provisioner::Bootstrap
    use Caterer::Action::Provisioner::Install
    use Caterer::Action::Provisioner::Cleanup
    use Caterer::Action::Server::Unlock
  end
end

Caterer.actions.register(:provision) do
  Vli::Action::Builder.new do
    use Caterer.actions.get(:validate)
    use Caterer::Action::Provisioner::Validate::Bootstrapped
    use Caterer::Action::Provisioner::Prepare
    use Caterer::Action::Server::Lock
    use Caterer::Action::Provisioner::Provision
    use Caterer::Action::Provisioner::Cleanup
    use Caterer::Action::Server::Unlock
  end
end

Caterer.actions.register(:up) do
  Vli::Action::Builder.new do
    use Caterer.actions.get(:validate)
    use Caterer::Action::Provisioner::Prepare
    use Caterer::Action::Server::Lock
    use Caterer::Action::Provisioner::Bootstrap
    use Caterer::Action::Provisioner::Provision
    use Caterer::Action::Provisioner::Cleanup
    use Caterer::Action::Server::Unlock
  end
end

Caterer.actions.register(:reboot) do
  Vli::Action::Builder.new do
    use Caterer::Action::Server::Validate::SSH
    use Caterer::Action::Server::Reboot
  end
end