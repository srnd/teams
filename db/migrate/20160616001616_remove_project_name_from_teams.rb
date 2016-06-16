class RemoveProjectNameFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :project, :string
  end
end
