class ChallengeMembership < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(
    :adapter => "mysql2",
    :host => "production-ro.ct1vjcyxovqq.us-east-1.rds.amazonaws.com",
    :username => "gynxpFLh7",
    :password => "MLPTFchgCvBmvWEx",
    :database => "FRONTEND",
    :encoding => "utf8",
    :reconnect => "false",
    :pool => "5"
  )

  belongs_to :challenge
  belongs_to :user
  validates_presence_of :challenge_id
  validates_presence_of :user_id
  validates_uniqueness_of :challenge_id, :scope => :user_id
end
