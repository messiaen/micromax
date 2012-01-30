class AddIndexingToTransactions < ActiveRecord::Migration
  def change
    add_index :transactions, :child_id
    add_index :transactions, :parent_id
    add_index :transactions, :date
  end
end
