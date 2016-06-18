class Volunteer::TeamsController < Volunteer::MainController
  def index
    @title = "Teams"
    @teams = Team.where(:event => current_user.event, :batch => current_batch)
  end

  def edit
    # this nice WHERE query lets us not do a bunch of validation afterwards...
    @team = Team.where(:event => current_user.event, :batch => current_batch).find(params[:id])
    @title = "Edit Team \"#{@team.name}\""
  end

  def update
    team = Team.where(:event => current_user.event, :batch => current_batch).find(params[:id])
    team.update(params.require(:team).permit(:name, :short_description, :project_description, :youtube_url, :download_url, :website_url, tag_ids: []))
    redirect_to volunteer_teams_path
  end
end
