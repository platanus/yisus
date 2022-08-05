class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.integer :harvest_id, null: false
      t.integer :bsale_id, null: false

      t.timestamps
    end
  end
end
