module Destiny
   ###
  # Characters: This class inherits from PlatformObjects allow for the retrieval
  # of multiple memberships.
  #
  # TODO: Retrieving of multiple memberships currently will now work with current code.
  class Characters < PlatformObjects

    ###
    # initialize: Initializes a Memberships object.  Also manually sets the path for the resource.
    def initialize(path, client, params={})
      path = "Destiny/#{client.config[:console_id]}/Account/#{client.config[:membership_id]}"

      super path, client, params
    end

    ###
    # list: Executes a HTTP request to retrieve a list of objects for the specified resource.
    #
    # TODO: This was pulled from a previous gem.  May need to be reworked in order to work with
    # Bungie's data.
    def list(params={})
      raise "Can't list Object without a client" unless @client
      response = @client.get @path, params
      resources = response["Response"]["data"]["characters"]

      resource_list = resources.map do |resource|
        @instance_class.new "#{@path.split('?').first}/#{resource['name']}", @client, resource["characterBase"]
      end

      client, list_class = @client, self.class

      resource_list
    end
  end

  ###
  # Character: This class contains information for a singular character.
  class Character < PlatformObject
    ###
    # initialize: Initializes a Membership object.
    def initialize(path, client, params={})
      path = "Destiny/#{client.config[:console_id]}/Account/#{client.config[:membership_id]}/Character/#{params['characterId']}"
      super
    end

    protected

    ###
    # setup_properties: Overrides the existing setup_properties of PlatformObject until it can be determined
    # that Bungie's responses are uniform. 
    def setup_properties(hash)
      hash = hash["Response"].first if hash.has_key? "Response"
      tmpclass = class << self; self; end

      ["membershipId", "membershipType", "stats", "customization","peerView"].each do |attribute|
        hash.delete(attribute)
      end

      create_class_modules hash
    end
  end
end