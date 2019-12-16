# LANGUAGE = ""
require "yaml"
MESSAGES = YAML.load_file("calculator_messages.yml")

def messages(message, lang = "en")
  MESSAGES[lang][message]
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

def integer?(input)
  input.to_i.to_s == input
end

def float?(input)
  input.to_f.to_s == input
end

def valid_number?(input)
  integer?(input) || float?(input)
end

def division(number1, number2)
  if number2 == "0"
    # prompt(messages("error_division_zero", LANGUAGE))
    messages("infinity", LANGUAGE)
    # "infinity"
  else
    number1.to_f / number2.to_f
  end
end

def operation_message(op)
  word =  case op
          when "1"
            messages("adding", LANGUAGE)
          when "2"
            messages("subtracting", LANGUAGE)
          when "3"
            messages("multiplying", LANGUAGE)
          when "4"
            messages("deviding", LANGUAGE)
          end
  word
end

=begin
we can assign the result to word in case of when
we want to add some code after the case statement.
=end

def clear_screen
  system('clear') || system('cls')
end

#-------------------------------------------------

language = ""
loop do
  prompt(messages("language_selection"))
  language = Kernel.gets().chomp().downcase

  break if language == "en" || language == "jp"
  prompt(messages("error_invalid_lang"))
end

LANGUAGE = language

prompt(messages("welcome", LANGUAGE))

name = ""
loop do
  name = Kernel.gets().chomp()
  if name.empty?
    prompt(messages("error_empty_input", LANGUAGE))
  else
    break
  end
end

prompt(messages("hi", LANGUAGE) + " #{name}!")

loop do # main loop
  number1 = ""
  loop do
    prompt(messages("first_number", LANGUAGE))
    number1 = Kernel.gets().chomp()
    if valid_number?(number1)
      break
    else
      prompt(messages("error_valid_number", LANGUAGE))
    end
  end

  number2 = ""
  loop do
    prompt(messages("second_number", LANGUAGE))
    number2 = Kernel.gets().chomp()
    valid_number?(number2)
    if valid_number?(number2)
      break
    else
      prompt(messages("error_valid_number", LANGUAGE))
    end
  end

  prompt(messages("operator_prompt", LANGUAGE))

  operator = ""
  loop do
    operator = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(messages("error_operator", LANGUAGE))
    end
  end

  prompt("#{operation_message(operator)}#{messages('calculating', LANGUAGE)}")

  case operator
  when "1"
    result = number1.to_f + number2.to_f
  when "2"
    result = number1.to_f - number2.to_f
  when "3"
    result = number1.to_f * number2.to_f
  when "4"
    result = division(number1, number2)
  end

  prompt(messages("result", LANGUAGE) + " #{result}")

  try_again_answer = ""
  loop do
    prompt(messages("try_again", LANGUAGE))
    try_again_answer = Kernel.gets().chomp().downcase
    if try_again_answer.empty?
      prompt(messages("error_empty_input", LANGUAGE))
    elsif try_again_answer != "yes" && try_again_answer != "no"
      prompt(messages("error_invaild_input", LANGUAGE))
    else
      break
    end
  end

  clear_screen if try_again_answer == "yes"
  break if try_again_answer == "no"
end

prompt(messages("good_bye", LANGUAGE) + " #{name}!")
