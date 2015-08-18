module GameHelpers
  def protected!
    unless player_known?
      redirect to('/player/new')
    end
  end

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

  def save_players
    save_player
    save_dealer
  end

  def image_name(card)
    return 'cover.jpg' if card.nil?
    "#{suit_name(card)}_#{face_name(card)}.jpg"
  end

  def face_name(card)
    faces = {j: 'jack', q: 'queen', k: 'king', a: 'ace'}
    card[0].to_i == 0 ? faces[card[0].to_sym] : card[0].to_i
  end

  def suit_name(card)
    suits = {c: 'clubs', d: 'diamonds', h: 'hearts', s: 'spades'}
    suits[card[1].to_sym]
  end

  def calculate_total(cards)
    arr = cards.map {|card| card[0]}

    total = 0
    arr.each do |a|
      if a == 'a'
        total += 11
      else
        total += a.to_i == 0 ? 10 : a.to_i
      end
    end

    # correct for aces
    arr.select {|card| card == 'a'}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end
end
