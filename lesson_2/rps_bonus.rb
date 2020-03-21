VALID_CHOICES = [{ "r" => "rock" },
                 { "p" => "paper" },
                 { "ss" => "scissors" },
                 { "l" => "lizard" },
                 { "sp" => "spock" }]

def prompt(message)
  puts "=> #{message}"
end

def player_wins?(player_choice, computer_choice)
  win_conditions = {
    "scissors" => ["paper", "lizard"],
    "paper" => ["rock", "spock"],
    "rock" => ["lizard", "scissors"],
    "lizard" => ["spock", "paper"],
    "spock" => ["scissors", "rock"]
  }
  win_conditions[player_choice].include?(computer_choice)
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
    Choose one >> type : 'rock' or 'r' for 'rock', as well as\n
    'p' for 'paper','ss' for 'scissors','sp' for 'spock', 'l' for 'lizard'")

    player_choice = gets.downcase.chomp

    if %w(rock paper scissors lizard spock).include?(player_choice)
      break
    elsif %w(r p ss l sp).include?(player_choice)
      player_choice = choice_to_word(player_choice)
      break
    else
      prompt("That's not a valid choice")
    end
  end

  computer_choice = VALID_CHOICES.sample.values.join

  prompt("You chose : #{player_choice}
   Computer chose : #{computer_choice}")

  display_results(player_choice, computer_choice)

  prompt("Do you want to play again?(yes or no)")
  answer = gets.chomp.downcase
  clear_screen if answer == "yes"
  break if answer == "no"
end

prompt("Thank you for playing. Good bye!")
