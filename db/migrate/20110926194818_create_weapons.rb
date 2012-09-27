class CreateWeapons < ActiveRecord::Migration
  def self.up
    create_table :weapons do |t|
      t.string :name

      t.timestamps
    end

    Weapon.create :name => "Rock"
    Weapon.create :name => "Paper"
    Weapon.create :name => "Scissors"

  end

  def self.down
    drop_table :weapons
  end
end
