class CreatePeopleAccounts < ActiveRecord::Migration
  def up
    create_table :people_accounts, :id => false do |t|
      t.integer :person_id
      t.integer :account_id
    end
  end

  def down
    drop_table :people_accounts
  end
end
