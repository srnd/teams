class RemoveRegionWebnameFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :region_webname, :string
  end
end
