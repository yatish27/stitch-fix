class AddCompleteToClearanceBatch < ActiveRecord::Migration
  def change
    add_column :clearance_batches, :complete, :boolean, null: false, default: false
  end
end
