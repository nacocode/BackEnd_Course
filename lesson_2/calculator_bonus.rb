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

def language_setting(language)
  loop do
    prompt(messages("language_selection"))
    language = Kernel.gets().chomp().downcase
    return language if language == "en" || language == "jp"
    prompt(messages("error_invalid_lang"))
  end
end

def get_name(name, language)
  loop do
    name = Kernel.gets().chomp()
    if name.empty?
      prompt(messages("error_empty_input", language))
    else
      return name
    end
  end
end

def get_number(msg, language)
  loop do
    prompt(messages(msg, language))
    number = Kernel.gets().chomp()
    if valid_number?(number)
      return number
    else
      prompt(messages("error_valid_number", language))
    end
  end
end

def get_operator(operator, language)
  loop do
    prompt(messages("operator_prompt", language))
    operator = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operator)
      return operator
    else
      prompt(messages("error_operator", language))
    end
  end
end

def division(number1, number2, language)
  if number2 == "0"
    prompt(messages("error_division_zero", language))
    messages("infinity", language)
    # "infinity"
  else
    number1.to_f / number2.to_f
  end
end

def op_to_msg(op, language)
  word =  case op
          when "1"
            messages("adding", language)
          when "2"
            messages("subtracting", language)
          when "3"
            messages("multiplying", language)
          when "4"
            messages("deviding", language)
          end
  word
end

def calculation(operator, number1, number2, language)
  case operator
  when "1"
    number1.to_f + number2.to_f
  when "2"
    number1.to_f - number2.to_f
  when "3"
    number1.to_f * number2.to_f
  when "4"
    division(number1, number2, language)
  end
end

def get_op_answer(answer, language)
  loop do
    prompt(messages("continue", language))
    answer = Kernel.gets().chomp().downcase
    if answer.empty?
      prompt(messages("error_empty_input", language))
    elsif answer != "yes" && answer != "no"
      prompt(messages("error_invaild_input", language))
    else
      return answer
    end
  end
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
LANGUAGE = language_setting(language)

prompt(messages("welcome", LANGUAGE))

name = get_name(name, LANGUAGE)

prompt(messages("hi", LANGUAGE) + " #{name}!")

#----------------main loop---------------------------------

loop do
  number1 = get_number("first_number", LANGUAGE)

  number2 = get_number("second_number", LANGUAGE)

  operator = get_operator(operator, LANGUAGE)

  prompt("#{op_to_msg(operator, LANGUAGE)}#{messages('calculating', LANGUAGE)}")

  result = calculation(operator, number1, number2, LANGUAGE)

  prompt(messages("result", LANGUAGE) + " #{result}")

  answer = get_op_answer(answer, LANGUAGE)

  clear_screen if answer == "yes"

  break if answer == "no"
end

prompt(messages("good_bye", LANGUAGE) + " #{name}!")
