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

def retrieve_amount(number)
  loop do
    prompt("what is the Mortgage Amount?")
    amount = gets.chomp
    if amount.empty?
      prompt("Error:Make sure to enter a valid number. A blank space is not allowed.")
    elsif amount.to_f < 0 || amount == "0"
      prompt("Please enter a mortgage amount that is greater than 0")
    elsif valid_number(amount)
      return amount
    else
      prompt("Error: Invalid input.")
    end
  end
end

prompt("Welome to the mortgage calculator!")
prompt("-----------------------------------")


amount = retrieve_amount(amount)
prompt("#{amount}")

=begin
  prompt("What is the Annual Percentage Rate (APR)?")
  prompt("What is the loan duration?")
=end