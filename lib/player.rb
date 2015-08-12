require 'json'

class Player
  attr_accessor :name, :money, :bet

  DEFAULT_ALLOWANCE = 500
  DEFAULT_BET = 0

  def initialize(name: '', money: DEFAULT_ALLOWANCE, bet: DEFAULT_BET)
    self.name = name
    self.money = money
    self.bet = bet
  end

  def save_to_session
    session[:player] = {name: name, money: money, bet: bet}.to_json
  end

  def load_from_session(json: session_json)
    data = JSON.parse(session_json)
    self.name = data['name']
    self.money = data['money']
    self.bet = data['bet']
    self
  end
end
