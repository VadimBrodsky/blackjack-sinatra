module Blackjack
  BLACKJACK = 21

  def calculate_total(cards)
    arr = cards.map { |card| card[0] }

    total = 0
    arr.each do |a|
      if a == 'a'
        total += 11
      else
        total += a.to_i == 0 ? 10 : a.to_i
      end
    end

    # correct for aces
    arr.select { |card| card == 'a' }.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def hand_value
    calculate_total(cards)
  end

  def playing?
    status == 'playing'
  end

  def standing?
    @status == 'stand'
  end

  def busted?
    hand_value > BLACKJACK
  end

  def blackjack?
    hand_value == BLACKJACK
  end

  def set_busted_status
    @status = 'busted'
  end

  def set_blackjack_status
    @status = 'blackjack'
  end

  def set_lose_status
    @status = 'lost'
  end

  def set_stand_status
    @status = 'stand'
  end

  def set_win_status
    @status = 'won'
  end
end
