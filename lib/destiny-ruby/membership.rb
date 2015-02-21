module Destiny
  ###
  # Memberships: This class inherits from PlatformObjects allow for the retrieval
  # of multiple memberships.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class Memberships < PlatformObjects

    ###
    # initialize: Initializes a Memberships object.  Also manually sets the path for the resource.
    def initialize(path, client, params={})
      path = "Destiny/SearchDestinyPlayer/#{client.config[:console_id]}"
      super path, client, params
    end
  end

  ###
  # Membership: This class contains information for a singular membership.
  class Membership < PlatformObject

    ###
    # initialize: Initializes a Membership object.
    def initialize(path, client, params={})
      super
    end

    protected

    ###
    # setup_properties: Overrides the existing setup_properties of PlatformObject until it can be determined
    # that Bungie's responses are uniform. 
    def setup_properties(hash)
      hash = hash["Response"].first if hash.has_key? "Response"
      tmpclass = class << self; self; end

      hash.each do |key,val|
        tmpclass.send :define_method, key.underscore.to_sym, &lambda { val }
      end
    end
  end
end