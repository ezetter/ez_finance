class RenameAccountStartOpened < ActiveRecord::Migration
  def change
    rename_column :accounts, :start_date, :date_opened
  end
end
