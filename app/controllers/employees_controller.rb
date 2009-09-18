require 'authenticated_system'
require 'session_manager'
require 'helper_functions'

class EmployeesController < ApplicationController
  include AuthenticatedSystem
  include SessionManager
  include HelperFunctions
  
  before_filter :authorize_employee, :only => [:employee_chat, :update_employee_info, :help_next_customer]
  before_filter :authorize_manager, :only => [:manager_index, :create_customer_service_rep]
  before_filter :fetch_company, :only => [:login]
  
  def signup
    render :layout => "default" and return unless request.post?
    
    if params[:manager][:password] != params[:password_confirmation]
      flash[:error] = "Passwords don't match."
      redirect_to signup_url and return
    end
    
    drop = nil
    begin
      drop = Dropio::Drop.create(Company::DEFAULT_DROP_OPTIONS.merge(:admin_password => random_string(10)))
    rescue Exception => e
      flash[:error] = "Error creating company chat room."
      redirect_to signup_url and return
    end
    
    begin
      Employee.transaction do
        @company = Company.new(params[:company]) 
        @company.drop_name = drop.name
        @company.drop_token = drop.admin_token
        @company.chat_password = drop.chat_password    
        @company.save!
        @manager = @company.create_manager(params[:manager])
        @manager.save!
      end
    rescue Exception => e
      flash[:error] = e.message
      render :layout => "default" and return
    end
    
    start_manager_session(@manager)
    redirect_to manager_index_url(@company.url_name) and return
  end
  
  def login
    render :layout => "default" and return unless request.post? && params[:email] && params[:password]
    
    if @csr = CustomerServiceRep.authenticate(params[:email],params[:password])
      start_employee_session(@csr)
      redirect_to employee_chat_url(@company.url_name) and return
    elsif @m = Manager.authenticate(params[:email],params[:password])
      start_manager_session(@m)
      redirect_to manager_index_url(:url_name => @company.url_name) and return
    else
      flash[:error] = "Login failed"
      redirect_to login_url(@company.url_name) and return
    end
    
  end
  
  def logout 
    end_all_sessions
    redirect_to homepage_url and return
  end
  
  def employee_chat
    @counts = @company.counts
    @drop_name = @company.drop_name
    @chat_password = @company.chat_password
    render :layout => "employees"
  end
  
  def help_next_customer
    @customer_visit = @company.customer_visits.need_help.first
    @customer_visit.help_arrived!(@employee) if @customer_visit
    render :layout => "employees"  
  end
  
  def create_customer_service_rep
    @reps = @company.customer_service_reps
    
    render :layout => "employees" and return unless request.post?
    
    temp_pass = random_string(10)
    rep = @company.customer_service_reps.new(params[:rep].merge(:password => temp_pass))
    
    if rep.save
      flash[:message] = "Representative Added."
      EmployeeMailer.deliver_customer_service_rep_created(@company,@manager,rep,temp_pass)
    else
      flash[:error] = "Error adding representative: #{rep.errors.full_messages.join(",")}"
    end

    render :layout => "employees" and return
  end
  
  def update_employee_info
    render :layout => "employees" and return unless request.post?
    
    params[:employee].delete_if { |p| p.blank? }
    params[:employee].delete(:password) if params[:employee][:password].blank?
    params.delete(:password_confirmation) if params[:password_confirmation].blank?
      
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
    
    redirect_to update_employee_info_url(@company.url_name) and return
  end
  
  def manager_index
    @counts = @company.counts
    render :layout => "employees"
  end
  
end
