class AddRawValueToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :raw_value, :string
  end
end
