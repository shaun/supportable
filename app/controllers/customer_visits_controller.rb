require 'authenticated_system'
require 'session_manager'
require 'helper_functions'

class CustomerVisitsController < ApplicationController
  include AuthenticatedSystem
  include SessionManager
  include HelperFunctions
  
  before_filter :fetch_company, :only => [:index, :init_customer_visit]
  before_filter :authorize_customer, :only => [:support]
  before_filter :authorize_manager, :only => [:show]
  
  DEFAULT_DROP_OPTIONS = {
    :guests_can_add => false,
    :guests_can_delete => false,
    :expiration_length => "1_YEAR_FROM_LAST_VIEW"
  }
  
  def index 
    render :layout => "homepage"
  end
  
  # ajax call
  def init_customer_visit
    render :json => {:success => false, :message => "need post"} and return unless request.post?
    
    drop = nil
    begin 
      drop = Dropio::Drop.create(CustomerVisit::DEFAULT_DROP_OPTIONS.merge(:admin_password => random_string(10)))
    rescue Exception => e
    end
    
    if drop
      drop_name = drop.name
      drop_pass = drop.admin_token
      chat_password = drop.chat_password
      
      drop_details = {
        :drop_name => drop_name, 
        :drop_token => drop_token, 
        :chat_password => chat_password
      }
      
      cv = @company.customer_visits.create!(drop_details)
      start_customer_session(@company,cv,drop_details)
      
      @company.dispatch_support_bot(cv)
            
      render :json => {:success => true}.to_json
    else
      render :json => {:success => false, :message => "drop creation failed"}
    end  
    
    return
  end
  
  def support
    # use the instance vars to init a drop chat using realtime js library
  end
  
  def show
    @counts = @company.counts
    # perhaps also show charts with time breakdowns eventually
  end
  
end
