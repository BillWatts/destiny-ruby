module Destiny
  ###
  # PlatformObjects: This class is inherited in every resource that expects multiple resource instances to be
  # returned.
  class PlatformObjects
    include Utils

    ###
    # initialize: Creates the new object based on the parent module and current resource being accessed.
    def initialize(path, client, params={})
      @path, @client = path, client
      resource_name = self.class.name.split('::')[-1]
      instance_name = resource_name.chop

      parent_module = self.class.to_s.split('::')[-2]
      full_module_path = parent_module == 'Destiny' ? (Destiny) : (Destiny.cost_get parent_module)

      @instance_class = full_module_path.const_get instance_name
    end

    ###
    # list: Executes a HTTP request to retrieve a list of objects for the specified resource.
    #
    # TODO: This was pulled from a previous gem.  May need to be reworked in order to work with
    # Bungie's data.
    def list(params={})
      raise "Can't list Object without a client" unless @client
      response = @client.get @path, params
      resources = response


      resource_list = resources.map do |resource|
        @instance_class.new "#{@path.split('?').first}/#{resource['name']}", @client, resource
      end

      client, list_class = @client, self.class

      resource_list
    end

    ###
    # get: Creates a new instances of the particular resource object.  This does not execute a
    # HTTP request.  HTTP request are not made until the user tries to access an attribute.
    def get(id)
      instance = @instance_class.new "#{@path}/#{id}", @client
    end
    alias :find :get
  end

  ###
  # PlatformObject: This class is inherited by singular resource objects. 
  class PlatformObject
    include Utils
    
    ###
    # initialize: Creates a new objects based on the passed variables.
    def initialize(path, client, params={})
      @path, @client = path, client
      setup_properties params
    end

    ###
    # to_hash: Retrieves all singleton methods and creates a hash.  The singleton methods will be the 
    # parameters that are retrieved via and HTTP request.
    def to_hash
      hash = {}

      self.singleton_methods.each do |method|
        hash[method] = self.send method
      end

      hash
    end

    ###
    # method_missing: When trying to access an objects attributes, if method_missing is called meaning 
    # the attribute doesn't exists an HTTP call will be made to retrieve that attribute.  This allows
    # for lazy loading of a singular resource object attributes.
    def method_missing(method, *args)
      #super if @updated
      setup_properties(@client.get(@path,nil))
      self.send method, *args
    end

    protected

    ###
    # resource: Takes a collection of resources and create new resource objects.
    def resource(*resources)
      resources.each do |r|
        resource = resourceify r
        path = "#{@path}/#{resource.downcase}"
        enclosed_module = @sub_module == nil ? (Destiny) : (Destiny.const_get(@sub_module))
        resource_class = enclosed_module.const_get resource
        instance_variable_set("@#{r}", resource_class.new(path, @client))
      end

      self.class.instance_eval { attr_reader *resources }
    end

    ###
    # setup_properties: Accepts a hash that is looped through so attribute can be accessed on each resource object.
    def setup_properties(hash)
      tmpclass = class << self; self; end

      hash.each do |key,val|
        tmpclass.send :define_method, key.to_sym, &lambda { val }
      end
    end
  end
end