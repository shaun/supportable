class SupportAction < ActiveRecord::Base
  validates_presence_of :description, :action_type, :company_id
    
  belongs_to :company
  has_many :support_options, :foreign_key => "parent_support_action_id", :dependent => :destroy
  
  named_scope :root, lambda { {:conditions => ["root = ?",true], :limit => 1} }
  
  START_OVER_COMMAND = "start over"
  DEFAULT_SUPPORT_BOT_NICK = "SupportBot"
  DEFAULT_SUPPORT_BOT_ERROR_RESPONSE = "Sorry, I did not understand that command. Please type one of the valid choices listed above."
  
  module Actions
    TEXT = "text"
    OPTIONS = "options"
    HELP = "help"
    ALL = [TEXT,OPTIONS,HELP]
  end
  
  DIV = "--------------------"
  LINE_BREAK = "<br />"
  
  def act(customer_visit)
    res = "#{LINE_BREAK}#{LINE_BREAK}#{self.description}"
    
    case self.action_type
    when Actions::TEXT
      # nothing else to do
    when Actions::OPTIONS
      res += "#{LINE_BREAK}#{DIV}#{LINE_BREAK}"
      opts = self.support_options
      opts.each do |opt|
        res += opt.full_text
        res += LINE_BREAK
      end
    when Actions::HELP
      customer_visit.need_help!
    end
    return res       
  end
  
end
