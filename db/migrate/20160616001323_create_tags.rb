class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :text
      t.string :thumbnail_url
      t.text :description

      t.timestamps null: false
    end
  end
end
