require 'authenticated_system'
require 'session_manager'

class EmployeesController < ApplicationController
  include AuthenticatedSystem
  include SessionManager
  
  before_filter :authorize_employee, :only => [:employee_chat, :update_employee_info, :help_next_customer]
  before_filter :authorize_manager, :only => [:manager_index]
  before_filter :fetch_company => :only => [:login]
  
  def signup
    return unless request.post?
    
    drop = nil
    begin
      drop = Dropio::Drop.create(Company::DEFAULT_DROP_OPTIONS.merge(:admin_password => random_string(10)))
    rescue Exception => e
      flash[:error] = "Error creating company chat room."
      redirect_to signup_url and return
    end
  
    if params[:manager][:password] != [:password_confirmation]
      flash[:error] = "Passwords don't match."
      redirect_to signup_url and return
    end
    
    begin
      Employee.transaction do
        @company = Company.new(params[:company]) 
        @company.drop_name = drop.name
        @company.drop_token = drop.admin_token
        @company.chat_password = drop.chat_password    
        @company.save!
        @manager = @company.create_manager(params[:manager])
        @manager.save!
      end
    rescue Exception => e
      flash[:error] = e.message
      redirect_to signup_url and return
    end
    
    start_manager_session(@manager)
    redirect_to manager_index_url(:company_name => @company.name) and return
  end
  
  def login
    return unless request.post? && params[:email] && params[:password]
    
    if @csr = CustomerServiceRep.authenticate(params[:email],params[:password])
      start_employee_session(@csr)
      redirect_to employee_chat_url(:company_name => @company.name) and return
    elsif @m = Manager.authenticate(params[:email],params[:password])
      start_manager_session(@m)
      redirect_to manager_index_url(:company_name => @company.name) and return
    else
      flash[:error] = "Login failed"
      redirect_to login_url(:company_name => @company.name) and return
    end
    
  end
  
  def logout 
    end_all_sessions
    redirect_to hompage_url and return
  end
  
  def employee_chat
    @counts = @company.counts
    # meeting ground for employees
    # init a drop chat with js library
  end
  
  def help_next_customer
    @customer_visit = @company.customer_visits.need_help.first
    @customer_visit.help_arrived!(@employee)
    # connect to same chat room as are in the customer visit model  
  end
  
  def update_employee_info
    return unless request.post?
    
    params[:employee].delete_if { |p| p.blank? }
    params[:password_confirmation] = nil if params[:password_confirmation].blank?
    
    if params[:employee][:password] != params[:password_confirmation]
      flash[:error] = "Passwords do not match"
    else
      @employee.attributes = @employee.attributes.merge(params[:employee])
      @employee.company = @company
      
      if @employee.save
        flash[:message] = "Account info updated"
      else
        flash[:error] = @employee.errors.full_messages.join(",")
      end
    end
    
    redirect_to update_employee_info_url(:company_name => @company.name) and return
  end
  
  def manager_index
    @counts = @company.counts
    # show counts with nav bar to update employee info, update company info, update ai behavior
  end
  
end
