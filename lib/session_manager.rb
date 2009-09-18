module SessionManager
  def start_manager_session(manager)
    end_all_sessions
    session[:manager] = manager
    session[:employee] = manager
  end
  
  def start_employee_session(customer_service_rep)
    end_all_sessions
    session[:employee] = customer_service_rep
  end
  
  def start_customer_session(customer_visit,drop_details)
    end_all_sessions
    session[:customer_visit] = customer_visit
    session[:drop_details] = drop_details
  end
  
  def end_all_sessions
    session[:manager] = nil
    session[:employee] = nil
    session[:customer_visit] = nil
    session[:drop_details] = nil
  end
  
end