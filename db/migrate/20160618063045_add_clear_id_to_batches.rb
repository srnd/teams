class AddClearIdToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :clear_id, :string
  end
end
