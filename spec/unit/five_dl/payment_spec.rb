require 'spec_helper'

describe FiveDL::Payment do
  
  let!(:pdata) do
    CreditCard.make.to_merchant
      .merge!(
        firstname: 'Test', 
        lastname: 'McTesterson',
        zip: '23219')
  end
  
  describe '#format_money' do
    
    let(:result) do
      FiveDL::Payment.send(
        :format_money, value)
    end
    
    Smfm::TestUtils.money_format_types.each do |name, val|
      
      context "when passed a #{name}" do
      
        let!(:value) do
          val
        end
      
        it "converts it to the proper format" do
          result.should eq '10.00'
        end
      end
    end
    
  end
  
  describe 'creating payments' do
    
    context 'when the transaction is successful' do

      let(:resp) do
        VCR.use_cassette('create_payment', record: :new_episodes, match_requests_on: [:body]) do
          FiveDL::Payment.create("1.00", pdata)
        end
      end
      
      it '.success? returns true' do
        resp.success?
          .should be_true
      end
      
      it 'returns the token' do
        resp.token
          .should eq '1544206'
      end
    end
    
    
    context 'when the transaction is not successful' do
      
      let(:resp) do
        VCR.use_cassette('create_payment_fail', record: :new_episodes, match_requests_on: [:body]) do
          FiveDL::Payment.create("0.50", pdata)
        end
      end
      
      it '.success? returns false' do
        resp.success?
          .should be_false
      end
      
      it 'returns a nil token' do
        resp.token
          .should be_nil
      end
    end
    
  end
  
  
  describe 'authorizing payments' do
    
    context 'when the transaction is successful' do

      let(:resp) do
        VCR.use_cassette('authorize_payment', record: :new_episodes, match_requests_on: [:body]) do
          FiveDL::Payment.authorize("1.00", pdata)
        end
      end
      
      it '.success? returns true' do
        resp.success?
          .should be_true
      end
      
      it 'returns the token' do
        resp.token
          .should eq '1544208'
      end
    end
    
    
    context 'when the transaction is not successful' do
      
      let(:resp) do
        VCR.use_cassette('authorize_payment_fail', record: :new_episodes, match_requests_on: [:body]) do
          FiveDL::Payment.authorize("0.50", pdata)
        end
      end
      
      it '.success? returns false' do
        resp.success?
          .should be_false
      end
      
      it 'returns a nil token' do
        resp.token
          .should be_nil
      end
    end
  end
  
  
  describe 'capturing previous authorizations' do
    
    context 'when the transaction is successful' do

      let(:resp) do
        VCR.use_cassette('capture_authorization', record: :new_episodes, match_requests_on: [:body]) do
          FiveDL::Payment.capture('1544208', "1.00", pdata)
        end
      end
      
      it '.success? returns true' do
        resp.success?
          .should be_true
      end
      
      it 'returns the new transaction token' do
        resp.token
          .should eq '1544208'
      end
    end
    
    
    context 'when the transaction is not successful' do
      
      let(:resp) do
        VCR.use_cassette('capture_authorization_fail', record: :new_episodes, match_requests_on: [:body]) do
          FiveDL::Payment.capture("12345", "1.00", pdata)
        end
      end
      
      it '.success? returns false' do
        resp.success?
          .should be_false
      end
      
      it 'returns a nil token' do
        resp.token
          .should be_nil
      end
    end
    
  end
end