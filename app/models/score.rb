class Score < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_console
  
  belongs_to :user
  belongs_to :challenge

  scope :this_week, lambda {
    where("#{Score.table_name}.earned_at >= ?", Time.zone.now.monday)
  }
  scope :in_challenge, lambda { |id| where(:challenge_id => id)}

  scope :user_scores, lambda { |user_id|
    where(:user_id => user_id)
  }
  scope :team_scores, lambda { |team_id|
    joins("JOIN #{TeamUserAssociation.table_name} ON" +
          " #{TeamUserAssociation.table_name}.user_id = #{Score.table_name}.user_id").
    where("#{TeamUserAssociation.table_name}.team_id = #{team_id}")
  }

  scope :active_users_in_all_divisions, lambda {
    group("#{Score.table_name}.user_id").
    where(:users => {:deactivated => false}).
    joins("JOIN #{User.table_name} ON" +
          " #{User.table_name}.id = #{Score.table_name}.user_id")
  }
  scope :active_users_in_division, lambda { |division_id|
    active_users_in_all_divisions.
    where("#{User.table_name}.division_id = ?", division_id)
  }

  scope :teams_in_all_divisions, lambda {
    group("#{TeamUserAssociation.table_name}.team_id").
    joins("JOIN #{TeamUserAssociation.table_name} ON" +
          " #{TeamUserAssociation.table_name}.user_id = #{Score.table_name}.user_id")
  }
  scope :teams_in_division, lambda { |division_id|
    teams_in_all_divisions.
    joins("JOIN #{Team.table_name} ON" +
          " #{TeamUserAssociation.table_name}.team_id = #{Team.table_name}.id").
    where("#{Team.table_name}.division_id = ?", division_id)
  }

end
