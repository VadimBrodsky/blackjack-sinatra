module PlayerHelpers
  def player_known?
    !session[:player].nil?
  end

  def protected!
    unless player_known?
      redirect to('/player/new')
    end
  end

  def load_player
    if player_known?
      Player.new.load_from_session(session[:player])
    end
  end

  def save_player
    session[:player] = @player.save_to_session
  end

  def set_bet
    if @player.bet <= 0
      redirect to('/game/bet/new')
    end
  end
end
