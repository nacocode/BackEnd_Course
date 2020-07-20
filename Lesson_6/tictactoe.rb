require "pry"

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # column
                [[1, 5, 9], [3, 5, 7]] # diagnals

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop: disable Metrics/AbcSize
def display_board(brd)
  puts "                                                            "
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop: enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delimiter = ', ', word = 'or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end

def greeting
  prompt "Welcome to the TIC TAC TOE!\n
  First player who wins 5 times become the Grand winner!\n
  Let's get started!"
end

def player_places_piece!(brd)
  square = ""
  loop do
    prompt "Choose a position to place a piece:
    (#{joinor(empty_squares(brd))})"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, That's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_squere(line, brd, maker)
  if brd.values_at(*line).count(maker) == 2
    brd.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def get_mark_at_risk_square(brd, maker)
  square = nil

  WINNING_LINES.each do |line|
    square = find_at_risk_squere(line, brd, maker)
    break if square
  end

  square
end

def computer_places_piece!(brd)
  # offense first
  square = get_mark_at_risk_square(brd, COMPUTER_MARKER)

  # defense
  if !square
    square = get_mark_at_risk_square(brd, PLAYER_MARKER)
  end

  # pick square #5 if it's available
  square = 5 if brd[5] == INITIAL_MARKER

  # just pick a square ramdomly
  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
  # means : board is full
  # also can be witten >> empty_squares(brd) == []
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return "player"
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return "computer"
    end
    # if brd[line[0]] == PLAYER_MARKER &&
    #    brd[line[1]] == PLAYER_MARKER &&
    #    brd[line[2]] == PLAYER_MARKER
    #   return "player"
    # elsif brd[line[0]] == COMPUTER_MARKER &&
    #       brd[line[1]] == COMPUTER_MARKER &&
    #       brd[line[2]] == COMPUTER_MARKER
    #   return "Computer"
    # end
  end
  nil
end

def display_score(score)
  prompt "[SCORE]"
  score.each { |k, v| puts "#{k} : #{v}" }
end

def keep_score(score, winner)
  if winner == "player"
    score["player"] += 1
  elsif winner == "computer"
    score["computer"] += 1
  end
end

def grand_winner?(score)
  if score.key(5) == "player"
    prompt "You won 5 times! Congratulations! You are the Grand Winner!!!"
  elsif score.key(5) == "computer"
    "Computer won 5 times. Game over."
  end
end

# Starting a game
greeting

loop do
  score = { "player" => 0, "computer" => 0 }

  loop do
    board = initialize_board

    loop do
      display_board(board)
      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      system "clear"
    end

    display_board(board)

    winner = detect_winner(board)
    system "clear"

    if someone_won?(board)
      prompt "#{winner} won!"
    else
      prompt "It's a tie!"
    end

    keep_score(score, winner)
    display_score(score)
    break if score.value?(5)
  end

  grand_winner?(score)

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
