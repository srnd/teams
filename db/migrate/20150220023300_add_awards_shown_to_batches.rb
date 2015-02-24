class AddAwardsShownToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :awards_shown, :boolean
  end
end
