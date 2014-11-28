class CreateAccountOwner < ActiveRecord::Migration
  def change
    create_table :account_owners do |t|
      t.string :name, :null => false
      t.boolean :joint, :default => false
    end

    add_reference :accounts, :account_owner
  end
end
