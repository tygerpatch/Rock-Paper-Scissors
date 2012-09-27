class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|

      t.integer :player_id
      t.integer :opponent_id, :default => nil

      t.integer :player_weapon_id, :default => nil
      t.integer :opponent_weapon_id, :default => nil
      t.boolean :is_waiting, :default => false
    end
  end

  def self.down
    drop_table :games
  end
end
