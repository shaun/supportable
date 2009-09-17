require 'employee'

class Manager < Employee
  def manager? 
    true
  end
  
  def self.authenticate(email,password)
    Manager.first(:conditions => ["email = ? and password = ?", email, Digest::SHA1::hexdigest(password)])
  end
end