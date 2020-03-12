VALID_CHOICES = ["rock", "paper", "scissors"]

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  (first == "rock" && second == "scissors") ||
    (first == "paper" && second == "rock") ||
    (first == "scissors" && second == "paper")
end

def display_results(player_choice, computer_choice)
  if win?(player_choice, computer_choice)
    prompt("You won!")
  elsif win?(computer_choice, player_choice)
    prompt("Computor won!")
  else
    prompt("It's a tie!")
  end
end

def clear_screen
  system("clear") || system("cls")
end

loop do
  player_choice = ""
  loop do
    prompt("Choose one : #{VALID_CHOICES.join(', ')}")
    player_choice = gets.chomp

    if VALID_CHOICES.include?(player_choice)
      break
    else
      prompt("That's not a valid choice")
    end
  end

  computer_choice = VALID_CHOICES.sample

  prompt("You chose : #{player_choice}, Computer chose : #{computer_choice}")
  display_results(player_choice, computer_choice)

  prompt("Do you want to play again?(yes or no)")
  answer = gets.chomp.downcase
  clear_screen if answer == "yes"
  break if answer == "no"
end

prompt("Thank you for playing. Good bye!")
