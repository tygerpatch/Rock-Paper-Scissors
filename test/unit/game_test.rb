require 'test_helper'

class GameTest < ActiveSupport::TestCase

  def test_belongs_to_player    
    assert_equal games(:game1).player, players(:player1)
  end

  def test_belongs_to_opponent
    assert_equal games(:game1).opponent, players(:player2)
  end

  def test_find_by_player
    player1 = players(:player1)
    player2 = players(:player2)
    test = Game.find_by_player_id player1

    assert (test.player === player1 )
    assert (test.opponent === player2)
  end

  def test_is_waiting
    # player1 logs in and has no one to play against
    player1 = players(:player1)
    assert_not_nil player1

    player1_game = player1.game
    assert_not_nil player1_game

    player1_game.is_waiting = false
    player1_game.player_weapon_id = nil
    player1_game.opponent_weapon = nil
    assert player1_game.save

    opponent_game = Game.find_by_is_waiting true
    assert_nil opponent_game

    unless opponent_game.nil?
      assert true, "Problem with unless statement"
    end

    player1_game.is_waiting = true
    player1_game.opponent = nil
    assert player1_game.save

    # player2 logs in and has someone to play against
    player2 = players(:player2)
    assert_not_nil player2

    player2_game = player2.game
    assert_not_nil player2_game

    player2_game.is_waiting = false
    player2_game.player_weapon_id = nil
    player2_game.opponent_weapon = nil
    assert player2_game.save

    opponent_game = Game.find_by_is_waiting true
    assert_not_nil opponent_game

    unless opponent_game.nil?
      assert (opponent_game === player1_game)

      player2_game.is_waiting = false
      player2_game.opponent = opponent_game.opponent_id
      assert player2_game.save

      opponent_game.opponent_id = player2.id
      opponent_game.is_waiting = false
      assert opponent_game.save
    end
  end
  
end
