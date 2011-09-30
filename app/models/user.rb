class User < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_db_connection

end
