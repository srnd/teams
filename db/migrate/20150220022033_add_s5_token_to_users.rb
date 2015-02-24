class AddS5TokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :s5_token, :string
  end
end
