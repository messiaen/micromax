class CreateCategoriesProfiles < ActiveRecord::Migration
  def up
    create_table :categories_profiles, :id => false do |t|
      t.integer :category_id
      t.integer :profile_id
    end
  end

  def down
    drop_table :categories_profiles
  end
end
