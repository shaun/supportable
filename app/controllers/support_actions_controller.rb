require 'authenticated_system'

class SupportActionsController < ApplicationController
  include AuthenticatedSystem
  
  before_filter :authorize_manager
  
  def update_support_bot_behavior
    @root_action = @company.support_actions.root
    
    render :layout => "employees" and return unless request.post?
    
    begin
      ActiveRecord::Base.transaction do 
        @company.support_actions.destroy_all
        
        support_actions = {}
        
        # create all support actions
        params[:support_action].each do |sah|
          sa = @company.support_actions.create!(sah)
          sa.company = @company
          sa.root = true if sah[:root].to_s == "true"
          support_actions[sah[:dom_id]] = sah
        end
        
        # now create the support options
        params[:support_action].each do |sah|
          next if sah[:status] != SupportAction::Actions::OPTIONS || !sah[:support_option]
          psa = support_actions[sah[:dom_id]]
          sah[:support_option].each do |soh|
            tsa = support_actions[soh[:target_action_dom_id]]
            SupportOption.create!(:parent_support_action_id => psa.id, 
                                  :control => soh[:control], 
                                  :description => soh[:description],
                                  :target_support_action_id => tsa.id )
          end
        end
      end
      
      flash[:message] = "Successfully updated support behavior"
    rescue Exception => e
      flash[:error] = e.message
    end
    
    redirect_to update_support_bot_behavior(@company.url_name) and return
  end
end
