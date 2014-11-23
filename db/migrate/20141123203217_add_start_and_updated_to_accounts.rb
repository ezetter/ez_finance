class AddStartAndUpdatedToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :start_date, :date
    add_column :accounts, :updated, :date
  end
end
