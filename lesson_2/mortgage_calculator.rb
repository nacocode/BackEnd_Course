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
      return number.to_f
    else
      prompt(messages("error_invalid_input"))
    end
  end
end

def year_to_month(number)
  number.to_i * 12
end

def continue?(answer)
  loop do
    prompt(messages("continue"))
    answer = Kernel.gets().chomp().downcase
    if answer.empty?
      prompt(messages("error_blank_input"))
    elsif answer != "yes" && answer != "no"
      prompt(messages("error_invalid_input"))
    else
      return answer
    end
  end
end

def clear_screen
  system("clear") || system("cls")
end

#---Main---------------------------------------------------------
prompt("Welome to the Mortgage Calculator!")
prompt("-----------------------------------")

loop do
  mortgage_amount = retrieve_number("retrieve_mortgage_amount")
  annual_interest_rate = retrieve_number("retrieve_interest_rate")
  duration = retrieve_number("retrieve_loan_duration")
  month_duration = year_to_month(duration)
  monthly_interest_rate = (annual_interest_rate.to_f / 12)

  prompt("Mortgage amount is $#{mortgage_amount}")
  prompt("interest is #{annual_interest_rate}%")
  prompt("duration is #{duration} years")
  prompt("month duration is #{month_duration} months")
  prompt("monthly interest rate is #{monthly_interest_rate.round(2)}%")

  monthly_payment = mortgage_amount * (monthly_interest_rate / (1 - (1 + monthly_interest_rate)**(-month_duration)))

  prompt("monthly payment is $#{monthly_payment.round(2)}")

  continue_answer = continue?(continue_answer)

  clear_screen if continue_answer == "yes"
  break if continue_answer == "no"
end

prompt(messages("good_bye"))
