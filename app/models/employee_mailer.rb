class EmployeeMailer < ActionMailer::Base
  SUPPORTABLE_FROM_ADDRESS = "support@supportable.com"
  
  def customer_service_rep_created(company,manager,rep,password)
    recipients rep.email
    from SUPPORTABLE_FROM_ADDRESS
    subject "Your manager would like you to log on to supportable.com"
    body :manager => manager, :rep => rep, :company => company, :password => password
  end
end
