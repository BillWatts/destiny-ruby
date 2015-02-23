module Destiny
  ###
  # Genders: This class inherits from PlatformObjects allow for the retrieval
  # of multiple Genders.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class Classes < PlatformObjects

    ###
    # initialize: Initializes a Genders object.  Also manually sets the path for the resource.
    def initialize(path, client, params={})
      path = "Destiny/Manifest/Class"
      super path, client, params
    end
  end

  ###
  # Gender: This class contains information for a singular Gender.
  class Class < PlatformObject

    ###
    # initialize: Initializes a Gender object.
    def initialize(path, client, params={})
      super path, client, params
    end

    protected

    ###
    # setup_properties: Overrides the existing setup_properties of PlatformObject until it can be determined
    # that Bungie's responses are uniform. 
    def setup_properties(hash)
      if hash.has_key? "Response" and hash["Response"].has_key? "data" and hash["Response"]["data"].has_key? "classDefinition"
        hash = hash["Response"]["data"]["classDefinition"]
      end

      ["classHash","classIdentifier","mentorVendorIdentifier"].each do |attribute|
        hash.delete(attribute)
      end

      create_class_methods hash
    end
  end
end