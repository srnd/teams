class AddYearToBatch < ActiveRecord::Migration
  def change
    add_column :batches, :year, :integer
  end
end
