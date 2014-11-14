class MainController < ApplicationController
	def index
		@title = "Welcome"
	end

	def s5
		require 'rest_client'
		begin
			code = RestClient.get('https://s5.studentrnd.org/api/oauth/exchange', {:params => {:code => params[:code], :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}})
			s5_data = JSON.parse(RestClient.get('https://s5.studentrnd.org/api/user/me', {:params => {:access_token => code, :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}}))
			if User.where(:username => s5_data["username"]).first
				session[:current_user_id] = User.where(:username => s5_data["username"]).first.id
			end
			redirect_to root_path
		rescue
			redirect_to login_path
		end
	end
end
