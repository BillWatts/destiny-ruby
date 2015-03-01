module Destiny
  ###
  # Character: This class contains information for a singular character.
  class Account < PlatformObject

    ###
    # initialize: Initializes a Membership object.
    def initialize(client, params={}, path=nil)
      path = "Destiny/#{client.config[:console_id]}/Account/#{client.config[:membership_id]}"
      super client, params, path

      # resource :characters
    end

    protected

    ###
    # setup_properties: Overrides the existing setup_properties of PlatformObject until it can be determined
    # that Bungie's responses are uniform. 
    def setup_properties(obj={}, ignore_attributes=[])
      obj = obj["data"] if obj.is_a? Hash and obj.has_key? "data" 

      super obj, ["characters", "inventory", "membershipId", "membershipType"]
    end
  end
end