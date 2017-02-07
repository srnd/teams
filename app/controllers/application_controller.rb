class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method ([
    :current_user,
    :handle_errors,
    :current_batch,
    :current_teams,
    :current_awards,
    :current_user_team,
    :api_error,
    :api_success
  ])

  before_filter :init_og_tags

  def init_og_tags
    @open_graph = {
      :site_name => "CodeDay Showcase"
    }

    @twitter_card = {
      :site => "@StudentRND"
    }
  end

  def current_user
  	if session[:current_user_id]
      begin
    		User.find(session[:current_user_id])
      rescue
        session[:current_user_id] = nil
        flash[:message] = "You have been signed out due to an invalid session"
        nil
      end
  	else
  		nil
  	end
  end

  def api_error(message = "Generic Error")
    {
      :code => 401,
      :success => false,
      :message => message
    }
  end

  def api_success(hash = {})
    hash.merge({
      :code => 200,
      :success => true
    })
  end

  def handle_errors(messages)
    error = ""
    # this is safe. /s
    # TODO fix this thing, too
    if messages.is_a? Array then messages.each do |m| error += "#{m}<br>" end end
    error
  end

  def current_batch
    Batch.where(:current => true).first
  end

  def current_teams(query = [])
    query[:batch_id] = current_batch.id
    Team.where(query)
  end

  def current_user_team
    if current_user
      current_user.current_team
    else
      nil
    end
  end

  def current_awards(query = [])
    query[:batch_id] = current_batch.id
    Award.where(query)
  end

  private
    def check_legacy
      if current_user && current_user.legacy
        unless request.path == legacy_path || request.path == legacy_oauth_path
          redirect_to legacy_path
        end
      end
    end
end
