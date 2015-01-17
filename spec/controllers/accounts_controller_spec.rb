require "rails_helper"

RSpec.describe AccountsController, :type => :controller do
  before :each do
    DatabaseCleaner.clean
    Rails.application.load_seed
    allow(subject).to receive(:authorize_user).and_return(true)
  end

  describe '#destroy' do
    it 'deletes the account' do
      account = Account.new(name: 'Test', value: 100, value_fractional: 0)
      account.save
      expect { delete :destroy, {:id => account.id} }.to change(Account, :count).by(-1)
    end

    it 'deletes the history' do
      account = Account.new(name: 'Test', value: 100, value_fractional: 0)
      account.save
      expect(AccountHistory.count).to eq(1)
      delete :destroy, {:id => account.id}
      expect(AccountHistory.count).to eq(0)
    end
  end

  describe '#edit' do
    it 'renders the edit template' do
      account = Account.new(name: 'Test', value: 100, value_fractional: 0)
      account.save
      get :edit, {:id => account.id}
      expect(response).to render_template(:edit)
    end
  end

  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

  describe '#create' do
    it 'creates the account' do
      account_type = AccountType.first
      account_owner = create(:account_owner)
      account_params = {:value => 100,
                        :name => 'an account',
                        :date_opened => '2014-12-10',
                        :account_type_id => account_type.id,
                        :account_owner_id => account_owner.id}
      post :create, {:account => account_params}
      account = Account.first
      expect(account.date_opened).to eq(Date.parse('2014-12-10'))
      expect(account.name).to eq('an account')
      expect(account.value).to eq(100)
      expect(account.account_type).to eq(account_type)
      expect(account.account_owner).to eq(account_owner)
    end
  end

  describe '#update' do
    it 'updates the account' do
      account_owner = create(:account_owner)
      account_type = AccountType.first
      account_params = {:value => 100,
                        :name => 'an account',
                        :date_opened => '2014-12-10',
                        :account_type_id => account_type.id}
      account = Account.new(account_params)
      account.save
      account_type = AccountType.last
      account_params = {:value => 200,
                        :name => 'another account',
                        :date_opened => '2014-12-11',
                        :account_type_id => account_type.id,
                        :account_owner_id => account_owner.id}
      put :update , {:id => account.id, :account => account_params}
      account = Account.first
      expect(account.date_opened).to eq(Date.parse('2014-12-11'))
      expect(account.name).to eq('another account')
      expect(account.value).to eq(200)
      expect(account.account_type).to eq(account_type)
      expect(account.account_owner).to eq(account_owner)
    end
  end
end