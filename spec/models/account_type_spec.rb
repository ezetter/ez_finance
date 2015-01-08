require "rails_helper"

RSpec.describe AccountType, :type => :model do
  describe '#retirement_yes_no' do

    context 'when retirement is false' do
      it 'returns Yes'  do
        account_type = AccountType.new(:retirement => false)
        expect(account_type.retirement_yes_no).to eq('No')
      end
    end

    context 'when retirement is false' do
      it 'returns Yes'  do
        account_type = AccountType.new(:retirement => true)
        expect(account_type.retirement_yes_no).to eq('Yes')
      end
    end

  end
end
