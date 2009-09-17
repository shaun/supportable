class CreateCustomerVisits < ActiveRecord::Migration
  def self.up
    create_table :customer_visits do |t|
      t.integer :company_id
      t.string :status
      t.datetime :needed_help_at
      t.datetime :help_arrived_at
      t.datetime :problem_solved_at
      t.string :drop_name
      t.string :drop_token
      t.string :chat_password
      t.integer :employee_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_visits
  end
end
