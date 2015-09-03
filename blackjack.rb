#!/usr/bin/env ruby

#require_relative 'cardart'
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
  if deck_num == ""
    puts "\e[A\e[K" #clear the last input line so I don't have a hanging input
    leave("Quitting.")
  end
  deck_num = deck_num.to_i rescue false
  deck_num == 1 || deck_num == 2 || deck_num > 3
end

def cards_determine_soft(cards)
  sum = cards_determine_sum(cards)
  cards.each do |card|
    next if card == "K" || card == "Q" || card == "J"
    card = card.to_i
    return false if card == 0 && sum + 11 > 21
  end
  cards_determine_sum(cards, "ace_is_one") < 21 && cards.include?("A")
end

def cards_determine_sum(cards, mode = "auto")
  sum = 0
  sortedcards = cards.clone
  sortedcards.length.times do |c|
    if sortedcards[c-1] == "A"
     sortedcards[c-1] = "Z"
    end
  end
  sortedcards.sort!
  sortedcards.each do |card|
    if (card == "K" || card == "Q" || card == "J") then sum += 10; next end
    card = card.to_i
    if (card != 0) then sum += card; next end

    case mode
    when "auto"
      if (card == 0 && sum + 11 > 21) then sum += 1 else sum += 11 end
    when "ace_is_one"
      if card == 0 then sum += 1 end
    when "ace_is_eleven"
      if card == 0 then sum += 11 end
    end
  end
  sortedcards = []
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
puts "      A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K\n\n"

soft = false
advice = ""
gameOver = false


# Collect Deck Choice
puts "How many decks will you be playing with today? 1, 2, or 4+?"
until valid_deck?(decks)
  print "Number of decks: "
  decks = gets.chomp
  valid_deck?(decks) ? next : puts("That's not a valid number of decks")
end
decks = decks.to_i

# Collect card details for first round
card = nil
until valid_card?(card)
  print "Please enter the dealer's visible card: "
  card = gets.chomp!
  card = card.upcase
  valid_card?(card) ? next : puts("Please tell me a valid card.")
end
dealerCards << card
dealerCardsSum = cards_determine_sum(dealerCards)

until gameOver

  userCardsSum = cards_determine_sum(userCards)
  card_num = userCards.length + 1

  if userCardsSum == 21
    gameOver = true
    system 'say -v "Pipe Organ" "You won!!" 2> /dev/null &'
    leave("You won!!")
  end

  card = nil
  until valid_card?(card)
    print "Please enter your #{card_num.ordinalize} card: "
    card = gets.chomp!
    card = card.upcase
    valid_card?(card) ? next : puts("Please tell me a valid card.")
  end
  userCards << card

  userCardsSum = cards_determine_sum(userCards)
  soft = cards_determine_soft(userCards)
  soft ? soft_word = "Soft" : soft_word = "Hard"

  if userCardsSum > 21
    puts "You busted with #{cards_determine_sum(userCards)}! Sorry bruh."
    gameOver = true
    puts "#{userCards}"
    next
  end

  if userCards.length > 1

    # Determine if user has a pair
    puts "Dealer Card: #{dealerCards}"
    puts "User Cards: #{userCards}"
    puts "User Card Sum: #{userCardsSum} #{soft_word}"
    if is_pair?(userCards)
      puts "You have a pair!"
      advice = pair_advice(userCards[0], dealerCardsSum, decks)
    elsif soft
      advice = soft_advice(userCardsSum, dealerCardsSum, decks)
    else
      advice = hard_advice(userCardsSum, dealerCardsSum, decks)
    end

    if advice == "Bust"
      next
    end

    puts "My advice to you is to #{advice}"
  end
end
