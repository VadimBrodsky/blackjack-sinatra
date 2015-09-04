module DealerHelpers
  def dealer_set?
    !session[:dealer].nil?
  end

  def load_dealer
    if dealer_set?
      Dealer.new.load_from_session(session[:dealer])
    end
  end

  def save_dealer
    session[:dealer] = @dealer.save_to_session
  end

  def dealer_hit
    if @dealer.can_hit? && @player.standing? && @dealer.hand_value < @player.hand_value
      @dealer.hand = @deck.deal
    else
      @dealer.set_stand_status if @dealer.playing?
      flash[:info] = 'Dealer has chosen to stay.'
    end
  end

  def check_dealer_hand
    if @dealer.busted?
      dealer_busted
      redirect to('/game/end')
    elsif @dealer.blackjack?
      dealer_blackjack
      redirect to('/game/end')
    end
  end

  def dealer_busted
    flash[:error] = 'Dealer has busted. You Won!'
    @dealer.set_busted_status
    reward_player(2)
  end

  def dealer_blackjack
    @dealer.set_blackjack_status
    flash[:error] = 'Dealer got a Blackjack! You Lose.'
    redirect to('/game/end')
  end
end
