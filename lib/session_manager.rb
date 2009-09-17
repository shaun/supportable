module SessionManager
  def start_manager_session(manager)
    session[:manager] = manager
    session[:employee] = manager
  end
  
  def start_employee_session(customer_service_rep)
    session[:employee] = customer_service_rep
  end
  
  def start_customer_session(customer_visit,drop_details)
    session[:customer_visit] = customer_visit
    session[:drop_details] = drop_details
  end
end