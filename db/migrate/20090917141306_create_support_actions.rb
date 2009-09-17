class CreateSupportActions < ActiveRecord::Migration
  def self.up
    create_table :support_actions do |t|
      t.text :description
      t.string :action_type
      t.integer :company_id
      t.boolean :root

      t.timestamps
    end
  end

  def self.down
    drop_table :support_actions
  end
end
