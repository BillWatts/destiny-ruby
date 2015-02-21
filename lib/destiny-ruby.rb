require "destiny-ruby/version"

module Destiny
  require 'cgi'
  require 'net/http'
  require 'net/https'
  require 'multi_json'
  require 'active_support/inflector'

  require 'destiny-ruby/utils'
  require 'destiny-ruby/platform_objects'
  require 'destiny-ruby/errors'
  
  require 'destiny-ruby/client'
  require 'destiny-ruby/membership'

  class << self
    def new(options={})
      Client.new options
    end
  end
end
