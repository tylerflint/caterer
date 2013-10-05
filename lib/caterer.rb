require 'vli'
require 'caterer/version'
require 'caterer/logger'
require 'caterer/action'
require 'caterer/berkshelf'
require 'caterer/cli'
require 'caterer/command'
require 'caterer/communication'
require 'caterer/config'
require 'caterer/environment'
require 'caterer/group'
require 'caterer/image'
require 'caterer/member'
require 'caterer/provisioner'
require 'caterer/server'
require 'caterer/util'

module Caterer
  
  extend self

  def actions
    @actions ||= Vli::Registry.new
  end

  def commands
    @commands ||= Vli::Registry.new
  end

  def provisioners
    @provisioners ||= Vli::Registry.new
  end

  def config_keys
    @config_keys  ||= Vli::Registry.new
  end

  def config
    @config ||= Config::Base.new
  end

  def configure
    yield config if block_given?
  end

end

require 'caterer/commands'
require 'caterer/actions'
require 'caterer/provisioners'