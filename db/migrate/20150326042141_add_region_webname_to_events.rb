class AddRegionWebnameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :region_webname, :string
  end
end
