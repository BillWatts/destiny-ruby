###
# Client: Responsible for all GET requests for all resources.  Also houses main configuration and initializes
# specified resources on its initialization.
module Destiny
  class Client
    include Utils

    ###
    # Default configuration including Bungie base URL, HTTP settings, and basic information
    # that will be referenced throughout the gem.
    DEFAULTS = {
      host: 'www.bungie.net',
      timeout: 30,
      console: :xbox,
      membership_id: nil,
      group_id: nil,
    }

    ###
    # Setting publicly accessible object for the class.
    attr_reader :config, :memberships, :races, :genders, :classes,
      :armors

    ###
    # initialize:  Merges default configuration with any custom options passed into the Client class on
    # initialization.  Also configuration net/HTTP and initializes specified resources.  `console_id` is 
    # also set depending on the `:console` that is passed using the `CONSOLE_MAP`.
    def initialize(options={})
      @config = DEFAULTS.merge! options

      setup_connection
      setup_resources
    end

    ###
    # Defines get helper methods for the sending of HTTP requests for all resources.
    # each request returns a JSON object which is converted into a hash.
    [:get].each do |method|
      method_class = Net::HTTP.const_get method.to_s.capitalize

      define_method method do |params, path|
        params = {} if params.nil? or params.empty?

        ###
        # All known Bungie resources start with "/Platform" in the path and end with a trailing "/".
        # not adding the trailing slash causes Bungie to redirect to the path with a trailing "/".
        path = '/Platform/' + path + '/'

        ###
        # If there are parameters, url encode them and add them to the path as query parameters.
        path << '&#{url_encode(params)}' unless params.empty? 

        ###
        # Create new GET request with path.  Also take parameters and dump them in to the request
        # body for good measure.
        request = method_class.new path
        request.body = MultiJson.dump(params) unless params.empty?

        ###
        # Make the HTTP magic happen.
        send_request request
      end
    end

    private

    ###
    # setup_connection: Configurations net/HTTP with available configuration.
    def setup_connection
      connection = Net::HTTP::Proxy @config[:proxy_address], @config[:proxy_port], @config[:proxy_user], @config[:proxy_address]
      @connection = connection.new @config[:host], @config[:port]

      @connection.open_timeout = @config[:timeout]
      @connection.read_timeout = @config[:timeout]
    end

    ###
    # setup_resources: Initializes the specified resources making them available after Client has been initialized.
    def setup_resources
      @memberships = Memberships.new self
      # @races = Races.new self
      # @genders = Genders.new self
      # @classes = Classes.new self
      # @armors = Armors.new self
    end

    ###
    # send_request: Takes a net/HTTP object and attempts to execute the request.  If request is successful the
    # response is parsed for the return JSON and then returned.
    def send_request(request)
      @previous_request = request
      retries_remaining = @config[:retries]
      json = {}
 
      begin
        response = @connection.request request
        @previous_request = response

        if response.kind_of? Net::HTTPServerError
          object = parse_response response
          raise Destiny::ServerError.new object['error']['message'], object['error']['code']
        else
          json = parse_response(response)
        end

        
      rescue Exception

      end

      

      p json

      json
    end

    ###
    # parse_response: Accepts a net/HTTML response and parses the response body using MultiJson.
    def parse_response(response)
      object = nil

      if response.body and !response.body.empty?
        object = MultiJson.load response.body
      end

      object
    end
  end
end