class Integration::SlackController < Integration::MainController
  protect_from_forgery :except => [:update_token, :hook]

  def index
    @title = "Slack Integration"
    @team = current_user.current_team
  end

  def update_token
    current_user.current_team.update(:slack_token => params[:team][:slack_token])
    flash[:message] = "Token Updated"
    redirect_with_https integration_slack_path
  end
end
