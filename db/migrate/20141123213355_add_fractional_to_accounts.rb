class AddFractionalToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :value_fractional, :integer
  end
end
