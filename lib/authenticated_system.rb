module AuthenticatedSystem
  def authorize_employee
    return if !fetch_company
    unauthorized and return if session[:employee].blank?
    @employee = session[:employee].reload
    unauthorized and return if @employee.company_id != @company.id
  end
  
  def authorize_manager
    return if !fetch_company
    unauthorized and return if !session[:manager]
    @manager = @employee = session[:manager].reload
    unauthorized and return if @manager.company_id != @company.id
  end
  
  def authorize_customer
    return if !fetch_company
    redirect_to company_landing_page_url(@company.url_name) and return unless session[:customer_visit]
    @customer_visit = session[:customer_visit].reload
    @drop_details = session[:drop_details]
    redirect_to company_landing_page_url(@company.url_name) and return unless @company.id == @customer_visit.company_id
  end
  
  def unauthorized
    redirect_to login_url(@company.url_name) and return
  end
  
  def fetch_company
    @company = Company.find_by_url_name(params[:url_name]) rescue nil
    redirect_to homepage_url and return false unless @company
    return true
  end
end