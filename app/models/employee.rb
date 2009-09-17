require 'regex_library'
require 'digest/sha1'

class Employee < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :password, :company_id
  validates_format_of :email, :with => RegexLibrary::EMAIL
  
  belongs_to :company

  set_inheritance_column("employee_type")
    
  def manager?
    false
  end
  
  def rep?
    false
  end
  
  def password=(pw) 
    self[:password] = Digest::SHA1.hexdigest(pw)
  end
end
