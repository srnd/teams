class Integration::SlackController < Integration::MainController
  protect_from_forgery :except => [:update_token, :hook]

  def index
    redirect_with_https root_path
    @title = "Slack Integration"
    @team = current_user.current_team
  end

  def update_token
    team = current_user.current_team
    team.slack_webhook_url ||= params[:team][:slack_webhook_url]
    team.slack_token ||= params[:team][:slack_token]
    team.save
    flash[:message] = "Slack updated"
    redirect_with_https integration_slack_path
  end
end
