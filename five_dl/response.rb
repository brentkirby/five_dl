module FiveDL
  require 'rack/utils'
  
  ##
  # Handles parsing responses from the 5DL API
  # 
  class Response
    SUCCESS_CODES = ['1', '520', '00', '100', 'A']
    ERROR_CODES   = ['3', '550', 'X', 'ER']
    DECLINE_CODES = ['2', '530', '540', 'D', '05', '500']
    
    attr_accessor :data, :response
    
    def initialize(resp)
      @response = resp
      @data     = ::Rack::Utils.parse_nested_query(resp.parsed_response)
    end
    
    
    ##
    # The error message for the response
    # 
    def error_message
      return nil if success?
      @data['textresponse'] || @data['codedescription']
    end
    
    
    ##
    # Was the response successful?
    # 
    def success?
      SUCCESS_CODES.include?(@data['response'])
    end
    
    
    ##
    # Returns the appropriate 'token' for a response
    # 
    def token
      return nil unless success?
      return @data['transid'] if ['sale', 'auth', 'capture'].include?(@data['type'])
      nil
    end
  end
  
end