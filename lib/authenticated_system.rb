module AuthenticatedSystem
  def authorize_employee
    fetch_company
    unauthorized and return if !session[:employee]
    @employee = session[:employee].reload
    unauthorized and return if @employee.company != @company
  end
  
  def authorize_manager
    fetch_company
    unauthorized and return if !session[:manager]
    @manager = @employee = session[:manager].reload
    unauthorized and return if @manager.company != @company
  end
  
  def authorize_customer
    fetch_company
    redirect_to company_landing_page_url(@company) and return unless session[:customer_visit]
    @customer_visit = session[:customer_visit].reload
    @drop_details = session=[:drop_details]
    redirect_to company_landing_page_url(@company) and return unless @company == @customer_visit.company
  end
  
  def unauthorized
    redirect_to login_url(:company_name => @company.name) and return
  end
  
  def fetch_company
    @company = Company.find_by_name(params[:company_name]) rescue nil
    redirect_to homepage_url and return unless @company
  end
end