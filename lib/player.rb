require 'json'
require_relative 'blackjack'

class Player
  include Blackjack

  attr_accessor :name, :money, :bet, :cards, :number_of_games
  attr_reader :status

  DEFAULT_ALLOWANCE = 500
  DEFAULT_BET = 0

  def initialize(name: '', money: DEFAULT_ALLOWANCE, bet: DEFAULT_BET)
    self.name = name
    self.money = money
    self.bet = bet
    self.cards = []
    self.number_of_games = 0;
    @status = 'playing'
  end

  def save_to_session
    {name: name, money: money, bet: bet, hand: cards, number_of_games: number_of_games, status: status}.to_json
  end

  def load_from_session(session_json)
    data = JSON.parse(session_json)
    self.name = data['name']
    self.money = data['money']
    self.bet = data['bet']
    self.hand = data['hand']
    self.number_of_games = data['number_of_games']
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

  def reset!
    self.bet = DEFAULT_BET
    self.cards = []
    self.number_of_games += 1
    @status = 'playing'
  end

  def reset_hand!
    self.cards = []
  end

  def collect_winnings(bet)
    self.money += bet
  end
end
