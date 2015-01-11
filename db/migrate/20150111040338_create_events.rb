class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :city

      t.timestamps
    end
  end
end
