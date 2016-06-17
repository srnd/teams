class Judge::AwardsController < Judge::MainController
  def show
    @award = Award.find(params[:id])
    @title = "Selecting Team for #{@award.name}"
  end

  def new
    @title = "Create Award"
    @award = Award.new
  end

  def create
    award = Award.create(params.require(:award).permit(:name, :description).merge({
      :event => current_user.event,
      :batch => current_batch
    }))
    redirect_to judge_root_path
  end

  def update
    @award = Award.find(params[:id])
    @award.update(:team_id => params[:award][:team_id], :notes => params[:award][:notes])
    redirect_to judge_root_path
  end
end
