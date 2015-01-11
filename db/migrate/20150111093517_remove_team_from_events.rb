class RemoveTeamFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :team_id, :integer
  end
end
