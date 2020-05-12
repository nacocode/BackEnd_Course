munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

munsters.each do |name, details|
  case details["age"]
  when 0..17
    details["age_group"] = "kid"
  when 18..64
    details["age_group"] = "adult"
  else
    details["age_group"] = "senior"
  end
end

p munsters

=begin
________Another solution with using if statement___________

p names = munsters.keys

names.each do |name|
  if munsters[name]["age"] >= 0 && munsters[name]["age"] <= 17 
    munsters[name]["age_group"] = "kid"
  elsif munsters[name]["age"] <= 64
    munsters[name]["age_group"] = "adult"
  else
    munsters[name]["age_group"] = "senior"
  end
end

----------------------------------------------------------------

munsters.each do |name, value|
  if munsters[name]["age"] >= 0 && munsters[name]["age"] <= 17 
    munsters[name]["age_group"] = "kid"
  elsif munsters[name]["age"] <= 64
    munsters[name]["age_group"] = "adult"
  else
    munsters[name]["age_group"] = "senior"
  end
end

p munsters
=end