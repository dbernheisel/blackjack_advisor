#!/usr/bin/env ruby

require_relative 'cardart'
require_relative 'advice'

class Fixnum
  def ordinalize
    if (11..13).include?(self % 100)
      "#{self}th"
    else
      case self % 10
        when 1; "#{self}st"
        when 2; "#{self}nd"
        when 3; "#{self}rd"
        else    "#{self}th"
      end
    end
  end
end

def valid_card?(card)
  possibleChoices = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
  card ? possibleChoices.include?(card.upcase) : false
end

def cards_sum_determine_soft(cards)
  sum = 0
  soft = false
  cards.each do |card|
    if card == "A"
      sum += 11
      soft = true
    end

    if card == "K" || card == "Q" || card == "J"
      sum += 10
    end

    card = card.to_i
    if card < 11
      sum += card
    end

  end
  return sum, soft
end

def is_pair?(cards)
  cards[0] == cards[1]
end


# Introduction
userCards = []
dealerCards = []

cardIntro =   "                  ______\n"
cardIntro +=  "                  |J ____|_\n"
cardIntro +=  "                  | |A     |\n"
cardIntro +=  "                  | |  /\\  |\n"
cardIntro +=  "                  | | /  \\ |\n"
cardIntro +=  "                  | |( -- )|\n"
cardIntro +=  "                  |_|  )(  |\n"
cardIntro +=  "                    |_____V|\n"

puts cardIntro
puts "                \e[1mBLACKJACK ADVISOR\e[0m"

puts "  I need some information before I can give advice."
puts "Please tell me some cards in play using these values:"
puts "     A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K\n\n"

card = nil
soft = false
advice = ""

# Collect Deck Choice
# TODO
#

# Collect card details
until valid_card?(card)
  print "Please enter your 1st card: "
  card = gets.chomp!
  valid_card?(card) ? nil : puts("Please tell me a valid card.")
end
userCards << card

card = nil
until valid_card?(card)
  print "Please enter your 2nd card: "
  card = gets.chomp!
  valid_card?(card) ? nil : puts("Please tell me a valid card.")
end
userCards << card

userCardsSum, soft = cards_sum_determine_soft(userCards)

card = nil
until valid_card?(card)
  print "Please enter the dealer's visible card: "
  card = gets.chomp!
  valid_card?(card) ? nil : puts("Please tell me a valid card.")
end
dealerCards << card

# Determine if user has a pair
# puts "Dealer Card: #{dealerCards}"
# puts "User Cards: #{userCards}"
# puts "User Card Sum: #{userCardsSum}"
if is_pair?(userCards)
  advice = pair_advice(userCardsSum, dealerCards[0])
elsif soft
  advice = soft_advice(userCardsSum, dealerCards[0])
else
  advice = hard_advice(userCardsSum, dealerCards[0])
end

puts "My advice to you: #{advice}"
