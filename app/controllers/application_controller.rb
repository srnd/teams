class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :handle_errors, :ctf_hook, :http_get, :current_batch, :current_teams, :current_awards, :current_user_team
  before_filter :check_legacy

  def http_get(domain, path, params)
    return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
    return Net::HTTP.get(domain, path)
  end

  def current_user
  	if session[:current_user_id]
      begin
    		return User.find(session[:current_user_id])
      rescue
        session[:current_user_id]
        flash[:message] = "You have been signed due to an invalid session"
        return nil
      end
  	else
  		return nil
  	end
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

  private
    def check_legacy
      if current_user && current_user.legacy
        unless request.path == legacy_path || request.path == legacy_oauth_path
          redirect_to legacy_path
        end
      end
    end
end
