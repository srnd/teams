class Judge::AwardsController < Judge::MainController
  def show
    @award = Award.find(params[:id])
    @title = "Selecting Team for #{@award.name}"
  end
end
