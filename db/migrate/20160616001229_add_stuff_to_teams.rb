class AddStuffToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :youtube_url, :string
    add_column :teams, :short_description, :string
    add_column :teams, :download_url, :string
    add_column :teams, :website_url, :string
  end
end
