arr = ['10', '11', '9', '7', '8']
p arr.sort {|a, b| b.to_i <=> a.to_i}



=begin
________Another Solution____________
rescue => exception
  
end
arr2 = arr.map do |num|
         num.to_i
       end

p arr2.sort.reverse

=end