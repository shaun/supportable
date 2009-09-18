class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :url_name
      t.string :drop_name
      t.string :drop_token
      t.string :chat_password
      t.string :support_bot_nick
      t.string :support_bot_error_response
      t.text :landing_page_welcome_text
      t.string :homepage

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
