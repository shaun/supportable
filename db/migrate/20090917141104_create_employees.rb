class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.integer :company_id
      t.string :employee_type

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
