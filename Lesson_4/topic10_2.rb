ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

total_ages = 0
ages.values.each {|age| total_ages += age }

p total_ages

=begin
__________Other solution 1______________

total_ages = 0
ages.each { |_,age| total_ages += age }
total_ages # => 6174

__________Other solution 2______________

ages.values.inject(:+) # => 6174

=end