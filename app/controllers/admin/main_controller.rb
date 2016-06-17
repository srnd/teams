class Admin::MainController < ApplicationController
  before_filter :requires_admin
  # protect_from_forgery :except => [:inject]

  def index
    @title = "Admin Panel"
  end

  def event
    @title = "Change Managed Event"
  end

  def batch
    @title = "Change Current Batch"
  end

  def inject
    # please
    # http_get("codeday-teams-socket.herokuapp.com", "/eval", {:secret => "ASNCxi20fkSALc3kylf9", :command => params[:js]})
    redirect_to admin_root_path
  end

  def awards
    if current_batch.awards_shown then current_batch.update(:awards_shown => false) else current_batch.update(:awards_shown => true) end
    redirect_to admin_root_path
  end

  def set_batch
    current_batch.update(:current => false)
    Batch.find(params[:id]).update(:current => true)
    redirect_to admin_batch_path
  end

  def set_event
    current_user.update(:event_id => params[:id])
    redirect_to admin_event_path
  end

  def seed_awards
    awards = ["Top Overall", "Best App", "Best Game", "Special Award 1", "Special Award 2", "0-to-60"]
    # get all events
    Event.all.each do |event|
      # seed the awards
      awards.each do |award|
        Award.create(:batch => current_batch, :event_id => event.id, :name => award)
      end
    end
    redirect_to admin_root_path
  end

  def scramble
    @title = "Scrambled Teams"
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
