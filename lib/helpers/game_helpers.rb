module GameHelpers
  def game_set!
    unless player_known? && deck_set?
      redirect to '/game/new'
    end
  end

  def load_game_state
    @player = load_player
    @deck = load_deck
  end
end
