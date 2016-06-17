class TeamsController < ApplicationController
	def index
		@title = "Current Teams"
		@batch = current_batch
	end

	def batch
		@batch = Batch.find(params[:id])
		@title = "Teams for #{@batch.name}"
		render :index
	end

	def edit
		unless current_user.admin then redirect_to root_path end
		@team = Team.find(params[:id])
		@title = "Edit #{@team.name}"
	end

	def update
		unless current_user.admin then redirect_to root_path end
		Team.find(params[:id]).update(:extra => params[:team][:extra], :team_photo_url => params[:team][:team_photo_url])
		redirect_to Team.find(params[:id])
	end

	def user_update
		if current_user_team
			team = current_user_team
			team.update(params.require(:team).permit(:name, :short_description, :project_description, :youtube_url, :download_url, :website_url, tag_ids: []))

			if team.errors.any?
				flash[:error] = handle_errors(team.errors.full_messages)
			else
				flash[:message] = "Team updated"
			end

			redirect_to teams_mine_path
		end
	end

	def show
		@team = Team.find(params[:id])
		@title = @team.name
		@extra_body_class = "full-content-width"

		@open_graph[:title] = @team.name
		@open_graph[:type] = "website"
		@open_graph[:url] = team_url(@team)
		@open_graph[:image] = @team.team_photo
		@open_graph[:description] = @team.short_description
	end

	def code
		@title = "My Team"
		unless current_user_team then redirect_to root_path end
		@team = current_user_team
	end

	def join
		@title = "Join Team"
		if current_user_team
			redirect_to root_path
		end
	end

	def join_team
		if Team.where(:code => params[:team][:code], :batch_id => current_batch.id).first
			team = Team.where(:code => params[:team][:code]).first
			team.users << current_user
			# team.hook_slack({:text => "<#{request.protocol}#{request.host_with_port}#{user_path(current_user)}|#{current_user.name}> has joined the team!"})
			# current_user.update(:team_id => Team.where(:code => params[:team][:code]).first.id)
			redirect_to root_path
		else
			flash[:error] = "Could not find team for #{current_batch.name} with that code!"
			redirect_to teams_join_path
		end
	end

	def new
		@title = "Create Team"
		if current_user_team
			redirect_to root_path
		end
	end

	def create
		@title = "Create Team"
		if current_user_team
			redirect_to root_path
		end
		params.require(:team).permit(:name, :short_description, :event_id)
		if Event.where(:id => params[:team][:event_id]).first.is_a? Event
			team = Team.create(:name => params[:team][:name], :code => SecureRandom.urlsafe_base64(5), :event_id => params[:team][:event_id], :short_description => params[:team][:short_description], :batch_id => current_batch.id)
			if team.valid?
				team.users << current_user
				redirect_to teams_mine_path
			else
				flash[:error] = handle_errors(team.errors.full_messages)
				redirect_to new_team_path
			end
		else
			flash[:error] = "Invalid event"
			redirect_to new_team_path
		end
	end

	def event
		@teams = Team.where(:event_id => params[:id], :batch_id => params[:batch_id] || 1)
		respond_to do |m|
			m.json {
				json_teams = []
				@teams.each do |t|
					json_teams.push(t.api_filter)
				end
				render json: api_success({:teams => json_teams})
			}

			m.html {
				@event = Event.find(params[:id])
				@title = "Teams for #{@event.city}"
				@batch = Batch.find(params[:batch_id] || 1)
			}
		end
	end

	def leave
		team = current_user.current_team
		team.users.delete(current_user)
		if team.users.count == 0
			team.destroy
		end
		redirect_to root_path
	end

	def save_project
		# params.require(:project).permit(:name, :description)
		# current_user_team.update(:project => params[:project][:name], :project_description => params[:project][:description])
		# render json: api_success
	end

	private
		def team_params
			params.require(:team).permit(:name, :event_id)
		end
end
