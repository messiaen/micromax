class Category < ActiveRecord::Base
  has_many :transactions
  has_and_belongs_to_many :profiles, :join_table => :categories_profiles
  
  validates_presence_of :name
  validates_presence_of :internal_name
  validates_presence_of :kind
end
