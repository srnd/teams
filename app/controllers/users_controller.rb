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
end
