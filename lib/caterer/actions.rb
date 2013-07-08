# actions
Caterer.actions.register(:validate) do
  Vli::Action::Builder.new do
    use Caterer::Action::Config::Validate::Image
    use Caterer::Action::Config::Validate::Provisioner
    use Caterer::Action::Server::Validate::SSH
    use Caterer::Action::Server::Validate::Unlocked
  end
end

Caterer.actions.register(:lock) do
  Vli::Action::Builder.new do
    use Caterer::Action::Environment::Setup
    use Caterer::Action::Server::Validate::SSH
    use Caterer::Action::Server::Lock
  end
end

Caterer.actions.register(:unlock) do
  Vli::Action::Builder.new do
    use Caterer::Action::Environment::Setup
    use Caterer::Action::Server::Validate::SSH
    use Caterer::Action::Server::Unlock
  end
end

Caterer.actions.register(:provision) do
  Vli::Action::Builder.new do
    use Caterer::Action::Environment::Setup
    use Caterer.actions.get(:validate)
    use Caterer::Action::Server::Platform
    use Caterer::Action::Server::Lock
    use Caterer::Action::Server::Prepare
    use Caterer::Action::Image::Prepare
    use Caterer::Action::Provisioner::Prepare
    use Caterer::Action::Image::Run
    use Caterer::Action::Provisioner::Cleanup
    use Caterer::Action::Image::Cleanup
    use Caterer::Action::Server::Cleanup
    use Caterer::Action::Server::Unlock
  end
end

Caterer.actions.register(:clean) do
  Vli::Action::Builder.new do
    use Caterer::Action::Environment::Setup
    use Caterer.actions.get(:validate)
    use Caterer::Action::Server::Platform
    use Caterer::Action::Provisioner::Uninstall
  end
end