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

  def image_name(card)
    if card.nil?
      'cover.jpg'
    else
      "#{suit_name(card)}_#{face_name(card)}.jpg"
    end
  end

  def face_name(card)
    face = card[0].to_i
    if face == 0
      face = case face
        when 'j' then 'jack'
        when 'q' then 'queen'
        when 'k' then 'king'
        when 'a' then 'ace'
      end
    end
    face
  end

  def case_name(card)
    case card[1]
      when 'c' then 'clubs'
      when 'd' then 'diamonds'
      when 'h' then 'hearts'
      when 's' then 'spaces'
    end
  end
end
