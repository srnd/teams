class AddNotesToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :notes, :string
  end
end
