class UsersController < ApplicationController
	def login
		if params[:appid]
			@application = Application.where(:appid => params[:appid]).first || nil
			session[:app_intent] = params[:appid]
			if current_user
				token = Token.token_for(@application, current_user)
				redirect_to "#{@application.oauth_callback}?access_token=#{CGI::escape(token.access_token)}"
			end
			@s5_sso_url = "https://s5.studentrnd.org/oauth/qgoZfHW1vcb9yZarnAvOeQOyk5uBBzrU?return=http://#{request.host_with_port}/oauth/s5#{CGI::escape("?appid=#{params[:appid]}")}"
		else
			if current_user then redirect_to root_path end
			@s5_sso_url = "https://s5.studentrnd.org/oauth/qgoZfHW1vcb9yZarnAvOeQOyk5uBBzrU?return=http://#{request.host_with_port}/oauth/s5"
			session[:app_intent] = nil
			@application = nil
		end
		@title = "Login"
	end

	def api_me
		params.require(:token)
		params.require(:secret)
		app = Application.where(:secret => params[:secret]).first
		if app.is_a? Application
			render json: Token.user_with_token(app, params[:token]).api_filter
		else
			render json: {:error => "ur fgt"}
		end
	end

	def me
		redirect_to user_path(current_user)
	end

	def show
		@user = User.find(params[:id])
		@title = @user.name
	end

	def logout
		session[:current_user_id] = nil
		redirect_to root_path
	end

	def register
		redirect_to login_path
		# UNCOMMENT TO RE-ENABLE REGISTRATION

		# if current_user then redirect_to root_path; return end
		# if params[:appid]
		# 	@application = Application.where(:appid => params[:appid]).first || nil
		# 	session[:app_intent] = params[:appid]
		# 	@s5_sso_url = "https://s5.studentrnd.org/oauth/qgoZfHW1vcb9yZarnAvOeQOyk5uBBzrU?return=http://teams.codeday.org/oauth/s5#{CGI::escape("?appid=#{params[:appid]}")}"
		# else
		# 	if current_user then redirect_to root_path end
		# 	@s5_sso_url = "https://s5.studentrnd.org/oauth/qgoZfHW1vcb9yZarnAvOeQOyk5uBBzrU?return=http://teams.codeday.org/oauth/s5"
		# 	session[:app_intent] = nil
		# 	@application = nil
		# end
		# @title = "Register"
	end

	def post_register
		redirect_to login_path
		# UNCOMMENT TO RE-ENABLE REGISTRATION

		# @title = "Register"
		# # if params[:password]
		# 	user = User.create(user_params)
		# 	if user.valid?
		# 		user.set_password(params[:user][:password])
		# 		session[:current_user_id] = user.id
		# 		if Application.where(:appid => session[:app_intent]).first.is_a? Application
		# 			app = Application.where(:appid => session[:app_intent]).first || nil
		# 			token = Token.token_for(app, user)
		# 			session[:app_intent] = nil
		# 			redirect_to "#{app.oauth_callback}?access_token=#{CGI::escape(token.access_token)}"
		# 		else
		# 			redirect_to root_path
		# 		end
		# 	else
		# 		flash.now[:error] = handle_errors(user.errors.full_messages)
		# 		render :register
		# 	end
		# # else
		# # 	flash.now[:error] = handle_errors(["Password is required"])
		# # 	render :register
		# # end
	end

	def post_login
		@title = "Login"
		user = User.where(:username => params[:user][:username]).first
		if user.is_a? User
			if user.authenticate(params[:user][:password])
				session[:current_user_id] = user.id
				if Application.where(:appid => session[:app_intent]).first.is_a? Application
					app = Application.where(:appid => session[:app_intent]).first || nil
					token = Token.token_for(app, user)
					session[:app_intent] = nil
					redirect_to "#{app.oauth_callback}?access_token=#{CGI::escape(token.access_token)}"
				else
					redirect_to root_path
				end
			else
				flash.now[:error] = "Invalid password"
				render :login
			end
		else
			flash.now[:error] = "Invalid username"
			render :login
		end
	end

	private
		def user_params
			userparams = params.require(:user).permit(:username, :first_name, :last_name, :password)
			return {:username => userparams[:username], :name => "#{userparams[:first_name]} #{userparams[:last_name]}"}
		end

		def user_login_params
			params.require(:user).permit(:username, :password)
		end
end
