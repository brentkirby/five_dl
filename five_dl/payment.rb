module FiveDL
  module Payment
    extend self
    
    ##
    # Authorize a payment method for a dollar amount. 
    # @param [String] amount The amount to authorize
    # @param [Hash] data Additional data to pass to the api.
    # 
    def authorize(amount, data = {})
      amount = format_money(amount)
      data = FiveDL.build_params(data.merge!(amount: amount, transtype: 'auth'), true)
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    ##
    # Capture a previous authorization
    # @param [String] trans_id The original transaction id from the authorization
    # @param [String] amount The amount to charge
    # @param [Hash] data Additional data to pass to the api.
    # 
    def capture(trans_id, amount, data = {})
      data = FiveDL.build_params(data.merge!(transid: trans_id, amount: amount, transtype: 'capture'), true)
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    ##
    # Create a new payment/sale.
    # @param [String] amount The amount to charge
    # @param [Hash] data Additional data to pass to the api.
    # 
    def create(amount, data = {})
      amount = format_money(amount)
      data = FiveDL.build_params(data.merge!(amount: amount, transtype: 'sale'), true)
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    ##
    # Create a credit on a payment method.
    # @param [String] amount The amount to credit
    # @param [Hash] data Additional data to pass to the api.
    # 
    def credit(amount, data = {})
      amount = format_money(amount)
      data = FiveDL.build_params({amount: amount, transtype: 'credit' }, true)
      FiveDL::Response.new( FiveDL::Gateway.post('/Payments/Services_api.aspx', data) )
    end
    
    
    private
    
    
    ##
    # Fix money strings to remove currency and 
    # ensure they have cents.
    # 
    def format_money(str)
      sprintf("%.2f", str.to_s.gsub(/[^\d.,]/,'').to_f)
    end
  end
end