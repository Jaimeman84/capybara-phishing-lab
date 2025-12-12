class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :email, null: false, foreign_key: true, index: { unique: true }
      t.datetime :reported_at, null: false

      t.timestamps
    end
  end
end
