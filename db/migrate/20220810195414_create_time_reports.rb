class CreateTimeReports < ActiveRecord::Migration[6.1]
  def change
    create_table :time_reports do |t|
      t.date :from, null: false
      t.date :to, null: false
      t.float :billable_hours, null: false
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
