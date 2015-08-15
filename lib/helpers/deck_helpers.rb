module DeckHelpers
  def deck_set?
    !session[:deck].nil?
  end

  def load_deck
    Deck.new(JSON.parse(session[:deck]))
  end

  def save_deck
    session[:deck] = @deck.save_to_session
  end

  def set_deck
    if deck_set?
      redirect to('/game')
    else
      @deck = Deck.new
    end
  end
end
