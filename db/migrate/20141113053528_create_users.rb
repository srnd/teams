class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.boolean :admin
      t.string :password
      t.integer :team_id

      t.timestamps
    end
  end
end
