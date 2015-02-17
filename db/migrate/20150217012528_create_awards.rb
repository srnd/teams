class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.integer :team_id
      t.text :description

      t.timestamps
    end
  end
end
