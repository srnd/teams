class Admin::MainController < ApplicationController
  before_filter :requires_admin

  def index
    @title = "Admin Panel"
  end

  def set_batch
    current_batch.update(:current => false)
    Batch.find(params[:id]).update(:current => true)
    redirect_to admin_root_path
  end

  def set_event
    current_user.update(:event_id => params[:id])
    redirect_to admin_root_path
  end

  def scramble
    @teams = current_teams(:event_id => current_user.event_id).order("RANDOM()")
    @names = []
    @teams.each do |t|
      @names.push(t.name)
    end
  end

  private
    def requires_admin
      if current_user && current_user.admin
        return true
      else
        redirect_to root_path
      end
    end
end
