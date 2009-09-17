require 'authenticated_system'

class CompaniesController < ApplicationController
  include AuthenticatedSystem
  
  before_filter :authenticate_employee, :only => [:get_counts]
  before_filter :authorize_manager, :only => [:update_company_info]
  
  def index
    # homepage
  end
  
  def update_company_info
    return unless request.post?
    
    params[:company].delete_if { |k,v| [:drop_name,:drop_pass,:stream_key].include?(k) }
    
    @company.attributes = @company.attributes.merge(params[:company])
    
    if @company.save
      flash[:message] = "Company info updated"
    else
      flash[:error] = @company.errors.full_messages.join(",")
    end
    
    redirect_to update_company_info_url(:company_name => @company.name) and return
  end
  
  def get_counts
    return unless request.post?
    render :json => @company.counts.to_json
    return
  end
  
  

end
