# require_relative 'player'
require 'json'

class Dealer
  attr_accessor :name, :cards
  attr_reader :hide_card

  def initialize
    self.name = 'Dealer'
    self.cards = []
    @hide_card = true
  end

  def hand=(card)
    @cards << card
    @cards.flatten!(1)
  end

  def hand
    if hide_card?
      @cards.map.with_index { |c,i| i == 0 ? nil : c }
    else
      @cards
    end
  end

  def hide_card?
    @hide_card
  end

  def save_to_session
    {name: name, hand: cards, hide: @hide_card}.to_json
  end

  def load_from_session(session_json)
    data = JSON.parse(session_json)
    self.name = data['name']
    self.hand = data['hand']
    @hide_card = data['hide']
    self
  end
end
