words = "the flintstones rock"

a = []
words.split.map do |word|
  a << word.capitalize
end

p a
p words
words = a.join " "
p words


=begin
__________Another solution______________

words = "the flintstones rock"

p words.split.map { |word| word.capitalize }.join (" ")
p words

=end