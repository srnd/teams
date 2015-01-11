class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :handle_errors

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
end
