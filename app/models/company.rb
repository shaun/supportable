class Company < ActiveRecord::Base
  validates_presence_of :name, :drop_name, :drop_token, :chat_password
  validates_uniqueness_of :name
  
  has_many :employees
  has_many :customer_service_reps
  has_one  :manager
  has_many :support_actions
  has_many :customer_visits
  
  DEFAULT_DROP_OPTIONS = {
    :guests_can_add => false,
    :guests_can_delete => false,
    :expiration_length => "1_YEAR_FROM_LAST_VIEW"
  }
  
  def counts_cache_key
    "company-#{self.id}-counts-cache-key"
  end
  
  def update_counts
    counts = {
      :self_help => self.customer_visits.self_help.count,
      :need_help => self.customer_visits.need_help.count,
      :help_arrived => self.customer_visits.help_arrived.count,
      :problem_solved => self.customer_visits.problem_solved.count 
    }
    CACHE.write(self.counts_cache_key,counts,:expires => 1.year.from_now)
  end
  
  def counts
    CACHE.get(self.counts_cache_key) || empty_counts
  end
  
  def empty_counts 
    counts = {
      :self_help => 0,
      :need_help => 0,
      :help_arrived => 0,
      :problem_solved => 0
    }
  end
  
  def self.dispatch_support_bot(customer_visit)
    # todo
  end
end
