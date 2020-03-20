# r == rock, p == paper, ss == scissors, sp == spock, l == lizard

VALID_CHOICES = ["r", "p", "ss", "sp", "l"]

def prompt(message)
  puts "=> #{message}"
end

def player_wins?(player_choice, computer_choice)
  win_conditions = {
    "ss" => ["p", "l"],
    "p" => ["r", "sp"],
    "r" => ["l", "ss"],
    "l" => ["sp", "p"],
    "sp" => ["ss", "r"]
  }
  (win_conditions[player_choice][0] == computer_choice) ||
    (win_conditions[player_choice][1] == computer_choice)
end

def display_results(player_choice, computer_choice)
  if player_choice == computer_choice
    prompt("It's a tie!")
  elsif player_wins?(player_choice, computer_choice)
    prompt("You won!")
  else
    prompt("Computer won!")
  end
end

def choice_to_word(choice)
  case choice
  when "r"
    "rock"
  when "p"
    "paper"
  when "ss"
    "scissors"
  when "sp"
    "spock"
  when "l"
    "lizard"
  end
end

def clear_screen
  system("clear") || system("cls")
end

loop do
  player_choice = ""

  loop do
    prompt("Let's play a rock paper scissors spock lizard!\n
    Choose one >> type : 'r' for 'rock', 'p' for 'paper',\n
    'ss' for 'scissors','sp' for 'spock', 'l' for 'lizard')")

    player_choice = gets.downcase.chomp

    if %w(r p ss sp l).include?(player_choice)
      break
    else
      prompt("That's not a valid choice")
    end
  end

  computer_choice = VALID_CHOICES.sample

  prompt("You chose : #{choice_to_word(player_choice)}
   Computer chose : #{choice_to_word(computer_choice)}")

  display_results(player_choice, computer_choice)

  prompt("Do you want to play again?(yes or no)")
  answer = gets.chomp.downcase
  clear_screen if answer == "yes"
  break if answer == "no"
end

prompt("Thank you for playing. Good bye!")
