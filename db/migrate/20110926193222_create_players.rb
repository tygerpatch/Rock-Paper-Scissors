class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.string :password
      t.integer :score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
