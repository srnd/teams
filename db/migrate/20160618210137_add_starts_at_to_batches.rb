class AddStartsAtToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :starts_at, :datetime
  end
end
