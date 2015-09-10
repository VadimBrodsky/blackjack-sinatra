module PlayerHelpers
  def player_known?
    !session[:player].nil?
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

  def process_bet(bet)
    if @player.valid_bet?(bet)
      @player.bet = bet
      @player.money -= @player.bet
      save_player
    else
      redirect to '/game/bet/new'
    end
  end

  def player_hit
    unless @player.busted? && @player.blackjack?
      @player.hand = @deck.deal
    end
  end

  def reset_player!
    @player.reset!
  end

  def reward_player(multiplier)
    @player.collect_winnings( (@player.bet * multiplier).to_i )
  end

  def return_bet
    reward_player(1)
  end

  def check_player_hand
    if @player.busted?
      player_busted
      # redirect to('/game/end')
    elsif @player.blackjack?
      player_blackjack
      # redirect to('/game/end')
    end
  end

  def player_busted
    @player.set_busted_status
    flash[:error] = 'You have busted. Dealer Won!'
    @dealer.open_hand
    @dealer.set_win_status
    start_new_game
  end

  def player_blackjack
    @player.set_blackjack_status
    start_new_game
    if @dealer.blackjack?
      flash[:success] = "It's a Blackjack Tie!"
      @dealer.set_blackjack_status
    else
      flash[:success] = "Blackjack! You Won $#{ (@player.bet * 1.5).to_i }"
      @dealer.open_hand
      @dealer.set_lose_status
      reward_player(1.5)
    end
  end
end
