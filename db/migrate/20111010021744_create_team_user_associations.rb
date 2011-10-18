class CreateTeamUserAssociations < ActiveRecord::Migration
  def change
    create_table :team_user_associations do |t|

      t.timestamps
    end
  end
end
