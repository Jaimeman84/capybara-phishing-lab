class CreatePhishingIndicators < ActiveRecord::Migration[7.1]
  def change
    create_table :phishing_indicators do |t|
      t.references :email, null: false, foreign_key: true
      t.string :indicator_type, null: false
      t.string :severity, null: false
      t.text :description, null: false
      t.text :details

      t.timestamps
    end

    add_index :phishing_indicators, [:indicator_type, :severity]
  end
end
