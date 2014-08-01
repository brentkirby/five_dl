module FiveDL
  ##
  # Manage creating and updating payment info
  # 
  module PaymentType
    extend self
    
    ##
    # Create a new payment type for a customer
    # @param [String] cust_token The customer's unique merchant token
    # @param [Array,Hash] data Either a hash representing a single payment type, or an array of hashes representing multiple types
    # 
    def create(cust_token, data = {})
      pdata = build_payment_info(data)
      data = FiveDL.build_params(data.merge!(transtype: 'updatecustomer', token: cust_token).merge!(pdata))
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    ##
    # Update a payment method
    # @param [String] cust_token The customer's unique merchant token
    # @param [Hash] data Hash representing payment data to be updated
    # 
    def update(cust_token, data = {})
      pdata = build_payment_info(data)
      data  = FiveDL.build_params(data.merge!(transtype: 'updatecustomer', token: cust_token).merge!(pdata))
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    ##
    # Delete a customer
    # 
    def destroy(token)
      data = FiveDL.build_params({ transtype: 'deletecustomer', token: token })
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    private
    
    
    ##
    # Re-format payment type data into the format required by 5th DL
    # 
    def build_payment_info(data)
      result = {}
      [data].flatten.each_with_index do |props, ind|
        props.symbolize_keys!
        result.merge!(:"operationtype_#{ind}" => ( props[:token].present? ? 'updatepaytype' : 'addpaytype' ))
        props.each do |key, value|
          result.merge!(:"#{key.to_s}_#{ind}" => value)
        end
      end
      result
    end
  end
end