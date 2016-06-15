class AddProjectDescriptionToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :project_description, :text
  end
end
