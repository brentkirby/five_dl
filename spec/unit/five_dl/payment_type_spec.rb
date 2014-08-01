require 'spec_helper' 

describe FiveDL::PaymentType do
  
  let!(:card1) do
    PaymentMethod.make(
      number: "4556859198068594"
    )
  end
  
  let!(:card2) do
    PaymentMethod.make
  end
  
  describe 'creating hashes with #build_payment_info' do
    
    let(:result) do
      FiveDL::PaymentType.send(
        :build_payment_info, data
      )
    end
    
    let(:result_keys) do
      result.keys.map(&:to_s)
    end
    
    context 'when passed card data' do
      
      let!(:data) do
        card1.to_merchant
      end
      
      it 'includes each original key with an index' do
        result_keys.should include(
          'cardnum_0')
      end
      
      context 'and the card was not previously stored' do
        
        it 'sets the operation type to "addpaytype"' do
          result[:operationtype_0]
            .should eq 'addpaytype'
        end
      end
      
      context 'and the card was previously stored' do
      
        let!(:data) do
          card1.to_merchant.merge!(
            token: '12345'
          )
        end
      
        it 'sets the operation type to "updatepaytype"' do
          result[:operationtype_0]
            .should eq 'updatepaytype'
        end
      end
    end
    
    context 'when passed data for multiple cards' do
      
      let!(:data) do
        [card1, card2].map(&:to_merchant)
      end
      
      it 'includes each original key with an index' do
        result_keys.should include(
          'cardnum_0', 'cardnum_1')
      end
    end
    
  end
end