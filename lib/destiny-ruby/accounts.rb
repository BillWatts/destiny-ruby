module Destiny
  ###
  # Character: This class contains information for a singular character.
  class Account < PlatformObject

    ###
    # initialize: Initializes a Membership object.
    def initialize(path, client, params={})
      path = "Destiny/#{get_console_id(client.config[:console_id])}/Account/#{client.config[:membership_id]}"
      super path, client, params

      resource :characters
    end

    protected

    ###
    # setup_properties: Overrides the existing setup_properties of PlatformObject until it can be determined
    # that Bungie's responses are uniform. 
    def setup_properties(hash)
      hash = hash["Response"]["data"] if hash.has_key? "Response" and hash["Response"].has_key? "data" 

      ["characters", "inventory", "membershipId", "membershipType"].each do |attribute|
        hash.delete(attribute)
      end

      create_class_methods hash
    end
  end
end