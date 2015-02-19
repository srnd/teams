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

	def exchange_token
		params.require(:access_token)
		params.require(:secret)
		app = Application.where(:secret => params[:secret]).first
		if app.is_a? Application
			render json: {:token => Token.exchange(app, params[:access_token])}
		else
			render json: {:token => "no"}
		end
	end

	def legacy
		@s5_sso_url = "https://s5.studentrnd.org/oauth/qgoZfHW1vcb9yZarnAvOeQOyk5uBBzrU?return=http://#{request.host_with_port}/legacy/oauth"
		@title = "Migrate to s5"
	end

	def legacy_oauth
		unless current_user then redirect_to root_path end
		begin
			code = RestClient.get('https://s5.studentrnd.org/api/oauth/exchange', {:params => {:code => params[:code], :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}})
			s5_data = JSON.parse(RestClient.get('https://s5.studentrnd.org/api/user/me', {:params => {:access_token => code, :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}}))
			admin_groups = [2, 3]
			admin = false
			s5_data["groups"].each do |g|
				if admin_groups.include? g["id"]
					admin = true
				end
			end

			current_user.update(:s5_username => s5_data["username"], :admin => admin, :legacy => false, :name => "#{s5_data['first_name']} #{s5_data['last_name']}")
			redirect_to root_path
		rescue => e
			if Rails.env.development?
				flash[:error] = e.inspect
			else
				flash[:error] = "Error linking s5 and Teams account"
			end
			redirect_to legacy_path
		end
	end

	def s5
		require 'rest_client'
		begin
			code = RestClient.get('https://s5.studentrnd.org/api/oauth/exchange', {:params => {:code => params[:code], :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}})
			s5_data = JSON.parse(RestClient.get('https://s5.studentrnd.org/api/user/me', {:params => {:access_token => code, :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}}))
			admin_groups = [2, 3]
			admin = false
			s5_data["groups"].each do |g|
				if admin_groups.include? g["id"]
					admin = true
				end
			end

			if Rails.env.development?
				render json: {:s5_data => s5_data, :will_admin_user => admin}
			else
				if User.where(:username => s5_data["username"]).first
					User.where(:username => s5_data["username"]).first.update(:admin => true)
					session[:current_user_id] = User.where(:username => s5_data["username"]).first.id
				else
					user = User.create(:username => s5_data["username"], :name => "#{s5_data['first_name']} #{s5_data['last_name']}", :admin => admin, :s5_username => s5_data["username"])
					session[:current_user_id] = user.id
				end
				redirect_to root_path
			end
		rescue => e
			if Rails.env.development?
				flash[:error] = e.inspect
			end
			redirect_to login_path
		end
	end
end
