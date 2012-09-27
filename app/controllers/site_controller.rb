
class SiteController < ApplicationController

  # logger = Logger.new(STDOUT)

  def register
    if request.post?
      player = Player.new params[:player]
      if player.save(true)
        player.game = Game.create
        player.save
        redirect_to :action => :login
      end
    end
  end

  def logout
    session[:id] = nil
    redirect_to :action => :login
  end

  def login
    if request.post?
      player = Player.find_by_name_and_password params[:player][:name], params[:player][:password]
      unless player.nil?
        session[:id] = player.id
        redirect_to :action => :home
      end
    end
  end

  def home
  end


  def play
    player = Player.find session[:id]
    @player_name = player.name

    opponent = Player.find player.game.opponent_id
    @opponent_name = opponent.name
  end

  def scoreboard
    @players = Player.find( :all, :order => "score DESC", :limit => 5 )
    @player = Player.find session[:id]

    unless @players.include? @player
      @rank = Player.find(:all, :order => "score DESC").index(@player) + 1
    end    
  end

  def get_opponent
  end

  def set_my_choice
  end

  def get_their_choice
    game = player.game

    if game.opponent.nil?
      redirect_to :waiting
    end
  end

  def waiting
    player = Player.find session[:id]
    player_game = player.game

    # prevent player from being own opponent
    player_game.is_waiting = false 
    player_game.player_weapon_id = nil
    player_game.opponent_weapon = nil
    player_game.save

    opponent_game = Game.find_by_is_waiting true

    if opponent_game.nil?
      player_game.is_waiting = true
      player_game.opponent = nil
      player_game.save
    else
      player_game.is_waiting = false
      player_game.opponent = opponent_game.player
      player_game.save

      opponent_game.opponent = player
      opponent_game.is_waiting = false
      opponent_game.save
      redirect_to :action => :play
    end
  end

end
