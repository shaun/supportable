require 'employee'

class CustomerServiceRep < Employee
  def rep?
    true
  end  
  
  def self.authenticate(email,password)
    CustomerServiceRep.first(:conditions => ["email = ? and password = ?", email, Digest::SHA1::hexdigest(password)])
  end

end