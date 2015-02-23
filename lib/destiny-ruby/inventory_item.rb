module Destiny
  ###
  # InventoryItems: This class inherits from PlatformObjects allow for the retrieval
  # of multiple InventoryItems.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class InventoryItems < PlatformObjects

    ###
    # initialize: Initializes a InventoryItems object.  Also manually sets the path for the resource.
    def initialize(path, client, params={})
      path = "Destiny/Manifest/InventoryItem"
      super path, client, params
    end
  end

  ###
  # InventoryItem: This class contains information for a singular InventoryItem.
  class InventoryItem < PlatformObject

    ###
    # initialize: Initializes a InventoryItem object.
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