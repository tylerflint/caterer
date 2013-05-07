## Caterer

Caterer is a tool for provisioning production environments.

### Getting Started

Install caterer:

```bash
gem install caterer
```

Define images in a Caterfile:

```ruby
Caterer.configure do |config|

  config.image :rails do |image|
    image.provision :chef_solo do |chef|
      chef.add_recipe 'ruby'
      chef.add_recipe 'mysql::server'
      chef.add_recipe 'mysql::client'
      chef.json = {
        "ruby" => {
          "gems" => ['mysql2']
        }
      }
    end
  end
end
```

Provision a server with the "rails" image:

```bash
cater provision -i rails HOST
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
