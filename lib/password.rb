module Password
  
  def self.generate_salt
    ActiveSupport::SecureRandom.hex(32)
  end
  
  def self.generate_hash (plain_pass, salt)
    Digest::SHA512.hexdigest(plain_pass + salt)
  end
  
  def self.generate_store (plain_pass, salt)
    self.generate_hash(plain_pass, salt) + salt
  end
  
  def self.get_hash (store)
    store[0 .. 127]
  end
  
  def self.get_salt (store)
    store[128 .. 192]
  end
  
  def self.check_password (plain_pass, store)
    salt = self.get_salt(store)
    hash = self.get_hash(store)
    
    self.generate_hash(plain_pass, salt) == hash
  end
end