class AddVolunteerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :volunteer, :boolean
  end
end
