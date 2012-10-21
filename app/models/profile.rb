class Profile < ActiveRecord::Base
  belongs_to :account
  belongs_to :person
  
  has_and_belongs_to_many :categories, :join_table => :categories_profiles
  
  validate :single_admin
  
  
  def single_admin
    if self.is_admin && Profile.where(:is_admin => true).size > 0
      self.errors.add(:is_admin, "Only one user may be the admin")
    end
  end
  
end
