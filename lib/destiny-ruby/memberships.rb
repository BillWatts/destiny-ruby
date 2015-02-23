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
      super path, client, params
      client.config[:membership_id] = self.membership_id

      resource :account
    end

    protected

    ###
    # setup_properties: Accepts a hash that is looped through so attribute can be accessed on each resource object.
    def setup_properties(hash)
      hash = hash["Response"].first if hash.has_key? "Response"
      create_class_methods hash
    end
  end
end