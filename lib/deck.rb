class Deck
  attr_accessor :cards

  CARDS = { '2' => 2, '3' => 3, '4' => 4, '5' => 5,
          '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10,
          'j' => 10, 'q' => 10, 'k' => 10, 'a' => [1, 11] }
  SUITS = { 's' => 'spades', 'h' => 'hearts', 'd' => 'diamonds', 'c' => 'clubs' }

  def initialize(data=nil)
    if data.nil?
      self.cards = CARDS.keys.product(SUITS.keys).shuffle
    else
      self.cards = data
    end
  end

  def to_s
    cards.to_s
  end

  def save_to_session
    cards.to_json
  end

  def deal(num_of_cards = 1)
    num_of_cards == 1 ? [cards.pop] : cards.pop(num_of_cards)
  end
end
