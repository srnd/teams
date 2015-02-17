class AddEventIdToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :event_id, :integer
  end
end
