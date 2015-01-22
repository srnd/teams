class AddSecretToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :secret, :string
  end
end
