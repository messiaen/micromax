class AddTypeToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :type, :string
  end
  
  def down
    remove_column :accounts, :type
  end
end
