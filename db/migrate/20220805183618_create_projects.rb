class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.integer :harvest_id, null: false
      t.float :unit_price, null: false
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
