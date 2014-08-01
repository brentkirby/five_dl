require 'spec_helper'

describe FiveDL::Customer do
  
  describe 'creating new customers' do
    
    let(:resp) do
      VCR.use_cassette('create_merchant_customer', record: :new_episodes, match_requests_on: [:body]) do
        FiveDL::Customer.create(data)
      end
    end
    
    context 'when successful' do
      
      let!(:data) do
        {
          firstname: "Test",
          lastname: "McTesterson"
        }
      end
      
      it 'returns a successful response' do
        resp.success?
          .should be_true
      end
    end
    
    
    context 'when not successful' do
      
      let!(:data) do
        {
          firstname: "Test"
        }
      end
      
      it 'returns a successful response' do
        resp.success?
          .should be_false
      end
      
      
      it 'should fetch the API error message' do
        resp.error_message
          .should eq 'Required payment field lastname is missing'
      end
    end

  end
end