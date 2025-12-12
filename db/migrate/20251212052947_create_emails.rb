class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :emails do |t|
      t.string :sender_email, null: false
      t.string :sender_name, null: false
      t.string :recipient_email, null: false
      t.string :subject, null: false
      t.text :body_html
      t.text :body_plain, null: false
      t.datetime :received_at, null: false
      t.boolean :is_phishing, default: false
      t.string :phishing_type

      t.timestamps
    end

    add_index :emails, :sender_email
    add_index :emails, :received_at
    add_index :emails, :is_phishing
  end
end
