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

def leave(message)
  puts "#{message}"
  exit
end

def valid_card?(card)
  possibleChoices = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "q", "a", "j", "k"]
  if card == ""
    puts "\e[A\e[K" #clear the last input line so I don't have a hanging input
    leave("Good luck!")
  end
  card ? possibleChoices.include?(card) : false
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

def cards_determine_soft(cards)
  soft = false
  cards.each do |card|
    if card == "A" || card == "a"
      soft = true
    end
  end
  if cards_determine_sum(cards) > 21 && (cards.include?("A") || cards.include?("a"))
    soft = false
  end
end

def cards_determine_sum(cards)
  sum = 0
  cards.map(&:upcase)
  cards.each do |c|
    if c == "A"
      card = "Z"
    end
  end
  cards.sort!
  #cards_counts = Hash.new(0)
  #cards.each{ |c| cards_counts[c] += 1 }
  cards.each do |card|
    if card == "K" || card == "Q" || card == "J"
      sum += 10
      next
    end

    card = card.to_i

    if card != 0
      sum += card
      next
    end

    if card == 0 && sum + 11 > 21
      sum += 1
    else
      sum += 11
    end

  end
  sum
end

def is_pair?(cards)
  if cards.length > 2
    return false
  end
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
game_over = false


# Collect Deck Choice
puts "How many decks will you be playing with today? 1, 2, or 4+?"
until valid_deck?(decks)
  print "Number of decks: "
  decks = gets.chomp
  valid_deck?(decks) ? nil : puts("That's not a valid number of decks")
end
decks = decks.to_i

# Collect card details for first round
card = nil
until valid_card?(card)
  print "Please enter the dealer's visible card: "
  card = gets.chomp!
  valid_card?(card) ? nil : puts("Please tell me a valid card.")
  # if card == "K" || card == "Q" || card == "J"
  #   card = "10"
  # end
end
dealerCards << card

until game_over

  card_num = userCards.length + 1

  if cards_determine_sum(userCards) == 21
    leave("You won!!")
  end

  card = nil
  until valid_card?(card)
    print "Please enter your #{card_num.ordinalize} card: "
    card = gets.chomp!
    valid_card?(card) ? nil : puts("Please tell me a valid card.")
  end
  userCards << card

  if cards_determine_sum(userCards).to_i > 21
    puts "You busted with #{cards_determine_sum(userCards)}! Sorry bruh."
    game_over = true
    puts "#{userCards}"
    next
  end

  if userCards.length > 1
    userCardsSum = cards_determine_sum(userCards)

    # Determine if user has a pair
    puts "Dealer Card: #{dealerCards}"
    puts "User Cards: #{userCards}"
    puts "User Card Sum: #{userCardsSum}"
    if is_pair?(userCards)
      puts "You have a pair!"
      advice = pair_advice(userCardsSum, dealerCards[0], decks)
    elsif soft
      advice = soft_advice(userCardsSum, dealerCards[0], decks)
    else
      advice = hard_advice(userCardsSum, dealerCards[0], decks)
    end

    if advice == "Bust"
      next
    end

    puts "My advice to you is to #{advice}"
  end
end
