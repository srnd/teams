class AddAppidToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :appid, :string
  end
end
