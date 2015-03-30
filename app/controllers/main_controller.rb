class MainController < ApplicationController
	protect_from_forgery :except => [:slack_hook]

	def index
		@title = "Welcome"
	end

	def manual_login
		redirect_with_https root_path unless Rails.env == "development"
		@title = "Manual Login"
		if params[:user]
			session[:current_user_id] = User.where(:username => params[:user][:username]).first.id
			redirect_with_https root_path
		end
	end

	def exchange_token
		params.require(:access_token)
		params.require(:secret)
		app = Application.where(:secret => params[:secret]).first
		if app.is_a? Application
			render json: api_success({:token => Token.exchange(app, params[:access_token])})
		else
			render json: api_error("no")
		end
	end

	def legacy
		unless current_user && current_user.legacy then redirect_with_https root_path end
		@s5_sso_url = "https://s5.studentrnd.org/oauth/qgoZfHW1vcb9yZarnAvOeQOyk5uBBzrU?return=https://#{request.host_with_port}/legacy/oauth"
		@title = "Migrate to s5"
	end

	def legacy_oauth
		unless current_user && current_user.legacy then redirect_with_https root_path end
		begin
			code = RestClient.get('https://s5.studentrnd.org/api/oauth/exchange', {:params => {:code => params[:code], :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}})
			s5_data = JSON.parse(RestClient.get('https://s5.studentrnd.org/api/user/me', {:params => {:access_token => code, :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}}))
			admin_groups = [2, 3]
			admin = false
			judge = false
			if s5_data["is_admin"]
				admin = true
				judge = true
			else
				s5_data["groups"].each do |g|
					if admin_groups.include? g["id"]
						admin = true
					end
				end
			end

			current_user.update(:s5_username => s5_data["username"],
			                    :admin => admin,
													:email => s5_data["email"],
													:legacy => false,
													:name => "#{s5_data['first_name']} #{s5_data['last_name']}",
													:s5_token => code,
													:judge => judge)

			flash[:message] = "s5 account (#{s5_data["username"]}) linked"
			redirect_with_https root_path
		rescue => e
			if Rails.env.development?
				flash[:error] = e.inspect
			else
				flash[:error] = "Error linking s5 and Teams account"
			end
			redirect_with_https legacy_path
		end
	end

	def hall_of_fame
		@title = "Hall of Fame"
	end

	def slack_hook
		team = Team.find(params[:id])
		if team && params[:token] && team.slack_token == params[:token]
			render json: api_success({:text => "It works!"})
		else
			render json: api_error
		end
	end

	def s5
		require 'rest_client'
		begin
			code = RestClient.get('https://s5.studentrnd.org/api/oauth/exchange', {:params => {:code => params[:code], :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}})
			s5_data = JSON.parse(RestClient.get('https://s5.studentrnd.org/api/user/me', {:params => {:access_token => code, :secret => "4XE0nF3JiyK1HZlGGBNFqIMAjUH766Tl"}}))
			admin_groups = [2, 3]
			admin = false
			judge = false
			if s5_data["is_admin"]
				admin = true
				judge = true
			else
				s5_data["groups"].each do |g|
					if admin_groups.include? g["id"]
						admin = true
					end
				end
			end

			if User.where(:username => s5_data["username"]).first
				User.where(:username => s5_data["username"]).first.update(:admin => admin, :judge => judge)
				session[:current_user_id] = User.where(:username => s5_data["username"]).first.id
			else
				user = User.create(:username => s5_data["username"],
				                   :email => s5_data["email"],
													 :name => "#{s5_data['first_name']} #{s5_data['last_name']}",
													 :admin => admin,
													 :s5_username => s5_data["username"],
													 :s5_token => code,
													 :judge => judge)

				session[:current_user_id] = user.id
			end
			redirect_with_https root_path
		rescue => e
			if Rails.env.development?
				flash[:error] = e.inspect
			end
			redirect_with_https login_path
		end
	end
end
