class RemoveBatchIdFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :batch_id, :string
  end
end
