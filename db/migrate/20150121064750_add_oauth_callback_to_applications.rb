class AddOauthCallbackToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :oauth_callback, :string
  end
end
