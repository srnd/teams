class AddProjectToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :project, :string
  end
end
