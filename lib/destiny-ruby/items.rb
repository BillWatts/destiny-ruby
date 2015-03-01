module Destiny
  ###
  # InventoryItems: This class inherits from PlatformObjects allow for the retrieval
  # of multiple InventoryItems.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class Items < PlatformObjects

    ###
    # initialize: Initializes a InventoryItems object.  Also manually sets the path for the resource.
    def initialize(client, params={})
      super client, params
      @path = "Destiny/Explorer/Items"
    end

    ###
    # get: Creates a new instances of the particular resource object.  This does not execute a
    # HTTP request.  HTTP request are not made until the user tries to access an attribute.
    def get(id)
      instance = @instance_class.new @client, nil, "#{id}"
    end
  end

  ###
  # InventoryItem: This class contains information for a singular InventoryItem.
  class Item < PlatformObject

    ###
    # initialize: Initializes a InventoryItem object.
    def initialize(client, params={}, path=nil)
      path = "Destiny/Manifest/InventoryItem/#{path}"
      @path, @client = path, client
      
      setup_properties params, ["secondaryIcon", "itemHash", "actionName", "bucketTypeHash", 
        "tierType", "primaryBaseStat", "baseStats", "perkHashes", "specialItemType", "talentGridHash",
        "equippingBlock", "hasGeometry", "statGroupHash", "itemLevels", "values"]
    end

    protected

    ###
    # setup_properties: Accepts a hash that is looped through so attribute can be accessed on each resource object.
    def setup_properties(obj={}, ignore_attributes=[])
      obj = obj["data"]["inventoryItem"] if obj.is_a? Hash and obj.has_key? "data"

      super obj, ["secondaryIcon", "itemHash", "actionName", "bucketTypeHash", 
        "tierType", "primaryBaseStat", "baseStats", "perkHashes", "specialItemType", "talentGridHash",
        "equippingBlock", "hasGeometry", "statGroupHash", "itemLevels", "values"]
    end
  end
end