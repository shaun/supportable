require 'regex_library'
class Company < ActiveRecord::Base
  
  validates_presence_of :name, :url_name, :drop_name, :drop_token, :chat_password
  validates_uniqueness_of :name, :url_name
  validates_format_of :homepage, :with => RegexLibrary::URL
  
  
  has_many :employees, :dependent => :destroy
  has_many :customer_service_reps
  has_one  :manager
  has_many :support_actions, :dependent => :destroy
  has_many :customer_visits, :dependent => :destroy
  has_many :support_options, :through => :support_actions
  
  DEFAULT_DROP_OPTIONS = {
    :guests_can_add => false,
    :guests_can_delete => false,
    :expiration_length => "1_YEAR_FROM_LAST_VIEW"
  }
  
  DEFAULT_LANDING_PAGE_TEXT = "Welcome to Supportable! Here you will be able to get quick, realtime customer support. Click the button below to begin speaking with our intelligent customer service bot!"
  
  def name=(str)
    self[:name] = str
    self[:url_name] = str.gsub(/[^A-Za-z0-9]/,"")
  end
  
  def counts_cache_key
    "company-#{self.id}-counts-cache-key"
  end
  
  def update_counts
    #CACHE.get(self.counts_cache_key)
    #counts = {
    #  :self_help => self.customer_visits.self_help.count,
    #  :need_help => self.customer_visits.need_help.count,
    #  :help_arrived => self.customer_visits.help_arrived.count,
    #  :problem_solved => self.customer_visits.problem_solved.count 
    #}
    #CACHE.set(self.counts_cache_key,counts)
  end
  
  def counts
    #CACHE.get(self.counts_cache_key) || empty_counts
    counts = {
      :self_help => self.customer_visits.self_help.count,
      :need_help => self.customer_visits.need_help.count,
      :help_arrived => self.customer_visits.help_arrived.count,
      :problem_solved => self.customer_visits.problem_solved.count 
    }
  end
  
  def empty_counts 
    counts = {
      :self_help => 0,
      :need_help => 0,
      :help_arrived => 0,
      :problem_solved => 0
    }
  end
  
  def landing_page_welcome_text
    !self[:landing_page_welcome_text].blank? ? self[:landing_page_welcome_text] : Company::DEFAULT_LANDING_PAGE_TEXT
  end
  
  def support_bot_nick
    !self[:support_bot_nick].blank? ? self[:support_bot_nick] : SupportAction::DEFAULT_SUPPORT_BOT_NICK
  end
  
  def support_bot_error_response
    !self[:support_bot_error_response].blank? ? self[:support_bot_error_response] : SupportAction::DEFAULT_SUPPORT_BOT_ERROR_RESPONSE
  end
  
  def dispatch_support_bot(customer_visit)
    # TODO: this will need to eventually spawn support bot process via a farmer-like
    # infrastructure so as to be scalable in the future. for now, we just manually
    # spawn every process on this machine -- potentially disastrous
    
    system("ruby script/support_bot.rb start -- -e #{RAILS_ENV} -c #{self.id} -v #{customer_visit.id}")
  end
end
