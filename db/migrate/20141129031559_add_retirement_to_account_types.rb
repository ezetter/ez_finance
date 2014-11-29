class AddRetirementToAccountTypes < ActiveRecord::Migration
  def change
    add_column :account_types, :retirement, :boolean, :default => false
  end
end
