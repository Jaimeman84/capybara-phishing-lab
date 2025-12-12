class CreateThreatScores < ActiveRecord::Migration[7.1]
  def change
    create_table :threat_scores do |t|
      t.references :email, null: false, foreign_key: true, index: { unique: true }
      t.integer :score, null: false
      t.string :risk_level, null: false
      t.datetime :calculated_at, null: false

      t.timestamps
    end

    add_index :threat_scores, :risk_level
  end
end
