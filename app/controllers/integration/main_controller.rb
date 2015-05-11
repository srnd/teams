class Integration::MainController < ApplicationController
  before_filter :require_team

  def index
    redirect_with_https root_path
    @title = "Team Integrations"
  end

  private
    def require_team
      unless current_user && current_user.current_team
        redirect_with_https root_path
      end
    end
end
