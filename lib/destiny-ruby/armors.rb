module Destiny
  ###
  # Armors: This class inherits from PlatformObjects allow for the retrieval
  # of multiple Armors.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class Armors < PlatformObjects

    ###
    # initialize: Initializes a Armors object.  Also manually sets the path for the resource.
    def initialize(path, client, params={})
      super path, client, params
    end
  end

  ###
  # Armor: This class contains information for a singular Armor.
  class Armor < PlatformObject

    ###
    # initialize: Initializes a Armor object.
    def initialize(path, client, params={})
      p path
      super path, client, params
    end

    protected

    ###
    # setup_properties: Overrides the existing setup_properties of PlatformObject until it can be determined
    # that Bungie's responses are uniform. 
    def setup_properties(hash)
      if hash.has_key? "Response" and hash["Response"].has_key? "data" and hash["Response"]["data"].has_key? "Armor"
        hash = hash["Response"]["data"]["Armor"]
      end

      ["ArmorHash","ArmorDescription"].each do |attribute|
        hash.delete(attribute)
      end

      create_class_methods hash
    end
  end
end