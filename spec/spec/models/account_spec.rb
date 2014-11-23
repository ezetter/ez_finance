require "rails_helper"

RSpec.describe Account, :type => :model do
  it 'creates the account' do
    account = Account.create!(name: 'Big Bank', value: 1000)
    expect(Account.all).to eq([account])
  end
end