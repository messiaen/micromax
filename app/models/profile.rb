class Profile < ActiveRecord::Base
  belongs_to :account
  belongs_to :person
  
  has_and_belongs_to_many :categories, :join_table => :categories_profiles
end
