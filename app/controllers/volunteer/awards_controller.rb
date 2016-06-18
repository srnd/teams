class Volunteer::AwardsController < Volunteer::MainController
  def index
    @title = "Awards"
    @awards = Award.where(:event => current_user.event)
  end
end
