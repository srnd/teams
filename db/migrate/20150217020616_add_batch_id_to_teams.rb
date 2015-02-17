class AddBatchIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :batch_id, :integer
  end
end
