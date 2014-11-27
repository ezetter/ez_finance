class CreateAccountHistory < ActiveRecord::Migration
  def change
    create_table :account_history do |t|
      t.belongs_to :account
      t.decimal :historical_value
      t.date :date_changed
    end
  end
end
