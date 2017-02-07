class AddIsPresentingToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :is_presenting, :boolean
  end
end
