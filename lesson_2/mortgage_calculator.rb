require "yaml"
MESSAGES = YAML.load_file("mortgage_messages.yml")

def messages(message)
  MESSAGES[message]
end

def prompt(message)
  puts "=> #{message}"
end

def integer?(input)
  input.to_i.to_s == input
end

def float?(input)
  input.to_f.to_s == input || input.include?(".")
end

def valid_number(input)
  integer?(input) || float?(input)
end

def retrieve_number(msg)
  loop do
    prompt(messages(msg))
    number = gets.chomp
    if number.empty?
      prompt(messages("error_blank_input"))
    elsif number.to_f < 0 || number == "0"
      prompt(messages("greater_than_zero"))
    elsif valid_number(number)
      return number
    else
      prompt(messages("error_invalid_input"))
    end
  end
end

prompt("Welome to the mortgage calculator!")
prompt("-----------------------------------")

amount = retrieve_number("retrieve_amount")
interest = retrieve_number("retrieve_interest")

# prompt("What is the loan duration?")
