class CreateChallengeTeams < ActiveRecord::Migration
  def change
    create_table :challenge_teams do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :payment_method, null: false
      t.integer :limit, default: 10, null: false
      t.timestamps null: false
    end

    add_index :challenge_teams, :email
  end
end
