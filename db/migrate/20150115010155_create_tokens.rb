class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :access_token
      t.integer :user_id
      t.integer :application_id
      t.string :token_string

      t.timestamps
    end
  end
end
