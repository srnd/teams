class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method ([
    :current_user,
    :handle_errors,
    :ctf_hook,
    :current_batch,
    :current_teams,
    :current_awards,
    :current_user_team,
    :redirect_with_https,
    :api_error,
    :api_success
  ])
  before_filter :cloudflare_https
  before_filter :check_legacy

  def current_user
  	if session[:current_user_id]
      begin
    		User.find(session[:current_user_id])
      rescue
        session[:current_user_id]
        flash[:message] = "You have been signed due to an invalid session"
        nil
      end
  	else
  		nil
  	end
  end

  def api_error(message = "Generic Error")
    {
      :success => false,
      :message => message
    }
  end

  def api_success(hash = {})
    hash.merge({
      :success => true
    })
  end

  def handle_errors(messages)
    error = ""
    if messages.is_a? Array then messages.each do |m| error += "#{m}<br>" end end
    return error
  end

  def ctf_hook(params)
    params[:secret] = "R9HvxvTn3OuwmrHVpNRx4RmDuPsOKU9ceVqp5pq0nRxOn9J7CqFy8ULpre1Q"
    return JSON.parse(http_get("ctf.codeday.org", "/teamhook", params))
  end

  def current_batch
    return Batch.where(:current => true).first
  end

  def current_teams(query = [])
    query[:batch_id] = current_batch.id
    return Team.where(query)
  end

  def current_user_team
    if current_user
      return current_user.current_team
    else
      return nil
    end
  end

  def current_awards(query = [])
    query[:batch_id] = current_batch.id
    return Award.where(query)
  end

  def redirect_with_https(path)
    if Rails.env.production?
      redirect_to path, :protocol => "https://"
    else
      redirect_to path
    end
  end

  private
    def check_legacy
      if current_user && current_user.legacy
        unless request.path == legacy_path || request.path == legacy_oauth_path
          redirect_to legacy_path
        end
      end
    end

    def cloudflare_https
      if Rails.env.production?
        visitor = JSON.parse(request.headers["CF-Visitor"])
        if visitor["scheme"] == "http"
          redirect_to :protocol => "https://"
        end
      end
    end
end
