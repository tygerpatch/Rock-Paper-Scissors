class Game < ActiveRecord::Base
  belongs_to :player
  belongs_to :opponent, :class_name => "Player", :foreign_key => "opponent_id"

  belongs_to :player_weapon, :class_name => "Weapon", :foreign_key => "player_weapon_id"
  belongs_to :opponent_weapon, :class_name => "Weapon", :foreign_key => "opponent_weapon_id"
end
