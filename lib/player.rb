require 'json'

class Player
  attr_accessor :name, :money, :bet
  attr_reader :cards

  DEFAULT_ALLOWANCE = 500
  DEFAULT_BET = 0

  def initialize(name: '', money: DEFAULT_ALLOWANCE, bet: DEFAULT_BET)
    self.name = name
    self.money = money
    self.bet = bet
    @cards = []
  end

  def save_to_session
    {name: name, money: money, bet: bet, cards: cards}.to_json
  end

  def load_from_session(session_json)
    data = JSON.parse(session_json)
    self.name = data['name']
    self.money = data['money']
    self.bet = data['bet']
    self
  end

  def valid_bet?(bet)
    bet > 0 && bet <= money
  end

  def hand=(card)
    @cards << card
    @cards.flatten!(1)
  end
end
