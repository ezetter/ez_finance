class AddIndexToAccountHistoryAccountId < ActiveRecord::Migration
  def change
    add_index :account_history, :account_id
  end
end
