class Player < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_confirmation_of :password

  has_one :game
  has_one :opponent, :through => :game,  :foreign_key => :opponent_id
end
