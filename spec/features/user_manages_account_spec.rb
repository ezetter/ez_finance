require "rails_helper"

feature 'User updates an account' do
  before :each do
    DatabaseCleaner.clean
    Rails.application.load_seed
  end

  scenario 'they visit the new account page' do
    visit new_account_path
    expect(page).to have_title("Create Account")
  end

  scenario 'they visit the edit page' do
    account = Account.new(name: 'Test', value: 100, value_fractional: 0)
    account.save

    visit edit_account_path(account)
    expect(page).to have_title("Edit Account")
  end

  scenario 'the update the account' do
    account = Account.new(name: 'Test', value: 100, value_fractional: 0)
    account.save
    visit edit_account_path(account)
    fill_in "Name", :with => "Test2"
    fill_in "Value", :with => "200.50"
    fill_in "Date opened", :with => "2014-12-10"
    click_button "Save Account"
  end
end