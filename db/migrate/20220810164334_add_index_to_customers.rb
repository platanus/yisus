class AddIndexToCustomers < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :customers, :harvest_id, unique: true, algorithm: :concurrently
    add_index :customers, :bsale_id, unique: true, algorithm: :concurrently
    add_index :projects, :harvest_id, unique: true, algorithm: :concurrently
  end
end
