class MainController < ApplicationController
	protect_from_forgery :except => [:slack_hook]

	def index
		@title = "Welcome"

		if params[:filter]
			@filter = params[:filter].symbolize_keys
			batch = Batch.find(params[:filter][:batch_id]) || current_batch
			event = Event.find(params[:filter][:event_id]) || Event.first

			if @filter[:tag_ids] && @filter[:tag_ids] != [""]
				@teams = []

				Team.includes(:tags).where(:batch => batch, :event => event).each do |team|
					if (@filter[:tag_ids].map { |id| id.to_i }).included_in?(team.tag_ids) then @teams << team end
				end
			else
				@filter[:tag_ids] = []
				@teams = Team.where(:batch => batch, :event => event)
			end
		else
			@filter = {
				:tag_ids => [], # damn rails.
				:batch_id => current_batch.id
			}
			batch = current_batch
			event = Event.first

			@teams = Team.where(:batch => batch, :event => event)
		end
	end

	def manual_login
		redirect_to root_path unless Rails.env == "development"
		@title = "Manual Login"
		if params[:user]
			session[:current_user_id] = User.where(:username => params[:user][:username]).first.id
			redirect_to root_path
		end
	end

	def exchange_token
		params.require(:access_token)
		params.require(:secret)

		app = Application.where(:secret => params[:secret])
		
		if app.exists?
			app = app.first
			render json: api_success({ :token => Token.exchange(app, params[:access_token]) })
		else
			render json: api_error("Invalid secret")
		end
	end

	def legacy
		unless current_user && current_user.legacy then redirect_to root_path end
		@s5_sso_url = "https://s5.studentrnd.org/oauth/#{$s5_token}?return=https://#{request.host_with_port}/legacy/oauth"
		@title = "Migrate to s5"
	end

	def legacy_oauth
		unless current_user && current_user.legacy then redirect_to root_path end
		begin
			code = RestClient.get('https://s5.studentrnd.org/api/oauth/exchange', { :params => { :code => params[:code], :secret => $s5_secret }})
			s5_data = JSON.parse(RestClient.get('https://s5.studentrnd.org/api/user/me', { :params => { :access_token => code, :secret => $s5_secret }}))
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

	def hall_of_fame
		@title = "Hall of Fame"
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
			redirect_to root_path
		rescue => e
			if Rails.env.development?
				flash[:error] = e.inspect
			end
			redirect_to login_path
		end
	end
end
