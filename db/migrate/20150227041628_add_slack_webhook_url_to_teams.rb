class AddSlackWebhookUrlToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :slack_webhook_url, :string
  end
end
