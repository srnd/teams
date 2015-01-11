class MainController < ApplicationController
	def index
		@title = "Welcome"
	end

	def manual_login
		unless Rails.env == "development"
			redirect_to root_path
		end
		@title = "Manual Login"
		if params[:user]
			session[:current_user_id] = User.where(:username => params[:user][:username]).first.id
			redirect_to root_path
		end
	end

	def s5
		require 'rest_client'
		begin
			code = RestClient.get('https://s5.studentrnd.org/api/oauth/exchange', {:params => {:code => params[:code], :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}})
			s5_data = JSON.parse(RestClient.get('https://s5.studentrnd.org/api/user/me', {:params => {:access_token => code, :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}}))
			if User.where(:username => s5_data["username"]).first
				session[:current_user_id] = User.where(:username => s5_data["username"]).first.id
			else
				user = User.create(:username => s5_data["username"], :name => "#{s5_data['first_name']} #{s5_data['last_name']}")
				session[:current_user_id] = user.id
			end
			redirect_to root_path
		rescue
			redirect_to login_path
		end
	end
end
