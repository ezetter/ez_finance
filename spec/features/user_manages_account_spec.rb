require "rails_helper"

feature 'User manages an account' do
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

  scenario 'they create the account' do
    visit new_account_path
    fill_in "Name", :with => "Test2"
    fill_in "Value", :with => "200.50"
    fill_in "Date opened", :with => "2014-12-10"
    select('Brokerage')
    click_button "Save Account"
    expect(Account.first.name).to eq('Test2')
    expect(Account.first.value).to eq(200)
    expect(Account.first.value_fractional).to eq(50)
    expect(Account.first.account_type.description).to eq('Brokerage')
  end

  scenario 'they update the account' do
    account = Account.new(name: 'Test', value: 100, value_fractional: 0)
    account.save
    visit edit_account_path(account)
    fill_in "Name", :with => "Test2"
    fill_in "Value", :with => "200.50"
    fill_in "Date opened", :with => "2014-12-10"
    select('Brokerage')
    click_button "Save Account"
    expect(Account.first.name).to eq('Test2')
    expect(Account.first.value).to eq(200)
    expect(Account.first.value_fractional).to eq(50)
    expect(Account.first.account_type.description).to eq('Brokerage')
  end
end