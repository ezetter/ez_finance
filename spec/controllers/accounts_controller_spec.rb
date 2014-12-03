require "rails_helper"

RSpec.describe AccountsController, :type => :controller do
  describe '#destroy' do
    it 'deletes the account' do
      account = Account.new(name: 'Test', value: 100, value_fractional: 0)
      account.save
      expect{delete :destroy, {:id => account.id}}.to change(Account, :count).by(-1)
    end

    it 'deletes the history' do
      account = Account.new(name: 'Test', value: 100, value_fractional: 0)
      account.save
      AccountHistory.save_history(account)
      expect(AccountHistory.count).to eq(1)
      delete :destroy, {:id => account.id}
      expect(AccountHistory.count).to eq(0)
    end
  end
end