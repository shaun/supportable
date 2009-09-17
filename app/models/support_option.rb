class SupportOption < ActiveRecord::Base
  validates_presence_of :parent_support_action_id, :control, :description, :target_support_action_id
  
  belongs_to :parent_support_action, :class_name => "SupportAction"
  belongs_to :target_support_action, :class_name => "SupportAction"
  
  SEPARATOR = ") "
  
  def full_text
    "#{self.control}#{SEPARATOR}#{self.description}"
  end
end
