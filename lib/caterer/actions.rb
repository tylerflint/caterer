# actions
Caterer.actions.register(:validate) do
  Vli::Action::Builder.new do
    use Caterer::Action::Config::Validate::Image
    use Caterer::Action::Config::Validate::Provisioner
    use Caterer::Action::Server::Validate::SSH
  end
end

Caterer.actions.register(:prepare) do
  Vli::Action::Builder.new do
    use Caterer::Action::Provisioner::Prepare
  end
end

Caterer.actions.register(:cleanup) do
  Vli::Action::Builder.new do
    use Caterer::Action::Provisioner::Cleanup
  end
end

Caterer.actions.register(:bootstrap) do
  Vli::Action::Builder.new do
    use Caterer.actions.get(:validate)
    use Caterer.actions.get(:prepare)
    use Caterer::Action::Provisioner::Bootstrap
    use Caterer.actions.get(:cleanup)
  end
end

Caterer.actions.register(:provision) do
  Vli::Action::Builder.new do
    use Caterer.actions.get(:validate)
    use Caterer.actions.get(:prepare)
    use Caterer::Action::Provisioner::Install
    use Caterer::Action::Provisioner::Provision
    use Caterer.actions.get(:cleanup)
  end
end

Caterer.actions.register(:up) do
  Vli::Action::Builder.new do
    use Caterer.actions.get(:validate)
    use Caterer.actions.get(:prepare)
    use Caterer::Action::Provisioner::Bootstrap
    use Caterer::Action::Provisioner::Install
    use Caterer::Action::Provisioner::Provision
    use Caterer.actions.get(:cleanup)
  end
end