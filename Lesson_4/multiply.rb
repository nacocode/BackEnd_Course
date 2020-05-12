my_numbers = [1, 4, 3, 7, 2, 6]

def multiply(numbers,  multiplier)
  multiplied_numbers = []
  counter = 0

  loop do
    break if counter == numbers.size

    multiplied_numbers << numbers[counter] * multiplier
    counter +=1
  end

  multiplied_numbers
end

p multiply(my_numbers,2)
p multiply(my_numbers,3)