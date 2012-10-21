class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :person_id
      t.boolean :is_admin
      t.integer :account_id

      t.timestamps
    end
  end
end
