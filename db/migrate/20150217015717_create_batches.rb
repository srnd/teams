class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.string :name
      t.boolean :current

      t.timestamps
    end
  end
end
