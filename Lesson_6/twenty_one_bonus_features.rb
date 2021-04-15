SUITS = ["H", "D", "C", "S"]
VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
GAME_NAME = 21
DEALER_HIT_MIN = GAME_NAME - 4
WIN_SCORE = 3
VALID_YES_NO = %w(yes y no n)
VALID_YES = %w(yes y)
VALID_HIT_STAY = %w(hit h stay s)
VALID_QUIT = %w(q quit)

def prompt(msg)
  puts "=> #{msg}"
  puts
end

def clear_screen
  system "clear"
end

def display_newline(num = 1)
  num.times { puts "" }
end

def show_rules?
  prompt "To find out more about the rules, type 'r'.\n
   To start the game, press any other key."
  answer = gets.chomp.downcase
  %w(r rule).include?(answer)
end

def rule_title
  clear_screen
  prompt "#{GAME_NAME} Rules:"
end

def rules_one
  puts "<Card values>"
  puts "  ・ 2-10 : face value. "
  puts "  ・ Jack, Queen or King : 10."
  puts "  ・ Aces: 1 or 11 (whichever makes a better hand)."
  puts
  puts "<How To Play>"
  puts "  ・ Each player starts with two cards, "\
  "Player can see their 2 cards, but can only see one of the dealer's cards."
  puts "  ・ Player goes first, and can decide to either 'hit' or 'stay'."
end

def rules_two
  puts "  ・ To 'hit' is to ask for another card. "\
  "To 'stay' is to hold player's total and end player's turn."
  puts "  ・ Player can continue to hit as many times as player wants but "\
  "if player goes over #{GAME_NAME}, it's a 'BUST', means player loses."
  puts "  ・ Dealer must hit until the total is at least "\
  "#{DEALER_HIT_MIN} or higher. If the dealer busts, means player wins."
  puts "  ・ When both the player and the dealer stay, it's time to compare "\
  "the total value of the cards and see who has the highest value."
  display_newline(2)
end

def start_game
  prompt "Press any key to start the game."
  gets
end

def display_rules
  rule_title
  rules_one
  rules_two
  start_game
end

def display_welcome_msg
  clear_screen
  prompt "WELCOME TO #{GAME_NAME}!"
  prompt "The goal of #{GAME_NAME} is to try to get as close to "\
  "#{GAME_NAME} as possible,\n
   without going over."
  prompt "First player who wins the game #{WIN_SCORE} times "\
  "becomes the grand winner!"
  display_rules if show_rules?
end

def display_round_no(num)
  puts "<< ROUND #{num} >>"
  display_newline(2)
end

def initialize_score
  { "player" => 0, "dealer" => 0 }
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def initial_deal(player_hand, dealer_hand, deck)
  2.times do
    player_hand << deck.pop
    dealer_hand << deck.pop
  end
end

def display_initial_hand(player_hand, dealer_hand)
  prompt "Dealer has #{dealer_hand[0]} and unknown."
  prompt "Player has #{player_hand}, "\
  "for a total of: #{calculate_hand_total(player_hand)}."
end

def display_player_hand(player_hand)
  prompt "Player has #{player_hand}, "\
  "for a total of: #{calculate_hand_total(player_hand)}."
end

def display_dealer_hand(dealer_hand)
  prompt "Dealer has #{dealer_hand}, "\
  "for a total of: #{calculate_hand_total(dealer_hand)}."
end

def hit_or_stay
  answer = nil
  loop do
    prompt "Would you like to hit or stay? "\
    "(Enter h or s)"
    answer = gets.chomp.downcase
    break if VALID_HIT_STAY.include?(answer)

    prompt "Sorry, must enter 'h' or 's'."
  end

  answer
end

def player_hit(player_hand, deck)
  prompt "Player chose to hit!"
  sleep(1)
  player_hand << deck.pop
  display_player_hand(player_hand)
  sleep(1)
end

def player_stay(player_hand)
  prompt "Player chose to stay."
  sleep(1)
  prompt "Player stayed at #{calculate_hand_total(player_hand)}."
  sleep(2)
end

def calculate_hand_total(hand)
  # hand = [['H', '3'], ['S', 'Q'], ... ]
  values = hand.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0 # J, Q, K
             10
           else
             value.to_i
           end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > GAME_NAME
  end

  sum
end

def busted?(hand)
  calculate_hand_total(hand) > GAME_NAME
end

def player_turn(player_hand, deck)
  player_move = ""

  display_newline(2)
  prompt "Player's turn..."
  sleep(1)

  loop do
    player_move = hit_or_stay
    if player_move.start_with?("h")
      player_hit(player_hand, deck)
      break if busted?(player_hand)
    else
      player_stay(player_hand)
      break
    end
  end
