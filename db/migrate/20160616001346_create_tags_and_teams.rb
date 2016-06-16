class CreateTagsAndTeams < ActiveRecord::Migration
  def change
    create_table :tags_teams, id: false do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :team, index: true
    end
  end
end
