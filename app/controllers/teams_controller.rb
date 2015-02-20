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

	def show
		@team = Team.find(params[:id])
		@title = @team.name
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
			ctf_hook({:event => "join", :id => current_user.id, :team_id => Team.where(:code => params[:team][:code]).first.id})
			current_user.update(:team_id => Team.where(:code => params[:team][:code]).first.id)
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
		params.require(:team).permit(:name, :event_id)
		if Event.where(:id => params[:team][:event_id]).first.is_a? Event
			team = Team.create(:name => params[:team][:name], :code => SecureRandom.urlsafe_base64(5), :event_id => params[:team][:event_id], :batch_id => current_batch.id)
			if team.valid?
				team.users << current_user
				ctf_hook(:event => "create", :id => team.id, :user_id => current_user.id, :name => team.name)
				redirect_to teams_code_path
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
				render json: {:teams => json_teams}
			}

			m.html {
				@event = Event.find(params[:id])
				@title = "Teams for #{@event.city}"
				@batch = Batch.find(params[:batch_id] || 1)
			}
		end
	end

	def leave
		team = current_user_team
		ctf_hook({:event => "leave", :id => current_user.id})
		team.users.delete(current_user)
		if team.users.count == 1
			ctf_hook({:event => "delete", :thing => "team", :id => team.id})
			team.destroy
		end
		redirect_to root_path
	end

	def save_project
		params.require(:name)
		current_user_team.update(:project => params[:name])
		render json: {:success => true}
	end

	private
		def team_params
			params.require(:team).permit(:name, :event_id)
		end
end
