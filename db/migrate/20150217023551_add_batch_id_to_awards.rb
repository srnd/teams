class AddBatchIdToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :batch_id, :integer
  end
end
