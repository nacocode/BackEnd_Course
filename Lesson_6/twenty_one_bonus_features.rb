SUITS = ["H", "D", "C", "S"]
VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
GAME_NAME = 21
DEALER_HIT_MIN = GAME_NAME - 4
WIN_SCORE = 3
VALID_YES_NO = %w(yes y no n)
VALID_YES = %w(yes y)

def prompt(msg)
  puts "=> #{msg}"
  puts
end

def clear_screen
  system "clear"
end

def display_welcome_msg
  prompt "Welcome to #{GAME_NAME}!"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > GAME_NAME
  end

  sum
end

def busted?(cards)
  total(cards) > GAME_NAME
end

# :tie, :player, :dealer, :player_busted, :dealer_busted, :
def detect_result(player_cards, dealer_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > GAME_NAME
    :player_busted
  elsif dealer_total > GAME_NAME
    :dealer_busted
  elsif player_total > dealer_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(player_cards, dealer_cards)
  result = detect_result(player_cards, dealer_cards)

  case result
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def keep_score(score, player_cards, dealer_cards)
  result = detect_result(player_cards, dealer_cards)

  case result
  when :player_busted
    score["dealer"] += 1
  when :dealer_busted
    score["player"] += 1
  when :player
    score["player"] += 1
  when :dealer
    score["dealer"] += 1
  end
end

def display_score(score)
  puts "«SCORE» You | #{score['player']} - " \
  "#{score['dealer']} | Dealer"
  puts
end

def grand_winner?(score)
  score.value?(WIN_SCORE)
end

def display_grand_winner(score)
  if score.key(WIN_SCORE) == "player"
    prompt "You won #{WIN_SCORE} times! Congratulations! "\
    "You are the grand winner!"
  elsif score.key(WIN_SCORE) == "dealer"
    prompt "Dealer won #{WIN_SCORE} times. Game over."
  end
end

def play_again?
  answer = nil
  loop do
    prompt "Do you want to play again? "\
    "Enter 'y' for yes or 'n' for no."
    answer = gets.chomp.downcase
    break if VALID_YES_NO.include?(answer)
    prompt "Not a valid input."
  end

  VALID_YES.include?(answer)
end

def display_goodbye_msg
  prompt "Thank you for playing #{GAME_NAME}. Good bye!"
end

clear_screen
display_welcome_msg

loop do
  score = { "player" => 0, "dealer" => 0 }

  loop do
    clear_screen
    # initialize variables
    deck = initialize_deck
    player_cards = []
    dealer_cards = []

    # initial deal
    2.times do
      player_cards << deck.pop
      dealer_cards << deck.pop
    end

    prompt "Dealer has #{dealer_cards[0]} and ?"
    prompt "You have #{player_cards[0]} and "\
    "#{player_cards[1]}, for a total of #{total(player_cards)}."

    # player turn.
    loop do
      player_turn = nil
      loop do
        prompt "Would you like to hit or stay? "\
        "(Enter h or s)"
        player_turn = gets.chomp.downcase
        break if ["h", "s"].include?(player_turn)
        prompt "Sorry, must enter 'h' or 's'."
      end

      if player_turn == "h"
        player_cards << deck.pop
        prompt "You chose to hit!"
        prompt "Your cards are now: #{player_cards}."
        prompt "Your total is now: #{total(player_cards)}."
      end

      break if player_turn == "s" || busted?(player_cards)
    end

    if busted?(player_cards)
      display_result(player_cards, dealer_cards)
      keep_score(score, player_cards, dealer_cards)
      display_score(score)
      play_again? ? next : break
    else
      prompt "You stayed at #{total(player_cards)}"
    end

    # dealer turn
    prompt "Dealer turn..."

    loop do
      break if total(dealer_cards) >= DEALER_HIT_MIN
      dealer_cards << deck.pop
      prompt "Dealer's cards are now: #{dealer_cards}"
    end

    if busted?(dealer_cards)
      prompt "Dealer's total is now: #{total(dealer_cards)}"
      display_result(player_cards, dealer_cards)
      keep_score(score, player_cards, dealer_cards)
      display_score(score)
      play_again? ? next : break
    else
      prompt "Dealer stayed at #{total(dealer_cards)}"
    end

    # When both player and dealer stays - compare cards!
    prompt "You have #{dealer_cards}, "\
    "for a total of: #{total(player_cards)}"
    prompt "Dealer has #{dealer_cards}, "\
    "for a total of: #{total(dealer_cards)}"

    display_result(player_cards, dealer_cards)
    keep_score(score, player_cards, dealer_cards)
    display_score(score)
    break if grand_winner?(score) || !play_again?
  end

  display_grand_winner(score)
  break unless play_again?
end

display_goodbye_msg
