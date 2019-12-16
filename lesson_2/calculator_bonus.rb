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

def get_number(msg, language)
  loop do
    prompt(messages(msg, language))
    number = Kernel.gets().chomp()
    if valid_number?(number)
      return number
    else
      prompt(messages("error_valid_number", LANGUAGE))
    end
  end
end

def get_operator(*)
  loop do
    prompt(messages("operator_prompt", LANGUAGE))
    operator = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operator)
      return operator
    else
      prompt(messages("error_operator", LANGUAGE))
    end
  end
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

#--------------------start-------------------------

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
  number1 = get_number("first_number", LANGUAGE)
  number2 = get_number("second_number", LANGUAGE)
  operator = get_operator(LANGUAGE)

  prompt("#{operation_message(operator)}#{messages('calculating', LANGUAGE)}")

  result =  case operator
            when "1"
              number1.to_f + number2.to_f
            when "2"
              number1.to_f - number2.to_f
            when "3"
              number1.to_f * number2.to_f
            when "4"
              division(number1, number2)
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
