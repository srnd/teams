class Volunteer::MainController < ApplicationController
  before_filter :requires_volunteer

  def index
    @title = "Volunteer"
  end

  private
    def requires_volunteer
      if current_user && current_user.volunteer
        true
      else
        redirect_to root_path
      end
    end
end