end

def dealer_hit(dealer_hand, deck)
  prompt "Dealer chose to hit!"
  sleep(1)
  dealer_hand << deck.pop
end

def display_dealer_stay
  prompt "Dealer chose to stay."
  sleep(2)
end

def dealer_turn(dealer_hand, deck)
  clear_screen
  prompt "Dealer's turn..."
  sleep(1)

  loop do
    if calculate_hand_total(dealer_hand) >= DEALER_HIT_MIN
      display_dealer_stay(dealer_hand)
      break
    end

    dealer_hit(dealer_hand, deck)
    if busted?(dealer_hand)
      display_dealer_hand(dealer_hand)
      sleep(2)
      break
    end
  end
end

# :tie, :player, :dealer, :player_busted, :dealer_busted
def detect_result(player_hand, dealer_hand)
  player_total = calculate_hand_total(player_hand)
  dealer_total = calculate_hand_total(dealer_hand)

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

def determine_winner(player_hand, dealer_hand)
  winner = detect_result(player_hand, dealer_hand)

  case winner
  when :player, :dealer_busted
    "player"
  when :dealer, :player_busted
    "dealer"
  end
end

def display_round_win_msg(player_hand, dealer_hand)
  result = detect_result(player_hand, dealer_hand)

  case result
  when :player_busted
    prompt "Player busted! Dealer won this round!"
  when :dealer_busted
    prompt "Dealer busted! Player won this round!"
  when :player
    prompt "Player won this round!"
  when :dealer
    prompt "Dealer won this round!"
  when :tie
    prompt "It's a tie."
  end
end

def keep_score(score, player_hand, dealer_hand)
  winner = determine_winner(player_hand, dealer_hand)

  case winner
  when "player"
    score["player"] += 1
  when "dealer"
    score["dealer"] += 1
  end
end

def display_score(score, player_hand, dealer_hand)
  clear_screen
  keep_score(score, player_hand, dealer_hand)

  puts "«SCORE» Player | #{score['player']} - " \
  "#{score['dealer']} | Dealer"

  display_newline(3)
end

def grand_winner?(score)
  score.value?(WIN_SCORE)
end

def reveal_hand(player_hand, dealer_hand)
  clear_screen
  prompt "Both player and dealer stayed. " \
  "Let's reveal hands!"
  sleep(1.5)
  display_newline(2)
  display_player_hand(player_hand)
  display_dealer_hand(dealer_hand)
  sleep(2)
end

def display_round_winner(player_hand, dealer_hand)
  unless busted?(player_hand) || busted?(dealer_hand)
    reveal_hand(player_hand, dealer_hand)
  end

  display_newline(2)
  display_round_win_msg(player_hand, dealer_hand)
  sleep(2)
end

def display_grand_winner(score)
  case score.key(WIN_SCORE)
  when "player"
    prompt "Player won #{WIN_SCORE} times! Congratulations! "\
    "You are the grand winner!"
  when "dealer"
    prompt "Dealer won #{WIN_SCORE} times. Game over..."
  end
end

def next_round?
  prompt "Next round? Press enter key to continue\n
  or hit 'q' if you wish to quit the game."
  answer = gets.chomp.downcase
  VALID_QUIT.none?(answer)
end

def play_again?
  display_newline(2)

  answer = nil
  loop do
    prompt "Would you like to play again? "\
    "Enter 'y' for yes or 'n' for no."
    answer = gets.chomp.downcase
    break if VALID_YES_NO.include?(answer)

    prompt "Not a valid input."
  end

  VALID_YES.include?(answer)
end

def display_goodbye_msg
  display_newline(2)
  prompt "Thank you for playing #{GAME_NAME}. Good bye!"
end

# Main game

display_welcome_msg

loop do
  score = initialize_score
  round_no = 0

  loop do
    clear_screen
    round_no += 1
    player_hand = []
    dealer_hand = []
    deck = initialize_deck

    display_round_no(round_no)
    initial_deal(player_hand, dealer_hand, deck)
    display_initial_hand(player_hand, dealer_hand)

    player_turn(player_hand, deck)

    dealer_turn(dealer_hand, deck) unless busted?(player_hand)

    display_round_winner(player_hand, dealer_hand)

    display_score(score, player_hand, dealer_hand)

    break if grand_winner?(score)

    sleep(2)
    next_round? ? next : break
  end

  break if !grand_winner?(score)

  display_grand_winner(score)
  sleep(2.5) if grand_winner?(score)
  break unless play_again?

  clear_screen
end

display_goodbye_msg
