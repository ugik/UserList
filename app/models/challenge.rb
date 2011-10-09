class Challenge < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_console

  attr_accessible :name, :league_id, :activation_date, :task_selection_date, :eligible_members, :splash_description
  
end
