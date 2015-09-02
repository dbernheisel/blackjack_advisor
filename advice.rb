### Source http://wizardofodds.com/games/blackjack/strategy/calculator/
# Deck = 1
# Dealer stands on a soft 17
# Doubling is allowed after split
# No surrender allowed
# Dealer peeks for blackjack

### LEGEND :
# H   = Hit
# S   = Stand
# P   = Split
# Dh  = Double if possible, otherwise Hit
# Ds  = Double if possible, otherwise Stand

# Top comment row represents dealer's showing card
# Key represents user's total
# Advice is split depending on the condition of pair/soft/hard.

def legend(what)
  return "Hit" if what == "H"
  return "Stand" if what == "S"
  return "Split" if what == "P"
  return "Double if possible, otherwise hit" if what == "Dh"
  return "Double if possible, otherwise stand" if what == "Ds"
end

def convert_to_index(what)
  if what == "A"
    what = -1
  elsif what == "K" || what == "Q" || what == "J"
    what = -2
  end
  if what > 0
    what = what - 2
  end
  return what
end

def hard_advice(cardtotal, dealercard)
    advice = {
    #        2    3     4     5     6     7     8     9     10    A
    5   => ["H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H"],
    6   => ["H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H"],
    7   => ["H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H"],
    8   => ["H",  "H",  "H",  "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
    9	  => ["Dh", "Dh", "Dh", "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
    10  => ["Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "H",  "H"],
    11  => ["Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh"],
    12  => ["H",  "H",  "S",  "S",  "S",  "H",  "H",  "H",  "H",  "H"],
    13  => ["S",  "S",  "S",  "S",  "S",  "H",  "H",  "H",  "H",  "H"],
    14  => ["S",  "S",  "S",  "S",  "S",  "H",  "H",  "H",  "H",  "H"],
    15  => ["S",  "S",  "S",  "S",  "S",  "H",  "H",  "H",  "H",  "H"],
    16  => ["S",  "S",  "S",  "S",  "S",  "H",  "H",  "H",  "H",  "H"],
    17  => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"],
    18  => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"],
    19  => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"],
    20  => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"],
    21  => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"]
    }

    dealerindex = convert_to_index(dealercard)
    legend(advice[cardtotal][dealerindex])
end

def soft_advice(cardtotal, dealercard)
  advice = {
  #       2	    3	    4	    5	    6	    7	    8	    9	    10	   A
  5   => ["H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H"],
  6   => ["H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H"],
  7   => ["H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H",  "H"],
  8   => ["H",  "H",  "H",  "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
  9	  => ["Dh", "Dh", "Dh", "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
  10  => ["Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "H",  "H"],
  11  => ["Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh"],
  12  => ["H",  "H",  "S",  "S",  "S",  "H",  "H",  "H",  "H",  "H"],
  13  => ["H",  "H",  "Dh", "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
  14  => ["H",  "H",  "Dh", "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
  15  => ["H",  "H",  "Dh", "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
  16  => ["H",  "H",  "Dh", "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
  17  => ["Dh", "Dh", "Dh", "Dh", "Dh", "H",  "H",  "H",  "H",  "H"],
  18  => ["S",  "Ds", "Ds", "Ds", "Ds", "S",  "S",  "H",  "H",  "S"],
  19  => ["S",  "S",  "S",  "S",  "Ds", "S",  "S",  "S",  "S",  "S"],
  20  => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"],
  21  => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"]
  }

  dealerindex = convert_to_index(dealercard)
  legend(advice[cardtotal][dealerindex])
end

def pair_advice(cardtotal, dealercard)
  advice = {
  #     2	    3	    4	    5	    6	    7	    8	    9	    10	   A
  2 =>  ["P",  "P",  "P",  "P",  "P",  "P",  "H",  "H",  "H",  "H"],
  3 =>  ["P",  "P",  "P",  "P",  "P",  "P",  "P",  "H",  "H",  "H"],
  4 =>  ["H",  "H",  "P",  "P",  "P",  "H",  "H",  "H",  "H",  "H"],
  5 =>  ["Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "Dh", "H",  "H"],
  6 =>  ["P",  "P",  "P",  "P",  "P",  "P",  "H",  "H",  "H",  "H"],
  7 =>  ["P",  "P",  "P",  "P",  "P",  "P",  "P",  "H",  "S",  "H"],
  8 =>  ["P",  "P",  "P",  "P",  "P",  "P",  "P",  "P",  "P",  "P"],
  9 =>  ["P",  "P",  "P",  "P",  "P",  "S",  "P",  "P",  "S",  "S"],
  10 => ["S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S",  "S"],
  "A" => ["P",  "P",  "P",  "P",  "P",  "P",  "P",  "P",  "P",  "P"]
  }

  dealerindex = convert_to_index(dealercard)
  legend(advice[cardtotal][dealerindex])
end
