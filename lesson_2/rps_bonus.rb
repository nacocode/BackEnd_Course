VALID_CHOICES = [{ "r" => "rock" },
                 { "p" => "paper" },
                 { "ss" => "scissors" },
                 { "l" => "lizard" },
                 { "sp" => "spock" }]

def prompt(message)
  puts "=> #{message}"
end

def greeting
  prompt("Let's play a rock paper scissors spock lizard!\n
  Choose one >> type : 'rock' or 'r' for 'rock', as well as\n
  'p' for 'paper','ss' for 'scissors','sp' for 'spock', 'l' for 'lizard'.")
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

score = {
  "player" => 0,
  "computer" => 0
}

def keep_score(score, player_choice, computer_choice)
  if player_wins?(player_choice, computer_choice)
    score["player"] += 1
  elsif player_wins?(computer_choice, player_choice)
    score["computer"] += 1
  end

  prompt("<Scores>")
  score.each { |key, value| puts "#{key}: #{value}" }
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

def grand_winner(score)
  if score.key(5) == "player"
    prompt("You won 5 times! Congratulations! You are the Grand Winner!!!")
  elsif score.key(5) == "computer"
    prompt("Computer won 5 times. Game over.")
  end
end

def continue?(continue_answer)
  loop do
    prompt("Do you want to play again?(yes or no)")
    continue_answer = gets.chomp.downcase
    if continue_answer == "yes" || continue_answer == "no"
      return continue_answer
    else
      prompt("Error: Invalid input. Try again.")
    end
  end
end

def clear_screen
  system("clear") || system("cls")
end

def good_bye
  prompt("Thank you for playing. Good bye!")
end

loop do
  player_choice = ""

  loop do
    loop do
      greeting

      player_choice = gets.downcase.chomp

      if %w(rock paper scissors lizard spock).include?(player_choice)
        break
      elsif %w(r p ss l sp).include?(player_choice)
        player_choice = choice_to_word(player_choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    computer_choice = VALID_CHOICES.sample.values.join

    prompt("You chose : #{player_choice}
    Computer chose : #{computer_choice}")

    display_results(player_choice, computer_choice)

    keep_score(score, player_choice, computer_choice)

    grand_winner(score)
    break if score.value?(5)
  end

  score["player"] = 0
  score["computer"] = 0

  continue_answer = continue?(continue_answer)

  clear_screen if continue_answer == "yes"
  break if continue_answer == "no"
end

good_bye
