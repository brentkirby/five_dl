module FiveDL
  module Customer
    extend self
    
    ##
    # Create a new customer.
    # 
    def create(data = {})
      data = FiveDL.build_params(build_payment_info(data.merge!(transtype: 'addcustomer')))
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    ##
    # Update an existing customer
    # 
    def update(token, data = {})
      data = FiveDL.build_params(build_payment_info(data.merge!(transtype: 'updatecustomer', token: token)))
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
    # Re-work payment info into the proper format for submission
    # 
    def build_payment_info(data)
      methods = data.delete(:payment_methods)
      return data unless methods
      data.merge!(FiveDL::PaymentType.send(:build_payment_info, methods))
      data
    end

  end
end