require "rails_helper"

feature 'User updates an account' do
  scenario 'they visit the edit page' do
    account = Account.new(name: 'Test', value: 100, value_fractional: 0)
    account.save

    visit edit_account_path(account)
  end
end