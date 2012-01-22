class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :date
      t.float :amount
      t.float :account_balance
      t.string :description
      t.integer :category_id
      t.integer :account_id
      t.integer :person_id
      t.integer :child_id
      t.integer :parent_id
      t.string :type

      t.timestamps
    end
  end
end
