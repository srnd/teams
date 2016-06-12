class AddExtraToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :extra, :text
  end
end
