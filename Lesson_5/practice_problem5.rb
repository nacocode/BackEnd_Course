munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

total_age = 0

munsters.each_value do |details|
  if details["gender"] == "male"
    total_age += details["age"]
  end
end

p total_age

# On line 12-14 can be one line 
# => total_age += details["age"] if details["gender"] == "male"