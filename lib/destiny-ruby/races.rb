module Destiny
  ###
  # Races: This class inherits from PlatformObjects allow for the retrieval
  # of multiple races.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class Races < PlatformObjects

    ###
    # initialize: Initializes a Memberships object.  Also manually sets the path for the resource.
    def initialize(path, client, params={})
      path = "Destiny/Manifest/Race"
      super path, client, params
    end
  end

  ###
  # Race: This class contains information for a singular Race.
  class Race < PlatformObject

    ###
    # initialize: Initializes a Race object.
    def initialize(path, client, params={})
      super path, client, params
    end

    protected

    ###
    # setup_properties: Overrides the existing setup_properties of PlatformObject until it can be determined
    # that Bungie's responses are uniform. 
    def setup_properties(hash)
      if hash.has_key? "Response" and hash["Response"].has_key? "data" and hash["Response"]["data"].has_key? "race"
        hash = hash["Response"]["data"]["race"]
      end

      ["raceHash"].each do |attribute|
        hash.delete(attribute)
      end

      create_class_methods hash
    end
  end
end