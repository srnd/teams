class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end
end
