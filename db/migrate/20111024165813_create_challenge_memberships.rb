class CreateChallengeMemberships < ActiveRecord::Migration
  def change
    create_table :challenge_memberships do |t|

      t.timestamps
    end
  end
end
