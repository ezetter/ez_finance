class CreateAccountType < ActiveRecord::Migration
  def change
    create_table :account_types do |t|
      t.string :description, :null => false
    end

    add_column :accounts, :account_type_id, :integer

  end
end
