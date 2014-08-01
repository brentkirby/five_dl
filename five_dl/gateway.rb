require 'httparty'

module FiveDL
  class Gateway
    include HTTParty
    base_uri "https://secure.5thdl.com"
    headers 'Content-Type' => 'application/x-www-form-urlencoded'
    
  end
end