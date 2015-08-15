# require_relative 'player'
require 'json'

class Dealer
  attr_accessor :name, :cards

  def initialize
    self.name = 'Dealer'
    self.cards = []
  end

  def hand=(card)
    @cards << card
    @cards.flatten!(1)
  end

  def hand
    @cards
  end

  def save_to_session
    {name: name, hand: cards}.to_json
  end

  def load_from_session(session_json)
    data = JSON.parse(session_json)
    self.name = data['name']
    self.hand = data['hand']
    self
  end
end
