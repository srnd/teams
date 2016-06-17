require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "should not create team without name" do
    team = Team.new(:short_description => "short")
    assert_not team.save
  end

  test "should not create team without short description" do
    team = Team.new(:name => "Project name")
    assert_not team.save
  end

  test "should not create team with name > 25 chars" do
    team = Team.new(:name => "This team has way too long of a name and it shouldn't save", :short_description => "It is a good.")
    assert_not team.save
  end

  test "should not create team with short description > 75 chars" do
    team = Team.new(:name => "Project name", :short_description => "This description is way too long and should really prevent this team from being committed to the database")
    assert_not team.save
  end

  test "should create team with name and short description" do
    team = Team.new(:name => "Project name", :short_description => "Short description")
    assert team.save
  end
end
