ActionController::Routing::Routes.draw do |map|
  
  # support actions controller
  map.update_support_bot_behavior ':company_name/manager/update_support_bot', :controller => "employees", :action => "update_support_bot_behavior"
  
  # employees controller
  map.signup 'signup', :controller => "employees", :action => "signup"
  map.login ':company_name/employees/login', :controller => "employees", :action => "login"
  map.logout ':company_name/employees/logout', :controller => "employees", :action => "logout"
  map.help_next_customer ':company_name/employees/assist', :controller => "employees", :action => "help_next_customer"
  map.employee_chat ':company_name/employees', :controller => "employees", :action => "employee_chat"
  map.update_employee_info ':company_name/employees/update', :controller => "employees", :action => "update_employee_info"
  map.manager_index ':company_name/manager', :controller => "employees", :action => "manager_index"
  
  # customer visits controller
  map.company_landing_page ':company_name', :controller => "customer_visits", :action => "index"
  map.init_customer_visit ':company_name/init_support', :controller => "customer_visits", :action => "init_customer_visit"
  map.support ':company_name/support', :controller => "customer_visits", :action => "support"
  map.show_customer_visits ':company_name/manager/visits', :controller => "customer_visits", :action => "show"
  
  # companies controller
  map.update_company_info ':company_name/details', :controller => "companies", :action => "update_company_info"
  map.get_counts ':company_name/counts', :controller => "companies", :action => "get_counts"
   
  # homapage
  map.homepage '', :controller => 'companies', :action => 'index', :conditions => { :method => :get }
end
