class DropTableTeamsUsers < ActiveRecord::Migration
  def change
    drop_table :teams_users
  end
end
