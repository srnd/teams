class AddProjectUrlToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :project_url, :string
  end
end
