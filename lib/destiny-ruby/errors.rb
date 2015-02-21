module Destiny
  class ServerError < StandardError
    attr_reader :code

    def initalize(message, code=nil)
      super message
      @code = code
    end
  end

  class RequestError < StandardError
    attr_reader :code

    def initialize(message, code=nil)
      super message
      @code = code
    end
  end

  class InputError < StandardError
    attr_reader :code

    def initialize(message, code=nil)
      super message
      @code = code
    end
  end
end