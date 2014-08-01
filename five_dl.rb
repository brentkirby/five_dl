module FiveDL
  VERSION = '0.0.1'
  
  autoload :Customer,       'five_dl/customer'
  autoload :PaymentType,    'five_dl/payment_type'
  autoload :Gateway,        'five_dl/gateway'
  autoload :Payment,        'five_dl/payment'
  
  extend self
  
  ##
  # All payment types allowed by 5th DL
  # 
  def available_payment_types
    ['creditcard', 'check', 'ach', 'starcard']
  end
  
  
  ##
  # Build a final "body" hash to send in a POST.
  # Adds the mkey param, and optional authentication params.
  # 
  def build_params(data, auth = false)
    data.merge!(mkey: FiveDL.token)
    data.merge!(apiname: username, apikey: password) if auth
    { body: data }
  end
  
  
  ##
  # The API password
  # 
  def password
    ENV['MERCHANT_PASS']
  end
   
  
  ##
  # The merchant API token.
  # 
  def token
    ENV['MERCHANT_KEY']
  end
  
  
  ##
  # The merchant API username
  # 
  def username
    ENV['MERCHANT_LOGIN']\
  end
end