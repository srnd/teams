class RemoveSlackStuffFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :slack_token, :string
    remove_column :teams, :slack_webhook_url, :string
  end
end
