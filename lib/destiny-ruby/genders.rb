module Destiny
  ###
  # Genders: This class inherits from PlatformObjects allow for the retrieval
  # of multiple Genders.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class Genders < PlatformObjects

    ###
    # initialize: Initializes a Genders object.  Also manually sets the path for the resource.
    def initialize(path, client, params={})
      super path, client, params
    end
  end

  ###
  # Gender: This class contains information for a singular Gender.
  class Gender < PlatformObject

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
      if hash.has_key? "Response" and hash["Response"].has_key? "data" and hash["Response"]["data"].has_key? "gender"
        hash = hash["Response"]["data"]["gender"]
      end

      ["genderHash","genderDescription"].each do |attribute|
        hash.delete(attribute)
      end

      create_class_methods hash
    end
  end
end