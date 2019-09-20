#LANGUAGE = ""
require "yaml"
MESSAGES = YAML.load_file("Calculator_messages.yml")


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

def devision(number1, number2)
  if number2 == "0" 
    #prompt(messages("error_division_zero", LANGUAGE))
    messages("infinity", LANGUAGE)
    #"infinity"
  else
    number1.to_f / number2.to_f
  end
end

def operation_to_message(op)
  word = case  op
          when  "1"
            messages("adding", LANGUAGE)
          when "2"
            messages("subtracting", LANGUAGE)
          when "3"
            messages("multiplying", LANGUAGE)
          when "4"
            messages("deviding", LANGUAGE)
         end
  # we assign the result to word in case of when we want to add some code after the case statement.
  word
end

#------------------------------------------------------------------------------------------------------------------

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
    prompt(messages("valid_name", LANGUAGE))
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

  prompt("#{operation_to_message(operator)}#{(messages("calculating", LANGUAGE))}")
  result = case operator
           when "1"
             number1.to_f + number2.to_f
           when "2"
             number1.to_f - number2.to_f
           when "3"
             number1.to_f * number2.to_f
           when "4"
             devision(number1, number2)
           end

  prompt(messages("result", LANGUAGE) + " #{result}.")

  prompt(messages("try_again", LANGUAGE))
  answer = Kernel.gets().chomp().downcase
  break if ["no", "n"].include?(answer)
  # my solution here is : answer = Kernel.gets().chomp().downcase
  #                       break unless answer == "y"
end

prompt(messages("good_bye", LANGUAGE) + " #{name}!")
