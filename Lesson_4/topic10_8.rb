numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

p "---------------------"

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end

p "---------------------"

numbers = [1, 2, 3, 4]
numbers.each_with_index do |number, index|
  p "#{numbers}"
  p "index: #{index}, number:#{number}"
  numbers.shift(1)
end