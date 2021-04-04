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

def display_welcome_msg
  clear_screen
  prompt "WELCOME TO #{GAME_NAME}!"
  prompt "The goal of #{GAME_NAME} is to try to get as close to "\
  "#{GAME_NAME} as possible,\n
   without going over."
  prompt "First player who wins the game #{WIN_SCORE} times "\
  "becomes the grand winner!"
  display_rules if show_rules?
  clear_screen
end

def show_rules?
  prompt "To find out more about the rules, type 'r'.\n
   To start the game, press any other key."
  answer = gets.chomp.downcase
  answer == "r"
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
  "You can see their 2 cards, but can only see one of the dealer's cards."
  puts "  ・ You go first, and can decide to either 'hit' or 'stay'."
end

def rules_two
  puts "  ・ To 'hit' is to ask for another card. "\
  "To 'stay' is to hold your total and end your turn."
  puts "  ・ You can continue to hit as many times as you want but "\
  "if you go over #{GAME_NAME}, it's a 'BUST', means you lose."
  puts "  ・ Dealer must hit until the total is at least "\
  "#{DEALER_HIT_MIN} or higher. If the dealer busts, means you win."
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
  prompt "You have #{player_hand}, "\
  "for a total of: #{calculate_hand_total(player_hand)}."
end

def display_player_hand(player_hand)
  prompt "You have #{player_hand}, "\
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

  if answer.start_with?("h")
    prompt "You chose to hit!"
  else
    prompt "You chose to stay."
  end

  sleep(1)
  answer
end

def player_hit(player_hand, deck)
  player_hand << deck.pop
  display_player_hand(player_hand)
  sleep(1)
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
      prompt "You stayed at #{calculate_hand_total(player_hand)}."
      sleep(2)
      break
    end
  end
end

def dealer_hit(dealer_hand, deck)
  prompt "Dealer chose to hit!"
  sleep(1)
  dealer_hand << deck.pop
  display_dealer_hand(dealer_hand)
  sleep(1)
end

def display_dealer_stay(dealer_hand)
  prompt "Dealer chose to stay."
  sleep(1)
  prompt "Dealer chose to stayed at #{calculate_hand_total(dealer_hand)}."
end

def dealer_turn(dealer_hand, deck)
  prompt "Dealer's turn..."
  sleep(1)

  loop do
    if calculate_hand_total(dealer_hand) >= DEALER_HIT_MIN
      display_dealer_stay(dealer_hand)
      break
    end

    dealer_hit(dealer_hand, deck)
    break if busted?(dealer_hand)
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

def display_round_winner(player_hand, dealer_hand)
  result = detect_result(player_hand, dealer_hand)

  case result
  when :player_busted
    prompt "You busted! Dealer won this round!"
  when :dealer_busted
    prompt "Dealer busted! You won this round!"
  when :player
    prompt "You won this round!"
  when :dealer
    prompt "Dealer won this round!"
  when :tie
    prompt "It's a tie."
  end

  sleep(1.5)
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

def display_score(score)
  sleep(1)
  display_newline
  puts "«SCORE» You | #{score['player']} - " \
  "#{score['dealer']} | Dealer"
  display_newline(2)
end

def grand_winner?(score)
  score.value?(WIN_SCORE)
end

def reveal_hand(player_hand, dealer_hand)
  prompt "Both you and dealer stayed. " \
  "Let's reveal hands!"
  sleep(1)
  display_player_hand(player_hand)
  sleep(1)
  display_dealer_hand(dealer_hand)
  display_newline
  sleep(1)
end

def end_of_round(player_hand, dealer_hand, score)
  display_newline
  display_round_winner(player_hand, dealer_hand)
  keep_score(score, player_hand, dealer_hand)
  display_score(score)
end

def display_grand_winner(score)
  case score.key(WIN_SCORE)
  when "player"
    prompt "You won #{WIN_SCORE} times! Congratulations! "\
    "You are the grand winner!"
  when "dealer"
    prompt "Dealer won #{WIN_SCORE} times. Game over."
  end
end

def next_round?
  display_newline
  prompt "Next round? Press enter key to continue\n
  or hit 'q' if you wish to quit the game."
  answer = gets.chomp.downcase
  VALID_QUIT.none?(answer)
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
  display_newline(2)
  prompt "Thank you for playing #{GAME_NAME}. Good bye!"
end

# Main game

display_welcome_msg

loop do
  score = initialize_score
  round_no = 0

  loop do
    round_no += 1
    player_hand = []
    dealer_hand = []
    deck = initialize_deck

    display_round_no(round_no)
    initial_deal(player_hand, dealer_hand, deck)
    display_initial_hand(player_hand, dealer_hand)

    player_turn(player_hand, deck)

    if busted?(player_hand)
      end_of_round(player_hand, dealer_hand, score)
      break if grand_winner?(score)

      if next_round?
        clear_screen
        next
      else
        break
      end
    end

    clear_screen

    dealer_turn(dealer_hand, deck)

    if busted?(dealer_hand)
      end_of_round(player_hand, dealer_hand, score)
      break if grand_winner?(score)

      if next_round?
        clear_screen
        next
      else
        break
      end
    end

    sleep(2)
    clear_screen

    reveal_hand(player_hand, dealer_hand)
    end_of_round(player_hand, dealer_hand, score)
    break if grand_winner?(score) || !next_round?

    clear_screen
  end

  break if !grand_winner?(score)

  display_grand_winner(score)
  sleep(2.5) if grand_winner?(score)
  break unless play_again?

  clear_screen
end

display_goodbye_msg
