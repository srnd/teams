class AddBatchIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :batch_id, :integer
  end
end
