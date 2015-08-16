# require_relative 'player'
require 'json'

class Dealer
  attr_accessor :name, :cards
  attr_reader :status

  def initialize
    self.name = 'Dealer'
    self.cards = []
    @status = 'hide card'
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
    @status == 'hide card'
  end

  def open_hand
    @status = 'playing'
  end

  def playing?
    @status == 'playing'
  end

  def save_to_session
    {name: name, hand: cards, status: @status}.to_json
  end

  def load_from_session(session_json)
    data = JSON.parse(session_json)
    self.name = data['name']
    self.hand = data['hand']
    @status = data['status']
    self
  end
end
