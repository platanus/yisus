class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.integer :bsale_id, null: false
      t.string :url, null: false
      t.references :time_report, null: false, foreign_key: true

      t.timestamps
    end
    add_index :documents, :bsale_id, unique: true
  end
end
