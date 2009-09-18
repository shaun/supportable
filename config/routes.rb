ActionController::Routing::Routes.draw do |map|
  
  # support actions controller
  map.update_support_bot_behavior ':url_name/manager/update_support_bot', :controller => "support_actions", :action => "update_support_bot_behavior"
  
  # employees controller
  map.signup 'signup', :controller => "employees", :action => "signup"
  map.login ':url_name/employees/login', :controller => "employees", :action => "login"
  map.logout ':url_name/employees/logout', :controller => "employees", :action => "logout"
  map.help_next_customer ':url_name/employees/assist', :controller => "employees", :action => "help_next_customer"
  map.employee_chat ':url_name/employees', :controller => "employees", :action => "employee_chat"
  map.update_employee_info ':url_name/employees/update', :controller => "employees", :action => "update_employee_info"
  map.manager_index ':url_name/manager', :controller => "employees", :action => "manager_index"
  map.create_customer_service_rep ':url_name/manager/employees', :controller => "employees", :action => "create_customer_service_rep"
  
  # customer visits controller
  map.company_landing_page ':url_name', :controller => "customer_visits", :action => "index"
  map.init_customer_visit ':url_name/init_support', :controller => "customer_visits", :action => "init_customer_visit"
  map.support ':url_name/support', :controller => "customer_visits", :action => "support"
  map.show_customer_visits ':url_name/manager/visits', :controller => "customer_visits", :action => "show"
  
  # companies controller
  map.update_company_info ':url_name/details', :controller => "companies", :action => "update_company_info"
  map.get_counts ':url_name/counts', :controller => "companies", :action => "get_counts"
   
  # homapage
  map.homepage '', :controller => 'companies', :action => 'index', :conditions => { :method => :get }
end
