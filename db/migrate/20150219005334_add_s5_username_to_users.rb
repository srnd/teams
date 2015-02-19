class AddS5UsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :s5_username, :string
  end
end
