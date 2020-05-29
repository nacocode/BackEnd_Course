arr1 = [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}]
arr2 = []

arr1.map do |hash|
  incremented_hash = {}
  hash.each do |k, v|
    incremented_hash[k] = v + 1
  end
  arr2 << incremented_hash
end

p arr1
p arr2
