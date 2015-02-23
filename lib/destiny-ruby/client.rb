###
# Client: Responsible for all GET requests for all resources.  Also houses main configuration and initializes
# specified resources on its initialization.
module Destiny
  class Client
    include Utils

    ###
    # Bungie references the difference platforms by "Membership Type" below maps each 
    # to its designated id.
    CONSOLE_MAP = {
      xbox: 1,
      playstation: 2
    }

    ###
    # Default configuration including Bungie base URL, HTTP settings, and basic information
    # that will be referenced throughout the gem.
    DEFAULTS = {
      host: 'www.bungie.net',
      port: 80,
      use_ssl: false,
      ssl_verify_peer: false,
      ssl_ca_file: nil,
      timeout: 30,
      proxy_address: nil,
      proxy_user: nil,
      proxy_password: nil,
      retries: 1,
      device_type: 'Ruby',
      console: :xbox,
      console_id: 1,
      membership_id: nil,
      group_id: nil,
      platform: :destiny
    }

    ###
    # Setting publicly accessible object for the class.
    attr_reader :config, :memberships, :races, :genders, :classes

    ###
    # initialize:  Merges default configuration with any custom options passed into the Client class on
    # initialization.  Also configuration net/HTTP and initializes specified resources.  `console_id` is 
    # also set depending on the `:console` that is passed using the `CONSOLE_MAP`.
    def initialize(options={})
      @config = DEFAULTS.merge! options
      @config[:console_id] = CONSOLE_MAP[@config[:console]] if CONSOLE_MAP.has_key? @config[:console]

      setup_connection
      setup_resources
    end

    ###
    # Defines get helper methods for the sending of HTTP requests for all resources.
    # each request returns a JSON object which is converted into a hash.
    [:get].each do |method|
      method_class = Net::HTTP.const_get method.to_s.capitalize

      define_method method do |path, params|
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

      setup_ssl if @config[:use_ssl]

      @connection.open_timeout = @config[:timeout]
      @connection.read_timeout = @config[:timeout]
    end

    ###
    # setup_ssl: If the user sets the `:use_ssl` options to true this method will setup the SSL configuration.
    def setup_ssl
      @connection.use_ssl = @config[:use_ssl]

      if @config[:ssl_verify_peer]
        @connection.verify_mdoe = OpenSSL::SSL::VERIFY_PEER
        @connection.ca_file = @config[:ssl_ca_file]
      else
        @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    ###
    # setup_resources: Initializes the specified resources making them available after Client has been initialized.
    def setup_resources
      @memberships = Memberships.new '', self
      @races = Races.new '', self
      @genders = Genders.new '', self
      @classes = Classes.new '', self
    end

    ###
    # send_request: Takes a net/HTTP object and attempts to execute the request.  If request is successful the
    # response is parsed for the return JSON and then returned.
    def send_request(request)
      @previous_request = request
      retries_remaining = @config[:retries]

      begin
        response = @connection.request request
        @previous_request = response

        if response.kind_of? Net::HTTPServerError
          object = parse_response response
          raise Destiny::ServerError.new object['error']['message'], object['error']['code']
        end
      rescue Exception
        raise if request.class == Net::HTTP::Post
        if retries_remaining > 0 then retries_remaining -= 1; retry else raise end
      end

      object = parse_response response
      #p object
      if response.body and !response.body.empty?
        object = MultiJson.load response.body
      end

      object
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