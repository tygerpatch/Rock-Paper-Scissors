require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  def test_validates_uniqueness_of_name
    player = Player.new :name => players(:player1).name
    assert !player.save(true)
  end

  def test_validates_confirmation_of_password
    player = Player.new :name => "Ruby", :password => "Rails", :password_confirmation => "Grails"
    assert !player.save(true)
  end

  def test_has_one_game
    assert_not_nil players(:player1).game
    assert_not_nil games(:game1)
    assert_equal players(:player1).game, games(:game1)
  end

  def test_has_one_opponent    
    assert_equal players(:player1).opponent, games(:game1).opponent
  end

  # simulate two players logging in, one selects weapon and then logs out, second player tries to start new game
  def test_starting_new_game
    # create two new players
    fred = Player.create :name => "fred", :game => Game.create
    bob = Player.create :name => "bob", :game => Game.create

    assert Player.exists? :name => "fred"
    assert Player.exists? :name => "bob"

    # remove references
    fred = nil
    bob = nil

    # fred logs in and clicks play
    player = Player.find_by_name "fred"
    assert_not_nil player

    player_game = player.game
    assert_not_nil player_game

    player_game.is_waiting = false
    player_game.player_weapon_id = nil
    player_game.opponent_weapon = nil
    assert player_game.save

    opponent_game = Game.find_by_is_waiting true
    assert_nil opponent_game

    if opponent_game.nil?
      player_game.is_waiting = true
      player_game.opponent = nil
      player_game.save
    else
      fail "Somehow fred has an opponent"
    end

    # fred gets redirected to waiting screen

    # remove references
    player = nil
    player_game = nil
    opponent_game = nil

    # bob logs in and clicks play
    player = Player.find_by_name "bob"
    assert_not_nil player

    player_game = player.game
    assert_not_nil player_game

    player_game.is_waiting = false
    player_game.player_weapon_id = nil
    player_game.opponent_weapon = nil
    assert player_game.save

    opponent_game = Game.find_by_is_waiting true
    assert_not_nil opponent_game

    if opponent_game.nil?
      fail "Somehow bob doesn't have an opponent"
    else
      player_game.is_waiting = false
      player_game.opponent = opponent_game.player
      assert player_game.save

      opponent_game.opponent = player
      opponent_game.is_waiting = false
      assert opponent_game.save
    end

    # bob gets redirected to playing screen

    # remove references
    player = nil
    player_game = nil
    opponent_game = nil

    # fred should now be redirected to playing screen
    player = Player.find_by_name "fred"
    assert_not_nil player
    player_game = player.game
    assert_not_nil player_game
    assert (false == player_game.is_waiting )

    # remove references
    player = nil
    player_game = nil
    opponent_game = nil

    # bob selects a weapon
    player = Player.find_by_name "bob"
    assert_not_nil player

    if player.opponent.nil?
      fail "Somehow bob no longer has an opponent"
    else
      player_game = player.game
      assert_not_nil player_game

      weapon = Weapon.find_by_name "rock"
      assert_not_nil weapon

      # update player's table
      player_game.player_weapon = weapon
      assert player_game.save

      # update opponent's table
      opponent_game = Game.find_by_player_id player_game.opponent
      assert_not_nil opponent_game

      opponent_game.opponent_weapon = weapon
      assert opponent_game.save
    end

    # remove references
    player = nil
    player_game = nil
    weapon = nil
    opponent_game = nil

    # bob is disconnected from game because fred takes too long
    player = Player.find_by_name "bob"
    assert_not_nil player

    player_game = player.game
    assert_not_nil player_game

    unless player_game.opponent_weapon.nil?
      fail "Somehow fred selected a weapon"
    end

    opponent_game = player.opponent.game
    assert_not_nil opponent_game
    opponent_game.opponent = nil
    assert opponent_game.save

    player_game = player.game
    assert_not_nil player_game
    player_game.opponent = nil
    assert player_game.save

    # remove references
    player = nil
    player_game = nil
    weapon = nil
    opponent_game = nil

    # fred selects a weapon
    player = Player.find_by_name "fred"
    assert_not_nil player

    assert player.opponent.nil?, "Somehow fred has an opponent"

    # remove references
    player = nil
    player_game = nil
    weapon = nil
    opponent_game = nil

    # fred tries to start a new game
    player = Player.find_by_name "fred"
    assert_not_nil player

    player_game = player.game
    assert_not_nil player_game

    player_game.is_waiting = false
    player_game.player_weapon_id = nil
    player_game.opponent_weapon = nil
    assert player_game.save

    opponent_game = Game.find_by_is_waiting true
    assert_nil opponent_game

    if opponent_game.nil?
      player_game.is_waiting = true
      player_game.opponent = nil
      player_game.save
    else
      fail "Somehow fred has an opponent"
    end

    # remove references
    player = nil
    player_game = nil
    weapon = nil
    opponent_game = nil

    # now bob tries to start a new game
    player = Player.find_by_name "bob"
    assert_not_nil player

    player_game = player.game
    assert_not_nil player_game

    player_game.is_waiting = false
    player_game.player_weapon_id = nil
    player_game.opponent_weapon = nil
    assert player_game.save

    opponent_game = Game.find_by_is_waiting true
    assert_not_nil opponent_game

    if opponent_game.nil?
      fail "Somehow bob doesn't have an opponent"
    else
      player_game.is_waiting = false
      player_game.opponent = opponent_game.player
      assert player_game.save

      opponent_game.opponent = player
      opponent_game.is_waiting = false
      assert opponent_game.save
    end
  end

end
