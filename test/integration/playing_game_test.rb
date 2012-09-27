require 'test_helper'

class PlayingGameTest < ActionController::IntegrationTest
  fixtures :all

  def test_simple_game
    player1 = players(:player1)
    player2 = players(:player2)

    # player1 logs in
    player1_session = open_session
    player1_session.post "/site/login", :player => {:name => player1.name, :password => player1.password}
    player1_session.assert_response :redirect

    # player2 logs in
    player2_session = open_session
    player2_session.post "/site/login", :player => {:name => player2.name, :password => player2.password}
    player2_session.assert_response :redirect
    
    # player1 clicks on play game
    player1_session.get "/site/waiting"
    player1_session.assert_response :success
    
    # player2 clicks on play game
    player2_session.get "/site/waiting" # TODO: Why does this redirect work, but the one using xml_http_request doesn't?
    player2_session.assert_response :redirect
    player2_session.follow_redirect!
    player2_session.assert_response :success

    # player1 calls getOpponent
    player1_session.xml_http_request :post, 'site/get_opponent'
    player1_session.assert_equal player1_session.response.body, 'window.location.href = "/site/play";'
    player1_session.get "/site/play"

    # player2 clicks on rock
    player2_session.xml_http_request :post, 'site/set_my_choice', {:choice => 'Rock'}
    
    # player1 clicks on paper
    player1_session.xml_http_request :post, 'site/set_my_choice', {:choice => 'Paper'}

    # player1 wins
    player1_session.xml_http_request :post, 'site/get_their_choice'

    # player2 loses
    player2_session.xml_http_request :post, 'site/get_their_choice'

    # check that player1 won
    player1 = Player.find_by_name player1.name
    assert (1 == player1.score)

    # check that player2 lost
    player2 = Player.find player2
    assert (-1 == player2.score)

    # player1 logs out
    player1_session.get "/site/logout"
    player1_session.assert_response :redirect

    # player2 logs out
    player2_session.get "/site/logout"
    player2_session.assert_response :redirect
  end

end

