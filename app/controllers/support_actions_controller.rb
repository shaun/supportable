require 'authenticated_system'

class SupportActionsController < ApplicationController
  include AuthenticatedSystem
  
  before_filter :authorize_manager
  
  def update_support_bot_behavior
    @support_actions = @company.support_actions
    
    render :layout => "employees"
  end
  
  def update_support_bot_config
    redirect_to update_support_bot_behavior_url(@company.url_name) and return unless request.post?
    
    @company.support_bot_nick = params[:support_bot_nick]
    @company.support_bot_error_response = params[:support_bot_error_response]
    
    if @company.save
      flash[:message] = "Support Bot name and error response updated."
    else
      flash[:error] = "There was a problem updating the support bot's configuration."
    end
    
    redirect_to update_support_bot_behavior_url(@company.url_name) and return
  end
  
  def create_support_action
    redirect_to update_support_bot_behavior_url(@company.url_name) and return unless request.post?
    
    root_action = @company.support_actions.root
    
    sa = @company.support_actions.new(params[:support_action].merge(:root => root_action.nil? )) 
   
    if sa.save
      flash[:message] = "Support Action Created"
    else
      flash[:error] = "There was a problem saving that support action: #{sa.errors.full_messages.join(",")}"
    end
    
    redirect_to update_support_bot_behavior_url(@company.url_name) and return
  end
  
  def create_support_option
    redirect_to update_support_bot_behavior_url(@company.url_name) and return unless request.post?
    
    parent_support_action = @company.support_actions.find(params[:support_option][:parent_support_action_id])
    target_support_action = @company.support_actions.find(params[:support_option][:target_support_action_id])
    
    if !parent_support_action || !target_support_action
      flash[:error] = "Invalid support action IDs"
    else
      so = parent_support_action.support_options.new(params[:support_option]) 
    
      if so.save
        flash[:message] = "Support Option Created"
      else
        flash[:error] = "There was a problem saving that support option: #{so.errors.full_messages.join(",")}"
      end
    end
    
    redirect_to update_support_bot_behavior_url(@company.url_name) and return
  end
end
