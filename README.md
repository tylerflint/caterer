# Caterer

Heavily inspired by vagrant, caterer is a remote server configuration tool that caters to your servers using a collaborative, fast, and iterative push model. Caterer supports chef-solo by default.

## Why?

Caterer is designed as a workflow-first utility around 3 guiding principles:

1. Configuration as code. 
2. Push provisioning.
3. Modular provisioner. 

Caterer does not replace chef or puppet, but leverages them to provide a faster iterative approach to live infrastructures. If you're familiar with the vagrant workflow, imagine that your 'boxes' are remote servers and you'll feel right at home.

The goal of caterer is that an entire infrastructure definition lives within a git repo. An infrastructure developer can open the Caterfile and read the infrastructure like a map. All provisioning recipes or definitions will live within this repo, and infrastructure developers can interate repidly to provide a hot infrastructure.

## Installation

Add this line to your application's Gemfile:

    gem 'caterer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install caterer

## Usage

### Caterfile

Caterer loads a Caterfile from the current directory. A Caterfile defines your infrastructure in a centralized, familiar ruby dsl. A Caterfile essentially creates a library of images that can be aggregated and applied to live servers.

### Images

An image is a configuration construct that defines the end state of the machine after that image has been applied. An image requires a provisioner. 

### Provisioner

A provisioner is the tool that will provision a server to meet the end requirements of an image. Currently only chef-solo is supported.

### Member

A member is an optional configuration for servers. Storing live server credentials in a version controlled repo is not suitable for many infrastructures, but is there for your convenience if you want it.

### Group

A group is a simply way of grouping images or members to provide agrregate funcionality in a simple, concise way.

## Example

### Caterfile

```ruby
Caterer.configure do |config|

  config.image :basic do |image|
    image.provision :chef_solo do |chef|
      chef.cookbooks_path = ['cookbooks'] # default
      chef.add_recipe 'ruby'
    end
  end

  config.image :rails do |image|
    image.provision :chef_solo do |chef|
      chef.bootstrap_script = 'script/bootstrap'
      chef.cookbooks_path = ['cookbooks'] # default
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

  config.group :oven do |group|

    group.images    = [:basic, :rails]
    group.user     = 'root' # optional
    group.password = 'password' # optional

    # optional member configuration
    group.member :oven1 do |m|
      m.host = "192.168.1.100"
    end

    group.member :oven2 do |m|
      m.host     = "192.168.1.101"
      m.password = 'samIam'
    end

  end

end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
