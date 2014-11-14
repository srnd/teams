class TeamsController < ApplicationController
	def index
		@title = "Current Teams"
		@teams = Team.all
	end

	def show
		@team = Team.find(params[:id])
		@title = @team.name
	end

	def code
		@title = "My Team"
		unless current_user.team
			redirect_to root_path
		end
		@team = current_user.team
	end

	def join
		@title = "Join Team"
		if current_user.team
			redirect_to root_path
		end
	end

	def join_team
		if Team.where(:code => params[:team][:code]).first
			current_user.update(:team_id => Team.where(:code => params[:team][:code]).first.id)
			redirect_to root_path
		else
			flash[:error] = "Could not find team with code"
			redirect_to teams_join_path
		end
	end

	def new
		@title = "Create Team"
		if current_user.team
			redirect_to root_path
		end
	end

	def create
		params.require(:team).require(:name)
		team = Team.create(:name => params[:team][:name], :code => SecureRandom.urlsafe_base64(5))
		current_user.update(:team_id => team.id)
		redirect_to teams_code_path
	end

	def leave
		if current_user.team.users.count == 1
			current_user.team.destroy
		end
		current_user.update(:team_id => nil)
		redirect_to root_path
	end

	private
		def team_params
			params.require(:name)
		end
end
