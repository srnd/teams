class CreateTeamsUsers < ActiveRecord::Migration
  def change
    drop_table :teams_users

    create_join_table :teams, :users, column_options: {null: true} do |t|
      t.index [:team_id, :user_id]
      t.index [:user_id, :team_id]
    end
  end
end
