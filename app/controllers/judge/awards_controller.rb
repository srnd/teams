class Judge::AwardsController < Judge::MainController
  def show
    @award = Award.find(params[:id])
    @title = "Selecting Team for #{@award.name}"
  end

  def update
    @award = Award.find(params[:id])
    @award.update(:team_id => params[:award][:team_id], :notes => params[:award][:notes])
    redirect_to judge_root_path
  end
end
