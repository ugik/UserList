class Challenge < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_console

end
