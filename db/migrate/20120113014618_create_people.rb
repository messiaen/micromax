class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
