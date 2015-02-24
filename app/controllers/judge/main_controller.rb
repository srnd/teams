class Judge::MainController < ApplicationController
  before_filter :requires_judge

  def index
    @title = "Judge Panel"
  end

  private
    def requires_judge
      if current_user && current_user.judge
        return true
      else
        redirect_with_https root_path
      end
    end
end
