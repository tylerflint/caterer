## Caterer

Caterer is a tool for provisioning production environments.

### Getting Started

#### Install caterer:

```bash
gem install caterer
```

#### Define images in a Caterfile:

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

#### Provision a server with the "rails" image:

```bash
cater provision HOST -i rails
```

## Documentation

The Caterer Wiki has lots of additional information about Caterer including many usage references, configuration examples, how-to articles, and answers to the most frequently asked questions.

You can view all of the available wiki pages [here](https://github.com/tylerflint/caterer/wiki/_pages).

### Getting started

Here is the basic information to get started: [Soup to Nuts](https://github.com/tylerflint/caterer/wiki/Soup-to-Nuts)

For answers to the most frequently asked questions: [FAQ](https://github.com/tylerflint/caterer/wiki/FAQ)

Some definitions to help you through the rest of the guides: [Definitions](https://github.com/tylerflint/caterer/wiki/Definitions)

A few cli usage examples: [cli examples](https://github.com/tylerflint/caterer/wiki/cli-examples)

### Configuration

* [general](https://github.com/tylerflint/caterer/wiki/Config:-General)
* [images](https://github.com/tylerflint/caterer/wiki/Config:-Images)
* [members](https://github.com/tylerflint/caterer/wiki/Config:-Members)
* [groups](https://github.com/tylerflint/caterer/wiki/Config:-Groups)

#### Provisioners 
* [chef-solo](https://github.com/tylerflint/caterer/wiki/Config:-Provisioners:-chef-solo)

### How To...

Use berkshelf for cookbook dependencies: [Howto: Berkshelf](https://github.com/tylerflint/caterer/wiki/Howto:-Berkshelf)

Display verbose output: [Howto: Verbose Logging]()

Structure a large project: [Howto: Large Projects]()

Limit chef runlist for iterative provisioning: [Howto: Runlist Override]()


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
