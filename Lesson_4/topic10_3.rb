ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

ages.delete_if { |name, age| age > 100 }
p ages

#________Another solution___________

# ages.keep_if { |_, age| age < 100 }