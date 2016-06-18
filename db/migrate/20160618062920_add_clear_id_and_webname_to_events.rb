class AddClearIdAndWebnameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :clear_id, :string
    add_column :events, :webname, :string
  end
end
