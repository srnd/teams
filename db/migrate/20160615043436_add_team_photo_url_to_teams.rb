class AddTeamPhotoUrlToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :team_photo_url, :string
  end
end
