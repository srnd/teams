class UsersController < ApplicationController
	def login
		@title = "Login"
	end

	def me
		@user = current_user
		@title = @user.name
		render :show
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
		if current_user then redirect_to root_path end
		@title = "Register"
	end

	def post_register
		@title = "Register"
		user = User.create(user_params)
		if user.valid?
			user.set_password(params[:user][:password])
			session[:current_user_id] = user.id
			redirect_to root_path
		else
			flash.now[:error] = handle_errors(user.errors.full_messages)
			render :register
		end
	end

	def post_login
		@title = "Login"
		user = User.where(:username => params[:user][:username]).first
		if user.is_a? User
			if user.authenticate(params[:user][:password])
				session[:current_user_id] = user.id
				redirect_to root_path
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
