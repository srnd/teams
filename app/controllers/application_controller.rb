class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :handle_errors, :ctf_hook, :http_get

  def http_get(domain, path, params)
    return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
    return Net::HTTP.get(domain, path)
  end

  def current_user
  	if session[:current_user_id]
  		return User.find(session[:current_user_id])
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
end
