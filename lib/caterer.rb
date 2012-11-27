require "caterer/version"
require 'caterer/logger'

module Caterer
  autoload :Environment,  'caterer/environment'
  autoload :Config,       'caterer/config'  

  extend self

  def config
    @config ||= Caterer::Config::Base.new
  end

  def configure
    yield config if block_given?
  end

end
