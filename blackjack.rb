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

def valid_deck?(deck_num)
  if deck_num
    deck_num = deck_num.to_i
  else
    return false
  end

  if deck_num < 1
    return false
  end

  if deck_num == 3
    return false
  end

  deck_num == 1 || deck_num == 2 || deck_num > 3
end

def cards_sum_determine_soft(cards)
  sum = 0
  soft = false
  cards.each do |card|
    if card.upcase == "A"
      sum += 11
      soft = true
    end

    if card.upcase == "K" || card.upcase == "Q" || card.upcase == "J"
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
decks = 0

cardIntro =   "                   ______\n"
cardIntro +=  "                   |J ____|_\n"
cardIntro +=  "                   | |A     |\n"
cardIntro +=  "                   | |  /\\  |\n"
cardIntro +=  "                   | | /  \\ |\n"
cardIntro +=  "                   | |( -- )|\n"
cardIntro +=  "                   |_|  )(  |\n"
cardIntro +=  "                     |_____V|\n"

puts cardIntro
puts "                \e[1mBLACKJACK ADVISOR\e[0m"

puts "  I need some information before I can give advice."
puts "Please tell me some cards in play using these values:"
puts "     A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K\n\n"

soft = false
advice = ""


# Collect Deck Choice
puts "How many decks will you be playing with today? 1, 2, or 4+?"
until valid_deck?(decks)
  print "Number of decks: "
  decks = gets.chomp
  valid_deck?(decks) ? nil : puts("That's not a valid number of decks")
end
decks = decks.to_i

# Collect card details
card = nil
until valid_card?(card)
  print "Please enter the dealer's visible card: "
  card = gets.chomp!
  valid_card?(card) ? nil : puts("Please tell me a valid card.")
end
dealerCards << card

card = nil
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

# Determine if user has a pair
# puts "Dealer Card: #{dealerCards}"
# puts "User Cards: #{userCards}"
# puts "User Card Sum: #{userCardsSum}"
if is_pair?(userCards)
  advice = pair_advice(userCardsSum, dealerCards[0], decks)
elsif soft
  advice = soft_advice(userCardsSum, dealerCards[0], decks)
else
  advice = hard_advice(userCardsSum, dealerCards[0], decks)
end

puts "My advice to you: #{advice}"
