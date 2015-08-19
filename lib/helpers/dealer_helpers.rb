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
    if @dealer.hand_value < 17
      @dealer.hand = @deck.deal
    end
  end

end
