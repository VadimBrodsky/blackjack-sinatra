module GameHelpers
  def game_set!
    unless player_known? && deck_set? && dealer_set?
      redirect to '/game/new'
    end
  end

  def load_game_state
    @player = load_player
    @dealer = load_dealer
    @deck = load_deck
  end

  def save_game_state
    save_player
    save_dealer
    save_deck
  end
end
