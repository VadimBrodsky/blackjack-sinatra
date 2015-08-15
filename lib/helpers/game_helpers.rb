module GameHelpers
  def game_set!
    unless player_known? && deck_set?
      redirect to '/game/new'
    end
  end
end
