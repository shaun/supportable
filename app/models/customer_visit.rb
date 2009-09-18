class CustomerVisit < ActiveRecord::Base
  validates_presence_of :company_id, :status
  
  belongs_to :company
  belongs_to :employee
  
  named_scope :self_help,      lambda { {:conditions => ["status = ?",Status::SELF_HELP], :order => "created_at ASC"}}
  named_scope :need_help,      lambda { {:conditions => ["status = ?",Status::NEED_HELP], :order => "needed_help_at ASC"}}
  named_scope :help_arrived,   lambda { {:conditions => ["status = ?",Status::HELP_ARRIVED], :order => "help_arrived_at ASC"}}
  named_scope :problem_solved, lambda { {:conditions => ["status = ?",Status::PROBLEM_SOLVED], :order => "problem_solved_at ASC"}}

  after_save :update_counts
  
  DEFAULT_DROP_OPTIONS = {
    :guests_can_add => false,
    :guests_can_delete => false,
    :expiration_length => "1_YEAR_FROM_LAST_VIEW"
  }
  
  module Status
    SELF_HELP = "self_help"
    NEED_HELP = "need_help"
    HELP_ARRIVED = "help_arrived"
    PROBLEM_SOLVED = "problem_solved"
  end
  
  def need_help!
    self.status = Status::NEED_HELP
    self.needed_help_at = Time.now
    self.save
  end
  
  def help_arrived!(employee)
    self.status = Status::HELP_ARRIVED
    self.help_arrived_at = Time.now
    self.employee = employee
    self.save
  end
  
  def problem_solved!
    self.status = Status::PROBLEM_SOLVED
    self.problem_solved_at = Time.now
    self.save
  end
  
  def update_counts
    self.company.update_counts
  end

end
