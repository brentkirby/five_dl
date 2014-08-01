require 'spec_helper'

describe FiveDL::Response do
  
  let!(:user) do
    User.make!
  end
  
  
  describe '.success?' do
    
    let(:resp) do
      VCR.use_cassette('create_merchant_customer', record: :new_episodes, match_requests_on: [:body]) do
        FiveDL::Customer.create(data)
      end
    end
    
    context 'when a successful response is returned' do
      
      let!(:data) do
        {
          firstname: "Test",
          lastname: "McTesterson"
        }
      end
      
      it 'should return true' do
        resp.success?
          .should be_true
      end
    end
    
    
    context 'when an un-successful response is returned' do
      
      let!(:data) do
        {
          firstname: "Test"
        }
      end
      
      it 'should return true' do
        resp.success?
          .should be_false
      end
      
      it 'should fetch the API error message' do
        resp.error_message
          .should eq 'Required payment field lastname is missing'
      end
    end
    
    context 'when a declined response is returned' do
      
    end
  end
end