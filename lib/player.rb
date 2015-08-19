require 'json'
require_relative 'blackjack'

class Player
  include Blackjack
  
  attr_accessor :name, :money, :bet, :cards
  attr_reader :status

  DEFAULT_ALLOWANCE = 500
  DEFAULT_BET = 0

  def initialize(name: '', money: DEFAULT_ALLOWANCE, bet: DEFAULT_BET)
    self.name = name
    self.money = money
    self.bet = bet
    self.cards = []
    @status = 'playing'
  end

  def save_to_session
    {name: name, money: money, bet: bet, hand: cards, status: status}.to_json
  end

  def load_from_session(session_json)
    data = JSON.parse(session_json)
    self.name = data['name']
    self.money = data['money']
    self.bet = data['bet']
    self.hand = data['hand']
    @status = data['status']
    self
  end

  def valid_bet?(bet)
    bet > 0 && bet <= money
  end

  def hand=(cards)
    cards.each {|card| @cards << card }
  end

  def hand
    @cards
  end

  def playing?
    status == 'playing'
  end

  def stand
    @status = 'stand'
  end

  def reset!
    self.bet = DEFAULT_BET
    self.cards = []
    @status = 'playing'
  end
end
